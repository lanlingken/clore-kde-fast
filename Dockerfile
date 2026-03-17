FROM nvidia/cuda:12.1.0-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=all

# 1. 基础工具 + 中文
RUN apt-get update && apt-get install -y \
    software-properties-common wget curl git vim nano htop net-tools openssh-server locales sudo \
    && sed -i '/zh_CN.UTF-8/s/^# //g' /etc/locale.gen && locale-gen \
    && rm -rf /var/lib/apt/lists/*

# 2. GPU + X + 音频 + 编码依赖（关键！）
RUN apt-get update && apt-get install -y \
    xserver-xorg-core xserver-xorg-video-dummy \
    libgl1 libegl1 libgles2 \
    libnvidia-gl-535 libnvidia-encode-535 \
    libva2 libva-drm2 libva-x11-2 vainfo \
    pipewire pipewire-pulse wireplumber \
    && rm -rf /var/lib/apt/lists/*

# 3. KDE 精简版 + 输入法
RUN apt-get update && apt-get install -y \
    kde-plasma-desktop sddm konsole dolphin \
    fcitx5 fcitx5-pinyin fcitx5-chinese-addons fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*

# 输入法环境变量
RUN echo 'export GTK_IM_MODULE=fcitx' >> /etc/profile.d/fcitx.sh \
    && echo 'export QT_IM_MODULE=fcitx' >> /etc/profile.d/fcitx.sh \
    && echo 'export XMODIFIERS=@im=fcitx' >> /etc/profile.d/fcitx.sh

# SSH
RUN mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Sunshine（固定最新稳定版，永不 404）
RUN wget -O /tmp/sunshine.deb https://github.com/LizardByte/Sunshine/releases/download/v2025.924.154138/sunshine-ubuntu-22.04-amd64.deb \
    && apt-get update && apt-get install -y /tmp/sunshine.deb \
    && rm /tmp/sunshine.deb && rm -rf /var/lib/apt/lists/*

# 配置目录
RUN mkdir -p /root/.config/sunshine

COPY sunshine.conf /root/.config/sunshine/sunshine.conf
COPY apps.json /root/.config/sunshine/apps.json
COPY xorg.conf /etc/X11/xorg.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22 47984 47989 47990 48000/udp 48010

CMD ["/start.sh"]
