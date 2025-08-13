#!/bin/sh

TYPE=$(
  gum filter "feat: 增加了一个新功能（feature）" \
    "fix: 修复了一个 bug" \
    "perf: 优化性能" \
    "docs: 只修改了文档" \
    "style: 代码格式（不影响功能，比如空格、分号等格式修正）" \
    "refactor: 重构代码（既不是新增功能，也不是修复 bug）" \
    "test: 添加或修改测试用例" \
    "chore: 构建过程或辅助工具的变动（不影响源代码、测试用例）" \
    "build: 影响构建系统或外部依赖（例如 gulp、npm、yarn 等）" \
    "ci: 修改 CI 配置、脚本" \
    "revert: 回滚到上一个版本" \
    "wip: 该提交或分支尚未完成，可能存在不稳定或未完善的代码"
)

# Extract the type from the selected option
TYPE=${TYPE%%:*}
SCOPE=$(gum input --placeholder "scope")

# Since the scope is optional, wrap it in parentheses if it has a value.
test -n "$SCOPE" && SCOPE="($SCOPE)"

# Pre-populate the input with the type(scope): so that the user may change it
SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change")
DESCRIPTION=$(gum write --placeholder "Details of this change")

# Commit these changes if user confirms
gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION"
