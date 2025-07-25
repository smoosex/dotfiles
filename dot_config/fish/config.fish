if status is-interactive
# ╭──────────────────────────────────────────────────────────╮
# │                        vim mode                          │
# ╰──────────────────────────────────────────────────────────╯
  # Commands to run in interactive sessions can go here
  set -g fish_key_bindings fish_vi_key_bindings
  # Emulates vim's cursor shape behavior
  # Set the normal and visual mode cursors to a block
  set fish_cursor_default block
  # Set the insert mode cursor to a line
  set fish_cursor_insert line
  # Set the replace mode cursors to an underscore
  set fish_cursor_replace_one underscore
  set fish_cursor_replace underscore
  # Set the external cursor to a line. The external cursor appears when a command is started.
  # Set the select mode cursor to a line  
  set fish_cursor_external line
  # The following variable can be used to configure cursor shape in
  # visual mode, but due to fish_cursor_default, is redundant here
  set fish_cursor_visual block
  # This binds the sequence j,k to switch to normal mode in vi mode.
  # If you kept it like that, every time you press "j",
  # fish would wait for a "k" or other key to disambiguate
  bind -M insert -m default j,k cancel repaint-mode
end

set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml # starship config path
set -gx PATH "/opt/homebrew/sbin:$PATH"
set -gx PATH "/opt/homebrew/bin:$PATH"
set -gx PATH "/Users/smoose/.local/share/tmux/plugins/tmuxifier/bin" $PATH # tmuxifier plugin
set -gx EDITOR "nvim" # default edirot

set -gx LDFLAGS "-L/opt/homebrew/lib"
set -gx CPPFLAGS "-I/opt/homebrew/include"

starship init fish | source
eval (tmuxifier init - fish)

# YAZI
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

zoxide init fish | source
thefuck --alias | source

# Set up fzf key bindings
fzf --fish | source

# NVIM
alias nvchad="NVIM_APPNAME='nvchad' nvim"
alias lazyvim="NVIM_APPNAME='lazyVim' nvim"
alias astro="NVIM_APPNAME='astroNvim' nvim"
alias kickstart="NVIM_APPNAME='kickstart' nvim"

# GIT
alias gl="git clone"
alias gss="git status"
alias ga="git add"
alias gaa="git add --all"
alias gm="git commit"
alias gmm="git commit -m"
alias gb="git branch"
alias gbr="git branch -r"
alias gk="git checkout"
alias gkb="git checkout -b"
alias gkt="git checkout -t"
alias glg="git log"
alias glgo="git log --oneline"
alias gw="git switch"
