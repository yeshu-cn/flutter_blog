#!/bin/bash

echo "Shell 传递参数实例！";
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";

function createNewPost() {
	if [ -z "$1" ]; then
		echo "please input post name"
	else
		if [ -a "source/post/$1/$1.md" ]; then
			echo "file $1.md already exists!!"
		else
			mkdir "source/post/$1"
			echo "create post file: srouce/post/$1/$1.md"
			touch "source/post/$1/$1.md"
			echo "---" > "source/post/$1/$1.md"
			echo "title: $1.md" >> "source/post/$1/$1.md"
			date=$(date '+%Y-%m-%d %H:%M:%S')
			echo "date: $date" >> "source/post/$1/$1.md"
			echo "tags: " >> "source/post/$1/$1.md"
			echo "categories: " >> "source/post/$1/$1.md"
			echo "---" >> "source/post/$1/$1.md"
		fi
	fi
}


if [ "new" == "$1" ]; then
	createNewPost "$2"
elif [ "d" == "$1" ]; then
	echo "deploy blog"
elif [ "clean" == "$1" ]; then
	echo "clean"
elif [ "g" == "$1" ]; then
	echo "generate blog data"
else
	echo "unkown command"
fi
