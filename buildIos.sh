#!/bin/bash

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

# 构建
 flutter build ios --release --dart-define=app_env=${envName}

# 输出路径
echo $'\n在编辑器中打开文件目录 (Cmd + 单击)'
echo $'\e[35m'"$(realpath "build/ios/iphoneos/")"$'\e[0m'

exit
