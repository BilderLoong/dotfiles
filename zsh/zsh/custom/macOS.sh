
# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"

# The wechat mp devtool cli path: https://segmentfault.com/a/1190000040867117 .
wechatcli () {
  wechatcli='/Applications/wechatwebdevtools.app/Contents/MacOS/cli'

  if [[ -z "$1" ]] 
  then
    "${wechatcli}"
  else
   ${wechatcli} open --project ~/Project/menuorder-new-rms-h5-$1/apps/menuorder/dist/merchant
  fi
}
