#!/bin/bash
#Variables
DATE=$(date +%d-%m-%Y_%H%M%S)
export red="\033[1;31m"
export green="\033[1;32m"
export yellow="\033[1;33m"
export blue="\033[1;34m"
export purple="\033[1;35m"
export cyan="\033[1;36m"
export grey="\033[0;37m"
export reset="\033[m"
############################################ Log File #################################################################
LOG_FILE="/tmp/sqream-sqdiag.log"
sudo rm -rf $LOG_FILE
logit() 
{
    echo "[`date`] - ${*}" >> ${LOG_FILE}    
}
######################################### run with sudo ########################################################################
run_with_sudo () {
        if ! [ $(id -u) = 0 ]; then
   clear
   echo "##################################################################"
   echo "Please run This script with sudo." >&2
   logit "Error: please run_with sudo"
   echo "##################################################################"
   
   exit 1
else
clear
logit "###################################################################"
logit "Success: script runs with sudo"
echo -e  "Success: script runs with sudo"
logit "###################################################################"
fi
}
################################################################################################################################
run_with_sudo
################################################################################################################################
sqream_user () {
if ! id "sqream" &>/dev/null; then
echo "##################################################################"
logit "Error: User sqream not exist"
echo "Error: User sqream not exist"
echo "##################################################################"
logit "##################################################################"
else
echo "##################################################################"
logit "Success: User sqream exist"
echo "Success: User sqream exist"
logit "##################################################################"
echo "##################################################################"
sleep 4
fi
}
sqream_user
################################################################################################################################
user_shell () {
echo "######################################################################################"
echo "checking user shell"
if [ -n "$SUDO_USER" ]; then
  echo "Originally invoked by: $SUDO_USER (UID: $SUDO_UID)"
fi
echo "######################################################################################"
sleep 1
if  [ $(getent passwd "$SUDO_USER" | cut -d: -f7) = /bin/bash ]; then
echo "######################################################################################"
echo "Success: current $SUDO_USER shell is   $SHELL"
logit "Success: current $SUDO_USER shell is   $SHELL"
logit "##################################################################"
echo "######################################################################################"
sleep 2
else
echo "######################################################################################"
echo "this is current shell: $(getent passwd "$SUDO_USER" | cut -d: -f7)"
echo "Error: SQream installer cannot work with this shell"
echo "Please change sqream user shell to /bin/bash"
logit "Error: SQream installer cannot work with this shell"
logit "Please change sqream user shell to /bin/bash"
logit "##################################################################"
exit
echo "######################################################################################"
sleep 2
fi
}
user_shell
#######################################################################################################################
user_visudo () {
echo "Checking if user is in sudoers file"
if [ -n "(cat  /etc/sudoers | grep $SUDO_USER)" ] ; then
echo "######################################################################################"
echo "Success: user $SUDO_USER is in sudoers file"
echo "$(cat  /etc/sudoers | grep $SUDO_USER)"
logit "Success: user $SUDO_USER is in sudoers file"
logit "$(cat  /etc/sudoers | grep $SUDO_USER)"
logit "##################################################################"
echo "######################################################################################"
else
echo "######################################################################################"
echo "Error: user $SUDO_USER is not in sudoers file"
logit "Error: user $SUDO_USER is not in sudoers file"
logit "##################################################################"
echo "######################################################################################"
fi
}
#######################################################################################################################
user_visudo
user_group () {
echo "######################################################################################"
echo "Checking user group"
if [ -n "(id $SUDO_USER)" ] ; then
echo "user group is: $(id $SUDO_USER)"
logit "user group is: $(id $SUDO_USER)"
logit "##################################################################"
echo "######################################################################################"
else
echo "######################################################################################"
echo "No $SUDO_USER group found"
logit "No $SUDO_USER group found"
logit "##################################################################"
echo "######################################################################################"
fi
}
user_group
sleep 5
########################################Required Cuda Drivers to Start ################################################
clear
echo "######################################################################################"
echo "Checking Required Cuda Drivers"
echo "######################################################################################"
if ! [ -x "$(command -v nvidia-smi)" ]; then
echo -e "${yellow}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${red}>>>>>>>>>>>>>>>>>>>>>>>>No NVIDIA Cuda driver Found<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<${reset}" 
echo -e "${red}+++++++++++++++++++ Please install cuda driver ++++++++++++++++++++${reset}"
logit "Error: Please install cuda driver"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
sleep 5
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${yellow}++++++++++++++++++++++ NVIDIA Cuda Found ++++++++++++++++++++++++++++++++++++++${reset}" 
logit "Success: NVIDIA Cuda Found"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
logit "###################################################################"
nvidia-smi
logit "$(nvidia-smi)"
logit "###################################################################"
sleep 2
fi
########################################Required packages Information################################################
echo "######################################################################################"
echo "Checking Required packages Information"
echo "######################################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${yellow}>>>>>>>>>>>>>>>>>>>>>>Required packages Information<<<<<<<<<<<<<<<<<<<<<<<<<<<<<${reset}"
logit ">>>>> Required packages Information <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
logit "###################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
if ! rpm -qa | grep pciutils &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (pciutils) ${red}NOT FOUND"
logit "Error: Package (pciutils) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (pciutils) ${green}PASSED"
logit "Success: Package (pciutils) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep monit  &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo "Monit is not required when working in HA Cluster"
echo -e "Package (monit) ${red}NOT FOUND"
logit "Error: Package (monit) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (monit) ${green}PASSED"
logit "Success: Package (monit) PASSED"
logit "###################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep zlib-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (zlib-devel) ${red}NOT FOUND"
logit "Error: Package (zlib-devel) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (zlib-devel) ${green}PASSED"
logit "Success: Package (zlib-devel) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep openssl-devel  &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (openssl-devel) ${red}NOT FOUND"
logit "Error: Package (openssl-devel) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (openssl-devel) ${green}PASSED"
logit "Success: Package (openssl-devel) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep gcc  &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (gcc) ${red}NOT FOUND"
logit "Error: Package (gcc) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (gcc) ${green}PASSED"
logit "Success: Package (gcc) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep wget  &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (wget) ${red}NOT FOUND"
logit "Error: Package (wget) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (wget) ${green}PASSED"
logit "Success: Package (wget) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep net-tools &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (net-tools) ${red}NOT FOUND"
logit "Error: Package (net-tools) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (net-tools) ${green}PASSED"
logit "Success: Package (net-tools) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep jq  &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (jq) ${red}NOT FOUND"
logit "Error: Package (jq) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package(jq) ${green}PASSED"
logit "Success: Package (jq) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep libffi-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (libffi-devel) ${red}NOT FOUND"
logit "Error: Package (libffi-devel) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (libffi-devel) ${green}PASSED"
logit "Success: Package (libffi-devel) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep xz-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (xz-devel) ${red}NOT FOUND"
logit "Error: Package (xz-devel) NOT FOUND"
logit "##################################################################"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (xz-devel) ${green}PASSED"
logit "Success: Package (xz-devel) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep tk-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (tk-devel) ${red}NOT FOUND"
logit "Error: Package (tk-devel) NOT FOUND"
logit "##################################################################"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (tk-devel) ${green}PASSED"
logit "Success: Package (tk-devel) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep gdbm-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (gdbm-devel) ${red}NOT FOUND"
logit "Error: Package (gdbm-devel) NOT FOUND"
logit "##################################################################"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (gdbm-devel) ${green}PASSED"
logit "Success: Package (gdbm-devel) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep sqlite-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (sqlite-devel) ${red}NOT FOUND"
logit "Error: Package (sqlite-devel) NOT FOUND"
logit "##################################################################"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (sqlite-devel) ${green}PASSED"
logit "Success: Package (sqlite-devel) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep readline-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (readline-devel) ${red}NOT FOUND"
logit "Error: Package (readline-devel) NOT FOUND"
logit "##################################################################"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (readline-devel) ${green}PASSED"
logit "Success: Package (readline-devel) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep bzip2-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (bzip2-devel) ${red}NOT FOUND"
logit "Error: Package (bzip2-devel) NOT FOUND"
logit "##################################################################"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (bzip2-devel) ${green}PASSED"
logit "Success: Package (bzip2-devel) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep ncurses-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (ncurses-devel) ${red}NOT FOUND"
logit "Error: Package (ncurses-devel) NOT FOUND"
logit "##################################################################"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (ncurses-devel) ${green}PASSED"
logit "Success: Package (ncurses-devel) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep texinfo &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (texinfo) ${red}NOT FOUND"
logit "Error: Package (texinfo) NOT FOUND"
logit "##################################################################"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (texinfo) ${green}PASSED"
logit "Success: Package (texinfo) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep pcs &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Pacamaker is not required when working in Standalone SQreamDB"
echo -e "Package (pcs) ${red}NOT FOUND"
logit "Error: Package (pcs) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (pcs) ${green}PASSED"
logit "Success: Package (pcs) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
sudo systemctl start pcsd.service  &> /dev/null
sudo systemctl enable pcsd.service &> /dev/null
if ! rpm -qa | grep corosync &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (Corosync) ${red}NOT FOUND"
echo -e "Package (Corosync) is Required for HA Cluster"
logit "Error: Package (Corosync) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else 
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (Corosync) ${green}PASSED"
logit "Success: Package (Corosync) PASSED"
logit "##################################################################"
sudo systemctl disable corosync.service  &> /dev/null
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
if ! rpm -qa | grep pacemaker &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (pacemaker) ${red}NOT FOUND"
echo -e "Package (pacemaker) is Required for HA Cluster"
logit "Error: Package (pacemaker) NOT FOUND"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (pacemaker) ${green}PASSED"
logit "Success: Package (pacemaker) PASSED"
logit "##################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
fi
fi
######################################## Python 3.11.7    #################################################################
if ! [ -x "$(command -v python3)" ]; then
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${red}Python3 Not Installed${reset}" 
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${red}      SQream related Python3 should be Python 3.11.7${reset}"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
VERSION=$(su - sqream -c "python3 --version")
if [ "$VERSION" = "Python 3.11.7" ]; then
echo "##################################################################"
echo "            Python3 Current Version is 3.11.7                     "
echo "########            No need to install        ####################"
echo "##################################################################"    
else
echo "##################################################################"
echo -e "${red}########### Python current version is $VERSION"
echo -e "${green}########    please install python 3.11.7    ${reset}"
echo "##################################################################"
fi
################################ Node JS  ##############################################################################
if ! [ -z $(command -pVv node) ] >>/dev/null ;then
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"  
echo -e "${green}                  Current NodeJS Version${reset}" 
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "                   ${green}SQream recommended NodeJS 16.X or 18.X${reset}                      " 
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${red}NodeJS not installd - Please install NodeJS Ver 16.X or 18.X{reset}" 
echo -e "${green}NodeJS required only if this host running SQream Studio${reset}"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
if ! [ -x "$(command -v pm2)" ]; then
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${red}PM2 Not Found${reset}" 
echo -e "${green}SQream requires PM2 only if this host running SQream Studio${reset}" 
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo "PM2 is Installed" 
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
######################################## Security limits ###############################################################
sleep 5
logit "######### Security limits ########################################" 
logit "##################################################################"
########################################################################################################################
##################################### Security limits ##################################################################
#clear
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${green}SQREAM Security limits- Current Information${reset}"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
if  [ -z "$(grep "sqream soft nproc" /etc/security/limits.conf)" ] ;then
echo -e "${red}sqream soft nproc - ${red}NOT FOUND"
logit "Error: sqream soft nproc - NOT FOUND"
logit "##################################################################"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^^SQREAM soft nproc Should be: 1000000 ${reset}^^^^^^^^^^^^^^^^^^^^^^^^^"
echo -e "${green}sqream soft nproc Exists - Current Value: " 
grep "sqream soft nproc" /etc/security/limits.conf
logit "##################################################################"
logit "Success: sqream soft nproc Exists"
logit "Current Value:$(grep "sqream soft nproc" /etc/security/limits.conf)"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
if  [ -z "$(grep "sqream hard nproc" /etc/security/limits.conf)" ] ;then
echo -e "sqream hard nproc - ${red}NOT FOUND"
logit "Error: sqream hard nproc - NOT FOUND"
logit "##################################################################"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^^SQREAM hard nproc Should be: 1000000 ^^^^^^^^^^^^^${reset}"
echo -e "${green}sqream hard nproc Exists - Current Value:" 
grep "sqream hard nproc" /etc/security/limits.conf
logit "Success: sqream hard nproc Exists"
logit "Current Value:$(grep "sqream hard nproc" /etc/security/limits.conf)" 
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
if  [ -z "$(grep "sqream soft nofile" /etc/security/limits.conf)" ] ;then
echo -e "sqream soft nofile - ${red}NOT FOUND"
logit "Error: sqream soft nofile - NOT FOUND"
logit "##################################################################"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^^SQREAM soft nofile Should be: 1000000 ^^^^^^^^^^^^^${reset}"
echo -e "${green}sqream soft nofile Exists - Current Value:" 
grep "sqream soft nofile" /etc/security/limits.conf
logit "Success: sqream soft nofile Exists"
logit "Current Value:$(grep "sqream soft nofile" /etc/security/limits.conf)"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
if  [ -z "$(grep  "sqream hard nofile" /etc/security/limits.conf)" ] ;then
echo -e "sqream hard nofile - ${red}NOT FOUND"
logit "Error: sqream hard nofile - NOT FOUND"
logit "##################################################################"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^^SQREAM hard nofile Should be: 1000000 ^^^^^^^^^^^^^${reset}"
echo -e "${green}sqream hard nofile Exists - Current Value:" 
grep "sqream hard nofile" /etc/security/limits.conf
logit "Success: sqream hard nofile Exists"
logit "Current Value:$(grep "sqream hard nofile" /etc/security/limits.conf)"
logit "###################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
if  [ -z "$(grep "sqream soft core" /etc/security/limits.conf)" ] ;then
echo -e "sqream soft core - ${red}NOT FOUND"
logit "Error: sqream soft core - NOT FOUND"
logit "###################################################################"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^SQREAM soft core Should be: unlimited ^^^^^^^^^^^^^${reset}"
echo -e "${green}sqream soft core Exists - Current Value:" 
grep "sqream soft core" /etc/security/limits.conf
logit "Success: sqream soft core Exists"
logit "Current Value:$(grep "sqream soft core" /etc/security/limits.conf)"
logit "###################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
if  [ -z "$(grep "sqream hard core" /etc/security/limits.conf)" ] ;then
echo -e "sqream hard core - ${red}NOT FOUND"
logit "Error: sqream hard core - NOT FOUND"
logit "##################################################################"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^^SQREAM hard core Should be: unlimited ^^^^^^^^^^^^^${reset}"
echo -e "${green}sqream hard core Exist - Current Value:" 
grep "sqream hard core" /etc/security/limits.conf
logit "Success: sqream hard core Exist"
logit "Current Value:$(grep "sqream hard core" /etc/security/limits.conf)"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${green}Configure security limits Anyway ?${reset}"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
read -p "Do you want to proceed? (Y/n) " Yn
case $Yn in 
	n ) 
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" ;
echo -e ${red}No Changes Made.;
logit "##################################################################"
logit "No Changes Made"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" ;
sleep 2
		;;
  
  * ) echo ok,;
  sed -i '/sqream soft nproc/d' /etc/security/limits.conf
  sed -i '/sqream hard nproc/d' /etc/security/limits.conf
  sed -i '/sqream soft nofile/d' /etc/security/limits.conf
  sed -i '/sqream hard nofile/d' /etc/security/limits.conf
  sed -i '/sqream soft core/d' /etc/security/limits.conf
  sed -i '/sqream hard core/d' /etc/security/limits.conf
  
  echo sqream soft nproc 1000000 | sudo tee -a /etc/security/limits.conf;
  echo sqream hard nproc 1000000 | sudo tee -a /etc/security/limits.conf;
  echo sqream soft nofile 1000000 | sudo tee -a /etc/security/limits.conf;
  echo sqream hard nofile 1000000 | sudo tee -a /etc/security/limits.conf;
  echo sqream soft core unlimited | sudo tee -a /etc/security/limits.conf;
  echo sqream hard core unlimited | sudo tee -a /etc/security/limits.conf;
  echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"   
