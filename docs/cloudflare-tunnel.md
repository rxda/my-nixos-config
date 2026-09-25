# Cloudflare Tunnel

当前 `link-eq12` 已启用一个基于 Tunnel Token 的 `cloudflared` systemd 服务：

- 配置模块：`system/cloudflare-tunnel.nix`
- 主机配置：`hosts/link-eq12/configuration.nix`
- Token 文件：`/etc/cloudflared/link-eq12-token`
- systemd 服务：`cloudflare-tunnel.service`

Tunnel 是主动向 Cloudflare 建立出站连接，不需要在路由器上做端口转发，也不需要把 SSH/RDP 端口直接暴露到公网。域名和本地服务的对应关系在 Cloudflare Zero Trust 控制台中配置。

## 1. 在 Cloudflare 创建 Tunnel

1. 确认域名已经托管在 Cloudflare。
2. 打开 Cloudflare Zero Trust → **Networks → Tunnels**，创建一个 Cloudflared Tunnel，例如命名为 `link-eq12`。
3. 选择 **Cloudflared** 作为 connector，复制安装命令中的 Tunnel Token。只复制 `--token` 后面的那一长串 token，不要复制命令本身。
4. 在这个 Tunnel 的 **Public hostnames** 中添加需要的域名。例如：

   | 域名 | Service | 用途 |
   | --- | --- | --- |
   | `rdp.example.com` | `rdp://127.0.0.1:3389` | GNOME RDP 远程桌面 |
   | `ssh.example.com` | `ssh://127.0.0.1:22` | SSH 远程登录 |
   | `files.example.com` | `http://127.0.0.1:5005` | Dufs 文件/WebDAV 服务 |

   将 `example.com` 换成你自己的域名；不需要的 hostname 不要添加。

建议给 SSH、RDP 和文件服务分别创建 Cloudflare Access Application，并至少配置邮箱/身份验证策略，不要设置为对所有人公开。

## 2. 在 NixOS 上安装 Token

先切换一次配置，让 `cloudflared` 用户和服务存在：

```bash
sudo nixos-rebuild switch --flake .#link-eq12
```

然后把 token 保存到 root 可写、`cloudflared` 可读的文件中：

```bash
sudo install -d -o root -g cloudflared -m 0750 /etc/cloudflared
sudo install -o root -g cloudflared -m 0640 /dev/null /etc/cloudflared/link-eq12-token
sudoedit /etc/cloudflared/link-eq12-token
```

文件内容只放一行 Tunnel Token，保存后重启服务：

```bash
sudo systemctl restart cloudflare-tunnel.service
sudo systemctl status cloudflare-tunnel.service
sudo journalctl -u cloudflare-tunnel.service -f
```

服务使用 `--token-file` 读取 token，不会把 token 写入 Nix store。Token 文件位于 `/etc`，不应提交到 Git。

## 3. 客户端连接

- `files.example.com` 可以直接用浏览器访问；如使用 WebDAV，请在客户端填入该 HTTPS 地址。
- SSH/RDP 应通过 Cloudflare Access 对应的客户端方式连接，并按控制台生成的 Access 策略进行身份验证。
- 如果只想远程桌面，建议只创建 `rdp.example.com`，不要同时发布 SSH、Samba 或 Dufs。

## 4. 排障

```bash
# 查看服务状态
systemctl status cloudflare-tunnel.service

# 查看实时日志
journalctl -u cloudflare-tunnel.service -f

# 确认 token 权限
sudo stat -c '%A %U:%G %n' /etc/cloudflared/link-eq12-token
```

如果日志显示 token 文件不存在或权限错误，确认文件为 `root:cloudflared`、权限为 `0640`，并重新执行 `systemctl restart cloudflare-tunnel.service`。
