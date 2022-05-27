#!/bin/bash
delay="0.1"
tmux new-session -d -s p10k
tmux send-keys 'p10k configure' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys '1' C-m
sleep $delay
tmux send-keys '2' C-m
sleep $delay
tmux send-keys '1' C-m
sleep $delay
tmux send-keys '1' C-m
sleep $delay
tmux send-keys '2' C-m
sleep $delay
tmux send-keys '1' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys '1' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys 'exit' C-m
sleep $delay

if [ ! -r .p10k.zsh ]
then
        echo 'p10k config file generation failed'
        exit 1
fi