echo "Done, Configure security limits"
logit "Success: Configure security limits is set now"
logit "##################################################################"
   sleep 2
		;;	
	
esac
#################################### kernel parameters ##################################################
logit "########## kernel parameters #####################################"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${green}Current kernel parameters for SQREAM ?${reset}"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
if  [ -z "$(grep "kernel.core_uses_pid" /etc/sysctl.conf)" ] ;then
echo -e "${red}kernel.core_uses_pid - ${red}NOT FOUND"
logit "Error: kernel.core_uses_pid - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^kernel.core_uses_pid Should be: 1 ^^^^^^^^^^^^^${reset}"
echo -e "${green}kernel.core_uses_pid Exists - Current Value:"
grep "kernel.core_uses_pid" /etc/sysctl.conf
logit "##################################################################"
logit "Success: kernel.core_uses_pid Exists"
logit "Current Value:$(grep "kernel.core_uses_pid" /etc/sysctl.conf)"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if  [ -z "$(grep "vm.dirty_background_ratio" /etc/sysctl.conf)" ] ;then
echo -e "vm.dirty_background_ratio - ${red}NOT FOUND"
logit "Error: vm.dirty_background_ratio - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^vm.dirty_background_ratio Should be: 5 ^^^^^^^^^^^^^${reset}"
echo -e "${green}vm.dirty_background_ratio Exists - Current Value:"
grep "vm.dirty_background_ratio" /etc/sysctl.conf
logit "Success: vm.dirty_background_ratio Exists"
logit "Current Value:$(grep "vm.dirty_background_ratio" /etc/sysctl.conf)"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if  [ -z "$(grep "vm.dirty_ratio" /etc/sysctl.conf)" ] ;then
echo -e "vm.dirty_ratio - ${red}NOT FOUND"
logit "Error: vm.dirty_ratio - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^vm.dirty_ratio Should be: 10 ^^^^^^^^^^^^^${reset}"
echo -e "${green}vm.dirty_ratio Exists - Current Value:"
grep "vm.dirty_ratio" /etc/sysctl.conf
logit "Success: vm.dirty_ratio Exists"
logit "Current Value:$(grep "vm.dirty_ratio" /etc/sysctl.conf)"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if  [ -z "$(grep  "vm.swappiness" /etc/sysctl.conf)" ] ;then
echo -e "vm.swappiness - ${red}NOT FOUND"
logit "Error: vm.swappiness - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^vm.swappiness Should be: 10 ^^^^^^^^^^^^^${reset}"
echo -e "${green}vm.swappiness Exists - Current Value:"
grep "vm.swappiness" /etc/sysctl.conf
logit "Success: vm.swappiness Exists"
logit "Current Value:$(grep "vm.swappiness" /etc/sysctl.conf)"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if  [ -z "$(grep  "vm.vfs_cache_pressure" /etc/sysctl.conf)" ] ;then
echo -e "vm.vfs_cache_pressure - ${red}NOT FOUND"
logit "Error: vm.vfs_cache_pressure - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^vm.vfs_cache_pressure Should be: 200 ^^^^^^^^^^^^^${reset}"
echo -e "${green}vm.vfs_cache_pressure Exists - Current Value:"
grep "vm.vfs_cache_pressure" /etc/sysctl.conf
logit "Success: vm.vfs_cache_pressure Exists"
logit "Current Value:$(grep "vm.vfs_cache_pressure" /etc/sysctl.conf)"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if  [ -z "$(grep "vm.zone_reclaim_mode" /etc/sysctl.conf)" ] ;then
echo -e "vm.zone_reclaim_mode - ${red}NOT FOUND"
logit "Error: vm.zone_reclaim_mode - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^vm.zone_reclaim_mode Should be: 0 ^^^^^^^^^^^^^${reset}"
echo -e "${green}vm.zone_reclaim_mode Exists - Current Value:"
grep "vm.zone_reclaim_mode" /etc/sysctl.conf
logit "Success: vm.zone_reclaim_mode Exists"
logit "Current Value:$(grep "vm.zone_reclaim_mode" /etc/sysctl.conf)"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${green}Configure kernel parameters for SQREAM ?${reset}"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
read -p "Do you want to proceed anyway? (Y/n) " Yn
case $Yn in 
 
		
	n ) echo -e ${red}No Changes Made;
