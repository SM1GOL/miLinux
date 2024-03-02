#!/bin/bash
clear

option=$1 #option value if existed

#banner
logo () {
 local delay=0.1
 echo -e "\033[1m\033[96m"
 sleep $delay
 echo "[][]  [][]  [][][]  []      [][][]  [][][]  []  []  []  []  []"
 sleep $delay
 echo "[]  []  []    []    []        []    []  []  []  []  []    []"
 sleep $delay
 echo "[]      []    []    []        []    []  []  []  []  []  []  []"
  sleep $delay
 echo "[]      []  [][][]  [][][]  [][][]  []  [][][]  [][][]  []  [] v0.4"
 echo -e "\n\033[0m"
}

definition () {
 echo -e "\033[1m\033[96mmiLinux\033[0m is a simple script that gives you many informations about your linux distribution."
 echo "Usage: miLinux.sh [OPTION]"
 echo -e "Options:\033[96m"
 echo -e "\t-g, --general  : show general informations."
 echo -e "\t-c, --cpu      : show cpu informations."
 echo -e "\t-m, --memory   : show memory informations."
 echo -e "\t-r, --ram      : show RAM status."
 echo -e "\t-s, --services : show services."
 echo -e "\t-h, --help     : show this help list."
return
}

#get general information
default () {

 echo -e "Here is the informations about your linux distribution :\033[1m\033[96m[]"
 echo -e "\033[96m[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [][]"

 echo -e "[] Operating system:\033[0m $(uname -o)"

 echo -e "\033[1m\033[96m[] Distribution :\033[0m $(cut -d' ' -f1-3 /etc/issue)"

 echo -e "\033[1m\033[96m[] Kernel name:\033[0m $(uname -s)"

 echo -e "\033[1m\033[96m[] Kernel version:\033[0m $(uname -v)"

 echo -e "\033[1m\033[96m[] Kernel release:\033[0m $(uname -r)"

 echo -e "\033[1m\033[96m[] Network node hostname:\033[0m $(uname -n)"

 echo -e "\033[1m\033[96m[] Machine hardware name:\033[0m $(uname -m)"

 echo -e "\033[1m\033[96m[] Hardware platform:\033[0m $(uname -i)"

 echo -e "\033[1m\033[96m[] Processor type:\033[0m $(uname -p)"

 echo -e "\033[1m\033[96m[] Processor type:\033[0m $(uname -p)"

 echo -e "\033[1m\033[96m[] Mac address:\033[0m $(ifconfig | head -n1 | grep -o 'HWaddr .*' | awk '{print $2}')"
 echo -e "\033[1m\033[96m[] Ip address:\033[0m $(ifconfig | head -n2 | tail -n1 | grep -o 'inet addr:[0-9.]*' | head -n 1 | awk -F: '{print $2}')"

 echo -e "\033[1m\033[96m[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [][]"
return
}
#get memory informations
memory () {
echo -e "\033[1m\033[96m[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [][]"
 while IFS= read -r line;
 do
  propriety=$(echo $line|cut -d: -f1)
  value=$(echo $line|cut -d: -f2)
  echo -e "\033[1m\033[96m[] $propriety:\033[0m$value"
 done</proc/meminfo
echo -e "\033[1m\033[96m[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [][]"
return
}

#get cpu informations
cpu () {
echo -e "\033[1m\033[96m[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [][]"
 while IFS= read -r line;
 do
  propriety=$(echo $line|cut -d: -f1)
  value=$(echo $line|cut -d: -f2)
  echo -e "\033[1m\033[96m[] $propriety:\033[0m$value"
 done</proc/cpuinfo
echo -e "\033[1m\033[96m[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [][]"
return
}

#show ram status
ram () {
echo -e "\033[1m\033[96m[][] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [][]"
 echo -e "\033[1m\033[96m$(free |head -n1)"
 echo -e "\033[1m\033[96m$(free |tail -n2|head -n1|cut -d: -f1)\033[0m$(free -h |tail -n2|head -n1|cut -d: -f2)"
 echo -e "\033[1m\033[96m$(free |tail -n1|cut -d: -f1)\033[0m$(free -h|tail -n1|cut -d: -f2)"
echo -e "\033[1m\033[96m[][] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [][]"
return
}

#get services informations
services () {
 echo -e "\033[1m\033[96m[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [][]"
 service --status-all&>temp_file
 while IFS= read -r line;
  do
   service_name=$(echo $line|cut -d']' -f2)
   whatis $service_name&>temp_serv
   grep -i nothing temp_serv>/dev/null

   if [ $? -eq 1 ]; then #if there is info about the service
    value=$(cat temp_serv|cut -d- -f2)
   else
    value="\033[91mNo definition available"
   fi
   echo -e "\033[1m\033[96m[]$service_name:\033[0m$value"
  done<temp_file
  rm -f temp_file,temp_serv
echo -e "\033[1m\033[96m[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [][]"
return
}

#show an error
error () {
 echo -e "\033[91mmiLinux : invalid option '$option'\nTry miLinux -h to get help."
}

#main
logo
echo "Starting at $(date)"

if [ $# -eq 0 ];
 then
  definition
else
  case "$1" in
    "-h"|"--help")
     definition
;;
    "-g"|"--general")
     default
;;

  "-c"|"--cpu")
     cpu
;;
  "-r"|"--ram")
     ram
;;
  "-m"|"--memory")
     memory
;;
  "-s"|"--services")
     services
;;
    *)
     error
;;
  esac
fi
