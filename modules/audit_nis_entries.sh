# audit_nis_entries
#
# The character + in various files used to be markers for systems to insert
# data from NIS maps at a certain point in a system configuration file.
# These entries are no longer required on Solaris systems, but may exist in
# files that have been imported from other platforms.
# These entries may provide an avenue for attackers to gain privileged access
# on the system.
#.

audit_nis_entries () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "NIS Map Entries"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Legacy NIS '+' entries"
    fi
    total=`expr $total + 1`
    for check_file in /etc/passwd /etc/shadow /etc/group; do
      if [ "$audit_mode" != 2 ]; then
        for file_entry in `cat $check_file |grep "^+"`; do
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   NIS entry \"$file_entry\" in $check_file [$score]"
            funct_verbose_message "" fix
            funct_verbose_message 'sed -e "s/^+/#&/" < $check_file > $temp_file' fix
            funct_verbose_message "cat $temp_file > $check_file" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            funct_backup_file $check_file
            echo "Setting:   File $check_file to have no NIS entries"
            sed -e "s/^+/#&/" < $check_file > $temp_file
            cat $temp_file > $check_file
            if [ "$os_name" = "SunOS" ]; then
              if [ "$os_version" != "11" ]; then
                pkgchk -f -n -p $check_file 2> /dev/null
              else
                pkg fix `pkg search $check_file |grep pkg |awk '{print $4}'`
              fi
            fi
            rm $temp_file
          fi
        done
        if [ "$file_entry" = "" ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    No NIS entries in $check_file [$score]"
          fi
        fi
      else
        funct_restore_file $check_file $restore_dir
      fi
    done
  fi
}
