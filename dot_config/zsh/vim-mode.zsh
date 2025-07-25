################################### custom vi mode ###################################
# 启用 vi 模式
bindkey -v

# jk 快捷从 insert 模式回到 normal(vicmd) 模式
bindkey -M viins 'jk' vi-cmd-mode

# 切换模式时更新光标形状
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    print -nP "\e[2 q"
  else
    print -nP "\e[6 q"
  fi
}
zle -N zle-keymap-select

# 每次新行强制进入 insert 模式并更新光标
function zle-line-init {
  zle -K viins
  zle-keymap-select
}
zle -N zle-line-init

# 补上 viins 下的退格键绑定
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# 修改替换模式下光标为下划线
__zle_vi_replace_chars_wrapper() {
  print -nP "\e[4 q"    # 下划线
  zle .vi-replace-chars  # 调用原生替换
  print -nP "\e[2 q"    # 恢复 block
}
zle -N vi-replace-chars __zle_vi_replace_chars_wrapper
###################################################################################

################################### zsh-vi-mode ###################################
# https://github.com/jeffreytse/zsh-vi-mode
# source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# ZVM_INIT_MODE=sourcing
# ZVM_VI_EDITOR=nvim
# ZVM_VI_HIGHLIGHT_FOREGROUND=#F3F4F6           # Hex value
# ZVM_VI_HIGHLIGHT_BACKGROUND=#323948           # Hex value
#
# ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
###################################################################################