logit "##################################################################"
logit "No Changes Made";
logit "##################################################################"
      sleep 2
		;;
  * ) echo ok,;
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"   
   sudo sed -i '/vm.dirty_background_ratio/d' /etc/sysctl.conf;
  sudo sed -i '/vm.dirty_ratio/d' /etc/sysctl.conf;
  sudo sed -i '/vm.swappiness/d' /etc/sysctl.conf;
  sudo sed -i '/vm.vfs_cache_pressure/d' /etc/sysctl.conf;
  sudo sed -i '/vm.zone_reclaim_mode/d' /etc/sysctl.conf;
  sudo sed -i '/kernel.core_uses_pid/d' /etc/sysctl.conf;
  echo kernel.core_uses_pid = 1 | sudo tee -a /etc/sysctl.conf;
  echo vm.dirty_background_ratio = 5 | sudo tee -a /etc/sysctl.conf;
  echo vm.dirty_ratio = 10 | sudo tee -a /etc/sysctl.conf;
  echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf;
  echo vm.vfs_cache_pressure = 200 | sudo tee -a /etc/sysctl.conf;
  echo vm.zone_reclaim_mode = 0 | sudo tee -a /etc/sysctl.conf;
  sudo sysctl -p >>/dev/null;
logit "##################################################################"
logit "Success: Configure kernel parameters is set now"
logit "##################################################################"
echo -e "${green}Done, Configure kernel parameters"
  sleep 2
  ;; 
   
