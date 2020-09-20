# check_file_perms
#
# Code to check permissions on a file
# If running in audit mode it will check permissions and report
# If running in lockdown mode it will fix permissions if they
# don't match those passed to routine
# Takes:
# check_file:   Name of file
# check_perms:  Octal of file permissions, eg 755
# check_owner:  Owner of file
# check_group:  Group ownership of file
#.

check_file_perms () {
  check_file=$1
  check_perms=$2
  check_owner=$3
  check_group=$4
  if [ "$id_check" = "0" ]; then
    find_command="find"
  else
    find_command="sudo find"
  fi
  if [ "$audit_mode" != 2 ]; then
    string="File permissions on $check_file"
    verbose_message "$string"
    if [ "$ansible" = 1 ]; then
      echo ""
      echo "- name: Checking $string"
      echo "  file:"
      echo "    path: $check_file"
      if [ ! "$check_owner" = "" ]; then
        echo "    owner: $check_owner"
      fi
      if [ ! "$check_group" = "" ]; then
        echo "    group: $check_group"
      fi
      echo "    mode: $check_perms"
      echo ""
    fi
  fi
  if [ ! -e "$check_file" ]; then
    if [ "$audit_mode" != 2 ]; then
      verbose_message "Notice:    File $check_file does not exist"
    fi
    return
  fi
  if [ "$check_owner" != "" ]; then
    check_result=$( find "$check_file" -perm $check_perms -user $check_owner -group $check_group 2> /dev/null )
  else
    check_result=$( find "$check_file" -perm $check_perms 2> /dev/null )
  fi
  log_file="fileperms.log"
  if [ "$check_result" != "$check_file" ]; then
    if [ "$audit_mode" = 1 ]; then
      increment_insecure "File $check_file has incorrect permissions"
      verbose_message "" fix
      verbose_message "chmod $check_perms $check_file" fix
      if [ "$check_owner" != "" ]; then
        verbose_message "chown $check_owner:$check_group $check_file" fix
      fi
      verbose_message "" fix
    fi
    if [ "$audit_mode" = 0 ]; then
      log_file="$work_dir/$log_file"
      if [ "$os_name" = "SunOS" ]; then
        file_perms=$( truss -vstat -tstat ls -ld $check_file 2>&1 | grep 'm=' | tail -1 | awk '{print $3}' | cut -f2 -d'=' | cut -c4-7 )
      else
        if [ "$os_name" = "Darwin" ]; then
          file_perms=$( stat -f %p $check_file | tail -c 4 )
        else
          file_perms=$( stat -c %a $check_file )
        fi
      fi
      file_owner=$( ls -l $check_file |awk '{print $3","$4}' )
      echo "$check_file,$file_perms,$file_owner" >> $log_file
      verbose_message "Setting:   File $check_file to have correct permissions"
      chmod $check_perms $check_file
      if [ "$check_owner" != "" ]; then
        chown $check_owner:$check_group $check_file
      fi
    fi
  else
    if [ "$audit_mode" = 1 ]; then
      increment_secure "File $check_file has correct permissions"
    fi
  fi
  if [ "$audit_mode" = 2 ]; then
    restore_file="$restore_dir/$log_file"
    if [ -f "$restore_file" ]; then
      restore_check=$( grep "$check_file" $restore_file | cut -f1 -d"," )
      if [ "$restore_check" = "$check_file" ]; then
        restore_info=$( grep "$check_file" $restore_file )
        restore_perms=$( echo "$restore_info" |cut -f2 -d"," )
        restore_owner=$( echo "$restore_info" |cut -f3 -d"," )
        restore_group=$( echo "$restore_info" |cut -f4 -d"," )
        verbose_message "Restoring: File $check_file to previous permissions"
        chmod $restore_perms $check_file
        if [ "$check_owner" != "" ]; then
          chown $restore_owner:$restore_group $check_file
        fi
      fi
    fi
  fi
}
