function get_distro() {
	source /etc/os-release
	echo $NAME
}
DISTRO=$(get_distro)

# If you come from bash you might have to change your $PATH.
export PATH="$HOME/.npmp/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="avit"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  shrink-path
)
source $ZSH/oh-my-zsh.sh
source ~/.cargo/env

fzf_base=/usr/share/doc/fzf
[ -d "$fzf_base" ] || fzf_base=/usr/share/fzf
[ -e "$fzf_base/completion.zsh" ] && source $fzf_base/completion.zsh
[ -e "$fzf_base/key-bindings.zsh" ] && source $fzf_base/key-bindings.zsh

export LS_COLORS='di=01;34;40:ln=01;35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE='$(shrink_path)'
DISABLE_AUTO_TITLE=true

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

zstyle :prompt:shrink_path tilde yes
zstyle :prompt:shrink_path last yes
zstyle :prompt:shrink_path nameddirs yes

function my_precmd {
  emulate -L zsh

  title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
}

function my_preexec {
  emulate -L zsh
  setopt extended_glob

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD=$(basename ${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%})
  local LINE="${2:gs/%/%%}"

  title '$CMD' '%100>...>$LINE%<<'
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd my_precmd
add-zsh-hook preexec my_preexec
unsetopt share_history
setopt inc_append_history_time

if [ "$DISTRO" = "Arch Linux" ]; then
	alias sp="sudo pacman"
	alias p="pacman"
	alias u="sp -Syu"
	alias i="sp -S"
	alias r="sp -Rsc"
	alias qs="p -Ss"
	alias ql="p -Ql"
elif [ "$DISTRO" = "void" ]; then
	alias sxi="sudo xbps-install"
	alias i="sxi"
	alias u="sxi -Su"
	alias sxr="sudo xbps-remove"
	alias r="sxr -Ro"
	alias xq="xbps-query"
	alias qs="xq -Rs"
	alias ql="xq -f"
fi

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
	if [ -x /bin/dircolors ]; then
		eval `dircolors -b ~/.dir_colors`
		alias ls='ls --color=auto'
		alias grep='grep --color=auto'
	fi
	zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}
fi

alias ec='emacsclient -a "" -nw'
alias ecw='emacsclient -a "" -c'
alias eck='emacsclient -e "(kill-emacs)"'
