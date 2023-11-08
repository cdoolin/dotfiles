# zmodload zsh/zprof

if [ -e /etc/zsh_command_not_found ]; then
    source /etc/zsh_command_not_found
fi

if which catbat > /dev/null; then
    alias bat='batcat'
fi

if [ -s ~/.config/antigen/antigen.zsh ]; then
    source ~/.config/antigen/antigen.zsh
    
    antigen bundle 'zsh-users/zsh-syntax-highlighting'
    antigen bundle 'zsh-users/zsh-autosuggestions'
    antigen bundle 'zsh-users/zsh-completions'

    antigen apply
fi

if which lsd > /dev/null; then
    alias ls='lsd'
    alias l='lsd -lah'
    alias la='lsd -lAh'
    alias ll='lsd -lh'
fi

if [ -d  ~/.fly ]; then
    export FLYCTL_INSTALL="${HOME}/.fly"                                       
    export PATH="$FLYCTL_INSTALL/bin:$PATH"    
fi

if which fnm > /dev/null; then
    eval "$(fnm env --use-on-cd)"
elif [ -f ~/.nvm/nvm.sh ]; then
    source ~/.nvm/nvm.sh
    source ~/.nvm/bash_completion
fi

if [ -d ~/bin ]; then
    export PATH="$HOME/bin:$PATH"
fi

# fix git branch paging
export LESS=-FRX
alias tf="tmux-sessionizer"

# prevent systemd clearing tmux sessions on logout
if ps -C systemd > /dev/null; then
    alias tmux='systemd-run --scope --user tmux'
fi

if which starship > /dev/null; then
    eval "$(starship init zsh)"
fi

if [ -d ~/.venv/venv ]; then
    source ~/.venv/venv/bin/activate
fi

# zprof
