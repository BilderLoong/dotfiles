	# Should be placed at the beginning of the init, so that the below commands that need to send network be proxied.
	# Proxy the WSL
	## 获取主机 IP
	## 主机 IP 保存在 /etc/resolv.conf 中
	# export hostip=$(cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*') 
	# export proxy_address="http://${hostip}:7890" 
	# export all_proxy=$proxy_address
	# export http_proxy=$proxy_address
	# export https_proxy=$proxy_address
	export D="/mnt/d"
  # For Android Studio
  export GDK_SCALE=3
  export GDK_DPI_SCALE=0.5
  alias android-studio="/opt/android-studio/bin/studio.sh > /dev/null 2>&1"

[ -f "/home/birudo/.ghcup/env" ] && source "/home/birudo/.ghcup/env" # ghcup-env
