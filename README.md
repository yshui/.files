# My dotfiles.

Uhm... So here is my .files.

## Changes
2018 Jul:

* systemd services are gone now. Intention is to use [deai](https://github.com/yshui/deai) for everything for now on (it still has some missing features, dogfooding should push me to finish them)
* Am trying out [kakoune](https://github.com/mawww/kakoune)

2017 Apr:

A lot has changed about how I use my system, so some files are no longer relevant:

* I migrated from zsh to fish.
* No more conky
* No more i3, sorry. I use awesome now. This is because awesome has a very flexible configuration interface, and I can change almost everything I want. No more fighting with upstream over features I want.
* Caps Lock and Control are not swapped using xkbd options.
* I use neovim and [dein.vim](https://github.com/Shougo/dein.vim) now so no need for a separate .vim repo any more

## Some explaination

* ~~I use systemd to manage my user session, see .config/systemd for related files.~~
* ~~I use a forked version of oh-my-zsh.~~
* i3 is a good window manager.
* I made all this config as general as possible. But there are still some specific config. For example, `bind_to_address "/run/user/1000/mpd/socket"` in mpd.conf should be changed to /run/user/$UID/mpd/socket. Sadly mpd doesn't support using shell variables in its config.

