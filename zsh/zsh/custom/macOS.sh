
# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"

alias wechatcli='/Applications/wechatwebdevtools.app/Contents/MacOS/cli'
# The wechat mp devtool cli path: https://segmentfault.com/a/1190000040867117 .
wechatcliopen () {
  wechatcli='/Applications/wechatwebdevtools.app/Contents/MacOS/cli'

  if [[ -z "$1" ]] 
  then
    ${wechatcli} open --project "$(realpath apps/menuorder/dist/merchant)"
  else
   ${wechatcli} open --project ~/Project/menuorder-new-rms-h5-$1/apps/menuorder/dist/merchant
  fi
}

    # Make Ankiconnect be able to run in background, source: https://github.com/FooSoft/anki-connect#installation
  defaults write net.ankiweb.dtop NSAppSleepDisabled -bool true
  defaults write net.ichi2.anki NSAppSleepDisabled -bool true
  defaults write org.qt-project.Qt.QtWebEngineCore NSAppSleepDisabled -bool true

  # Change the homebrew packages source.
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles

# Haskell
[ -f "/Users/birudo/.ghcup/env" ] && source "/Users/birudo/.ghcup/env" # ghcup-env

# JAVA
export M2_HOME="/usr/local/Cellar/maven/3.9.6"
export PATH="$PATH:$M2_HOME/bin"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home"


  # Use Clash proxy.
  # export https_proxy=http://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export all_proxy=socks5://127.0.0.1:7890
