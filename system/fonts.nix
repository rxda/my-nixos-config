{ pkgs, lib, ... }:

let
  mkFont = { name, fileName, url, hash }:
    pkgs.stdenvNoCC.mkDerivation {
      pname = name;
      version = "11.0";
      src = pkgs.fetchurl { inherit url hash; };
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp $src $out/share/fonts/truetype/${fileName}
      '';
    };

  wpsFonts = pkgs.symlinkJoin {
    name = "wps-fonts";
    paths = map mkFont [
      { name = "simsun";         fileName = "simsun.ttc";          url = "https://140100000.xyz/font/simsun.ttc";          hash = "sha256-FSasJDdfUfbrc7wtP4By2+SoCjplIXZ3ydmoT2fasqs="; }
      { name = "fangsong-gb2312"; fileName = "仿宋_GB2312.ttf";  url = "https://140100000.xyz/font/仿宋_GB2312.ttf";  hash = "sha256-/vfPmRtFjKvRhLczeJGNnRVCkBDh1sgE8I05Q5XDw7Q="; }
      { name = "simhei";         fileName = "simhei.ttf";          url = "https://140100000.xyz/font/simhei.ttf";          hash = "sha256-mxlZ2zs6vrfv2uwm7fff6HGmA53o1hSvckhXUge+Yp4="; }
      { name = "dengxian";       fileName = "DengXian.ttf";       url = "https://140100000.xyz/font/DengXian.ttf";       hash = "sha256-Hugr4DUwxpO509RxScmB/sC3KE8pu4vXpA1fR+emyvY="; }
      { name = "dengxian-light"; fileName = "Dengl.ttf";          url = "https://140100000.xyz/font/Dengl.ttf";          hash = "sha256-UxH/YzIm3ozdDVEKyCX6ymUL8NsIZQIGryNY+mt8Ajs="; }
      { name = "wingdings";      fileName = "wingding.ttf";       url = "https://140100000.xyz/font/wingding.ttf";       hash = "sha256-m81gZOO1L6MKNH7dboJQbi7IsWApMLQjximoLBBGils="; }
      { name = "symbol";         fileName = "symbol.ttf";         url = "https://140100000.xyz/font/symbol.ttf";         hash = "sha256-u/EZKWXlJm+/IzcEFjN9KGH8HovTSd75PymUumc4L8M="; }
      { name = "fzfangsong";     fileName = "FZFSK.TTF";          url = "https://140100000.xyz/font/FZFSK.TTF";          hash = "sha256-74TPopuJ9ct5NjBt3sVIGddmf+xtAouCDPgHlGNcBD8="; }
      { name = "fzkaiti";        fileName = "FZKTK.TTF";          url = "https://140100000.xyz/font/FZKTK.TTF";          hash = "sha256-ZSfxpTQU2dHc22T38mzEUe96ssV6KisaBuUlXpfy2JQ="; }
      { name = "fzxiaobiaosong"; fileName = "FZXBSK.TTF";         url = "https://140100000.xyz/font/FZXBSK.TTF";         hash = "sha256-puTh7oh4uCS062bcWOJe0lWZLvOskBJkuERKW8WjACk="; }
    ];
  };
in
{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      source-code-pro
      hack-font
      wqy_microhei
      wqy_zenhei
      nerd-fonts.fira-code

      vista-fonts-chs
      vista-fonts
      vista-fonts-cht
      sarasa-gothic
      corefonts

      wpsFonts
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [
          "Noto Sans CJK SC"
          "DejaVu Sans"
          "Microsoft YaHei"
        ];
        serif = [
          "Noto Serif CJK SC"
          "DejaVu Serif"
          "SimSun"
        ];
        monospace = [
          "FiraCode Nerd Font Mono"
          "Noto Sans Mono CJK SC"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
      antialias = true;
      hinting.enable = true;
      subpixel.lcdfilter = "default";
    };
  };
}
