# A ubuntu shell for macOS

1. Clone the repository
   ```sh
   git clone git@github.com:zyobum/shell.git ~/workspace/myshell
   ```
1. Install 'lima' and required packages.
   ```sh
   brew install lima jq
   ```
1. Start new instance with pre-definedlib example:docker
   ```sh
   limactl start --name=default template://docker
   ```
1. Stop the docker instance
   ```sh
   limactl stop
   ```
1. Modify mount points. Put following lines in the mount section of `~/.lima/default/lima.yaml`

   1. Remove "~" home folder

   1. Add following mount point
      ```yaml
      - location: "~/.ssh/myshell_keys"
        writable: true
      - location: "~/workspace"
        writable: true
      - location: "~/Downloads"
        writable: true
      ```
1. Run setup script
   ```sh
   limactl start
   lima ~/workspace/myshell/myconfig.sh
   ```
1. Install login autostart
   ```sh
   ln -s ~/workspace/myshell/my.shell.lima.plist ~/Library/LaunchAgents/
   launchctl load ~/Library/LaunchAgents/my.shell.lima.plist
   ```
1. Check instance status
   ```sh
   limactl list
   ```
1. Install fonts for Terminal. Follow the instruction here: <https://github.com/romkatv/powerlevel10k#manual-font-installation>

1. Run the Shell - In the preference page of the terminal, choose the desired profile - In the 'Startup' section of the 'Shell' tab, check 'Run command', 'Run inside shell' and set the following command:
   ```sh
   /bin/zsh -c "$HOME/workspace/myshell/myshell.sh"
   ```

+ Note: _Do not use `sudo reboot` in the box, the mount points will lost. Use `sudo poweroff` and `limactl start` instead_
+ Uninstall launch scripte: `launchctl remove my.shell.lima`
