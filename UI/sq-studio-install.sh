#!/bin/bash
#
today=$(date +"%Y-%m-%d")
############################################ Log File ###########################################################################################
LOG_FILE="/tmp/sq-studio_install.log"
logit() 
{
    echo "[`date`] - ${*}" >> ${LOG_FILE}    
}
############################################ run_with_sudo ######################################################################################
run_with_sudo () {
        if  [ $(id -u) = 0 ]; then
   echo "Please run This script with no sudo." >&2
   exit 1
fi
}
####################################################################################################################################################
install_requirements () {
LinuxDistro=$(cat /etc/os-release |grep VERSION_ID |cut -d "=" -f2)
if [[ $(echo $LinuxDistro|grep '7') ]];then
sudo yum install epel-release -y 
curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash - 
sudo yum install -y nodejs
sudo yum install npm -y
sudo npm i -g pm2
elif [[ $(echo $LinuxDistro|grep '8') ]];then
sudo yum module install nodejs:16 -y
sudo npm install pm2 -g && pm2 update 
elif [[ $(echo $LinuxDistro|grep '9') ]];then
    echo "Detected RHEL 9.x"
    sudo dnf module enable nodejs:18 -y || true
    sudo dnf module install -y nodejs:18
    sudo npm install -g pm2
    pm2 update
  else
    echo "Unsupported OS version: $LinuxDistro"
    exit 1
  fi
}
#################################### Check  OS ersion #############################################################################################
check_os_version () {
LinuxDistro=$(cat /etc/os-release |grep VERSION_ID |cut -d "=" -f2)

if [[ $(echo $LinuxDistro|grep '7') ]];then
   echo "OS Version RHEL 7"
   check_requirements
   verify_and_extract_el7
   
elif [[ $(echo $LinuxDistro|grep '8') ]];then
   echo "OS Version RHEL 8"
   check_requirements
   verify_and_extract_el8
elif [[ $(echo $LinuxDistro|grep '9') ]];then
echo "OS Version RHEL 9"
   check_requirements
   verify_and_extract_el8
else
    echo "Unsupported OS version: $LinuxDistro"
    exit 1

fi
}
################################ Upgrade SQream Studio ###########################################################################################
upgrade_sqream_studio() {
if [ -d ~/sqream-admin-old ];then
rm -rf ~/sqream-admin-old
fi
if [ -d ~/sqream-admin ];then
echo "sqream-admin found"
echo "Backup Older Studio Version"
mv $HOME/sqream-admin $HOME/sqream-admin-old
sleep 2
tar -C ~/ -zxf $TARFILE --checkpoint=.1000
pm2 reload all
echo "SQream Studio Upgrade Complete"
else
echo "SQream Studio Not Found"
fi
}
##################### verify_and_extract_el7 
check_requirements () {
if ! [ -x "$(command -v node)" ]; then
clear
echo "##########################################################"
echo "##########################################################"
echo "############# SQream Studio requirements #################"
echo "##########################################################"
echo "NodeJS not found"
echo "##########################################################"
echo "Please install NodeJS 16.20.2"
echo "Please install NPM + PM2"
echo "##########################################################"
exit
else
clear
echo "##########################################################"
echo "##########################################################"
echo "############# SQream Studio requirements #################"
echo "##########################################################"
echo "NodeJS found"
echo "NodeJS Version $(node -v)"
echo "##########################################################"
fi
if ! [ -x "$(command -v npm)" ]; then
echo "##########################################################"
echo "npm not found"
echo "Please install NPM"
echo "##########################################################"
exit
else
echo "##########################################################"
echo "npm found"
echo "npm Version $(npm --version)"
echo "##########################################################"
fi
if ! [ -x "$(command -v pm2)" ]; then
echo "##########################################################"
echo "pm2 not found"
echo "Please install PM2"
echo "##########################################################"
exit
else
echo "##########################################################"
echo "pm2 found"
echo "PM2 Version $(pm2 --version)"
echo "##########################################################"
fi
}
#################################################################################################################################################
verify_and_extract_el7()
{
user=$(whoami)
rm -rf ~/sqream-admin
tar -C ~/ -zxf $TARFILE --checkpoint=.1000
sudo mkdir -p /etc/sqream/
sudo chown -R $user:$user /etc/sqream
cat <<EOF | sudo tee /etc/sqream/sqream-admin-config.json > /dev/null
{
  "debugSqream": false,
  "webHost": "localhost",
  "webPort": 8080,
  "webSslPort": 8443,
  "logsDirectory": "",
  "clusterType": "standalone",
  "dataCollectorUrl": "",
  "connections": [
    {
      "host": "127.0.0.1",
      "port":3108,
      "isCluster": true,
      "name": "default",
      "service": "sqream",
      "ssl":false,
      "networkTimeout": 60000,
      "connectionTimeout": 3000
    }
  ]
}
EOF
cd ~/sqream-admin
NODE_ENV=production pm2 start ./server/build/main.js --name=sqream-studio -- start --config-location=/etc/sqream/sqream-admin-config.json
sudo chown -R $user:$user /etc/sqream
echo "#################################################################################################################"
pm2 startup
echo "Please run this so PM2 will work in startup"
echo "#################################################################################################################"
pm2 save
pm2 list
echo -e "
...............................................................................

███████  ██████  ██████  ███████  █████  ███    ███               ██ ████████ 
██      ██    ██ ██   ██ ██      ██   ██ ████  ████               ██    ██    
███████ ██    ██ ██████  █████   ███████ ██ ████ ██     █████     ██    ██    
     ██ ██ ▄▄ ██ ██   ██ ██      ██   ██ ██  ██  ██               ██    ██    
███████  ██████  ██   ██ ███████ ██   ██ ██      ██               ██    ██    
            ▀▀
                                                 
.............................................................................."
}
##################### check_tar_file ##########################################################################################################################################################
check_tar_file()
{
  if [ -z $TARFILE ]
  then
     echo "ERROR: no archieve file was specified, exiting..."
     exit -1
  fi
  if [ ! -e "$TARFILE" ]
  then
     echo "ERROR: archeive file '$TARFILE' is NOT accessible, exiting..."
     exit -1
  fi
}
##################### verify_and_extract_el8 ##################################################################################################################################################
verify_and_extract_el8()
{
user=$(whoami)
rm -rf ~/sqream-admin
tar -C ~/ -zxf $TARFILE --checkpoint=.1000
sudo mkdir -p /etc/sqream/
sudo chown -R $user:$user /etc/sqream
cat <<EOF | sudo tee /etc/sqream/sqream-admin-config.json > /dev/null
{
  "debugSqream": false,
  "webHost": "localhost",
  "webPort": 8080,
  "webSslPort": 8443,
  "logsDirectory": "",
  "clusterType": "standalone",
  "dataCollectorUrl": "",
  "connections": [
    {
      "host": "127.0.0.1",
      "port":3108,
      "isCluster": true,
      "name": "default",
      "service": "sqream",
      "ssl":false,
      "networkTimeout": 60000,
      "connectionTimeout": 3000
    }
  ]
}
EOF

sudo chown -R $user:$user /etc/sqream
cd ~/sqream-admin
NODE_ENV=production pm2 start ./server/build/main.js --name=sqream-studio -- start --config-location=/etc/sqream/sqream-admin-config.json
pm2 save
echo "#################################################################################################################"
pm2 startup
echo "Please run this so PM2 will work in startup"
echo "#################################################################################################################"
pm2 save
pm2 list
echo -e "
...............................................................................

███████  ██████  ██████  ███████  █████  ███    ███               ██ ████████ 
██      ██    ██ ██   ██ ██      ██   ██ ████  ████               ██    ██    
███████ ██    ██ ██████  █████   ███████ ██ ████ ██     █████     ██    ██    
     ██ ██ ▄▄ ██ ██   ██ ██      ██   ██ ██  ██  ██               ██    ██    
███████  ██████  ██   ██ ███████ ██   ██ ██      ██               ██    ██    
            ▀▀
                                                 
.............................................................................."
}
##############################################################################################################################################################################################

