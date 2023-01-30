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
   limactl factory-reset default
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
1. Append the following lines after the `mount` section:
   ```yaml
   ssh:
     forwardAgent: true
     forwardX11: true
     forwardX11Trusted: true
   ```
1. Append the following line in the `provision` `mode: user` section:
   ```sh
   curl -sfL https://github.com/zyobum/shell/raw/main/myconfig.sh | bash -s - > /tmp/lima/myconfig.out 2>&1
   ```
1. Append the following line in the `message` section:
   ```
   Install Quartz for X11 support.
   ```
1. Check instance status
   ```sh
   limactl list
   ```
1. Check the progress of provision
   ```sh
   tail -f /tmp/myshell_service.err
   ```
1. Check the progress of myconfig.sh
   ```sh
   tail -f /tmp/lima/myconfig.out
   ```
1. If lima instance status became 'borken'
   ```sh
   limactl stop -f default
   ```
1. Install fonts for Terminal. Follow the instruction here: <https://github.com/romkatv/powerlevel10k#manual-font-installation>
1. Test myshell
   ```sh
   limactl start default
   lima
   ```

1. Run the Shell - In the preference page of the terminal, choose the desired profile - In the 'Startup' section of the 'Shell' tab, check 'Run command' and set the following command:
   ```sh
   /bin/bash -c "$HOME/workspace/myshell/myshell.sh"
   ```
1. Install login autostart. copy 'Startup.cmd' to home directory and assign it as login item.

+ Note: _Do not use `sudo reboot` in the box, the mount points will lost. Use `limactl stop` and `limactl start` instead._
+ Uninstall launch scripte: `launchctl remove my.shell.lima`
+ known issue: `shutdown` or `poweroff` cause the vm to 'Borken' state.
