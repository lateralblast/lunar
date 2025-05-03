#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ssh_config
#
# Check SSH config
#
# Refer to Section(s) 6.2.1-15  Page(s) 127-37 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.2.1-15  Page(s) 147-59 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.2.1-15  Page(s) 130-41 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.2.1-16  Page(s) 218-37 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 9.2.1-15  Page(s) 121-31 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.4.14.9  Page(s) 57-60  CIS OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 1.2       Page(s) 2-3    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 6.3-7     Page(s) 47-51  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.1.1-11  Page(s) 78-87  CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 5.2.1-16  Page(s) 201-18 CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 5.2.1-16  Page(s) 213-31 CIS Ubuntu 16.04 Benchmark v2.0.0
# Refer to Section(s) 5.1.1-22  Page(s) 523-78 CIS Ubuntu 24.04 Benchmark v1.0.0
#
# Refer to http://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.vsphere.security.doc%2FGUID-12E27BF3-3769-4665-8769-DA76C2BC9FFE.html
# Refer to https://wiki.mozilla.org/Security/Guidelines/OpenSSH
#.

audit_ssh_config () {
  verbose_message "SSH" "check"
  if [ "${os_name}" = "VMkernel" ]; then
    verbose_message     "SSH Daemon"  "check"
    check_linux_service "SSH"         "off"
  fi
  for check_file in /etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /opt/local/ssh/sshd_config; do
    if [ -f "${check_file}" ]; then
      if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "AIX" ]; then
       verbose_message "SSH Configuration" "check"
        if [ "${os_name}" = "Darwin" ]; then
          check_file_value    "is" "${check_file}" "GSSAPIAuthentication"               "space" "yes"                "hash"
          check_file_value    "is" "${check_file}" "GSSAPICleanupCredentials"           "space" "yes"                "hash"
        fi
        check_file_perms "${check_file}" "0600" "root" "root"
        # check_file_value is ${check_file} Host space "*" hash
        check_file_value      "is"  "${check_file}" "UseLogin"                          "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "X11Forwarding"                     "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "MaxAuthTries"                      "space" "4"                  "hash"
        check_file_value      "is"  "${check_file}" "MaxAuthTriesLog"                   "space" "0"                  "hash"
        check_file_value      "is"  "${check_file}" "RhostsAuthentication"              "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "IgnoreRhosts"                      "space" "yes"                "hash"
        check_file_value      "is"  "${check_file}" "StrictModes"                       "space" "yes"                "hash"
        check_file_value      "is"  "${check_file}" "AllowTcpForwarding"                "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "DisableForwarding"                 "space" "yes"                "hash"
        check_file_value      "is"  "${check_file}" "Protocol"                          "space" "${ssh_protocol}"    "hash"
        if [ "$ssh_protocol" = "1" ]; then
          check_file_value    "is"  "${check_file}" "ServerKeyBits"                     "space" "$ssh_key_size" "hash"
        fi
        check_file_value      "is"  "${check_file}" "GatewayPorts"                      "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "RhostsRSAAuthentication"           "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "PermitRootLogin"                   "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "PermitEmptyPasswords"              "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "PermitUserEnvironment"             "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "HostbasedAuthentication"           "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "PrintMotd"                         "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "ClientAliveInterval"               "space" "300"                "hash"
        check_file_value      "is"  "${check_file}" "ClientAliveCountMax"               "space" "0"                  "hash"
        check_file_value      "is"  "${check_file}" "RSAAuthentication"                 "space" "no"                 "hash"
        check_file_value      "is"  "${check_file}" "Banner"                            "space" "/etc/issue"         "hash"
        check_file_value      "is"  "${check_file}" "LogLevel"                          "space" "VERBOSE"            "hash"
        if [ ! "${ssh_allowusers}" = "" ]; then
          check_file_value    "is"  "${check_file}" "AllowUsers"                        "space" "${ssh_allowusers}"  "hash"
        fi
        if [ ! "${ssh_allowgroups}" = "" ]; then
                  check_file_value    "is"  "${check_file}" "AllowUsers"                "space" "${ssh_allowgroups}" "hash"
        fi
                if [ ! "${ssh_denyusers}" = "" ]; then
          check_file_value    "is"  "${check_file}" "DenyUsers"                         "space" "${ssh_denyusers}"    "hash"
        fi
        if [ ! "${ssh_denygroups}" = "" ]; then
                  check_file_value    "is"  "${check_file}" "DenyGroups"                "space" "${ssh_denygroups}"   "hash"
        fi
                        if [ "$ssh_sandbox" = "yes" ]; then
          check_file_value    "is"  "${check_file}" "UsePrivilegeSeparation"            "space" "sandbox"             "hash"
                else
           check_file_value    "is"  "${check_file}" "UsePrivilegeSeparation"           "space" "yes"                 "hash"
        f i
        check_file_value      "is"  "${check_file}" "LoginGraceTime"                    "space" "60"                  "hash"
        if [ "${os_vendor}" = "Ubuntu" ] && [ "${os_version}" -ge 24 ]; the n
          check_file_value    "is"  "${check_file}" "MaxStartups"                       "space" "10:30:60"            "hash"
          check_file_value    "is"  "${check_file}" "MaxSessions"                       "space" "10"                  "hash"
        f i
        # Check for kerbero s
        check_file="/etc/krb5/krb5.conf   "
        if [ -f "${check_file}" ]; the    n
          admin_check=$( grep -v '^#' ${check _file} | grep "admin_server" | cut -f2 -d= | sed 's/ //g' | wc -l | sed 's/ //g' )
          if [ "$admin_server" != "0" ]; the  n
            check_file="/etc/ssh/sshd_config"
            check_file_value  "is"  "${check_file}"  "UsePAM"                           "space" "yes"                 "hash"
            check_file_value  "is"  "${check_file}"  "GSSAPIAuthentication"             "space" "yes"                 "hash"
            check_file_value  "is"  "${check_file}"  "GSSAPIKeyExchange"                "space" "yes"                 "hash"
            check_file_value  "is"  "${check_file}"  "GSSAPIStoreDelegatedCredentials"  "space" "yes"                 "hash"
            #check_file_value is ${check_file} Host space "*" hash
          fi
        fi
        if [ "${os_name}" = "FreeBSD" ]; then
          check_file_value    "is"  "/etc/rc.conf"   "sshd_enable"                      "eq"    "YES"                 "hash"
        fi
      fi
    fi
  done
  verbose_message "SSH MACs" "check"
  ignore_list=""
  mac_list=$( sshd -T | grep "^macs" | sed "s/,/ /g" | sed "s/^macs //g" )
  for mac_name in ${mac_list}; do
    case "${mac_name}" in
      hmac-md5|hmac-md5-96|hmac-ripemd160|hmac-sha1-96|umac-64@openssh.com|hmac-md5-etm@openssh.com|hmac-md5-96-etm@openssh.com|hmac-ripemd160-etm@openssh.com|mac-sha1-96-etm@openssh.com|umac-64-etm@openssh.com|umac-128-etm@openssh.com)
        increment_insecure "MAC ${mac_name} is enabled"
        if [ "${ignore_list}" = "" ]; then
          ignore_list="${mac_name}"
        else
          ignore_list="${ignore_list},${mac_name}"
        fi
        ;;
      *)
        increment_secure "MAC ${mac_name} is enabled"
        ;;
    esac
  done
  if [ ! "${ignore_list}" = "" ]; then
    for check_file in /etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /opt/local/ssh/sshd_config; do
      if [ -f "${check_file}" ]; then
        check_file_value "is" "${check_file}" "MACs" "space" "-${ignore_list}" "hash"
      fi
    done
  fi
  verbose_message "SSH KexAlgorithms" "check"
  ignore_list=""
  kex_list=$( sshd -T | grep "^kexalgorithms" | sed "s/,/ /g" | sed "s/^kexalgorithms //g" )
  for kex_name in ${kex_list}; do
    case "${kex_name}" in
      diffie-hellman-group1-sha1|diffie-hellman-group14-sha1|diffie-hellman-group-exchange-sha1) 
        increment_insecure "Kex Algoritm ${kex_name} is enabled"
        if [ "${ignore_list}" = "" ]; then
          ignore_list="${kex_name}"
        else
          ignore_list="${ignore_list},${kex_name}"
        fi
        ;;
      *)
        increment_secure "Kex Algoritm ${kex_name} is enabled"
        ;;
    esac
  done
  if [ ! "${ignore_list}" = "" ]; then
    for check_file in /etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /opt/local/ssh/sshd_config; do
      if [ -f "${check_file}" ]; then
        check_file_value "is" "${check_file}" "KexAlgorithms" "space" "-${ignore_list}" "hash"
      fi
    done
  fi
  verbose_message "SSH Ciphers" "check"
  ignore_list=""
  cipher_list=$( sshd -T | grep "^ciphers" | sed "s/,/ /g" | sed "s/^ciphers //g" )
  for cipher_name in ${cipher_list}; do
    case "${cipher_name}" in
      3des-cbc|aes128-cbc|aes192-cbc|aes256-cbc) 
        increment_insecure  "Cipher ${cipher_name} is enabled"
        if [ "${ignore_list}" = "" ]; then
          ignore_list="${cipher_name}"
        else
          ignore_list="${ignore_list},${cipher_name}"
        fi
        ;;
      *)
        increment_secure    "Cipher ${cipher_name} is enabled"
        ;;
    esac
  done
  if [ ! "${ignore_list}" = "" ]; then
    for check_file in /etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /opt/local/ssh/sshd_config; do
      if [ -f "${check_file}" ]; then
        check_file_value "is" "${check_file}" "Ciphers" "space" "-${ignore_list}" "hash"
      fi
    done
  fi
}
