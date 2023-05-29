function new_session_if_not_exists {
  tmux has-session -t $1
  if [ $? != 0 ]
  then
    tmux new-session -s $1 -d
  fi
}

new_session_if_not_exists soa-systems
new_session_if_not_exists indexing-service
new_session_if_not_exists providerdirectory-service
new_session_if_not_exists service_configuration
new_session_if_not_exists soa-common
new_session_if_not_exists pricing-airflow
new_session_if_not_exists dataenv
new_session_if_not_exists pyrevenge
new_session_if_not_exists ikkuna
new_session_if_not_exists phoenix
new_session_if_not_exists vm

[[ -z "$TMUX" ]] && tmux attach
