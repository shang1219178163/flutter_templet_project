#!/bin/bash

# 提取 version_name、version_code
yaml_file="pubspec.yaml"
version=$(grep 'version:' "$yaml_file" | head -n 1 | awk '{print $2}')
appPrefix=$(grep 'name:' "$yaml_file" | head -n 1 | awk '{print $2}')
versionName=$(echo "$version" | cut -d'+' -f1)
versionCode=$(echo "$version" | cut -d'+' -f2)

# 获取输入环境名称  test（beta、pre） prod 
while true; do
    echo "请选择环境: 1:test  2:pre  0:prod"; read envName
    case $envName in
        1)
            envName="test"
            break
            ;;
        2)
            envName="pre"
            break
            ;;
        0)
            envName="prod"
            break
            ;;    
        *)
            echo "请输入有效的选项 (1 或 2 或 0)"
            ;;
    esac
done

# 定义变量
timestamp=$(date +%Y-%m-%d-%H-%M)
apkFileName="V${versionName}_${envName}_${timestamp}.apk"
apkFullName="${appPrefix}_${apkFileName}"

# 构建并重命名 apk 文件
 flutter build apk --release --dart-define=app_env=${envName}
cp build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/$apkFullName

# 输出路径
echo $'\n在编辑器中打开文件目录 (Cmd + 单击)'
echo $'\e[35m'"$(realpath "build/app/outputs/flutter-apk/")"$'\e[0m'

exit
