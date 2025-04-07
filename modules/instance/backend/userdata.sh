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


mkdir -p /opt/springboot /opt/images
cd /opt/springboot 
aws s3 cp s3://mybucket-ces-joyuri/joyuri/application.properties .
aws s3 cp s3://mybucket-ces-joyuri/joyuri/images.zip /opt/images/images.zip
unzip /opt/images/images.zip -d /opt/images/
rm -rf /opt/images/images.zip

cat <<EOF >> application.properties
frontend-url=http://${front_DNS}
spring.datasource.url=jdbc:mariadb://${DB_DNS}/project_dev?characterEncoding=utf8mb4&serverTimezone=Asia/Seoul
multipart.image.url=/opt/images/
image.upload-dir=/opt/images/
server.port=8080
spring.jpa.hibernate.ddl-auto=update
EOF

