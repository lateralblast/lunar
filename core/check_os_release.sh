#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# get_ubuntu_codename
#
# Get Ubuntu Codename 
#.

get_ubuntu_codename () {
  case "${1}" in
    "4.10")
      ubuntu_codename="warty"
      ;;
    "5.04")
      ubuntu_codename="hoary"
      ;;
    "5.10")
      ubuntu_codename="breezy"
      ;;
    "6.04")
      ubuntu_codename="dapper"
      ;;
    "6.10")
      ubuntu_codename="edgy"
      ;;
    "7.04")
      ubuntu_codename="feisty"
      ;;
    "7.10")
      ubuntu_codename="gutsy"
      ;;
    "8.04")
      ubuntu_codename="hardy"
      ;;
    "8.10")
      ubuntu_codename="intrepid"
      ;;
    "9.04")
      ubuntu_codename="jaunty"
      ;;
    "9.10")
      ubuntu_codename="karmic"
      ;;
    "10.04")
      ubuntu_codename="lucid"
      ;;
    "10.10")
      ubuntu_codename="maverick"
      ;;
    "11.04")
      ubuntu_codename="natty"
      ;;
    "11.10")
      ubuntu_codename="oneieric"
      ;;
    "12.04")
      ubuntu_codename="precise"
      ;;
    "12.10")
      ubuntu_codename="quantal"
      ;;
    "13.04")
      ubuntu_codename="raring"
      ;;
    "13.10")
      ubuntu_codename="saucy"
      ;;
    "14.04")
      ubuntu_codename="trusty"
      ;;
    "16.04")
      ubuntu_codename="xenial"
      ;;
    "18.04")
      ubuntu_codename="bionic"
      ;;
    "20.04")
      ubuntu_codename="focal"
      ;;
    "22.04")
      ubuntu_codename="jammy"
      ;;
    "24.04")
      ubuntu_codename="noble"
      ;;
    "24.10")
      ubuntu_codename="oracular"
      ;;
    "25.04")
      ubuntu_codename="plucky"
      ;;
    "25.10")
      ubuntu_codename="questing"
      ;;
    "26.04")
      ubuntu_codename="resolute"
      ;;
    *)
      ubuntu_codename="unknown"    
      ;;
  esac
}

# check_os_release
#
# Get OS release information
#.

