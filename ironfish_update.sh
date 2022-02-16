#!/bin/bash

. $HOME/.bashrc && . $HOME/.bash_profile

mkdir -p $HOME/ironfish_keys
yarn start:once accounts:export $IRONFISH_WALLET $HOME/ironfish_keys/$IRONFISH_WALLET.json
cp -r $HOME/.ironfish/accounts $HOME/ironfish_keys/ironfish_accounts_$(date +%s)

apt update && apt upgrade -y
npm --force install -g yarn

systemctl stop ironfishd ironfishd-miner

rm -r ironfish
git clone https://github.com/iron-fish/ironfish && cd $HOME/ironfish
cargo install --force wasm-pack && yarn

systemctl restart ironfishd ironfishd-miner
