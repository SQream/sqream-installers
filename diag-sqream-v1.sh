#!/bin/bash
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
   logit "Please: run_with_sudo"
   echo "##################################################################"
   
   exit 1
fi
logit "######################################################################################"
logit "Success: run_with_sudo"
logit "######################################################################################"

}
################################################################################################################################
run_with_sudo
logit "#############################################################################"
logit "Machine Hostname:$(hostname)"
logit "#############################################################################"
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


########################################Required Cuda Drivers to Start ################################################
clear
echo "######################################################################################"
echo "Checking Required Cuda Drivers"
logit "Checking Required Cuda Drivers"
echo "######################################################################################"
if ! [ -x "$(command -v nvidia-smi)" ]; then
  echo -e "${yellow}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
  echo -e "${red}>>>>>>>>>>>>>>>>>>>>>>>>No NVIDIA Cuda driver Found<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<${reset}" 
  echo -e "${red}+++++++++++++++++++ Please install cuda driver ++++++++++++++++++++${reset}"
  logit "Fail: Please install cuda driver"
  echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
  sleep 5
  else
     echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
     echo -e "${yellow}++++++++++++++++++++++ NVIDIA Cuda Found ++++++++++++++++++++++++++++++++++++++${reset}" 
     logit "Succes: NVIDIA Cuda Found"
     echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
     logit "#############################################################################"
     nvidia-smi
     logit "$(nvidia-smi)"
     logit "#############################################################################"
     sleep 2
     fi
########################################Required packages Information################################################
echo "######################################################################################"
echo "Checking Required packages Information"
logit "Checking Required packages Information"
echo "######################################################################################"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${yellow}>>>>>>>>>>>>>>>>>>>>>>Required packages Information<<<<<<<<<<<<<<<<<<<<<<<<<<<<<${reset}"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
if ! rpm -qa | grep pciutils &> /dev/null
then
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "(pciutils) ${red}NOT FOUND"
 logit "Fail: (pciutils) NOT FOUND"
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "(pciutils) ${green}PASSED"
logit "Success: (pciutils) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep monit  &> /dev/null
then
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo "Monit is not required when working in HA Cluster"
 echo -e "(monit) ${red}NOT FOUND"
 logit "Fail:(monit) NOT FOUND"
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "(monit) ${green}PASSED"
logit "Success: (monit) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep zlib-devel &> /dev/null
then
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (zlib-devel) ${red}NOT FOUND"
 logit "Fail: Package (zlib-devel) NOT FOUND"
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (zlib-devel) ${green}PASSED"
logit "Success: Package (zlib-devel) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep openssl-devel  &> /dev/null
then
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (openssl-devel) ${red}NOT FOUND"
 logit "Fail: Package (openssl-devel) NOT FOUND"
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (openssl-devel) ${green}PASSED"
logit "Success: Package (openssl-devel) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep gcc  &> /dev/null
then
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "(gcc) ${red}NOT FOUND"
 logit "Fail: (gcc) NOT FOUND"
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "(gcc) ${green}PASSED"
logit "Success: (gcc) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep wget  &> /dev/null
then
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "(wget) ${red}NOT FOUND"
 logit "Fail: (wget) NOT FOUND"
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "(wget) ${green}PASSED"
logit "Success: (wget) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep net-tools &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (net-tools) ${red}NOT FOUND"
 logit "Fail: Package (net-tools) NOT FOUND"
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (net-tools) ${green}PASSED"
logit "Success: Package (net-tools) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep jq  &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "(jq) ${red}NOT FOUND"
 logit "Fail: (jq) NOT FOUND"
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "(jq) ${green}PASSED"
logit "Success: (jq) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep libffi-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (libffi-devel) ${red}NOT FOUND"
 logit "Fail: Package (libffi-devel) NOT FOUND"
 echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (libffi-devel) ${green}PASSED"
logit "Success: Package (libffi-devel) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"

fi
if ! rpm -qa | grep xz-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (xz-devel) ${red}NOT FOUND"
 logit "Fail: Package (xz-devel) NOT FOUND"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (xz-devel) ${green}PASSED"
logit "Success: Package (xz-devel) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep tk-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (tk-devel) ${red}NOT FOUND"
 logit "Fail: Package (tk-devel) NOT FOUND"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (tk-devel) ${green}PASSED"
logit "Success: Package (tk-devel) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep gdbm-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (gdbm-devel) ${red}NOT FOUND"
 logit "Fail: Package (gdbm-devel) NOT FOUND"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (gdbm-devel) ${green}PASSED"
