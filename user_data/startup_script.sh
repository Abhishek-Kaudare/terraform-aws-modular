#!/bin/bash
sudo yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum install -y mysql-community-client

source /opt/server_ip
mysql -h $instance_target_host -P 3306 -u admin -ppassword -e 'CREATE DATABASE books;USE books;CREATE TABLE authors (id INT, name VARCHAR(20), email VARCHAR(20));INSERT INTO authors (id,name,email) VALUES(1,"Vivek","xuz@abc.com");'