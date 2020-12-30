function get_distro() {
	source /etc/os-release
	echo $NAME
}

# Set terminal window and tab/icon title
#
# usage: title short_tab_title [long_window_title]
#
# See: http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
# Fully supports screen, iterm, and probably most modern xterm and rxvt
# (In screen, only short_tab_title is used)
# Limited support for Apple Terminal (Terminal can't set window and tab separately)
function title {
  emulate -L zsh
  setopt prompt_subst

  [[ "$EMACS" == *term* ]] && return

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|konsole*|ansi|mlterm*|alacritty|st*|tmux*)
      print -Pn "\e]2;${2:q}\a" # set window name
      print -Pn "\e]1;${1:q}\a" # set tab name
      ;;
    screen*|tmux*)
      print -Pn "\ek${1:q}\e\\" # set screen hardstatus
      ;;
    *)
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;${2:q}\a" # set window name
        print -Pn "\e]1;${1:q}\a" # set tab name
      else
        # Try to use terminfo to set the title
        # If the feature is available set title
        if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
          echoti tsl
          print -Pn "$1"
          echoti fsl
        fi
      fi
      ;;
  esac
}

# Shrink directory paths, e.g. /home/me/foo/bar/quux -> ~/f/b/quux.
shrink_path () {
        setopt localoptions
        setopt rc_quotes null_glob

        typeset -i lastfull=0
        typeset -i short=0
        typeset -i tilde=0
        typeset -i named=0
        typeset -i length=1
        typeset ellipsis=""
        typeset -i quote=0

        if zstyle -t ':prompt:shrink_path' fish; then
                lastfull=1
                short=1
                tilde=1
        fi
        if zstyle -t ':prompt:shrink_path' nameddirs; then
                tilde=1
                named=1
        fi
        zstyle -t ':prompt:shrink_path' last && lastfull=1
        zstyle -t ':prompt:shrink_path' short && short=1
        zstyle -t ':prompt:shrink_path' tilde && tilde=1
        zstyle -t ':prompt:shrink_path' glob && ellipsis='*'
        zstyle -t ':prompt:shrink_path' quote && quote=1

        while [[ $1 == -* ]]; do
                case $1 in
                        --)
                                shift
                                break
                        ;;
                        -f|--fish)
                                lastfull=1
                                short=1
                                tilde=1
                        ;;
                        -h|--help)
                                print 'Usage: shrink_path [-f -l -s -t] [directory]'
                                print ' -f, --fish      fish-simulation, like -l -s -t'
                                print ' -g, --glob      Add asterisk to allow globbing of shrunk path (equivalent to -e "*")'
                                print ' -l, --last      Print the last directory''s full name'
                                print ' -s, --short     Truncate directory names to the number of characters given by -#. Without'
                                print '                 -s, names are truncated without making them ambiguous.'
                                print ' -t, --tilde     Substitute ~ for the home directory'
                                print ' -T, --nameddirs Substitute named directories as well'
                                print ' -#              Truncate each directly to at least this many characters inclusive of the'
                                print '                 ellipsis character(s) (defaulting to 1).'
                                print ' -e SYMBOL       Postfix symbol(s) to indicate that a directory name had been truncated.'
                                print ' -q, --quote     Quote special characters in the shrunk path'
                                print 'The long options can also be set via zstyle, like'
                                print '  zstyle :prompt:shrink_path fish yes'
                                return 0
                        ;;
                        -l|--last) lastfull=1 ;;
                        -s|--short) short=1 ;;
                        -t|--tilde) tilde=1 ;;
                        -T|--nameddirs)
                                tilde=1
                                named=1
                        ;;
                        -[0-9]|-[0-9][0-9])
                                length=${1/-/}
                        ;;
                        -e)
                                shift
                                ellipsis="$1"
                        ;;
                        -g|--glob)
                                ellipsis='*'
                        ;;
                        -q|--quote)
                                quote=1
                        ;;
                esac
                shift
        done

        typeset -i elllen=${#ellipsis}
        typeset -a tree expn
        typeset result part dir=${1-$PWD}
        typeset -i i

        [[ -d $dir ]] || return 0

        if (( named )) {
                for part in ${(k)nameddirs}; {
                        [[ $dir == ${nameddirs[$part]}(/*|) ]] && dir=${dir/#${nameddirs[$part]}/\~$part}
                }
        }
        (( tilde )) && dir=${dir/#$HOME/\~}
        tree=(${(s:/:)dir})
        (
                if [[ $tree[1] == \~* ]] {
                        cd -q ${~tree[1]}
                        result=$tree[1]
                        shift tree
                } else {
                        cd -q /
                }
                for dir in $tree; {
                        if (( lastfull && $#tree == 1 )) {
                                result+="/$tree"
                                break
                        }
                        expn=(a b)
                        part=''
                        i=0
                        until [[ $i -gt 99 || ( $i -ge $((length - ellen)) || $dir == $part ) && ( (( ${#expn} == 1 )) || $dir = $expn ) ]]; do
                                (( i++ ))
                                part+=$dir[$i]
                                expn=($(echo ${part}*(-/)))
                                (( short )) && [[ $i -ge $((length - ellen)) ]] && break
                        done

                        typeset -i dif=$(( ${#dir} - ${#part} - ellen ))
                        if [[ $dif -gt 0 ]]
                        then
                            (( quote )) && part=${(q)part}
                            part+="$ellipsis"
                        else
                            part="$dir"
                            (( quote )) && part=${(q)part}
                        fi
                        result+="/$part"
                        cd -q $dir
                        shift tree
                }
                echo ${result:-/}
        )
}

[[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor

DISTRO=$(get_distro)

# If you come from bash you might have to change your $PATH.
export PATH="$HOME/.npmp/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

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

source ~/.cargo/env

fzf_base=/usr/share/doc/fzf
[ -d "$fzf_base" ] && [ -e "$fzf_base/completion.zsh" ] || fzf_base=/usr/share/fzf
[ -e "$fzf_base/completion.zsh" ] && source $fzf_base/completion.zsh
[ -e "$fzf_base/key-bindings.zsh" ] && source $fzf_base/key-bindings.zsh

export LS_COLORS='di=01;38;2;100;200;250:ln=01;35;40:so=32;40:pi=33;40:ex=01;38;2;255;80;0;47:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE='$(shrink_path)'

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

  title '$CMD' '%15>...>$LINE%<<'
}

function make_targets {
  make -qp "$@" | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort -u
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd my_precmd
add-zsh-hook preexec my_preexec
unsetopt share_history
setopt inc_append_history_time

if [ "$DISTRO" = "Arch Linux" ]; then
	alias sp="sudo pacman --disable-download-timeout"
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
elif [ "$DISTRO" = "Gentoo" ]; then
	alias sp="sudo emerge"
	alias p="emerge"
	alias u="sudo eix-sync; sp -aNDuv @world"
	alias i="sp -av"
	alias qs="eix"
	alias ql="equery f"
	alias r="sp -C"
fi

alias sudo="TERM=tmux sudo"
alias ssh="TERM=tmux ssh"
alias urgh="fuck"
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
	#if [ -x /bin/dircolors ]; then
		#eval `dircolors -b ~/.dir_colors`
		#alias ls='ls --color=auto'
		#alias grep='grep --color=auto'
	#fi
	#zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}
#fi

alias ec='emacsclient -a "" -nw'
alias ecw='emacsclient -a "" -c'
alias eck='emacsclient -e "(kill-emacs)"'

backward-path-segment() {
  local WORDCHARS='*?_[]~=&;!#$%^(){}`@-+|\,. '
  zle backward-word
}

backward-kill-path-segment() {
  local WORDCHARS='*?_[]~=&;!#$%^(){}`@-+|\,. '
  zle backward-kill-word
}

zle -N backward-path-segment
zle -N backward-kill-path-segment

bindkey '\ew' backward-kill-path-segment
if [ -e /home/shui/.nix-profile/etc/profile.d/nix.sh ]; then . /home/shui/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# opam configuration
test -r /home/shui/.opam/opam-init/init.zsh && . /home/shui/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

eval "$(fasd --init auto)"
eval $(thefuck --alias)

export GPG_TTY=$(tty)

source $HOME/.config/prezto/init.zsh

alias ls="lsd -l -F --group-dirs=first"
