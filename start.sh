#!/bin/bash

#加载系统函数库
[ -f /etc/init.d/functions ] && source /etc/init.d/functions

# 判断命令是否正常执行 函数
if_success() {
	if [ $? -eq 0 ]; then
	        action "$1" /bin/true
	else
	        action "$2" /bin/false
	        exit 1
	fi
}

Server_Dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
Conf_Dir="$Server_Dir/conf"
Temp_Dir="$Server_Dir/temp"
Log_Dir="$Server_Dir/logs"
URL='更改为你的clash订阅地址'

# 临时取消环境变量
unset http_proxy
unset https_proxy

# 拉取更新config.yml文件
wget -q -O $Temp_Dir/clash.yaml $URL 
Text1="配置文件config.yaml下载成功！"
Text2="配置文件config.yaml下载失败，退出启动！"
if_success $Text1 $Text2

# 取出代理相关配置 
sed -n '/^proxies:/,$p' $Temp_Dir/clash.yaml > $Temp_Dir/proxy.txt

# 合并形成新的config.yaml
cat $Temp_Dir/templete_config.yaml > $Temp_Dir/config.yaml
cat $Temp_Dir/proxy.txt >> $Temp_Dir/config.yaml
\cp $Temp_Dir/config.yaml $Conf_Dir/

# 启动Clash服务
nohup $Server_Dir/clash-linux-amd64-v1.3.5 -d $Conf_Dir &> $Log_Dir/clash.log &
Text3="服务启动成功！"
Text4="服务启动失败！"
if_success $Text3 $Text4

# 添加环境变量
echo -e "export http_proxy=http://127.0.0.1:7890\nexport https_proxy=http://127.0.0.1:7890" > /etc/profile.d/clash.sh
echo -e "系统代理http_proxy/https_proxy设置成功，请在当前窗口执行以下命令加载环境变量:\n\nsource /etc/profile.d/clash.sh\n"
