#!/bin/bash

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
sudo apt-get install -y npm
sudo apt-get install nodejs -y

# Clone project
cd ~/
git clone https://github.com/spring-petclinic/spring-petclinic-angular.git
cd spring-petclinic-angular/

# Install node js
echo N | sudo npm install -g @angular/cli@11.2.11
echo N | ng analytics off
echo N | sudo npm install angular-http-server

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install 12.11.1

# Update configuration
sed -i "s/localhost/$SERVER_IP/g" src/environments/environment.ts src/environments/environment.prod.ts
sed -i "s/9966/$SERVER_PORT/g" src/environments/environment.ts src/environments/environment.prod.ts

# Build project
npm run build -- --prod

# Start server
npx angular-http-server --path ./dist -p $FRONT_PORT &
