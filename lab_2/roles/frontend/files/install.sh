#!/bin/bash

# Install package manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 12.11.1

echo N | npm install -g @angular/cli@latest || true
echo N | npm install || true
echo N | ng analytics off || true

npm install angular-http-server || true
