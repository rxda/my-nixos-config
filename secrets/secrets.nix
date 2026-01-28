let
  # --- 1. 用户公钥 (User Keys) ---
  # 作用：允许你在 这台电脑 上运行 `agenix -e` 编辑文件
  user_eq12 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEmmnspv3TeLPEMHS99R+cLfSVeEerXR9RQE2E9XGzh";
  user_xiaomi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaFc3auZJZIvznu+0/s25njbAlvLhAjKC8iUj3mexxP";

  # 把所有“人”放在一组
  all_users = [ user_eq12 user_xiaomi ];

  # --- 2. 主机公钥 (System Keys) ---
  # 作用：允许 这台电脑 在开机/部署时解密文件
  system_eq12 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOi98U1kTP0MP4GolNcg3csOmnPygvOOx3b23a9EBY7R";
  system_xiaomi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZl8cppETMB71druhUoqbqFPuAgh7Oy7xnzICz/aEYX";

  # 把所有“机器”放在一组
  all_systems = [ system_eq12 system_xiaomi ];
in
{
  "singbox-url.age".publicKeys = all_users ++ all_systems;
}