check_os_release () {
  echo ""
  echo "# Local System Information:"
  echo ""
  os_codename=""
  os_minorrev=""
  os_name=$( uname )
  if [ "${os_name}" = "Darwin" ]; then
    os_release=$( sw_vers |grep ProductVersion |awk '{print $2}' )
    os_version=$( echo "${os_release}" |cut -f1 -d. )
    os_update=$( echo "${os_release}" |cut -f2 -d. )
    os_vendor="Apple"
    if [ "${os_update}" = "" ]; then
      os_update=$( sw_vers |grep ^BuildVersion |awk '{print $2}' )
    fi
  fi
  if [ "${os_name}" = "Linux" ]; then
    linux_dist=$( lsb_release -i -s | tr '[:upper:]' '[:lower:]' )
    os_release=$(lsb_release -r 2> /dev/null |awk '{print $2}')
    if [ -f "/etc/redhat-release" ]; then
      os_version=$( awk '{print $3}' < /etc/redhat-release | cut -f1 -d. )
      if [ "${os_version}" = "Enterprise" ]; then
        os_version=$( awk '{print $7}' < /etc/redhat-release | cut -f1 -d. )
        if [ "${os_version}" = "Beta" ]; then
          os_version=$( awk '{print $6}' < /etc/redhat-release | cut -f1 -d. )
          os_update=$( awk '{print $6}' < /etc/redhat-release | cut -f2 -d. )
        else
          os_update=$( awk '{print $7}' < /etc/redhat-release | cut -f2 -d. )
        fi
      else
        if [ "${os_version}" = "release" ]; then
          os_version=$( awk '{print $4}' < /etc/redhat-release | cut -f1 -d. )
          os_update=$( awk '{print $4}' < /etc/redhat-release | cut -f2 -d. )
        else
          os_update=$( awk '{print $3}' < /etc/redhat-release | cut -f2 -d. )
        fi
      fi
      os_vendor=$( awk '{print $1}' < /etc/redhat-release )
      linux_dist="redhat"
    else
      if [ -f "/etc/debian_version" ]; then
        if [ -f "/etc/lsb-release" ]; then
          os_version=$( grep "DISTRIB_RELEASE" /etc/lsb-release | cut -f2 -d= | cut -f1 -d. )
          os_update=$( grep "DISTRIB_RELEASE" /etc/lsb-release | cut -f2 -d= | cut -f2 -d. )
          os_vendor=$( grep "DISTRIB_ID" /etc/lsb-release | cut -f2 -d= )
          os_codename=$( grep "DISTRIB_CODENAME" /etc/lsb-release | cut -f2 -d= )
          os_minorrev=$(lsb_release -d |awk '{print $3}' |cut -f3 -d. )
        else
          if [ -f "/etc/debian_version" ]; then
            os_version=$( cut -f1 -d. /etc/debian_version )
            os_update=$( cut -f2 -d. /etc/debian_version )
            os_vendor="Debian"
          else
            os_version=$( lsb_release -r | awk '{print $2}' | cut -f1 -d. )
            os_update=$( lsb_release -r | awk '{print $2}' | cut -f2 -d. )
            os_vendor=$( lsb_release -i | awk '{print $3}' )
          fi
        fi
        linux_dist="debian"
        os_test=$( echo "${os_version}" | grep "[0-9]" )
        if [ -n "$os_test" ]; then 
          if [ ! -f "/usr/sbin/sysv-rc-conf" ] && [ "${os_version}" -lt 16 ]; then
            echo "Notice:    The sysv-rc-conf package may be required by this script but is not present"
          fi
        fi
        if [ ! -f "/usr/bin/bc" ]; then
          use_expr="yes"
        fi
        if [ ! -f "/usr/bin/finger" ]; then
          use_finger="no"
        fi
      else
        if [ -f "/etc/SuSE-release" ]; then
          os_version=$( grep '^VERSION' /etc/SuSe-release | awk '{print $3}' | cut -f1 -d. )
          os_update=$( grep '^VERSION' /etc/SuSe-release | awk '{print $3}' | cut -f2 -d. )
          os_vendor="SuSE"
          linux_dist="suse"
        else
          if [ -f "/etc/arch-release" ]; then
            os_vendor="Arch"
            linux_dist="arch"
          else
            if [ -f "/etc/os-release" ]; then
              os_vendor="Amazon"
              os_version=$( grep 'CPE_NAME' /etc/os-release | cut -f2 -d: | cut -f1 -d. )
              os_update=$( grep 'CPE_NAME' /etc/os-release | cut -f2 -d: | cut -f2 -d. )
            fi
          fi
        fi
      fi
    fi
  fi
  if [ "${os_name}" = "SunOS" ]; then
    os_vendor="Oracle Solaris"
    os_version=$( uname -r |cut -f2 -d. )
    if [ "${os_version}" = "11" ]; then
      os_update=$( grep Solaris /etc/release | awk '{print $3}' | cut -f2 -d. )
    fi
    if [ "${os_version}" = "10" ]; then
      os_update=$( grep Solaris /etc/release | awk '{print $5}' | cut -f2 -d_ | sed 's/[A-z]//g' )
    fi
    if [ "${os_version}" = "9" ]; then
      os_update=$( grep Solaris /etc/release | awk '{print $4}' | cut -f2 -d_ | sed 's/[A-z]//g' )
    fi
  fi
  if [ "${os_name}" = "FreeBSD" ]; then
    os_version=$( uname -r | cut -f1 -d. )
    os_update=$( uname -r | cut -f2 -d. )
    os_vendor=${os_name}
  fi
  if [ "${os_name}" = "AIX" ]; then
    os_vendor="IBM"
    os_version=$( oslevel | cut -f1 -d. )
    os_update=$( oslevel | cut -f2 -d. )
  fi
  if [ "${os_name}" = "VMkernel" ]; then
    os_version=$( uname -r )
    os_update=$( uname -v | awk '{print $4}' )
    os_vendor="VMware"
  fi
  if [ "${os_name}" != "Linux" ] && [ "${os_name}" != "SunOS" ] && [ "${os_name}" != "Darwin" ] && [ "${os_name}" != "FreeBSD" ] && [ "${os_name}" != "AIX" ] && [ "${os_name}" != "VMkernel" ]; then
    echo "OS not supported"
    exit
  fi
  if [ "${os_name}" = "Linux" ]; then
    os_platform=$( grep model < /proc/cpuinfo |tail -1 |cut -f2 -d: |sed "s/^ //g" )
  else
    if [ "${os_name}" = "Darwin" ]; then
      os_platform=$( system_profiler SPHardwareDataType |grep Chip |cut -f2 -d: |sed "s/^ //g" )
    else
      os_platform=$( uname -p )
    fi
  fi
  echo "Hostname:   ${os_hostname}"
  os_domain=$( hostname -d )
  if [ "${os_domain}" = "" ]; then
    os_domain=$( hostname -f | cut -f2- -d. )
  fi
  echo "Domain:     ${os_domain}"
  os_machine=$( uname -m )
  check_virtual_platform
  if [ "${os_platform}" = "" ]; then
    os_platform=$( uname -p )
  fi
  echo "Processor:  ${os_platform}"
  echo "Machine:    ${os_machine}"
  echo "Vendor:     ${os_vendor}"
  echo "Name:       ${os_name}"
  if [ ! "${os_release}" = "" ]; then
    echo "Release:    ${os_release}"
  fi
  echo "Version:    ${os_version}"
  echo "Update:     ${os_update}"
  if [ ! "${os_minorrev}" = "" ]; then
    echo "Minor Rev:  ${os_minorrev}"
  fi
  if [ ! "${os_codename}" = "" ]; then
    echo "Codename:   ${os_codename}"
  fi
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${os_update}" -lt 10 ]; then
      long_update="0${os_update}"
    else
      long_update="${os_update}"
    fi
    long_os_version="${os_version}${long_update}"
    #echo "XRelease:  ${long_os_version}"
  fi
}
