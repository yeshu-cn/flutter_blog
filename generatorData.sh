#! /bin/bash

# 打印当前路径
currentPath=$(pwd)
echo "当前文件夹路径: $currentPath"

postPath=./source/post
assetsPath=./assets
webPath=./web
./data_generator/bin/blog.exe $postPath $assetsPath $webPath

flutter run -d chrome
