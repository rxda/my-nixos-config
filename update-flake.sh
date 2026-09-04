#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$script_dir"
cd "$repo_dir"

usage() {
  cat <<'EOF'
用法:
  ./update-flake.sh <target> [选项]

target:
  os                  执行 nh os switch .
  home                执行 nh home switch .
  nixpkgs             更新主 nixpkgs，然后切换 OS 和 Home
  agent               只更新 nixpkgs-agents，然后切换 Home
  heavy               只更新 nixpkgs-heavy，然后切换 Home
  all                 更新 nixpkgs、agent、heavy，然后各切换一次

选项:
  -h, --help          显示帮助

示例:
  ./update-flake.sh os
  ./update-flake.sh home
  ./update-flake.sh heavy
  ./update-flake.sh all
EOF
}

die() {
  printf '错误: %s\n' "$1" >&2
  exit 2
}

[[ $# -gt 0 ]] || {
  usage >&2
  exit 2
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

target="$1"
shift

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "未知选项: $1"
      ;;
  esac
  shift
done

case "$target" in
  os)
    nh os switch .
    ;;
  home)
    nh home switch .
    ;;
  nixpkgs|nixpkg)
    nix flake update nixpkgs
    nh os switch .
    nh home switch .
    ;;
  agent|agents)
    nix flake update nixpkgs-agents
    nh home switch .
    ;;
  heavy)
    nix flake update nixpkgs-heavy
    nh home switch .
    ;;
  all)
    nix flake update nixpkgs nixpkgs-agents nixpkgs-heavy
    nh os switch .
    nh home switch .
    ;;
  *)
    die "未知目标: $target（可选 os、home、nixpkgs、agent、heavy、all）"
    ;;
esac