logit "Success: Package (gdbm-devel) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep sqlite-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (sqlite-devel) ${red}NOT FOUND"
 logit "Fail: Package (sqlite-devel) NOT FOUND"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (sqlite-devel) ${green}PASSED"
logit "Success: Package (sqlite-devel) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep readline-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (readline-devel) ${red}NOT FOUND"
 logit "Fail: Package (readline-devel) NOT FOUND"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (readline-devel) ${green}PASSED"
logit "Success: Package (readline-devel) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep bzip2-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (bzip2-devel) ${red}NOT FOUND"
 logit "Fail: Package (bzip2-devel) NOT FOUND"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (bzip2-devel) ${green}PASSED"
logit "Success: Package (bzip2-devel) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep ncurses-devel &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (ncurses-devel) ${red}NOT FOUND"
 logit "Fail: Package (ncurses-devel) NOT FOUND"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (ncurses-devel) ${green}PASSED"
logit "Success: Package (ncurses-devel) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep texinfo &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
 echo -e "Package (texinfo) ${red}NOT FOUND"
 logit "Fail: Package (texinfo) NOT FOUND"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (texinfo) ${green}PASSED"
logit "Success: Package (texinfo) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if ! rpm -qa | grep pcs &> /dev/null
then
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Pacamaker is not required when working in Standalone SQreamDB"
echo -e "Package (Pacamaker) ${red}NOT FOUND"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
else
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "Package (Pacamaker) ${green}PASSED"
logit "Success: Package (Pacamaker) PASSED"
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
######################################## Install required packages for SQREAM ?################################################
sleep 5

###############################################################################################################################
##################################### Security limits ######################################################################
#clear
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${green}SQREAM Security limits- Current Information${reset}"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
if  [ -z "$(grep "sqream soft nproc" /etc/security/limits.conf)" ] ;then
echo -e "${red}sqream soft nproc - ${red}NOT FOUND"
logit "Fail: sqream soft nproc - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^^SQREAM soft nproc Should be: 1000000 ${reset}^^^^^^^^^^^^^^^^^^^^^^^^^"
echo -e "${green}sqream soft nproc Exists - Current Value: " 
grep "sqream soft nproc" /etc/security/limits.conf
logit "#############################################################################"
logit "Success: sqream soft nproc Exists"
logit "Current Value:$(grep "sqream soft nproc" /etc/security/limits.conf)"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
if  [ -z "$(grep "sqream hard nproc" /etc/security/limits.conf)" ] ;then
echo -e "sqream hard nproc - ${red}NOT FOUND"
logit "Fail: sqream hard nproc - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^^SQREAM hard nproc Should be: 1000000 ^^^^^^^^^^^^^${reset}"
echo -e "${green}sqream hard nproc Exists - Current Value:" 
grep "sqream hard nproc" /etc/security/limits.conf
logit "Success: sqream hard nproc Exists"
logit "Current Value:$(grep "sqream hard nproc" /etc/security/limits.conf)" 
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
if  [ -z "$(grep "sqream soft nofile" /etc/security/limits.conf)" ] ;then
echo -e "sqream soft nofile - ${red}NOT FOUND"
logit "Fail: sqream soft nofile - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^^SQREAM soft nofile Should be: 1000000 ^^^^^^^^^^^^^${reset}"
echo -e "${green}sqream soft nofile Exists - Current Value:" 
grep "sqream soft nofile" /etc/security/limits.conf
logit "Success: sqream soft nofile Exists"
logit "Current Value:$(grep "sqream soft nofile" /etc/security/limits.conf)"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
if  [ -z "$(grep  "sqream hard nofile" /etc/security/limits.conf)" ] ;then
echo -e "sqream hard nofile - ${red}NOT FOUND"
logit "Fail: sqream hard nofile - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^^SQREAM hard nofile Should be: 1000000 ^^^^^^^^^^^^^${reset}"
echo -e "${green}sqream hard nofile Exists - Current Value:" 
grep "sqream hard nofile" /etc/security/limits.conf
logit "Success: sqream hard nofile Exists"
logit "Current Value:$(grep "sqream hard nofile" /etc/security/limits.conf)"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi
if  [ -z "$(grep "sqream soft core" /etc/security/limits.conf)" ] ;then
echo -e "sqream soft core - ${red}NOT FOUND"
logit "Fail: sqream soft core - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^SQREAM soft core Should be: unlimited ^^^^^^^^^^^^^${reset}"
echo -e "${green}sqream soft core Exists - Current Value:" 
grep "sqream soft core" /etc/security/limits.conf
logit "Success: sqream soft core Exists"
logit "Current Value:$(grep "sqream soft core" /etc/security/limits.conf)"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi

