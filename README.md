# A ubuntu shell for macOS

  1. Clone the repository

         git clone git@github.com:zyobum/shell.git
  1. Build the image

         docker build -t="jayzhuang/shell" .
  1. Run the container:

         docker run -d --privileged --restart always --name myshell --mount type=bind,source=$HOME/.ssh,target=/root/.ssh --mount type=bind,source=$HOME/Downloads,target=/root/Downloads --mount type=bind,source=$HOME/workspace,target=/root/workspace jayzhuang/shell
  1. Install fonts. Follow the instruction here: https://github.com/romkatv/powerlevel10k#manual-font-installation

  1. Run the Shell
    - In the preference page of the terminal, choose the desired profile
    - In the 'Startup' section of the 'Shell' tab, check 'Run command','Run inside shell' and set the following command:

           /usr/local/bin/docker exec -it $(/usr/local/bin/docker ps -lqf "name=myshell") su -
