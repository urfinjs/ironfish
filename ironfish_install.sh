#!/bin/bash
apt update && apt upgrade -y < "/dev/null"

curl https://sh.rustup.rs -sSf | sh -s -- -y && . $HOME/.cargo/env && curl https://deb.nodesource.com/setup_16.x | sudo bash && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt install curl make clang pkg-config libssl-dev build-essential git jq nodejs -y < "/dev/null"
npm --force install -g yarn

apt update && apt upgrade -y < "/dev/null"

git clone https://github.com/iron-fish/ironfish && cd $HOME/ironfish
cargo install --force wasm-pack && yarn

cp $HOME/ironfish/ironfish-cli/bin/ironfish /usr/bin

printf "[Unit]
Description=IronFish Node
After=network-online.target
[Service]
User=$USER
ExecStart=/usr/bin/yarn --cwd $HOME/ironfish/ironfish-cli/ start start
Restart=always
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/ironfishd.service

printf "[Unit]
Description=IronFish Miner
After=network-online.target
[Service]
User=$USER
ExecStart=/usr/bin/yarn --cwd $HOME/ironfish/ironfish-cli/ start miners:start -t 2
Restart=always
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/ironfishd-miner.service

systemctl daemon-reload && systemctl enable ironfishd ironfishd-miner && systemctl restart ironfishd ironfishd-miner
