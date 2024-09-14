#!/bin/bash


# 获取当前脚本所在目录的路径
script_dir=$(dirname "$(realpath "$0")")
echo "脚本所在目录: $script_dir"

# 获取当前脚本的绝对路径
current_path=$(realpath "$0")
echo "当前脚本路径: $current_path"

git_author=$(git show -s --format='%ae')
echo "git_author: $git_author"

git_branch=$(git rev-parse --abbrev-ref HEAD)
echo "git_branch: $git_branch"

# 获取当前日期的倒数5天的日期
date_start=$(date -v -5d +%Y-%m-%d)
echo "date_start: $date_start"

git log --author="${git_author}" --after="$date_start" --pretty=format:"%s" > commit_messages.txt
