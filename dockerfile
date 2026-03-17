FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# 1. 基础工具 + 中文支持
RUN apt-get update && apt-get install -y software-properties-common wget curl git vim nano htop net-tools openssh-server locales && rm -rf /var/lib/apt/lists/*
RUN sed -i '/zh_CN.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# 2. KDE 桌面 + 输入法 + 虚拟显示
RUN add-apt-repository ppa:kubuntu-ppa/backports -y && apt-get update && apt-get install -y kubuntu-desktop fcitx5 fcitx5-pinyin fonts-noto-cjk x11vnc xvfb && rm -rf /var/lib/apt/lists/*

# 3. 输入法配置
RUN echo 'export GTK_IM_MODULE=fcitx' >> /etc/profile && echo 'export QT_IM_MODULE=fcitx' >> /etc/profile && echo 'export XMODIFIERS=@im=fcitx' >> /etc/profile

# 4. SSH 配置
RUN mkdir /var/run/sshd && echo 'root:Cloud123' | chpasswd && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 5. Sunshine 串流服务（使用官方安装脚本，最稳定）
RUN curl -fSsl https://raw.githubusercontent.com/LizardByte/Sunshine/master/installs/linux/install.sh | bash

# 6. Sunshine 配置
RUN mkdir -p /root/.config/sunshine && echo '{"username":"admin","password":"Cloud123","apps":[{"name":"Desktop","cmd":"startplasma-x11"},{"name":"Terminal","cmd":"konsole"}]}' > /root/.config/sunshine/config.json

# 7. 启动脚本
RUN echo '#!/bin/bash\n/usr/sbin/sshd -D &\nXvfb :1 -screen 0 1920x1080x24 &\nsleep 2\nDISPLAY=:1 startplasma-x11 &\nsleep 3\nx11vnc -display :1 -forever -shared -rfbport 5901 -nopw &\nsunshine &\ntail -f /dev/null' > /start.sh && chmod +x /start.sh

EXPOSE 22 47990 48000 48010 5901
CMD ["/start.sh"]
