#!/bin/sh
# -------------------
# 部署博客到指定的仓库
# Deploy posts to special repo.
#
# 配置 Configurations
# -------------------

# 自定义 `REPO_DEPLOYED` 为所要部署仓库
REPO_DEPLOYED="jack@aituyaa.com:/home/jack/.repo/site.git" 

# rm -rf "public/CNAME" && cp -r "CNAME" "public/" # Fix potential error - Recovery `CNAME` before deploy.

# 判断是否存在 public
if [ -d "public" ]
then
    # 判断是否已经存在与 site 同级的 .temp 文件夹
    if [ ! -d "../.temp" ]
    then
        # ^ 若不存在，直接复制 public 为 ../.temp ，进入该目录，初始化，强制推送至指定的远程仓库
        echo -e "\e[32m >>> .temp not exited. \e[0m"
        cp -r "public" "../.temp"
        echo -e "\e[32m >>>[DONE] copy public to .temp. \e[0m"

        cd "../.temp"

        git init
        git add .
        git commit -m "Posts update."
        git remote add origin $REPO_DEPLOYED
        # git remote add origin https://github.com/loveminimal/loveminimal.github.io.git
        # git push -f origin master:main
        git push -f origin master

    else 
        # ^ 若存在，则进入 ../.temp 目录，判断该仓库是否已初始化（包含 .git ）
        echo -e "\e[32m >>> .temp exited. \e[0m"
        cd "../.temp"
        if [ -d ".git" ]
        then
            # ^^ 若存在 .git ，则备份 .git ，并在处理 .temp 后，恢复它
            echo -e "\e[42m >>> copying.... \e[0m"
            
            mv ".git" "../.git.bak"
            # 此处，对于 .temp 处理的目的是为了绝对保持其与 site/public 文件的一致性（无论增删）
            cd ..
            rm -rf .temp
            cp -r "site/public" ".temp"
            mv ".git.bak" ".temp/.git"
            
            cd .temp
            git add .
            git commit -m "Posts update."
            git push -f origin master
        else
            # ^^ 若不存在 .git ，初始化，强制推送至指定的远程仓库
            git init
            git add .
            git commit -m "Posts update."
            git remote add origin $REPO_DEPLOYED
            # git remote add origin https://github.com/loveminimal/loveminimal.github.io.git
            # git push -f origin master:main
            git push -f origin master
        fi

    fi
    echo -e "\e[42m >>>[DONE] Update. \e[0m"
    cd "../site"
fi