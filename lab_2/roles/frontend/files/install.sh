#!/bin/bash


if [ "$#" -ne 1 ]; then
    echo "Usage: $0 FRONTEND_PORT" >&2
    exit 1
fi

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | sudo -E bash -

export NVM_DIR=$HOME/.nvm
source $NVM_DIR/nvm.sh

sudo chmod 777 $HOME/.nvm

nvm install 16
nvm use 16

npm install -g @angular/cli

npm install --save-dev @angular/cli@latest

npm install angular-http-server

cd spring-petclinic-angular/

npm install

nohup ng serve --host 0.0.0.0 --port ${frontend_port} 1>/dev/null 2>/dev/null &

# npm run build -- --prod

# nohup npx angular-http-server --path ./dist -p "$1" &

echo DONE