esac
#################################### Core Dump PATH ##########################################################################

echo -e "${yellow}+++++++++++++++++++++++++++ Core Dump PATH ++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${green}core dump PATH"
echo -e "${yellow}+++++++++++++++++++++++++++ Core Dump PATH ++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"

if ! [ -z "$(grep "kernel.core_pattern" /etc/sysctl.conf)" ] ;then
core_dump=$(grep "kernel.core_pattern" /etc/sysctl.conf)
echo -e "core dump path exist in: $core_dump${reset}"
logit "core dump path exist in: $core_dump"
read -p "Do you want to change core dump path? (y/n) " yn
case $yn in
y)
sudo sed -i '/kernel.core_pattern/d' /etc/sysctl.conf
echo "Enter path for core dump folder: ";
echo -e "core dump will be created under this path  ${yellow}<core dump path>${reset}/<hostname>/core_dump"
echo -e "please enter only ${yellow} <core dump path> ${reset} all the rest path will be created auto"
read k
echo "____________________________________________________________";
mkdir -p ${k}/$(hostname)/core_dumps
chmod -R 777 ${k}/$(hostname)/core_dumps;
echo kernel.core_uses_pid = 1 | sudo tee -a /etc/sysctl.conf &> /dev/null;
echo kernel.core_pattern = "${k}/$(hostname)/core_dumps/core-%e-%s-%u-%g-%p-%t" | sudo tee -a /etc/sysctl.conf &> /dev/null;
echo fs.suid_dumpable = 2 | sudo tee -a /etc/sysctl.conf &> /dev/null;
logit "##################################################################"
core_dump=$(grep "kernel.core_pattern" /etc/sysctl.conf)
logit "core dump path changed to: $core_dump"
echo -e "${yellow}+++++++++++++++++++++++++++ Current Core Dump PATH ++++++++++++++++++++++++++++++++++++++++++++${reset}";
grep  'kernel.core_pattern' /etc/sysctl.conf;
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}";
echo "____________________________________________________________";
;;
n )
core_dump=$(grep "kernel.core_pattern" /etc/sysctl.conf)
logit "No changes in core dump"
logit "core dump path stay in:$core_dump" 
echo  "No changes in core dump"
echo "core dump path stay in: $core_dump"
echo "End of Diagnostic"
;;
esac
else
echo -e "${red}core dump path not exist"
echo "Please create core dump path"
echo -e "${yellow}+++++++++++++++++++++++++++Core Dump PATH++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
read -p "Do you want to create core dump path? (Y/n) " Yn
case $Yn in

