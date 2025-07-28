# 0. 获取当前分支名称，并非 hash
current_branch=$(git symbolic-ref --short HEAD)

# 1. 切换到 release 分支
git checkout release

# 2. 清空旧内容（可选，如果你希望完全重来）
git rm -rf .

# 3. 从 emacs-mix 分支拷贝所有文件快照
git checkout emacs-mix -- .

# 4. 提交新的快照（不带 emacs-mix 历史）
git commit -am "Replace release with snapshot from emacs-mix"

# 5. 推送到 release 分支
git push release release --force

# 6. 切换回原来的分支
git checkout "$current_branch"
