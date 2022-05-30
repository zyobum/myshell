# A ubuntu shell for macOS

  1. Clone the repository

         git clone git@github.com:zyobum/shell.git
  1. Build the image

         docker build -t="jayzhuang/shell" .
  1. Run the container:

         docker run -itd --privileged --restart always jayzhuang/shell
  1. Install fonts. Follow the instruction here: https://github.com/romkatv/powerlevel10k#manual-font-installation

  1. Run the Shell
    - In the preference page of the terminal, choose the desired profile
    - In the "Shell" tab, check 'Run' and set the following command in the 'Startup' section

           /usr/local/bin/docker exec -it <container-id> su -
