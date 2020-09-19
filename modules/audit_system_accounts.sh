# audit_system_accounts
#
# Refer to Section(s) 7.2   Page(s) 146-147 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 7.2   Page(s) 169     CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 7.2   Page(s) 149-150 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.4.2 Page(s) 252     CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 10.2  Page(s) 138-9   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.1   Page(s) 27      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 9.3   Page(s) 73-4    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 7.1   Page(s) 100-1   CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 5.4.2 Page(s) 231     CIS Amazon Linux v2.0.0
# Refer to Section(s) 5.4.2 Page(s) 244     CIS Ubuntu 16.04 v2.0.0
#.

audit_system_accounts () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    verbose_message "System Accounts that do not have a shell"
    check_file="/etc/passwd"
    if [ "$audit_mode" != 2 ]; then
      for user_name in $( cat /etc/passwd | awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<500 && $7!="/sbin/nologin" && $7!="/bin/false" ) {print $1}' ); do
        shadow_field=$( grep "$user_name:" /etc/shadow | egrep -v "\*|\!\!|NP|UP|LK" | cut -f1 -d: );
        if [ "$shadow_field" = "$user_name" ]; then
          increment_insecure "System account $user_name has an invalid shell but the account is disabled"
        else
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "System account $user_name has an invalid shell"
            verbose_message "" fix
            if [ "$os_name" = "FreeBSD" ]; then
              verbose_message "pw moduser $user_name -s /sbin/nologin" fix
            else
              verbose_message "usermod -s /sbin/nologin $user_name" fix
            fi
            verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            verbose_message "Setting:   System account $user_name to have shell /sbin/nologin"
            backup_file $check_file
            if [ "$os_name" = "FreeBSD" ]; then
              pw moduser $user_name -s /sbin/nologin
            else
              usermod -s /sbin/nologin $user_name
            fi
          fi
        fi
      done
    else
      restore_file $check_file $restore_dir
    fi
  fi
}
