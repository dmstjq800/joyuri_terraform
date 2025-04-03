#!/bin/bash
### 지바 설치 및 설정
yum -y install java-21-amazon-corretto-devel.x86_64 
echo "JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto.x86_64/" >> /etc/profile
echo "export JAVA_HOME" >> /etc/profile
echo "PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
echo "export PATH" >> /etc/profile

yum install -y ruby
cd /home/ec2-user
wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto

# CodeDeploy 에이전트 시작
systemctl start codedeploy-agent
systemctl enable codedeploy-agent


mkdir -p /opt/springboot
cd /opt/springboot
aws s3 cp s3://mybucket-ces-joyuri/joyuri/application.properties .
aws s3 cp s3://mybucket-ces-joyuri/joyuri/joyuri.jar .
cat <<EOF >> application.properties
frontend-url=${front_DNS}
spring.datasource.url=jdbc:mariadb://${DB_DNS}/project_dev?characterEncoding=utf8mb4&serverTimezone=Asia/Seoul
EOF

cat <<EOF > /etc/systemd/system/springboot.service
[Unit]
Description=Joyuri Spring Boot App
After=network.target

[Service]
User=ec2-user
ExecStart=/usr/bin/java -jar /opt/springboot/joyuri.jar \
  --spring.config.location=file:/opt/springboot/application.properties
SuccessExitStatus=143
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# ALTER DATABASE project_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
