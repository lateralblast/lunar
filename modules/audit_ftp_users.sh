# audit_ftp_users
#
# Refer to Section(s) 2.12.9 Page(s) 213-4 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 6.9    Page(s) 52-3  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.5    Page(s) 89-91 CIS Solaris 10 Benchmark v5.1.0
#.

audit_ftp_users () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
    funct_verbost_message "FTP Users"
    if [ "$os_name" = "AIX" ]; then
      check_file=$1
      for user_name in $( lsuser -c ALL | grep -v ^#name | grep -v root | cut -f1 -d: ); do
        if [ $( lsuser -f $user_name | grep id | cut -f2 -d= ) -lt 200 ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "User $user_name not in $check_file"
          fi
          if [ "$audit_mode" = 0 ]; then
            backup_file $check_file
            verbose_message "Setting:   User $user_name to not be allowed ftp access"
            check_append_file $check_file $user_name hash
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "User $user_name in $check_file"
          fi
        fi
      done
      if [ "$audit_mode" = 2 ]; then
        restore_file $check_file $restore_dir
      fi
    fi
    if [ "$os_name" = "SunOS" ]; then
      check_file=$1
      for user_name in adm bin daemon gdm listen lp noaccess \
        nobody nobody4 nuucp postgres root smmsp svctag \
        sys uucp webserverd; do
        user_check=$( cat /etc/passwd | cut -f1 -d":" | grep "^$user_name$" )
        if [ $( expr "$user_check" : "[A-z]" ) = 1 ]; then
          ftpuser_check=$( cat $check_file | grep -v '^#' | grep "^$user_name$" )
          if [ $( expr "$ftpuser_check" : "[A-z]" ) != 1 ]; then
            if [ "$audit_mode" = 1 ]; then
              increment_insecure "User $user_name not in $check_file"
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file $check_file
              verbose_message "Setting:   User $user_name to not be allowed ftp access"
              check_append_file $check_file $user_name hash
            fi
          else
            if [ "$audit_mode" = 1 ]; then
              increment_secure "User $user_name in $check_file"
            fi
          fi
        fi
      done
      if [ "$audit_mode" = 2 ]; then
        restore_file $check_file $restore_dir
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      check_file=$1
      for user_name in root bin daemon adm lp sync shutdown halt mail \
        news uucp operator games nobody; do
        user_check=$( cat /etc/passwd | cut -f1 -d":" | grep "^$user_name$" )
        if [ $( expr "$user_check" : "[A-z]" ) = 1 ]; then
          ftpuser_check=$( cat $check_file | grep -v '^#' | grep "^$user_name$" )
          if [ $( expr "$ftpuser_check" : "[A-z]" ) != 1 ]; then
            if [ "$audit_mode" = 1 ]; then
              increment_insecure "User $user_name not in $check_file"
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file $check_file
              verbose_message "Setting:   User $user_name to not be allowed ftp access"
              check_append_file $check_file $user_name hash
            fi
          else
            if [ "$audit_mode" = 1 ]; then
              increment_secure "User $user_name in $check_file"
            fi
          fi
        fi
      done
      if [ "$audit_mode" = 2 ]; then
        restore_file $check_file $restore_dir
      fi
    fi
  fi
}
