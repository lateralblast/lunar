# audit_ndd_value
#
# Modify Network Parameters
# Checks and sets ndd values
#.

audit_ndd_value () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      ndd_name=$1
      ndd_property=$2
      correct_value=$3
      if [ "$ndd_property" = "tcp_extra_priv_ports_add" ]; then
        current_value=$( ndd -get $ndd_name tcp_extra_priv_ports | grep "$correct_value" )
      else
        current_value=$( ndd -get $ndd_name $ndd_property )
      fi
      file_header="ndd"
      log_file="$work_dir/$file_header.log"
      if [ "$audit_mode" = 2 ]; then
        restore_file="$restore_dir/$file_header.log"
        if [ -f "$restore_file" ]; then
          restore_property=$( grep "$ndd_property," $restore_file | cut -f2 -d',' )
          restore_value=$( grep "$ndd_property," $restore_file | cut -f3 -d',' )
          if [ $( expr "$restore_property" : "[A-z]" ) = 1 ]; then
            if [ "$ndd_property" = "tcp_extra_priv_ports_add" ]; then
              current_value=$( ndd -get $ndd_name tcp_extra_priv_ports | grep -c "$restore_value" )
            fi
            if [ $( expr "$current_value" : "[1-9]" ) = 1 ]; then
              if [ "$current_value" != "$restore_value" ]; then
                if [ "$ndd_property" = "tcp_extra_priv_ports_add" ]; then
                  ndd_property="tcp_extra_priv_ports_del"
                fi
                echo "Restoring: $ndd_name $ndd_property to $restore_value"
                ndd -set $ndd_name $ndd_property $restore_value
              fi
            fi
          fi
        fi
      else
        verbose_message "NDD $ndd_name $ndd_property"
      fi
      if [ "$current_value" -ne "$correct_value" ]; then
        command_line="ndd -set $ndd_name $ndd_property $correct_value"
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "NDD \"$ndd_name $ndd_property\" not set to \"$correct_value\""
          verbose_message "" fix
          verbose_message "$command_line" fix
          verbose_message "" fix
        else
          if [ "$audit_mode" = 0 ]; then
            verbose_message "Setting:   NDD \"$ndd_name $ndd_property\" to \"$correct_value\""
            echo "$ndd_name,$ndd_property,$correct_value" >> $log_file
            $( $command_line )
          fi
        fi
      else
        if [ "$audit_mode" != 2 ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_secure "NDD \"$ndd_name $ndd_property\" already set to \"$correct_value\""
          fi
        fi
      fi
    fi
  fi
}
