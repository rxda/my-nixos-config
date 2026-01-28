#!/usr/bin/env bash
INTERFACE="wlp4s0"      # 你的网卡名
DOWNLOAD="4mbit"     # 下载限制
UPLOAD="3mbit"       # 上传限制

# 1. 加载 IFB 模块
sudo modprobe ifb numifbs=1
sudo ip link set dev ifb0 up

# 2. 限制上传 (Egress)
sudo tc qdisc add dev $INTERFACE root handle 1: htb default 10
sudo tc class add dev $INTERFACE parent 1: classid 1:10 htb rate $UPLOAD

# 3. 限制下载 (Ingress)
# 创建 ingress 队列
sudo tc qdisc add dev $INTERFACE handle ffff: ingress
# 将所有进入 $INTERFACE 的流量重定向到 ifb0
sudo tc filter add dev $INTERFACE parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifb0
# 在 ifb0 上应用限速
sudo tc qdisc add dev ifb0 root handle 1: htb default 10
sudo tc class add dev ifb0 parent 1: classid 1:10 htb rate $DOWNLOAD