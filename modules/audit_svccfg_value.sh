# audit_svccfg_value
#
# Remote Procedure Calls (RPC) is used by many services within the Solaris 10
# operating system. Some of these services allow external connections to use
# the service (e.g. NFS, NIS).
#
# RPC-based services are typically deployed to use very weak or non-existent
# authentication and yet may share very sensitive information. Unless one of
# the services is required on this machine, it is best to disable RPC-based
# tools completely. If you are unsure whether or not a particular third-party
# application requires RPC services, consult with the application vendor.
#.

audit_svccfg_value () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "RPC Port Mapping"
    service_name=$1
    service_property=$2
    correct_value=$3
    current_value=`svccfg -s $service_name listprop $service_property |awk '{print $3}'`
    file_header="svccfg"
    log_file="$work_dir/$file_header.log"
    total=`expr $total + 1`
    if [ "$audit_mode" = 2 ]; then
      restore_file="$restore_dir/$file_header.log"
      if [ -f "$restore_file" ]; then
        restore_property=`cat $restore_file |grep "$service_name" |cut -f2 -d','`
        restore_value=`cat $restore_file |grep "$service_name" |cut -f3 -d','`
        if [ `expr "$restore_property" : "[A-z]"` = 1 ]; then
          if [ "$current_value" != "$restore_vale" ]; then
            echo "Restoring: $service_name $restore_propert to $restore_value"
            svccfg -s $service_name setprop $restore_property = $restore_value
          fi
        fi
      fi
    else
      echo "Checking:  Service $service_name"
    fi
    if [ "$current_value" != "$correct_value" ]; then
      if [ "$audit_mode" = 1 ]; then
        score=`expr $score - 1`
        echo "Warning:   Service $service_name $service_property not set to $correct_value [$score]"
        command_line="svccfg -s $service_name setprop $service_property = $correct_value"
        funct_verbose_message "" fix
        funct_verbose_message "$command_line" fix
        funct_verbose_message "" fix
      else
        if [ "$audit_mode" = 0 ]; then
          echo "Setting:   $service_name $service_propery to $correct_value"
          echo "$service_name,$service_property,$current_value" >> $log_file
          svccfg -s $service_name setprop $service_property = $correct_value
        fi
      fi
    else
      if [ "$audit_mode" != 2 ]; then
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score + 1`
          echo "Secure:    Service $service_name $service_property already set to $correct_value [$score]"
        fi
      fi
    fi
  fi
}
