. /etc/profile

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

PATH="/data/home/node_modules/.bin:$PATH"
export PATH
