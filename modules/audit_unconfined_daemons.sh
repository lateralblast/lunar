# audit_unconfined_daemons
#
# Unconfined daemons.
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