if  [ -z "$(grep "sqream hard core" /etc/security/limits.conf)" ] ;then
echo -e "sqream hard core - ${red}NOT FOUND"
logit "Fail: sqream hard core - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${grey}^^^^^^^^^^^^^^^^^^^^SQREAM hard core Should be: unlimited ^^^^^^^^^^^^^${reset}"
echo -e "${green}sqream hard core Exist - Current Value:" 
grep "sqream hard core" /etc/security/limits.conf
logit "Success: sqream hard core Exist"
logit "Current Value:$(grep "sqream hard core" /etc/security/limits.conf)"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
fi



echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
echo -e "${green}Configure security limits Anyway ?${reset}"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
read -p "Do you want to proceed? (y/n) " yn
case $yn in 
	n ) 
  echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" ;
  echo -e ${red}No Changes Made.;
  logit "#############################################################################"
  logit "No Changes Made"
  logit "#############################################################################"
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
  logit "#############################################################################"
  echo "Done, Configure security limits"
  logit "#############################################################################"
   sleep 2
		;;	
	
esac
#################################### kernel parameters ##########################################################################
#clear
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${green}Current kernel parameters for SQREAM ?${reset}"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
if  [ -z "$(grep "kernel.core_uses_pid" /etc/sysctl.conf)" ] ;then
echo -e "${red}kernel.core_uses_pid - ${red}NOT FOUND"
logit "Fail: kernel.core_uses_pid - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^kernel.core_uses_pid Should be: 1 ^^^^^^^^^^^^^${reset}"
echo -e "${green}kernel.core_uses_pid Exists - Current Value:"
grep "kernel.core_uses_pid" /etc/sysctl.conf
logit "#############################################################################"
logit "Success: kernel.core_uses_pid Exists"
logit "Current Value:$(grep "kernel.core_uses_pid" /etc/sysctl.conf)"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if  [ -z "$(grep "vm.dirty_background_ratio" /etc/sysctl.conf)" ] ;then
echo -e "vm.dirty_background_ratio - ${red}NOT FOUND"
logit "Fail: vm.dirty_background_ratio - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^vm.dirty_background_ratio Should be: 5 ^^^^^^^^^^^^^${reset}"
echo -e "${green}vm.dirty_background_ratio Exists - Current Value:"
grep "vm.dirty_background_ratio" /etc/sysctl.conf
logit "Success: vm.dirty_background_ratio Exists"
logit "Current Value:$(grep "vm.dirty_background_ratio" /etc/sysctl.conf)"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if  [ -z "$(grep "vm.dirty_ratio" /etc/sysctl.conf)" ] ;then
echo -e "vm.dirty_ratio - ${red}NOT FOUND"
logit "Fail: vm.dirty_ratio - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^vm.dirty_ratio Should be: 10 ^^^^^^^^^^^^^${reset}"
echo -e "${green}vm.dirty_ratio Exists - Current Value:"
grep "vm.dirty_ratio" /etc/sysctl.conf
logit "Success: vm.dirty_ratio Exists"
logit "Current Value:$(grep "vm.dirty_ratio" /etc/sysctl.conf)"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if  [ -z "$(grep  "vm.swappiness" /etc/sysctl.conf)" ] ;then
echo -e "vm.swappiness - ${red}NOT FOUND"
logit "Fail: vm.swappiness - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^vm.swappiness Should be: 10 ^^^^^^^^^^^^^${reset}"
echo -e "${green}vm.swappiness Exists - Current Value:"
grep "vm.swappiness" /etc/sysctl.conf
logit "Success: vm.swappiness Exists"
logit "Current Value:$(grep "vm.swappiness" /etc/sysctl.conf)"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if  [ -z "$(grep  "vm.vfs_cache_pressure" /etc/sysctl.conf)" ] ;then
echo -e "vm.vfs_cache_pressure - ${red}NOT FOUND"
logit "Fail: vm.vfs_cache_pressure - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^vm.vfs_cache_pressure Should be: 200 ^^^^^^^^^^^^^${reset}"
echo -e "${green}vm.vfs_cache_pressure Exists - Current Value:"
grep "vm.vfs_cache_pressure" /etc/sysctl.conf
logit "Success: vm.vfs_cache_pressure Exists"
logit "Current Value:$(grep "vm.vfs_cache_pressure" /etc/sysctl.conf)"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
if  [ -z "$(grep "vm.zone_reclaim_mode" /etc/sysctl.conf)" ] ;then
echo -e "vm.zone_reclaim_mode - ${red}NOT FOUND"
logit "Fail: vm.zone_reclaim_mode - NOT FOUND"
else
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${grey}^^^^^^^^^^^^^^^^^^^vm.zone_reclaim_mode Should be: 0 ^^^^^^^^^^^^^${reset}"
echo -e "${green}vm.zone_reclaim_mode Exists - Current Value:"
grep "vm.zone_reclaim_mode" /etc/sysctl.conf
logit "Success: vm.zone_reclaim_mode Exists"
logit "Current Value:$(grep "vm.zone_reclaim_mode" /etc/sysctl.conf)"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
fi
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${green}Configure kernel parameters for SQREAM ?${reset}"
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}" 
read -p "Do you want to proceed anyway? (y/n) " yn

