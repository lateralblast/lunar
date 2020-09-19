# audit_xinetd
#
# Refer to Section(s) 2.1.12-8  Page(s) 54-8  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.12-8  Page(s) 63-6  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.12-8  Page(s) 57-61 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.1.1-7   Page(s) 91-7  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 2.1.10-1  Page(s) 88-9  CIS Amazon Linux Benchmark v2.0.0
#.

audit_xinetd () {
  if [ "$os_name" = "Linux" ]; then
    check_dir="/etc/xinetd.d"
    if [ -d "$check_dir" ]; then
      check=$( ls -l $check_dir | awk '{print $2}' )
      if [ ! "$check" = "0" ]; then
        verbose_message "Xinet Services"
        xinetd_check=$( grep disable $check_dir/* | awk '{print $3}' | grep no | head -1 | wc -l )
        if [ "$xinetd_check" = "1" ]; then
          for service_name in amanda amandaidx amidxtape auth chargen-dgram \
            chargen-stream cvs daytime-dgram daytime-stream discard-dgram \
            echo-dgram echo-stream eklogin ekrb5-telnet gssftp klogin krb5-telnet \
            kshell ktalk ntalk rexec rlogin rsh rsync talk tcpmux-server telnet \
            tftp time-dgram time-stream uucp; do
            check_xinetd_service $service_name disable yes
          done
        else
          check_chkconfig_service xinetd 3 off
          check_chkconfig_service xinetd 5 off
        fi
      fi
    fi
  fi
}
  
