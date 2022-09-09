# 问题集

## (fetch first)和(non-fast-forward)问题详解
```
1.问题

当在本地main分支上向远程main仓库push时发生如下问题

To github.com:ReturnTmp/study.git
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'github.com:ReturnTmp/study.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
 
解决方案：

git push origin main

但是之后又报下面的错：

To github.com:ReturnTmp/study.git
 ! [rejected]        main -> main (non-fast-forward)
error: failed to push some refs to 'github.com:ReturnTmp/study.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
解决方案：
1.先合并之前的历史，再进行提交——提倡使用

（1）先把git的东西fetch到你本地然后merge后再push

$ git fetch origin master

$ git merge origin FETCH_HEAD 

先抓取远程仓库的更新到本地，然后与你的本地仓库合并，（如果有冲突就要解决冲突后再合并，冲突问题比较复杂，这里就不详细说了），这样就可以使远程仓库和你本地仓库一致了，然后就可以提交修改了。

（2）这2句命令等价于
$ git pull origin master

但是使用git fetch + git merge 更加安全。

（3）git pull --rebase origin master

重定基，可以是历史更加统一，即使提交历史趋向于一条直线。

补充：他们之间的关系

git pull = git fetch + git merge FETCH_HEAD 

git pull --rebase =  git fetch + git rebase FETCH_HEAD
2.丢弃之前的历史，强推-不推荐

git push -f origin main
原文链接：https://blog.csdn.net/m0_63748493/article/details/125519725
````

