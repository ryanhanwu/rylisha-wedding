# Rylisha Wedding

## Pull
```
ssh-agent bash -c 'ssh-add ~/.ssh/deploy_rsa; git pull'
```


## Build

* Ubuntu Only

```
sudo apt-get install libcurl4-openssl-dev
```

### Normal

```
./deploy.sh
export METEOR_SETTINGS="$(cat settings.json)"
pm2 start process.json
```
