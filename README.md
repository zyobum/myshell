# A ubuntu shell for macOS

1. Clone the repository
   ```sh
   git clone git@github.com:zyobum/shell.git ~/workspace/myshell
   ```
1. Install 'lima'
   ```sh
   brew install lima
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
      - location: "~/.ssh"
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

1. Reboot instance
   ```sh
   limactl stop
   limactl start
   ```
1. Install fonts for Terminal. Follow the instruction here: <https://github.com/romkatv/powerlevel10k#manual-font-installation>

1. Run the Shell - In the preference page of the terminal, choose the desired profile - In the 'Startup' section of the 'Shell' tab, check 'Run command', 'Run inside shell' and set the following command:
   ```sh
   /opt/homebrew/bin/limactl shell default
   ```
   or, in intel Mac,
   ```sh
   /usr/local/bin/limactl shell default
   ```
