#!/bin/bash


# echo "Shell 传递参数实例！";
# echo "执行的文件名：$0";
# echo "第一个参数为：$1";
# echo "第二个参数为：$2";
# echo "第三个参数为：$3";

postPath=./source/post
assetsPath=./assets
webPath=./web

function createNewPost() {
	if [ -z "$1" ]; then
		echo "please input post name"
	else
	  postFile="$postPath/$1/$1.md"
		if [ -a "$postFile" ]; then
			echo "$postFile already exists!!"
		else
			mkdir "$postPath/$1"
			echo "create post file: $postFile"
			touch "$postFile"
			echo "---" > "$postFile"
			echo "title: $1.md" >> "$postFile"
			date=$(date '+%Y-%m-%d %H:%M:%S')
			# shellcheck disable=SC2129
			echo "date: $date" >> "$postFile"
			echo "tags: " >> "$postFile"
			echo "categories: " >> "$postFile"
			echo "---" >> "$postFile"
		fi
	fi
}

function g() {
  ./data_generator/bin/blog.exe $postPath $assetsPath $webPath
}

function s() {
  flutter run -d chrome &
}


if [ "new" == "$1" ]; then
	createNewPost "$2"
elif [ "d" == "$1" ]; then
	echo "deploy to github"
elif [ "s" == "$1" ]; then
	echo "start server"
  s
elif [ "g" == "$1" ]; then
	echo "generate data"
	g
else
	echo "unkown command"
fi
