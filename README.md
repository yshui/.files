# My dotfiles.

Uhm... So here is my .files.

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
