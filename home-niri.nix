{ config, lib, pkgs, ... }:

{
  # =========================================================================
  # 1. 确保 Niri 运行所需的软件都装上了
  #    这样你就不用担心按下快捷键系统报错 "Command not found"
  # =========================================================================
  # 在 home-niri.nix 里新增
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-right = [ "custom/power" ]; # 确保右边有电源模块

        "custom/power" = {
            format = "⏻";
            tooltip = false;
            # 关键在这里：告诉它点击时运行 wlogout
            on-click = "wlogout"; 
        };
        # ... 其他模块配置 (cpu, memory, clock 等)
      };
    };
  };
  
  
  home.packages = with pkgs; [
    # 核心组件
    niri          # 窗口管理器本身
    waybar        # 顶部状态栏
    fuzzel        # 应用启动器 (按下 Win+D 弹出的那个搜索框)
    mako          # 通知弹窗守护进程
    swaybg        # 壁纸工具
    swaylock      # 锁屏工具
    
    # 截图工具
    grim          # 截图核心
    slurp         # 截图选区
    wl-clipboard  # 剪贴板工具 (wl-copy)

    # 系统控制
    brightnessctl # 亮度控制
    pamixer       # 音量控制
    playerctl     # 媒体控制 (播放/暂停)
    
    # 验证代理 (必装，否则需要输密码的 GUI 软件打不开)
    polkit_gnome 
  ];

  # =========================================================================
  # 2. 生成 Niri 配置文件 (~/.config/niri/config.kdl)
  # =========================================================================
  xdg.configFile."niri/config.kdl".text = ''
    // --- 输入设备配置 ---
    input {
        keyboard {
            xkb {
                layout "us"
                options "caps:escape" // 可选：把 CapsLock 映射为 Esc
            }
            repeat-delay 250
            repeat-rate 35
        }

        touchpad {
            tap
            dwt
            natural-scroll
        }

        mouse {
            accel-profile "flat"
        }
    }

    // --- 外观配置 ---
    output "eDP-1" {
        scale 1.0 // 如果你是 2K/4K 屏幕，改成 1.5 或 2.0
    }

    layout {
        gaps 16
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 1
            active-color "#7fc8ff"
            inactive-color "#505050"
        }
    }

    // --- 自启动程序 ---
    // 注意：这里是分号结尾
    spawn-at-startup "waybar";
    spawn-at-startup "mako";
    
    // 设置壁纸 (把颜色换成你喜欢的，或者用 -i 指定图片路径)
    spawn-at-startup "swaybg" "-c" "#333333";
    
    // 启动 Polkit 认证代理 (非常重要)
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    
    // 解决 xwayland 应用模糊问题
    spawn-at-startup "xprop" "-root" "-f" "_XWAYLAND_GLOBAL_OUTPUT_SCALE" "32c" "-set" "_XWAYLAND_GLOBAL_OUTPUT_SCALE" "1";

    // --- 截图 ---
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // --- 快捷键绑定 ---
    binds {
        // 帮助与退出
        "Mod+Shift+Slash" { show-hotkey-overlay; } // 显示快捷键提示
        "Mod+Shift+E" { quit; }                    // 退出 Niri

        // 核心应用
        "Mod+T" { spawn "alacritty"; }             // 打开终端 (如果没有 alacritty 请改成 foot)
        "Mod+Return" { spawn "alacritty"; }
        "Mod+D" { spawn "fuzzel"; }                // 打开应用启动器
        "Mod+B" { spawn "firefox"; }               // 打开浏览器
        "Mod+L" { spawn "swaylock"; }              // 锁屏

        // 窗口管理
        "Mod+Q" { close-window; }
        "Mod+F" { maximize-column; }
        "Mod+Shift+F" { fullscreen-window; }
        "Mod+Comma" { consume-window-into-column; }
        "Mod+Period" { expel-window-from-column; }

        // 焦点移动 (类似 Vim: h, j, k, l)
        "Mod+Left"  { focus-column-left; }
        "Mod+Down"  { focus-window-down; }
        "Mod+Up"    { focus-window-up; }
        "Mod+Right" { focus-column-right; }
        "Mod+H"     { focus-column-left; }
        "Mod+J"     { focus-window-down; }
        "Mod+K"     { focus-window-up; }
        "Mod+L"     { focus-column-right; }

        // 移动窗口
        "Mod+Shift+Left"  { move-column-left; }
        "Mod+Shift+Right" { move-column-right; }
        "Mod+Shift+H"     { move-column-left; }
        "Mod+Shift+L"     { move-column-right; }

        // 音量与亮度
        "XF86AudioRaiseVolume" { spawn "pamixer" "-i" "5"; }
        "XF86AudioLowerVolume" { spawn "pamixer" "-d" "5"; }
        "XF86AudioMute"        { spawn "pamixer" "-t"; }
        "XF86MonBrightnessUp"  { spawn "brightnessctl" "set" "10%+"; }
        "XF86MonBrightnessDown"{ spawn "brightnessctl" "set" "10%-"; }

        // 截图
        "Print" { spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"; } // 截图选区到剪贴板
        "Ctrl+Print" { screenshot; } // 全屏截图到文件
    }
  '';

  # =========================================================================
  # 3. (可选) 简单的 Fuzzel 配置，让启动器不那么难看
  # =========================================================================
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=Monospace:size=14
    dpi-aware=no
    [colors]
    background=282a36dd
    text=f8f8f2ff
    match=8be9fdff
    selection=44475add
    selection-text=f8f8f2ff
    border=bd93f9ff
  '';

}