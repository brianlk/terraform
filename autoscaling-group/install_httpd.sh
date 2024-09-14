#!/bin/bash

yum -y install httpd
systemctl enable httpd
systemctl start httpd

DATE=`date`

cd /var/www/html
cat <<EOF >> index.html
<html>
<h1>i am ok on $DATE</h1>
</html>
EOF
