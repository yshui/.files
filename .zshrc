# Path to your oh-my-zsh configuration.
export EDITOR=vim
[[ $TERM != "screen" && $TERM != "screen-256color" && $TERM != "linux" ]] && unset TMUX && exec tmux
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="my"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="false"
DISABLE_AUTO_UPDATE="true"
# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git grml-port loadkeys zkbd)
source $HOME/env.sh
source $ZSH/oh-my-zsh.sh
export PROMPT=$'%{$terminfo[bold]$fg[cyan]%}%#%{$reset_color%}%{$reset_color%}'
export RPROMPT='%{$reset_color%}${vcs_info_msg_0_}%{$reset_color%}'

export PATH="$PATH:/opt/intel/bin/:/home/shui/.cabal/bin"
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'
export XMODIFIERS="@im=fcitx"
export XIM="fcitx"
export XIM_PROGRAM="fcitx"
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export MPD_HOST=/home/shui/.mpd/socket
export QTDIR=/opt/qt
export LPDEST=HP


export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


if [ "$XAUTHORITY" = "" ]; then
	export XAUTHORITY=~/.Xauthority
fi
if [ -x /bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

if [ ! -d /caches/shui ]; then
	mkdir /caches/shui
fi
if [ ! -d /caches/shui/opera_cache ]; then
	mkdir /caches/shui/opera_cache
fi
[ 999$(pgrep 'watcher.pl') = 999 ] && ~/.utils/watcher.pl /home/shui/dr /home/shui/dr/dr.db.tar.gz
#recollindex -m -x
alias less='less -R'
alias df='df -Th'
alias du='du -h'
alias free='free -m'
alias ll='ls -lha'
alias P='pacman'
alias sP='sudo ~/.utils/pacman'
alias I='sP -Sy'
alias i='sP -S'
alias Ip='sudo powerpill -Sy'
alias U='sP -Syu'
alias u='sP -Su'
alias Up='sudo powerpill -Syu'
alias S='pacman -Ss'
alias M='makepkg --skipinteg -f -c'
alias C='sudo pacman -Scc'
alias L='pacman -Ql'
alias O='pacman -Qo'
alias R='sP -Rsc'
alias Is='sudo srcpac -Syb'
alias is='sudo srcpac -Sb'
alias Us='sudo srcpac -Syub'
alias us='sudo srcpac -Sub'
alias Ps='srcpac'
alias sr='sudo systemctl restart'
alias rr='/usr/bin/R'
alias ugz='tar -zxvf'
alias tmux='tmux -2'
alias reboot='systemctl reboot'
alias -s tar.gz='tar -zxvf'
alias -s pdf=apvlv
alias su='systemctl --user'
alias vi=vim
alias reboot='systemctl reboot -i'
alias poweroff='systemctl poweroff -i'
alias halt='systemctl poweroff -i'

if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
	eval $(dircolors -b ~/.dir_colors)
	zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}
fi
source /etc/makepkg.conf
source ~/.zshkeybinding
source ~/.infinality-settings.sh
autoload bashcompinit
bashcompinit
# Customize to your needs...
