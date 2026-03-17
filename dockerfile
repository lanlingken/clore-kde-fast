FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# 1. 基础工具 + 中文支持
RUN apt-get update && apt-get install -y software-properties-common wget curl git vim nano htop net-tools openssh-server locales && rm -rf /var/lib/apt/lists/*
RUN sed -i '/zh_CN.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# 2. KDE桌面 + 输入法 + 虚拟显示
RUN add-apt-repository ppa:kubuntu-ppa/backports -y && apt-get update && apt-get install -y kubuntu-desktop fcitx5 fcitx5-pinyin fonts-noto-cjk x11vnc xvfb && rm -rf /var/lib/apt/lists/*

# 3. 输入法配置
RUN echo 'export GTK_IM_MODULE=fcitx' >> /etc/profile && echo 'export QT_IM_MODULE=fcitx' >> /etc/profile && echo 'export XMODIFIERS=@im=fcitx' >> /etc/profile

# 4. SSH配置
RUN mkdir /var/run/sshd && echo 'root:Cloud123' | chpasswd && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 5. Sunshine串流服务
RUN wget -q https://github.com/LizardByte/Sunshine/releases/download/v0.20.0/sunshine_0.20.0_amd64.deb && apt-get install -y ./sunshine_0.20.0_amd64.deb && rm sunshine_0.20.0_amd64.deb

# 6. Sunshine配置
RUN mkdir -p /root/.config/sunshine && echo '{"username":"admin","password":"Cloud123","apps":[{"name":"Desktop","cmd":"startplasma-x11"},{"name":"Terminal","cmd":"konsole"}]}' > /root/.config/sunshine/config.json

# 7. 启动脚本
RUN echo '#!/bin/bash\n/usr/sbin/sshd -D &\nXvfb :1 -screen 0 1920x1080x24 &\nsleep 2\nDISPLAY=:1 startplasma-x11 &\nsleep 3\nx11vnc -display :1 -forever -shared -rfbport 5901 -nopw &\nsunshine &\ntail -f /dev/null' > /start.sh && chmod +x /start.sh

EXPOSE 22 47990 48000 48010 5901
CMD ["/start.sh"]