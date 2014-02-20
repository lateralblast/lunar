# audit_xinetd
#
# Audit xinetd services on Linux. Make sure services that are not required
# are not running. Leaving unrequired services running can lead to vectors
# of attack.
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
          audit_xinetd_service $service_name disable yes
        done
      else
        funct_chkconfig_service xinetd 3 off
        funct_chkconfig_service xinetd 5 off
      fi
    fi
  fi
}
