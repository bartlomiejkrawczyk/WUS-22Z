SERVER_IP=localhost
SERVER_PORT=8000
FRONT_PORT=8080

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install nodejs -y

npm cache clean
sudo npm install -g @angular/cli@14.17.3 -y

git clone https://github.com/spring-petclinic/spring-petclinic-angular.git

cd spring-petclinic-angular/
sed -i "s/localhost/$SERVER_IP/g" src/environments/environment.ts src/environments/environment.prod.ts
sed -i "s/9966/$SERVER_PORT/g" src/environments/environment.ts src/environments/environment.prod.ts

npm run build -- --prod

npm install angular-http-server

npx angular-http-server --path ./dist -p $FRONT_PORT

# npm install --save-dev @types/node 
# npm install --save-dev @angular/cli@latest -y
# npm install





