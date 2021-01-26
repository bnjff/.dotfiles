# dotfiles

Installs and configures zsh (zpresto), tmux, vim, and (optionally) sublime.

It will also install zsh source scripts with private (e.g. ip addresses) or local (e.g. system-specific paths) settings, if the corresponding files exists.
Those are expected to be in `$HOME/.dotfiles_private/[private.zsh | local.zsh]`

Install with:
`install.sh [-s n t]`

* -s option to copy sublime settings
* -n option to avoid installing apt packages (e.g. if you don't have sudo permissions)
* -t build and install a local version of tmux (current tmux configs in this repo are tested with tmux>=3.0, so building tmux is suggested on older systems)

Start a new terminal session after the install.  

Some tmux shortcuts are customized. They are commented in `tmux/tmux.conf`. The main thing to know:
* tmux prefix key is `ctrl+a`; pane splits with `-` and `|`

Zsh is extended with useful plugins, notably git and utility. The list of [git aliases](https://github.com/sorin-ionescu/prezto/tree/master/modules/git) (e.g. `gcm` for `git commit -m`) and [utility aliases](https://github.com/sorin-ionescu/prezto/tree/master/modules/utility), can be accessed at the linked locations on github.
