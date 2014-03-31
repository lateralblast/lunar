# audit_unconfined_daemons
#
# Daemons that are not defined in SELinux policy will inherit the security
# context of their parent process.
#
# Refer to Section(s) 1.4.6 Page(s) 40 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.4.6 Page(s) 45-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.4.6 Page(s) 43 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

audit_unconfined_daemons () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Unconfined Daemons"
    daemon_check=`ps -eZ | egrep "initrc" | egrep -vw "tr|ps|egrep|bash|awk" | tr ':' ' ' | awk '{ print $NF }'`
    total=`expr $total + 1`
    if [ "$daemon_check" = "" ]; then
      if [ "$audit_mode" = 1 ]; then
        score=`expr $score - 1`
        echo "Warning:   Unconfined daemons $daemon_check [$score]"
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        score=`expr $score + 1`
        echo "Secure:    No unconfined daemons [$score]"
      fi
    fi
  fi
}
