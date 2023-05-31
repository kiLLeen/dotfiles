source $HOME/.zprofile

# If not running interactively, do not do anything
[[ $- != *i* ]] && return
[[ -z "$TMUX" ]] && tmux attach
#if [ -n "$TMUX" ]; then
#  PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
#fi

export PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{32}%3~%f%b %# '
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
export RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{32}(%b) %r%f'
zstyle ':vcs_info:*' enable git

# don't put duplicate lines or lines that start with a blank space in the history. See bash(1)
export HISTFILE=~/.zsh_history
export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export HISTFILESIZE=100000
export SAVEHIST=100000
setopt SHARE_HISTORY
setopt HIST_FIND_NO_DUPS

#-----------------------------------
# Portable Aliases
#-----------------------------------

alias grep='grep --color'
alias l='ls -lh'
alias ls='ls -lGHFah'
alias la='ls -lGah'
alias ...='cd ../..'
alias ....='cd ../../..'
alias h='history'
alias whereami='curl -s http://api.hostip.info/get_html.php?ip=$1'
alias externalip="wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
alias path='echo -e ${PATH//:/\\n}'
alias vi='vim'
alias edit='vim'
alias svi='sudo vi'
alias ports='netstat -tulap tcp'
alias durev='du -s * | sort -rn'
alias httpdreload='sudo /usr/sbin/apachectl -k graceful'
alias t='tmux attach || tmux'
alias psgrep='ps aux | grep -v grep | grep "$@" -i --color=auto'
alias hgrep='h | grep --color=auto'
alias mostused='cut -f1 -d" " ~/.bash_history | sort | uniq -c | sort -nr | head -n 30'

#-----------------------------------
# Castlight Aliases
#-----------------------------------
alias  serv="svc.sh event account proxy benefits reviews pastcare configurator reward drug search providerdirectory providerdetail classifier pricing careteam kill,clean,clean-deploy,upgrade"
alias  killserv="svc.sh event account proxy benefits reviews pastcare configurator reward drug search providerdirectory providerdetail classifier pricing careteam kill"
alias svcb=svc_build
alias prodsys='cd ~/Projects/Ventana/prodsys'
alias act='cd ~/Projects/Ventana/action'
alias vent='cd ~/Projects/Ventana/ventana'
alias ikkuna='cd ~/Projects/Ventana/ventana/ikkuna'
alias shared='cd ~/Projects/Ventana/clh-soa-client'
alias config='cd ~/Projects/Ventana/config_master'
alias pantry='cd ~/Projects/Ventana/pantry'
alias mobile='cd ~/Projects/Ventana/phoenix'
alias soa='cd ~/Projects/Ventana/soa-systems'
alias sc='script/console'
alias startpg='pg_ctl -D /var/db/pgsql/data -l /var/db/pgsql/server.log start'
alias stoppg='pg_ctl -D /var/db/pgsql/data stop -s -m fast'
alias startmongo='mongod --config /etc/mongodb/mongodb.conf'
alias startmongo2='mongod --config /etc/mongodb/mongodb2.conf'
alias startmongo3='mongod --config /etc/mongodb/mongodb3.conf'
alias stopmongo='killall mongod'
alias startmemcached='/usr/bin/memcached -d -p 11211'
alias ssh3='ssh -p3389'
alias scp3='scp -P3389'
CLH_ENV=development
alias my='mysql -uroot ventana_$CLH_ENV'
alias jd='ssh3 den-jh01'
alias jp='ssh3 phx-jh01'
alias runningservices='ps aux | grep java | grep -E -o "/[a-z]*/deploy" | uniq | sort | sed -e "s|/deploy||" -e "s|/||"'
alias svcs=svc_list
alias getpriceableservers='curl "http://localhost:8180/pricingservice/getpriceableservers"'

#-----------------------------------
# OS X Aliases
#-----------------------------------

alias psmem='ps aux | sort -nr -k 4'
alias pscpu='ps aux | sort -nr -k 3'

# Top 10 memory and CPU consuming processes. Good for Geektool. On Linux, use auxf.
alias psmem10='ps aux | sort -nr -k 4 | head -10'
alias pscpu10='ps aux | sort -nr -k 3 | head -10'

