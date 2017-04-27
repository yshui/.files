# My dotfiles.

Uhm... So here is my .files.

## Changes
2017 Apr 27:

A lot has changed about how I use my system, so some files are no longer relevant:

* I migrated from zsh to fish.
* No more conky
* No more i3, sorry. I use awesome now. This is because awesome is because all written in Lua, and I can change almost everything I want. No more fighting with upstream over features I want.
* Caps Lock and Control are not swapped using xkbd options.
* I use neovim and [dein.vim](https://github.com/Shougo/dein.vim) now so no need for a separate .vim repo any more

## Some explaination

* I use systemd to manage my user session, see .config/systemd for related files.
* I use a forked version of oh-my-zsh (I haven't changed much though).
* My .conkyrc may not look nice on your desktop.
* My vim colorscheme may not look nice for you either. (Don't criticize my taste!)
* I3 is a good window manager.
* Do mount a tmpfs at /caches.
* .xmodmap swaps your Caps Lock and Control, delete it if you don't like this.
* I made all this config as general as possible. But there are still some specific config. For example, `bind_to_address "/run/user/1000/mpd/socket"` in mpd.conf should be changed to /run/user/$UID/mpd/socket. Sadly mpd doesn't support using shell variables in its config.

## Todo

* Add a zshell complete function for systemctl --user.
