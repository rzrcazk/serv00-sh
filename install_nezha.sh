#!/bin/sh

# 进入用户目录
cd ~/domains/nz.serv00.com/public_html

# 克隆 nezha 代码库
echo "Cloning nezha repository..."
git clone https://github.com/naiba/nezha.git

# 进入到构建目录
echo "Entering dashboard directory..."
cd ~/domains/nz.serv00.com/public_html/nezha/cmd/dashboard

# 构建项目
echo "Building the project..."
go build -ldflags="-s -w --extldflags '-static -fpic' -X github.com/naiba/nezha/service/singleton.Version=0.16.25"

# 创建 nezhapanel 目录并进入
echo "Creating and entering nezhapanel directory..."
mkdir ~/domains/nz.serv00.com/public_html/nezhapanel
cd ~/domains/nz.serv00.com/public_html/nezhapanel

# 复制构建后的 dashboard 文件
echo "Copying dashboard binary..."
cp ~/domains/nz.serv00.com/public_html/nezha/cmd/dashboard/dashboard ~/domains/nz.serv00.com/public_html/nezhapanel/dashboard

# 复制资源文件
echo "Copying resource directory..."
cp -r ~/domains/nz.serv00.com/public_html/nezha/resource ~/domains/nz.serv00.com/public_html/nezhapanel/resource

# 删除 resource.go 文件
echo "Removing resource.go..."
rm ~/domains/nz.serv00.com/public_html/nezhapanel/resource/resource.go

# 创建数据目录
echo "Creating data directory..."
mkdir ~/domains/nz.serv00.com/public_html/nezhapanel/data

# 复制配置文件
echo "Copying config.yaml..."
cp ~/domains/nz.serv00.com/public_html/nezha/script/config.yaml ~/domains/nz.serv00.com/public_html/nezhapanel/data/config.yaml

# 修改配置文件
echo "Modifying config.yaml..."
sed -i '' 's/language: .*/language: zh-CN/' ~/domains/nz.serv00.com/public_html/nezhapanel/data/config.yaml
sed -i '' 's/httpport: .*/httpport: 23622/' ~/domains/nz.serv00.com/public_html/nezhapanel/data/config.yaml
sed -i '' 's/grpcport: .*/grpcport: 41459/' ~/domains/nz.serv00.com/public_html/nezhapanel/data/config.yaml

# 进入 nezhapanel 目录并设置权限
echo "Entering nezhapanel directory and setting permissions..."
cd ~/domains/nz.serv00.com/public_html/nezhapanel
chmod +x ./dashboard

# 后台运行 dashboard
echo "Running dashboard in the background..."
nohup ./dashboard &

echo "Setup and execution completed."