case $yn in 
	  
			
	n ) echo -e ${red}No Changes Made;
      logit "#############################################################################"
      logit "No Changes Made";
      logit "#############################################################################"
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
   logit "#############################################################################"
   logit "Done, Configure kernel parameters"
   logit "#############################################################################"
  echo -e "${green}Done, Configure kernel parameters"
  sleep 2
  ;; 
   
esac
#################################### Core Dump PATH ##########################################################################

echo -e "${yellow}+++++++++++++++++++++++++++ Core Dump PATH ++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
echo -e "${green}core dump PATH"
echo -e "${yellow}+++++++++++++++++++++++++++ Core Dump PATH ++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"

if ! [ -z "$(grep "kernel.core_pattern" /etc/sysctl.conf)" ] ;then
echo -e "core dump ${green}exist${reset}"
echo "core dump path is:"
echo -e "${green}$(grep  'kernel.core_pattern' /etc/sysctl.conf)${reset}"
logit $(grep  'kernel.core_pattern' /etc/sysctl.conf) 
read -p "Do you want to change core dump path? (y/n) " yn
case $yn in
y)
sudo sed -i '/kernel.core_pattern/d' /etc/sysctl.conf
echo "Enter the path for core dump folder: ";
echo "core dump will be created under this path  <core dump path>/<hostname>/core_dump"
read k
echo "____________________________________________________________";
mkdir -p ${k}/$(hostname)/core_dumps
chmod -R 777 ${k}/$(hostname)/core_dumps;
echo kernel.core_uses_pid = 1 | sudo tee -a /etc/sysctl.conf &> /dev/null;
echo kernel.core_pattern = "${k}/$(hostname)/core_dumps/core-%e-%s-%u-%g-%p-%t" | sudo tee -a /etc/sysctl.conf &> /dev/null;
echo fs.suid_dumpable = 2 | sudo tee -a /etc/sysctl.conf &> /dev/null;
logit "#############################################################################"
logit "Core Dump Path Created"
logit "Core Dump PATH is: ${k}/$(hostname)/core_dumps"
echo -e "${yellow}+++++++++++++++++++++++++++ Current Core Dump PATH ++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}";
grep  'kernel.core_pattern' /etc/sysctl.conf;
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}";
echo "____________________________________________________________";
;;
n )
logit "core dump path exist"
logit $(grep  'kernel.core_pattern' /etc/sysctl.conf) 
echo "core dump path exist"
echo "End of Diagnostic"
;;
esac
else
echo -e "${red}core dump path not exist"
echo "Please create core dump path"
echo -e "${yellow}+++++++++++++++++++++++++++Core Dump PATH++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}"
read -p "Do you want to create core dump path? (y/n) " yn
case $yn in

n) echo core dump PATH not created...;
    logit "#############################################################################"
    logit "core dump path not created"
    logit "#############################################################################"
;;

* )
echo "enter the path for core dump folder: ";
echo "------------------------------------------------------------";
echo "core dump will be created under this path  <core dump path>/<hostname>/core_dump"
echo "------------------------------------------------------------";
read k
echo "____________________________________________________________";
mkdir -p ${k}/$(hostname)/core_dumps
chmod -R 777 ${k}/$(hostname)/core_dumps;
echo kernel.core_uses_pid = 1 | sudo tee -a /etc/sysctl.conf &> /dev/null;
echo kernel.core_pattern = "${k}/$(hostname)/core_dumps/core-%e-%s-%u-%g-%p-%t" | sudo tee -a /etc/sysctl.conf &> /dev/null;
echo fs.suid_dumpable = 2 | sudo tee -a /etc/sysctl.conf &> /dev/null;
logit "#############################################################################"
logit "core dump path created"
logit "Core Dump PATH is: ${k}/$(hostname)/core_dumps"
logit "#############################################################################"
echo -e "${yellow}+++++++++++++++++++++++++++ Current Core Dump PATH ++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}";
grep  'kernel.core_pattern' /etc/sysctl.conf;
echo -e "${yellow}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${reset}";
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

read -p "Do you want to view log file? (y/n) " yn
case $yn in 
n ) echo "End of Diagnostic"
;;
* ) 
more /tmp/sqream-sqdiag.log;
;;
esac

