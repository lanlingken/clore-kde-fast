#!/bin/bash
echo "root:${ROOT_PASSWORD:-Cloud123}" | chpasswd

/usr/sbin/sshd -D &

# 启动 X 显示（dummy 驱动 + GPU 加速）
X :1 -config /etc/X11/xorg.conf &
sleep 5

export DISPLAY=:1

# 启动 KDE 桌面
startplasma-x11 &
sleep 12   # 等待桌面完全加载

fcitx5 -d &

# 启动音频
pipewire & wireplumber & pipewire-pulse &

# 启动 Sunshine（第一次打开 Web UI 设置密码）
DISPLAY=:1 sunshine &

tail -f /dev/null