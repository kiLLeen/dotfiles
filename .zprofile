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
pushd $SOAS_HOME
source castlight_env.sh
popd


# Set up rvm and ruby
export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH=/usr/local/bin:$PATH
export USE_ARTIFACTORY=1

rvm use ruby-2.1.2

echo ".zprofile loaded"