# a less cpu intensive top. BSD-specific?
alias ttop='top -ocpu -R -F -s 2 -n30'


# Delete all .DS_Store files in current dir and its children
alias ds_store_rm='find . -name '.DS_Store' -print0 | xargs -t0 rm'


#-----------------------------
# Machine Specific Functions
#   i.e., may require additional setup of MySQL, Python, Java, etc.
#-----------------------------

# Log SQL statements. If local MySQL, you must connect with --protocol=tcp.  Assumes Wireshark installed.
alias mysqllog="sudo tshark -i lo0 -V -f 'dst port 3306' | egrep 'Statement:|Statement \[truncated\]:'"

# Start and stop MySQL. This usually works if the OS X installer was used.
alias mysql_start="/Library/StartupItems/MySQLCOM/MySQLCOM start"
alias mysql_stop="/Library/StartupItems/MySQLCOM/MySQLCOM stop"

#-----------------------------------
# Portable Functions
#-----------------------------------

function gitlines() {
  local temp_ifs=$IFS;
  local temp_lc_all=$LC_ALL
  IFS="|"
  LC_ALL="C"
  local args="$*"

  git ls-tree -r HEAD | \
    gsed -re 's/^.{53}//' | \
    while read filename; do file "$filename"; done | \
      grep -E ".*\.(${args})" | \
      gsed -r -e 's/: .*//' | \
      while read filename; do git blame -w "$filename"; done | \
        gsed -r -e 's/.*\((.*)[0-9]{4}-[0-9]{2}-[0-9]{2} .*/\1/' -e 's/ +$//' | \
        sort -gif | uniq -c

  IFS=${temp_ifs}
  LC_ALL=${temp_lc_all}
}

# cd's up directory path by the specified number of levels. Defaults to 1.
function ..() {
  local arg=${1:-1};
  while [ $arg -gt 0 ]; do
    cd .. >&/dev/null;
    arg=$(($arg - 1));
  done
}

function svc_list() {
  ant -f $SOAS_HOME/build.xml list-running-services;
}

# build and run the service provided in the argument
function svc_build() {
  for var in "$@"
  do
    ant -f $SOAS_HOME/libraries/${var}service/build.xml clean provide;
  done
  $SOAS_HOME/sysdefs/bin/svc.sh $@ kill,clean,clean-deploy,upgrade
}

function logs() {
   local defaultservices=$(find ${SOA_HOME}/services -iregex '.*service' -depth 1 | sed 's/^\(.*[\\\/]\)//g' | sed 's/service//g')
   local fullpath
   local services
   local currentlogpath

   if [ $# -gt 0 ]; then
      services=$*
   else
      services=${defaultservices[*]}
   fi
   for log in $services; do
     currentlogpath="$SOA_HOME/services/${log}service/output/logs"
     fullpath+=("$currentlogpath/${log}service.log")
   done
   $EDITOR -pR $fullpath
}

# Usage:
#    $ some_command ; notify
# After the command finishes, email is sent to space-delimited list of email addresses in mail variable
# Especially useful if you use a mobile carrier address that sends you a text message
# For example, nnnnnnnnnn@messaging.sprintpcs.com
function notify() {
  # NOTE!!! Set mail var to desired list of email addresses.
  mail="nkilleen@gmail.com"
  str1="`history 1 | cut -b 8-`"
  str2="${str1%;*}"
  echo ${str2} | mail -s CMD_FINISH ${mail}
}

# bash function to decompress archives - http://www.shell-fu.org/lister.php?id=375  
function extract() {  
  if [ -f $1 ] ; then 
    case $1 in  
      *.tar.bz2)   tar xvjf $1    ;;  
      *.tar.gz) tar xvzf $1 ;;  
      *.bz2) bunzip2 $1 ;;  
      *.rar) unrar x $1 ;;  
      *.gz) gunzip $1 ;;  
      *.tar) tar xvf $1 ;;  
      *.tbz2) tar xvjf $1 ;;  
      *.tgz) tar xvzf $1 ;;  
      *.txz) tar xfJ $1 ;;
      *.zip) unzip $1 ;;  
      *.Z) uncompress $1 ;;  
      *.7z) 7z x $1 ;;  
      *) echo "'$1' cannot be extracted via >extract<" ;;  
    esac  
  else  
    echo "'$1' is not a valid file"  
  fi  
}

