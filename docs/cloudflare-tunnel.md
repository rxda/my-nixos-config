# Cloudflare Tunnel

`link-eq12` 使用 NixOS 官方 `services.cloudflared` 模块，将 Cloudflare Tunnel 转发到本机 Hermes dashboard：

```text
http://127.0.0.1:9119
```

当前 Tunnel ID：`469cc5db-4750-4397-a786-17e640376ef9`

## 配置位置

- NixOS 配置：`hosts/link-eq12/configuration.nix`
- 加密 credentials：`secrets/cloudflare-tunnel-credentials.age`
- systemd 服务：`cloudflared-tunnel-469cc5db-4750-4397-a786-17e640376ef9.service`

域名不写入仓库。Public Hostname/DNS route 在 Cloudflare 控制台中配置，NixOS 侧使用 `default` 将进入 Tunnel 的流量转发到 Hermes。

## 加密 credentials

credentials JSON 不应提交明文。首次导入或更新时：

```bash
cd secrets
cat ~/.cloudflared/<tunnel-id>.json | agenix -e cloudflare-tunnel-credentials.age
```

## 部署与排障

```bash
sudo nixos-rebuild switch --flake .#link-eq12
sudo systemctl status cloudflared-tunnel-469cc5db-4750-4397-a786-17e640376ef9.service
sudo journalctl -u cloudflared-tunnel-469cc5db-4750-4397-a786-17e640376ef9.service -f
```

如果使用 Cloudflare Dashboard 配置 Public Hostname，请确认该 hostname 指向新的 Tunnel ID，而不是旧的 `6dfc1b52-c89b-4d80-aabe-01c6c54f868e`。

## Hermes 公网 URL（Agenix）

Hermes 也必须知道它对外提供服务的完整 URL，否则会拒绝来自 Tunnel
Public Hostname 的 `Host` 请求。公网 URL 保存在：

```text
secrets/hermes-public-url.age
```

该 secret 的明文格式只有一行：

```text
HERMES_DASHBOARD_PUBLIC_URL=https://<your-public-hostname>
```

`modules/hermes.nix` 可以通过 Agenix 提供 `/run/agenix/hermes-public-url`。
注意：`services.hermes-agent.environmentFiles` 会被 Home Manager 同时注入 Hermes
的 user services；对于 Hermes 0.21.5，设置公网 URL 但没有 Dashboard auth provider
会让 `hermes-backend.service` fail-closed，9119 不会监听。托管安装不能执行
`hermes dashboard register`，因此本机使用 Basic Auth；相关 secret 作为
`hermes-backend.service` 的 `EnvironmentFile` 注入。secret 文件不会进入 Git 或 Nix store。

修改域名时，在仓库根目录执行：

```bash
printf '%s\n' 'HERMES_DASHBOARD_PUBLIC_URL=https://<your-public-hostname>' \
  | (cd secrets && agenix -e hermes-public-url.age)
```

然后重新部署并重启 Hermes：

```bash
sudo nixos-rebuild switch --flake .#link-eq12
systemctl --user restart hermes-agent.service
```

## Hermes Dashboard 认证（托管安装）

托管/Hosted 安装不能执行 `hermes dashboard register`，因为 Nous OAuth 客户端由托管平台提供。
本机使用 Basic Auth；认证参数保存在 `secrets/hermes-dashboard-auth.age`，由 Agenix 在运行时
注入 `hermes-backend.service`，不会写入 Nix store。
