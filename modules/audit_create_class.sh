# audit_create_class
#
# Creating Audit Classes improves the auditing capabilities of Solaris.
#
# Refer to Section(s) 4.1-5 Page(s) 39-45 CIS Solaris 11.1 v1.0.0
#.

audit_create_class () {
  if [ "$os_name" = "SunOS" ]; then
    check_file="/etc/security/audit_class"
    if [ -f "$check_file" ]; then
      verbose_message "Audit Classes"
      class_check=$( cat $check_file | grep "Security Lockdown" )
      if [ $( expr "$class_check" : "[A-z]" ) != 1 ]; then
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "Audit class not enabled"
        else
          if [ "$audit_mode" = 0 ]; then
            verbose_message "Setting:   Audit class to enabled"
            if [ ! -f "$work_dir$check_file" ]; then
              verbose_message "Saving:    File $check_file to $work_dir$check_file"
              find $check_file | cpio -pdm $work_dir 2> /dev/null
            fi
            file_length=$( wc -l $check_file | awk '{print $1}' | sed 's/ //g' )
            file_length=$( expr $file_length - 1 )
            head -$file_length $check_file > $temp_file
            echo "0x0100000000000000:lck:Security Lockdown" >> $temp_file
            tail -1 $check_file >> $temp_file
            cp $temp_file $check_file
          fi
        fi
      fi
      if [ "$audit_mode" = 2 ]; then
        if [ -f "$restore_dir/$check_file" ]; then
          cp -p $restore_dir/$check_file $check_file
          if [ "$os_version" = "10" ]; then
            pkgchk -f -n -p $check_file 2> /dev/null
          else
            pkg fix $( pkg search $check_file | grep pkg | awk '{print $4}' )
         fi
        fi
      fi
    fi
  fi
}
