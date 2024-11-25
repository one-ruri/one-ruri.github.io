@echo off
:: -------------------
:: 部署博客到指定的仓库
:: Deploy posts to special repo.
::
:: 配置 Configurations
:: -------------------

:: 自定义 `REPO_DEPLOYED` 为所要部署仓库
set REPO_DEPLOYED=git@github.com:one-ruri/one-ruri.github.io.git

:: 判断是否存在 public 目录
if exist "public" (
    :: 判断是否已经存在与 site 同级的 .temp 文件夹
    if not exist "../.temp" (
        :: 若不存在，直接复制 public 为 ../.temp ，进入该目录，初始化，强制推送至指定的远程仓库
        echo [32m >>> .temp not exited.[0m
        xcopy "public" "../.temp" /E /I /Y
        echo [32m >>>[DONE] copy public to .temp.[0m

        cd "../.temp"

        git init
        git add .
        git commit -m "Posts update."
        git remote add origin %REPO_DEPLOYED%
        git push -f origin master
    ) else (
        :: 若存在，则进入 ../.temp 目录，判断该仓库是否已初始化（包含 .git ）
        echo [32m >>> .temp exited.[0m
        cd "../.temp"
        if exist ".git" (
            :: 若存在 .git ，则备份 .git ，并在处理 .temp 后，恢复它
            echo [42m >>> copying....[0m
            
            move ".git" "../.git.bak"
            :: 此处，对于 .temp 处理的目的是为了绝对保持其与 site/public 文件的一致性（无论增删）
            cd ..
            rmdir /S /Q .temp
            xcopy "site\public" ".temp" /E /I /Y
            move ".git.bak" ".temp\.git"
            
            cd .temp
            git add .
            git commit -m "Posts update."
            git push -f origin master
        ) else (
            :: 若不存在 .git ，初始化，强制推送至指定的远程仓库
            git init
            git add .
            git commit -m "Posts update."
            git remote add origin %REPO_DEPLOYED%
            git push -f origin master
        )
    )
    echo [42m >>>[DONE] Update.[0m
    cd "../site"
) 