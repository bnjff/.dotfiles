# dotfiles

Installs and configures zsh (zpresto), tmux, vim, and (optionally) sublime.  

It will also install a zsh source scripts with private (e.g. ip addresses) or local (e.g. system-specific paths) settings, if the corresponding files exists.
Those are expected to be in `$HOME/.dotfiles_private/[private.zsh | local.zsh]`

Install with:  
`install.sh [-s]`

zsh and tmux are heavily customized. The main thing to know:  
* tmux key is `ctrl+a`; pane splits with `-` and `|`
