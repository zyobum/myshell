# /bin/zsh
delay="0.1"
tmux new-session -d -s gitstatus
tmux send-keys 'su -' C-m
sleep $delay
tmux send-keys 'tmux wait -S fin' C-m
sleep $delay
tmux send-keys 'exit' C-m
sleep $delay
tmux send-keys 'exit' C-m
sleep $delay

tmux wait fin

if [ ! -d $HOME/.cache/gitstatus/ ]
then
        echo 'gitstatus init failed'
        exit 1
fi