# highlight search term when tailing log
# arg1 = file
# arg2 = search term
function tailsearch() { 
  tail -f $1 | perl -pe "s/$2/\e[1;31;43m$&\e[0m/g"
}

#-------------------------
# OS X Specific Functions
#-------------------------
# Quit OS X apps from command line.
# vararg = app names
function quit() {
  for app in $*; do
    osascript -e 'quit app "'$app'"'
  done
}

# Relaunch OS X apps from command line.
# vararg = app names
function relaunch() {
  for app in $*; do
    osascript -e 'quit app "'$app'"';
    sleep 3;
    open -a $app
  done
}

# spotlight powered locate
function slocate() {
  mdfind "kMDItemDisplayName == '$@'wc";
}

# cd's to frontmost window of Finder
function cdf() {
  cd "`osascript -e 'tell application "Finder"' \
  -e 'set myname to POSIX path of (target of window 1 as alias)' \
  -e 'end tell' 2>/dev/null`"
}

# Moves files to trash, rather than immediately deleting them
function trash () {
  local path
  for path in "$@"; do
    # ignore any arguments
    if [[ "$path" = -* ]];
    then :
    else local dst=${path##*/}
      # append the time if necessary
      while [ -e ~/.Trash/"$dst" ]; do
        dst="$dst "$(date +%H-%M-%S)
      done
      mv "$path" ~/.Trash/"$dst"
    fi
  done
}

# Lists 10 branches with the most recent commits on them by any author
function recent_branches {
  git for-each-ref --sort=-committerdate refs/heads/ | head -${1:-10}
}

# Pretty prints JSON from one file to another, or to stdout
# arg1 = file name with ugly JSON
# arg2 = file name to which to write pretty JSON.  If none specified, write to stdout.
function prettyjson() {
  if [ "$2" != "" ]; then
    cat $1 | python -mjson.tool > $2
  else
    cat $1 | python -mjson.tool 2>&1
  fi
}

# Return list of queries actually executing on a MySQL server
# arg1 = user
# arg2 = host, will use localhost if omitted
function dbq() {
  echo "SHOW PROCESSLIST" | mysql -u $1 -h ${2:-localhost} -p -t | grep -E "(^\| Id|^\+|Query)"
}

# Display JVM heap stats for specified service (e.g., pricing)
# Update path as necessary to JVM used by SOA
function heap() {
  SVC=$1
  P_PID=`ps aux | grep $SVC"service/deploy/runtime/endorsed" | grep -v grep | awk '{ print $2 }'`
  sudo $JAVA_HOME/bin/jmap -heap $P_PID
}

# Display summary of CMS collector part of JVM heap stats for specified service (e.g., pricing)
# Update path as necessary to JVM used by SOA
function heapsummary() {
  SVC=$1
  P_PID=`ps aux | grep $SVC"service/deploy/runtime/endorsed" | grep -v grep | awk '{ print $2 }'`
  sudo $JAVA_HOME/bin/jmap -heap $P_PID | grep "concurrent mark-sweep generation" -A4
}

function geocode() {
  curl -G --data-urlencode "address=${1}" http://maps.googleapis.com/maps/api/geocode/json
}

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="flazz"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

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

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git tmux)

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

if [ -d "$ZSH" ]; then
  source $ZSH/oh-my-zsh.sh
fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='nvr'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export PATH="/usr/local/opt/postgresql@9.4/bin:$PATH"
export PATH="/usr/local/opt/node@6/bin:$PATH"
export PATH="/usr/local/opt/percona-server@5.6/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.1.0/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.2.0/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
which npm > /dev/null && export PATH="$(npm config get prefix)/bin:$PATH"

which brew > /dev/null && export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.0)"

echo ".zshrc loaded"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
#if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi
#
export PATH="/usr/local/opt/mongodb-community@4.0/bin:$PATH"
export PATH="/usr/local/opt/mongodb-community@5.0/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
