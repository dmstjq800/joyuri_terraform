# CodeDeply Agent 설치
#!/bin/bash
yum install -y ruby
cd /home/ec2-user
wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto

# CodeDeploy 에이전트 시작
systemctl start codedeploy-agent
systemctl enable codedeploy-agent

# Node js 설치
yum -y install npm 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
. ~/.bashrc

mkdir -p /joyuri
cd /joyuri

# 환경설정 파일
cat <<EOF > .env.production
NEXT_PUBLIC_API_BASED_URL = http://${backend_DNS}
EOF
