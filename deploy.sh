#!/bin/sh
ssh-agent bash -c 'ssh-add ~/.ssh/deploy_rsa; git pull'
rm -rvf dist/
npm run build
cd dist && tar zxvf *.tar.gz
cd bundle/programs/server && npm install
rm -rfv npm/npm-bcrypt
cd .. && npm install bcrypt
