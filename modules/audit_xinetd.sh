# audit_xinetd
#
# Audit xinetd services on Linux. Make sure services that are not required
# are not running. Leaving unrequired services running can lead to vectors
# of attack.
#
# chargen-dram and chargen-stream are network service that respond with
# 0 to 512 ASCII characters for each datagram it receives.
#
# daytim-dgrem and daytime-stream are network services that respondeswith the
# server's current date and time.
#
# echo-dgram and echo-stream are network services that responde to clients
# with the data sent to it by the client.
#
# tcpmux-server is a network service that allows a client to access other
# network services running on the server.
# tcpmux-server can be abused to circumvent the server's host based firewall.
# Additionally, tcpmux-server can be leveraged by an attacker to effectively
# port scan the server.
#
# Refer to Section(s) 2.1.12-8 Page(s) 54-8 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.12-8 Page(s) 63-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.12-8 Page(s) 57-61 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

audit_xinetd () {
  if [ "$os_name" = "Linux" ]; then
    check_dir="/etc/xinetd.d"
    if [ -d "$check_dir" ]; then
      funct_verbose_message "Xinet Services"
      xinetd_check=`cat $check_dir/* |grep disable |awk '{print $3}' |grep no |head -1 |wc -l`
      if [ "$xinetd_check" = "1" ]; then
        for service_name in amanda amandaidx amidxtape auth chargen-dgram \
          chargen-stream cvs daytime-dgram daytime-stream discard-dgram \
          echo-dgram echo-stream eklogin ekrb5-telnet gssftp klogin krb5-telnet \
          kshell ktalk ntalk rexec rlogin rsh rsync talk tcpmux-server telnet \
          tftp time-dgram time-stream uucp; do
          funct_xinetd_service $service_name disable yes
        done
      else
        funct_chkconfig_service xinetd 3 off
        funct_chkconfig_service xinetd 5 off
      fi
    fi
  fi
}
