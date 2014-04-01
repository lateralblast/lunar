# audit_pam_wheel
#
# PAM Wheel group membership. Make sure wheel group membership is required to su.
#
# Refer to Section(s) 6.5 Page(s) 142-3 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.5 Page(s) 165-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.5 Page(s) 145-6 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 9.5 Page(s) 135-6 SLES 11 Benchmark v1.0.0
#.

audit_pam_wheel () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "PAM SU Configuration"
    check_file="/etc/pam.d/su"
    search_string="use_uid"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Wheel group membership required for su in $check_file"
      total=`expr $total + 1`
      check_value=`cat $check_file |grep '^auth' |grep '$search_string$' |awk '{print $8}'`
      if [ "$check_value" != "$search_string" ]; then
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score - 1`
          echo "Warning:   Wheel group membership not required for su in $check_file [$score]"
          funct_verbose_message "" fix
          funct_verbose_message "cp $check_file $temp_file" fix
          funct_verbose_message "cat $temp_file |awk '( $1==\"#auth\" && $2==\"required\" && $3~\"pam_wheel.so\" ) { print \"auth\t\trequired\t\",$3,\"\tuse_uid\"; next }; { print }' > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          echo "Setting:   Password minimum length in $check_file"
          cp $check_file $temp_file
          cat $temp_file |awk '( $1=="#auth" && $2=="required" && $3~"pam_wheel.so" ) { print "auth\t\trequired\t",$3,"\tuse_uid"; next }; { print }' > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score + 1`
          echo "Secure:    Wheel group membership required for su in $check_file [$score]"
        fi
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
