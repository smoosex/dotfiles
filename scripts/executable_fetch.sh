#!/bin/sh

# ————————————————
# 1. 定义颜色前缀
# ————————————————
c=3
b=4

# ————————————————
# 2. 生成 c0…c7 和 b0…b7 转义码
#    - 用 eval 间接扩展变量名
# ————————————————
for prefix in c b; do
  # 获取前缀对应的数值（如 c->3，b->4）
  eval code=\${$prefix}
  i=0
  while [ "$i" -le 7 ]; do
    # 生成 ESC[${code}${i}m
    esc=$(printf '\033[%sm' "${code}${i}")
    # 全局赋值，例如 c0、c1 … 或 b0、b1 …
    eval "${prefix}${i}='${esc}'"
    i=$((i + 1))
  done
done

# ————————————————
# 3. 构造色条（▁▁▁）
# ————————————————
colors=''
i=0
while [ "$i" -le 7 ]; do
  attr=$((30 + i))
  if [ "$bold_flag" ]; then
    colors="$colors$(printf '\033[1;%sm▁▁▁' "${attr}")"
  else
    colors="$colors$(printf '\033[%sm▁▁▁'  "${attr}")"
  fi
  i=$((i + 1))
done

# ————————————————
# 4. 调用 fastfetch 并拆分字段
# ————————————————
OLD_IFS=$IFS
IFS=$'\n'
set -- $(fastfetch --logo none \
    --wm-detect-plugin \
    -s title:os:kernel:wm:initsystem:packages:uptime:memory \
    --os-format '{2} {10} {8}' \
    --wm-format '{4}' \
    --packages-format '{17}(brew) {18}(cask)' \
    --uptime-format '{1}d {2}h {3}m' \
    --memory-format '{1} / {2}')
IFS=$OLD_IFS
title="$1"
user=${title%@*}
host=${title#*@}
os="${2#OS: }"
kernel="${3#Kernel: }"
wm="${4#WM: }"
init="${5#Init System: }"
pkgs="${6#Packages: }"
uptime="${7#Uptime: }"
mem="${8#Memory: }"

# 从环境变量中获取 shell 名称
shell="${SHELL##*/}"

# ————————————————
# 5. 输出主界面
# ————————————————
cat <<EOF
${c0} ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
${c0} ▎▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▎ ${c2}  ${c3}󰮕 ${c1} 󰅙 ${c0}▎ ${c1}${c4}${c1} ${c4}$user@${c1}$host
${c0} ▎                            ▎
${c0} ▎        ${c4}█▀▀▀▀▀▀▀▀▀█${c0}         ▎ ${c4}OS     ${c7} $os
${c0} ▎        ${c4}█         █${c0}         ▎ ${c4}Kernel ${c7} $kernel
${c0} ▎        ${c4}█  █   █  █${c0}         ▎ ${c4}WM     ${c7} $wm
${c0} ▎        ${c0}█         █${c0}         ▎ ${c4}Shell  ${c7} $shell
${c0} ▎        ${c0}▀█▄▄▄▄▄▄▄█▀${c0}         ▎ ${c4}Init   ${c7} $init
${c0} ▎                            ▎ ${c4}pkgs   ${c7} $pkgs
${c0} ▎                            ▎ ${c4}uptime ${c7} $uptime
${c0} ▎  ${c3} ${c4}arch    systemd ^_^  ${c0} ▎ ${c4}memory ${c7} $mem
${c0} ▎▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▎ $colors
EOF
