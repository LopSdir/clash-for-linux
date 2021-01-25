#!/bin/bash

# 关闭clash服务
PID_NUM=`ps -ef | grep [c]lash-linux-amd64 | wc -l`
PID=`ps -ef | grep [c]lash-linux-amd64 | awk '{print $2}'`
if [ $PID_NUM -ne 0 ]; then
	kill -9 $PID
	# ps -ef | grep [c]lash-linux-amd64 | awk '{print $2}' | xargs kill -9
fi

# 清除环境变量
> /etc/profile.d/clash.sh

echo -e "服务关闭成功，请在已打开的窗口执行以下命令：\nunset http_proxy\nunset https_proxy"