################################################## Installing_NGINX_proxy_for_SQream_UI_HTTPS ######################################################
Installing_NGINX_proxy_for_SQream_UI_HTTPS () {
sudo yum clean all
sudo yum install nginx -y
sudo systemctl start nginx 
sudo systemctl enable nginx
sudo mkdir /etc/ssl/private
sudo chmod 700 /etc/ssl/private
sudo mkdir /etc/nginx/conf.d

sudo mkdir /etc/nginx/default.d
sudo chmod 777 -R /etc/nginx/conf.d
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
echo 'upstream ui {
        server 127.0.0.1:8080;
    }
server {
    listen 443 http2 ssl;
    listen [::]:443 http2 ssl;

    server_name 127.0.0.1;

    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;

root /usr/share/nginx/html;

#    location / {
#    }

  location / {
        proxy_pass http://ui;
        proxy_set_header           X-Forwarded-Proto https;
        proxy_set_header           X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header           X-Real-IP       $remote_addr;
        proxy_set_header           Host $host;
                add_header                 Front-End-Https   on;
        add_header                 X-Cache-Status $upstream_cache_status;
        proxy_cache                off;
        proxy_cache_revalidate     off;
        proxy_cache_min_uses       1;
        proxy_cache_valid          200 302 1h;
        proxy_cache_valid          404 3s;
        proxy_cache_use_stale      error timeout invalid_header updating http_500 http_502 http_503 http_504;
        proxy_no_cache             $cookie_nocache $arg_nocache $arg_comment $http_pragma $http_authorization;
        proxy_redirect             default;
        proxy_max_temp_file_size   0;
        proxy_connect_timeout      90;
        proxy_send_timeout         90;
        proxy_read_timeout         90;
        proxy_buffer_size          4k;
        proxy_buffering            on;
        proxy_buffers              4 32k;
        proxy_busy_buffers_size    64k;
        proxy_temp_file_write_size 64k;
        proxy_intercept_errors     off;

        proxy_set_header           Upgrade $http_upgrade;
        proxy_set_header           Connection "upgrade";
    }

    error_page 404 /404.html;
    location = /404.html {
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
    }
}' > /etc/nginx/conf.d/ssl.conf


