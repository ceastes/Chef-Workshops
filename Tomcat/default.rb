#
# Cookbook:: Tomcat
# Recipe:: default
# Chris Eastes
#
# Copyright:: 2017, The Authors, All Rights Reserved.
# Installation Instructions

#* To install OpenJDK 7 JDK using yum, run this command:
# sudo yum install java-1.7.0-openjdk-devel
package 'java-1.7.0-openjdk-devel'

#* Create the User
# sudo groupadd chef
group 'chef' do
  action :create
end

# sudo useradd -g chef chef
user 'chef' do
  group 'chef'
end

#* Download the Tomcat Binary
#> NOTE: A specific binary will be mentioned below but it will likely be out of date. You can find the binaries for Tomcat 8 here at http://mirror.sdunix.com/apache/tomcat/tomcat-8/
# cd /tmp
# wget http://mirror.sdunix.com/apache/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz
remote_file '/tmp/apache-tomcat-8.0.45.tar.gz' do
  source 'http://httpd-mirror.frgl.pw/apache/tomcat/tomcat-8/v8.0.45/bin/apache-tomcat-8.0.45.tar.gz'
end

# Extract the Tomcat Binary
# sudo mkdir /opt/tomcat
directory '/opt/tomcat' do
  action :create
end
# sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
execute 'extract_tomcat' do
  command 'tar xvf /tmp/apache-tomcat-8.0.45.tar.gz -C /opt/tomcat --strip-components=1'
end

#* Update the Permissions
# sudo chgrp -R tomcat conf
execute 'chgrp -R chef /opt/tomcat/conf'
# sudo chmod g+rwx conf
directory '/opt/tomcat/conf' do
  group 'chef'
  mode '0474'
end
# sudo chmod g+r conf/*
execute 'chmod g+r /opt/tomcat/conf/*'
# sudo chown -R tomcat webapps/ work/ temp/ logs/
execute 'chown -R chef webapps/ work/ temp/ logs/ conf/' do
  cwd '/opt/tomcat'
end

#* Install the Systemd Unit File
# sudo vi /etc/systemd/system/tomcat.service
# This is the content of that file:
# Systemd unit file for tomcat
#[Unit]
#Description=Apache Tomcat Web Application Container
#After=syslog.target network.target
#
#[Service]
#Type=forking
#
#Environment=JAVA_HOME=/usr/lib/jvm/jre
#Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
#Environment=CATALINA_HOME=/opt/tomcat
#Environment=CATALINA_BASE=/opt/tomcat
#Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
#Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
#
#ExecStart=/opt/tomcat/bin/startup.sh
#ExecStop=/bin/kill -15 $MAINPID
#
#User=tomcat
#Group=tomcat
#
#[Install]
#WantedBy=multi-user.target

#chef generate template tomcat.service
#create default directory and edit tomcat/templates/default/tomcat.service.erb with proper content
template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

#* Reload Systemd to load the Tomcat Unit file
# sudo systemctl daemon-reload
# sudo systemctl start tomcat
# sudo systemctl enable tomcat

#* Verify that Tomcat is running by visiting the site
# curl http://localhost:8080
