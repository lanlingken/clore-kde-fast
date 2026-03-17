# Clore.ai 云电脑镜像 - KDE桌面 + Sunshine串流

## 📋 项目说明
这是一个用于Clore.ai的云电脑Docker镜像，包含：
- ✅ KDE Plasma 完整桌面环境
- ✅ 中文支持 + Fcitx5拼音输入法
- ✅ Sunshine串流服务（支持Moonlight低延迟连接）
- ✅ SSH远程管理
- ✅ Python 3.10环境

## 🚀 自动构建流程

### 方式1：GitHub Actions自动触发（推荐）

1. **修改代码后自动构建**
   - 修改 Dockerfile
   - 提交到 main 分支
   - GitHub Actions 自动触发构建
   - 推送到 Docker Hub

2. **手动触发构建**
   - 进入 Actions 标签
   - 选择 "Build and Push Docker Image"
   - 点击 "Run workflow"
   - 等待完成

### 方式2：Docker Hub自动构建

1. 访问 https://hub.docker.com/r/kenlanling/clore-kde-fast
2. 点击 "Builds" 标签
3. 链接到 GitHub 仓库
4. 配置构建规则：
   - Source: main 分支
   - Dockerfile: /Dockerfile
   - Tag: latest
5. 每次 push 到 main 分支自动触发

## 🔧 使用步骤

### 1. 在Clore.ai租用服务器
- 镜像名称：`kenlanling/clore-kde-fast:latest`
- 开放端口：`22,47990,48000,48010,5901`
- GPU：RTX 3060 或更高
- 存储：50GB+

### 2. 连接云电脑

**方式A：Moonlight串流（推荐）**
1. 本地安装 Moonlight：https://moonlight-stream.org
2. 添加电脑：输入服务器公网IP
3. 配对码：访问 https://服务器IP:47990 查看
4. 开始串流

**方式B：SSH连接**
```bash
ssh root@服务器IP -p 22
# 密码：Cloud123

默认账号密码
SSH用户名：root
SSH密码：Cloud123
Sunshine Web：admin / Cloud123

端口
用途
22
SSH远程管理

47990
Sunshine Web管理界面

48000-48010
Sunshine串流端口

5901
VNC备用连接