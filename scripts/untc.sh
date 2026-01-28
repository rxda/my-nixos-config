#!/usr/bin/env bash

sudo tc qdisc del dev wlp4s0 root
sudo tc qdisc del dev wlp4s0 ingress
sudo tc qdisc del dev ifb0 root