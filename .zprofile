#!/bin/zsh

# Increase limit on files open per process
ulimit -n 4096

export ECLIPSE_HOME=/Applications/eclipse
export SOAS_HOME=~/Projects/Ventana/soa-systems
export APP_SCRIPTS_HOME=~/Projects/Ventana/app_scripts
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export CLH_ENV=development

export PATH=$PATH:$SOAS_HOME/sysdefs/bin:$APP_SCRIPTS_HOME/build:$APP_SCRIPTS_HOME/ops:$APP_SCRIPTS_HOME/build


# Prevent Java 7 from launching undesired windows
export JAVA_OPTS="-Djava.awt.headless=true"


# Set up environment variables for Castlight Java development
if [ -d "$SOAS_HOME" ]; then
  pushd $SOAS_HOME
  source castlight_env.sh
  popd
fi


export PATH=/usr/local/bin:$PATH
export USE_ARTIFACTORY=1

# Delete orphaned shows
alias rm_unzipped_shows='mkdir -p ~/movies_to_delete && find -E . -type f -iregex ".*/*\.(mkv|avi|mov|mpg)$" -mindepth 2 -print0 | xargs -0 -I{} dirname {} | xargs -I{} find -E {} -maxdepth 1 -iregex ".*/*\.(rar|zip)$" -print0 | xargs -0 -I{} dirname {} | xargs -I{} find -E {} -maxdepth 1 -iregex ".*/*\.(mkv|avi|mov|mpg)$" | grep -v sample | xargs -I{} mv {} ~/movies_to_delete'
alias rm_show_no_torrent='mkdir -p ~/movies_to_delete && find -E **/ -type f -iregex ".*/*\.(mkv|avi|mov|mpg)$" -maxdepth 1 -print0 | xargs -0 -I{} dirname {} > dirs.txt && xargs -I{} find . -maxdepth 1 -type f -iname "{}.torrent" < dirs.txt > torrents.txt && cat dirs.txt | xargs -I{} bash -c "if !(grep -qa {} torrents.txt); then mv {} ~/movies_to_delete; fi"'

echo ".zprofile loaded"
