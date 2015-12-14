#!/bin/sh
ip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
if [ ! "$ip" = '' ];then
     echo "Network is OK !"
else
     echo  "Network is down,please check your Network !" 
     sleep 1000000
     exit
fi

###Check if Install
if [ -d "/var/lib/mysql/owncloud" ]; then
for (( i=0; i<10;)); do

     read -p "You have already initialized, the new initialization will cover the previous data, yes or no?" answer
      if [ "$answer" = "yes" ];then
         sh  /srv/cloudmai/clean.sh
         break
      elif [ "$answer" = "no" ] ;then
         echo "The initialization Stopped"
         sleep 1000000
         exit
       else
         echo "You should be strict in input  yes or no " 
       fi
done
fi

###Init database 
/etc/init.d/mysqld stop
rootpwd='qwer1234'
mysql_install_db
nohup mysqld_safe --skip-grant-tables >/dev/zero 2>&1 &
sleep 3
mysql -u root <<EOF
 UPDATE mysql.user SET Password=PASSWORD('$rootpwd') WHERE User='root';
 FLUSH  PRIVILEGES;
 exit
EOF
chkconfig mysqld on
/etc/init.d/mysqld restart 

###防止同nkscloud-web抢占80端口
#sed -i 's/Listen 80.*/Listen 8091/g' /etc/httpd/conf/httpd.conf
###设置owncloud路径
echo "
RedirectMatch ^/$ /owncloud/
<Directory /var/www/owncloud>
  AllowOverride All
</Directory>
Alias /owncloud /var/www/owncloud" >/etc/httpd/conf.d/owncloud.conf

###设置owncloud端口
#sed -i 's/Listen.*/Listen 9091/g' /etc/httpd/conf.d/ssl.conf
#sed -i 's/<VirtualHost _default_:.*/<VirtualHost _default_:9091>/g' /etc/httpd/conf.d/ssl.conf

#####生成owncloud配置文件
instanceid=`date +%s%N | md5sum | head -c 12`
passwordsalt=`date +%s%N | md5sum | head -c 30`
dbpassword=`date +%s%N | md5sum | head -c 30`
hostname=`hostname`
#port='9091'
echo "<?php
\$CONFIG = array (
  'instanceid' => '$instanceid',
  'passwordsalt' => '$passwordsalt',
  'trusted_domains' =>
  array (
    0 => '$ip',
  ),
  'datadirectory' => '/var/www/owncloud/data',
  'dbtype' => 'mysql',
  'version' => '6.0.9.2',
  'dbname' => 'owncloud',
  'dbhost' => 'localhost',
  'dbtableprefix' => 'oc_',
  'dbuser' => 'oc_admin',
  'dbpassword' => '$dbpassword',
  'installed' => true,
);" > /var/www/owncloud/config/config.php

###创建.ocdata
touch /var/www/owncloud/data/.ocdata

###赋予owncloud访问权限
chown apache:apache -R /var/www/owncloud
###获取admin密码
adminpasswd="qwer1234"
###获取密码的hash值
pwdhash=`php -f /srv/cloudmai/user.php passwordtohash $adminpasswd`
###初始化数据库，并修改admin密码
mysql -u root -pqwer1234<<EOF
   CREATE USER oc_admin@'%' IDENTIFIED BY '$dbpassword';
   CREATE USER oc_admin@'localhost' IDENTIFIED BY '$dbpassword';
   CREATE DATABASE IF NOT EXISTS owncloud CHARACTER SET utf8 COLLATE utf8_bin;
   USE owncloud;
   source /srv/cloudmai/owncloud.sql;
   GRANT ALL PRIVILEGES ON *.* TO oc_admin@localhost;
   UPDATE  owncloud.oc_users SET password = '$pwdhash' where uid ='admin';
   flush privileges;
   exit
EOF

###重启httpd 服务
chkconfig httpd on
/etc/init.d/httpd restart

###关闭防火墙
chkconfig iptables off
/etc/init.d/iptables stop

echo "Initialization Success!"
sleep 100000
