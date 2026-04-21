. /etc/profile

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

PS1="${debian_chroot:+($debian_chroot)}\u@\h:\W\$ "
export PS1

PATH="/data/home/.nvm/versions/node/node-v22.14.0-linux-x64/bin:$PATH"
PATH="/data/home/node_modules/.bin:/data/home/.local/bin:/data/home/bin:$PATH"
export PATH
