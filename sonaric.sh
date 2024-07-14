#!/bin/bash

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export NC='\033[0m'  # No Color

prompt() {
    local message="$1"
    read -p "$message" input
    echo "$input"
}

execute_and_prompt() {
    local message="$1"
    local command="$2"
    echo -e "${YELLOW}${message}${NC}"
    eval "$command"
    echo -e "${GREEN}Done.${NC}"
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo
execute_and_prompt "Updating and upgrading packages..." "sudo apt update -y && sudo apt upgrade -y"
echo
execute_and_prompt "Removing Node.js..." "sudo apt-get remove -y nodejs"
echo
execute_and_prompt "Installing NVM and Node.js LTS..." 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install --lts && nvm use --lts && \
    echo -e "${GREEN}Node.js installed: $(node -v)${NC}"'

sleep 2

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

sleep 2

execute_and_prompt "Updating npm to the latest version..." "npm install -g npm@latest"
echo
execute_and_prompt "Installing Sonaric..." 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/monk-io/sonaric-install/main/linux-install-sonaric.sh)"'
echo
execute_and_prompt "Updating and upgrading Sonaric..." 'sudo apt update -y && sudo apt upgrade -y sonaric'
echo
echo -e "${YELLOW}Checking Sonaric node info...${NC}"
sudo sonaric node-info
echo

SONARIC_IDENTITY_NAME=$(prompt "Enter a name for your Sonaric identity: ")
echo
sonaric identity-export -o "$SONARIC_IDENTITY_NAME.identity"
echo
echo -e "${YELLOW}Checking Sonaric points...${NC}"
sonaric points
echo
echo -e "${YELLOW}You can check Sonaric points by this command :  sudo sonaric points${NC}"
echo
