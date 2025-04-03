#!/bin/bash

yum -y install npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
. ~/.bashrc

mkdir -p /joyuri
cd /joyuri

cat <<EOF >> application.properties
NEXT_PUBLIC_API_BASED_URL = ${backend_DNS}
EOF