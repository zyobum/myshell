# A ubuntu shell for macOS

  * Clone repository

        git clone git@github.com:zyobum/shell.git
  * Build image

        docker build -t="jayzhuang/shell" .
  * Run container:

        docker run -itd --privileged --restart always jayzhuang/shell
  * Run shell
    - In the preference page of the terminal, choose the desired profile
    - In the "Shell" tab, check 'Run' and set the following command in the 'Startup' section

          /usr/local/bin/docker exec -it <container-id> su -
