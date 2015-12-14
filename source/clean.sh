rootpwd='qwer1234'
mysql -u root -p$rootpwd<<EOF
   DROP database IF EXISTS owncloud;
   delete from mysql.user where user='oc_admin';
   DROP user  oc_admin ;
   flush privileges;
   exit
EOF

rm -rf /etc/httpd/conf.d/owncloud.conf
rm -rf /var/www/owncloud/config/config.php

/etc/init.d/httpd restart
