#!/bin/bash

set -x

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 SERVER_IP SERVER_PORT FRONT_PORT" >&2
    exit 1
fi

SERVER_IP="$1"
SERVER_PORT="$2"
FRONT_PORT="$3"

# Instalation
sudo apt-get update
sudo apt-get upgrade -y
sudo apt autoremove -y
sudo apt-get install curl -y
sudo apt-get install npm -y

export HOME=/root

# Install package manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 12.11.1

# Clone project
cd ~/
git clone https://github.com/spring-petclinic/spring-petclinic-angular.git
cd spring-petclinic-angular/

# Update configuration
sed -i "s/localhost/$SERVER_IP/g" src/environments/environment.ts src/environments/environment.prod.ts
sed -i "s/9966/$SERVER_PORT/g" src/environments/environment.ts src/environments/environment.prod.ts

echo N | npm install -g @angular/cli@latest
echo N | npm install
echo N | ng analytics off

npm install angular-http-server

# Build project
npm run build -- --prod

# Start server
npx angular-http-server --path ./dist -p $FRONT_PORT &
