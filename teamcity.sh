#!/bin/sh

# Install TeamCity
cd ~
wget https://download.jetbrains.com/teamcity/TeamCity-9.0.4.tar.gz
tar xfz TeamCity-9.0.4.tar.gz
cd TeamCity
./bin/teamcity-server.sh start

# Install Build Agent
cd ~
wget http://localhost:8111/update/buildAgent.zip
unzip buildAgent.zip -d ./buildAgent
cd buildAgent
cp ./conf/buildAgent.dist.properties ./conf/buildAgent.properties
chmod u+x ./bin/agent.sh
./bin/agent.sh start