cat <<EOF | sudo tee /etc/nginx/conf.d/nginx.conf
    server {
        listen       80;
        listen       [::]:80;
        server_name  127.0.0.1;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
EOF
cat <<EOF | sudo tee /etc/nginx/default.d/ssl-redirect.conf
return 301 https://127.0.0.1:8080/;
EOF
sudo nginx -t
sudo systemctl restart nginx
echo -e "
...............................................................................

███████  ██████  ██████  ███████  █████  ███    ███               ██ ████████ 
██      ██    ██ ██   ██ ██      ██   ██ ████  ████               ██    ██    
███████ ██    ██ ██████  █████   ███████ ██ ████ ██     █████     ██    ██    
     ██ ██ ▄▄ ██ ██   ██ ██      ██   ██ ██  ██  ██               ██    ██    
███████  ██████  ██   ██ ███████ ██   ██ ██      ██               ██    ██    
            ▀▀
                                                 
.............................................................................."     
}
################################ HELP #########################################################################################################
help ()
{
  echo "usage: $0 [OPTIONS]"
  echo "Options:"
  clear
  echo "###################################################################################################"
  echo "-h, --help              show this help message end exit"
  echo "---------------------------------------------------------------------------------------------------"
  echo "-f,                     Install SQream Studio "
  echo "                        example: sq-studio-install.sh -f < path to SQream Studio Package > "
  echo "---------------------------------------------------------------------------------------------------"
  echo "-u,                     Upgrade SQream Studio Version"
  echo "                        example: sq-studio-install.sh -u < path to SQream Studio Package > "
  echo "---------------------------------------------------------------------------------------------------"
  echo "-pm2,                   Install NodeJS + NPM + PM2 > prepare for SQream Studio"
  echo "                        example: sq-studio-install.sh -pm2 "
  echo "---------------------------------------------------------------------------------------------------"
  echo "-nginx,                 Install NGINX beside SQream Studio so it can use HTTPS"
  echo "                        example: sq-studio-install.sh -nginx "
  echo "---------------------------------------------------------------------------------------------------"
  echo "###################################################################################################"
  exit
}
if [[ $# = 0 ]];then
help
fi
while [[ $# > 0 ]]
do
key="$1"
case $key in
        # Shows help
  -h|--help)
    help
  shift
  ;;

  -f|--file)
    shift;  TARFILE=$1;check_tar_file;run_with_sudo;check_os_version;  shift;
  ;;
-pm2|--install_requirements)
    shift;run_with_sudo;install_requirements;  shift;
  ;;
  -u|--upgrade_sqream_studio)
  shift;TARFILE=$1;check_tar_file;run_with_sudo;upgrade_sqream_studio;  shift;
  ;;
  -nginx|--Installing_NGINX_proxy_for_SQream_UI_HTTPS)
shift;Installing_NGINX_proxy_for_SQream_UI_HTTPS; shift;
;;
  *)
  echo "unrecognised option: $1"
  help
  ;;
esac
done
