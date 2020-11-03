function new_session_if_not_exists {
  tmux has-session -t $1
  if [ $? != 0 ]
  then
    tmux new-session -s $1 -d
  fi
}

new_session_if_not_exists soa-systems
new_session_if_not_exists pdpipeline
new_session_if_not_exists providerdirectory
new_session_if_not_exists web
new_session_if_not_exists mobile
new_session_if_not_exists clh-soa-client
new_session_if_not_exists service_config
new_session_if_not_exists vm
new_session_if_not_exists soa-common
new_session_if_not_exists pantry
new_session_if_not_exists config
new_session_if_not_exists mongos

[[ -z "$TMUX" ]] && tmux attach
