# zmodload zsh/zprof

alias stm32-activate='source ~/bin/stm32-activate'

# refresh tmux session env variables
if [ -n "$TMUX" ]; then                                                                               
  function refresh {                                                                                
    export DISPLAY="$(/usr/bin/tmux show-env | sed -n 's/^DISPLAY=//p')"
    export SSH_CONNECTION="$(/usr/bin/tmux show-env | sed -n 's/^SSH_CONNECTION=//p')"
  }                                                                                                 
else                                                                                                  
  function refresh { }                                                                              
fi

function preexec() {
    refresh
}

# ubuntu command-not-found utility
if [ -e /etc/zsh_command_not_found ]; then
    source /etc/zsh_command_not_found
fi

# stm32cubeide
if [ -s ~/stm32cubeide/stm32cubeide ]; then
    export PATH="$HOME/stm32cubeide:$PATH"
fi

if which batcat > /dev/null; then
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


if [ -d ~/go/bin ]; then
    export PATH="$HOME/go/bin:$PATH"
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

if [ -d ~/.local/bin ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d ~/bin ]; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d ~/apps ]; then
    export PATH="$HOME/apps:$PATH"
fi

# fix git branch paging
export LESS=-FRX
alias tf="tmux-sessionizer"

# prevent systemd clearing tmux sessions on logout
if ps -C systemd > /dev/null; then
    alias tmux='systemd-run --quiet --scope --user tmux'
fi

if which starship > /dev/null; then
    eval "$(starship init zsh)"
fi

venv() {
    source ~/.venv/venv/bin/activate
}

ipython_check() {
    ipython_path=$(whence -p ipython)

    if [[ -z "$ipython_path" ]]; then
        venv
        ipython_path=$(whence -p ipython)

        if [[ -z "$ipython_path" ]]; then
            echo "ipython still not found after activating the virtual environment."
            return 1
        fi
    fi
    "$ipython_path" "$@"
}

alias ipython=ipython_check
alias pwreset="systemctl --user restart pipewire"

# Find the latest Zig version in ~/zig and add it to PATH
if [ -d "$HOME/zig" ]; then
    LATEST_ZIG=$(ls -d $HOME/zig/zig-linux-x86_64-* | sort -V | tail -n 1)
    if [ -n "$LATEST_ZIG" ]; then
        export PATH="$LATEST_ZIG:$PATH"
    fi
fi

# zprof