n) echo core dump PATH not created...;
logit "##################################################################"
logit "Error: core dump path not created"
logit "##################################################################"
;;

* )
echo "enter path for core dump folder: ";
echo "------------------------------------------------------------";
echo -e "core dump will be created under this path ${yellow}<core dump path>${reset}/<hostname>/core_dump"
echo -e "please enter only ${yellow} <core dump path>${reset} all the rest path will be created auto"
echo "------------------------------------------------------------";
read k
echo "____________________________________________________________";
mkdir -p ${k}/$(hostname)/core_dumps
chmod -R 777 ${k}/$(hostname)/core_dumps;
echo kernel.core_uses_pid = 1 | sudo tee -a /etc/sysctl.conf &> /dev/null;
echo kernel.core_pattern = "${k}/$(hostname)/core_dumps/core-%e-%s-%u-%g-%p-%t" | sudo tee -a /etc/sysctl.conf &> /dev/null;
echo fs.suid_dumpable = 2 | sudo tee -a /etc/sysctl.conf &> /dev/null;
logit "##################################################################"
logit "Success: core dump path created"
logit "Core Dump PATH created in: ${k}/$(hostname)/core_dumps"
core_dump=$(grep "kernel.core_pattern" /etc/sysctl.conf)
logit "$core_dump"
logit "##################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++ Current Core Dump PATH ++++++++++++++++++++++++++++++++++++++++++${reset}";
grep  'kernel.core_pattern' /etc/sysctl.conf;
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}";
;;
esac
fi
echo -e "
...............................................................................

███████  ██████  ██████  ███████  █████  ███    ███               ██ ████████ 
██      ██    ██ ██   ██ ██      ██   ██ ████  ████               ██    ██    
███████ ██    ██ ██████  █████   ███████ ██ ████ ██     █████     ██    ██    
     ██ ██ ▄▄ ██ ██   ██ ██      ██   ██ ██  ██  ██               ██    ██    
███████  ██████  ██   ██ ███████ ██   ██ ██      ██               ██    ██    
            ▀▀
                                                 
.............................................................................."

read -p "Do you want to view log file? (y/N) " yN
case $yN in 
y ) 
more /tmp/sqream-sqdiag.log;
;;
* ) echo "Summery of Errors"
cat  /tmp/sqream-sqdiag.log  | grep Error
;;
esac

