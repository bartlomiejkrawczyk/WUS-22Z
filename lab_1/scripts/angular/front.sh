set -euxo pipefail

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 SERVER_IP SERVER_PORT FRONT_PORT" >&2
    exit 1
fi

SERVER_IP="$1"
SERVER_PORT="$2"
FRONT_PORT="$3"

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y npm
sudo apt-get install nodejs -y

echo N | npm install -g @angular/cli@11.2.11
echo N | ng analytics off

git clone https://github.com/spring-petclinic/spring-petclinic-angular.git

cd spring-petclinic-angular/
sed -i "s/localhost/$SERVER_IP/g" src/environments/environment.ts src/environments/environment.prod.ts
sed -i "s/9966/$SERVER_PORT/g" src/environments/environment.ts src/environments/environment.prod.ts

npm install angular-http-server

npm run build -- --prod

npx angular-http-server --path ./dist -p $FRONT_PORT