# Clore KDE Fast - 云桌面 + Sunshine 串流

这是一个为 **Clore.ai** GPU 云服务器优化的 Docker 镜像：一键拉取后就能得到带 KDE Plasma 桌面的云电脑，支持 **Sunshine + Moonlight** 低延迟串流（游戏/办公/远程桌面），完美支持中文输入法。

镜像特点：
- 基于 Ubuntu 22.04 + NVIDIA CUDA
- 精简 KDE Plasma 桌面 + Konsole、Dolphin
- Sunshine 最新版（v2025.924.154138）
- 支持 fcitx5 中文输入（搜狗/百度等）
- SSH root 登录（密码自定义）
- 体积控制在合理范围内，启动快

**镜像地址**：`kenlanling/clore-kde-fast:latest`

## 用户快速上手教程（Clore.ai 操作步骤）

1. 登录 Clore.ai → 去 Marketplace 租一台 GPU 服务器（推荐 RTX 4090 或更高，VRAM ≥16GB 流畅）

2. 在“Create Order”页面配置：
   - **Docker Image**：填入  
     `kenlanling/clore-kde-fast:latest`
   - **Port Forwarding**（端口转发，只加 TCP 端口，最多 5 个）：
     - 22 → SSH 登录（必须加）
     - 47990 → Sunshine Web UI（浏览器设置用户名/密码）
     - 47984 → HTTPS 控制（Moonlight 连接用）
     - 47989 → HTTP 控制（备用）
     - 48010 → RTSP/控制（推荐加）
   - **Environmental Variables**（环境变量）：
     - Name: `ROOT_PASSWORD`  
       Value: 你想要的 root 密码（建议 8 位以上，如 `MyPass2026`）  
       （第一次启动会自动设置 root 密码为此值）
   - 其他选项保持默认（不要勾 Enable startup script，除非你懂）

3. 点击 **Create** 支付并启动容器（创建费 ≈0.10 USD + 1 分钟租金）

4. 容器启动后（等 1-2 分钟）：
   - **SSH 登录检查**（可选，先确认容器活了）：
     用 Xshell / FinalShell / Termius 等工具连接：  
     IP：Clore 给你的服务器 IP  
     端口：22  
     用户：`root`  
     密码：你上面设的 ROOT_PASSWORD  
     登录成功后看到命令行就 OK（可以先不操作，直接关掉）

   - **设置 Sunshine 账户**（最重要一步，只做一次）：
     浏览器打开：`https://你的服务器IP:47990`  
     （会跳证书不安全警告，点“高级 → 继续”）  
     → 设置用户名（推荐 `admin`）  
     → 设置密码（自己记牢，以后 Moonlight 连接要用）  
     → 保存设置（以后不用再进 Web UI 改）

5. **用 Moonlight 连接云桌面**（手机/电脑都行）：
   - 下载 Moonlight（官网 moonlight-stream.org，或 App Store / Google Play）
   - 添加主机：
     - Host：你的 Clore 服务器 IP
     - Port：47989（或 47984，如果上面加了）
   - 配对：Moonlight 会显示 PIN 码
   - 在浏览器 Web UI（47990）输入这个 PIN 码确认配对
   - 连接后选择 “Desktop” 应用 → 进入完整 KDE 桌面！
   - 支持键盘/鼠标/手柄输入，低延迟游戏/办公/看视频都行

## 常见问题快速解决

- **黑屏 / 连不上**：等容器启动 2-3 分钟再连；确认端口全加了；Moonlight 用 47989 端口试试。
- **中文输入法不出**：桌面右下角点输入法图标 → 配置 → 加 fcitx5 → 重启容器或注销重登。
- **声音没输出**：Moonlight 设置里开启 “Play audio on host computer” 或检查客户端音量。
- **镜像拉取失败**：确认 Docker Image 拼写正确（kenlanling/clore-kde-fast:latest），Clore 网络有时慢，重试。
- **密码忘了**：删掉容器重新创建，重新设 ROOT_PASSWORD。
- **想自定义**：仓库开源，欢迎 fork 修改 Dockerfile。

享受你的云 KDE 桌面吧！如果有问题，欢迎在 GitHub Issues 反馈。

最后更新：2026 年
