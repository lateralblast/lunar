# audit_cron_allow
#
# Refer to Section(s) 6.1.10-1            Page(s) 125-7       CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.1.10-1            Page(s) 128-1verbose_message "     CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.1.10-1            Page(s) 145-7       CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.1.8               Page(s) 120         CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.4                 Page(s) 25          CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.11.8-10,2.12.13-4 Page(s) 196-8,217-8 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 6.13                Page(s) 56-7        CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.9                 Page(s) 93-4        CIS Solaris 10 Benchmark v5.1.0
#.

audit_cron_allow () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "At/Cron Authorized Users"
    if [ "$os_name" = "FreeBSD" ]; then
      cron_base_dir="/var/cron"
      at_base_dir="/var/at"
      cron_group="wheel"
      check_file="/etc/crontab"
      check_file_perms $check_file 0640 root $cron_group
    else
      if [ "$os_name" = "AIX" ]; then
        cron_base_dir="/var/adm/cron"
        at_base_dir="/var/adm/cron"
        cron_group="cron"
      else
        if [ "$os_name" = "SunOS" ] && [ "$os_version" = "11" ] || [ "$os_name" = "Linux" ]; then
          cron_base_dir="/etc/cron.d"
          at_base_base_dir="/etc/cron.d"
          cron_group="root"
        else
          cron_base_dir="/etc"
          at_base_base_dir="/etc"
          cron_group="root"
        fi
      fi
    fi
    check_file="$cron_base_dir/cron.deny"
    check_file_exists $check_file no
    check_file="$at_base_dir/at.deny"
    check_file_exists $check_file no
    cron_file="$cron_base_dir/cron.allow"
    check_file_exists $cron_file yes
    check_file_perms $check_file 0400 root $cron_group
    at_file="$at_base_dir/at.allow"
    check_file_exists $at_file yes
    check_file_perms $check_file 0400 root $cron_group
    if [ "$audit_mode" = 0 ]; then
      if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ]; then
        if [ "$( cat $check_file | wc -l )" = "0" ]; then
          dir_name="/var/spool/cron/crontabs"
          if [ -d "$dir_name" ]; then
            check_file_perms $dir_name 0770 root $cron_group
            for user_name in $( ls $dir_name ); do
              check_id=$( grep '^$user_name' /etc/passwd | cut -f 1 -d: )
              if [ "$check_id" = "$user_name" ]; then
                echo "$user_name" >> $cron_file
                echo "$user_name" >> $at_file
              fi
            done
          fi
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        if [ "$( cat $check_file | wc -l )" = "0" ]; then
          dir_name="/var/spool/cron"
          if [ -d "$dir_name" ]; then
            for user_name in $( ls $dir_name ); do
              check_id=$( grep '^$user_name' /etc/passwd | cut -f 1 -d: )
              if [ "$check_id" = "$user_name" ]; then
                echo "$user_name" >> $cron_file
                echo "$user_name" >> $at_file
              fi
            done
          fi
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        for dir_name in /etc/cron.d /etc/cron.hourly /etc/cron.daily /etc/cron.yearly; do
          if [ -d "$dir_name" ]; then
            for user_name in $( ls -l $dir_name grep '-' | awk '{print $4}' | uniq ); do
              user_check=$( grep ''$user_name'' $check_file )
              if [ "$user_check" != "$user_name" ]; then
                echo "$user_name" >> $cron_file
                echo "$user_name" >> $at_file
              fi
            done
          fi
        done
      fi
    fi
    check_file_perms $check_file 0640 root root
    check_file="/etc/at.allow"
    check_file_exists $check_file yes
    if [ "$audit_mode" = 0 ]; then
      if [ "$os_name" = "SunOS" ]; then
        if [ "$( cat $check_file | wc -l )" = "0" ]; then
          dir_name="/var/spool/cron/atjobs"
          if [ -d "$dir_name" ]; then
            for user_name in $( ls $dir_name ); do
              user_check=$( grep ''$user_name'' $check_file )
              if [ "$user_check" != "$user_name" ]; then
                echo "$user_name" >> $check_file
              fi
            done
          fi
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        if [ "$( cat $check_file | wc -l )" = "0" ]; then
          dir_name="/var/spool/at/spool"
          if [ -d "$dir_name" ]; then
            for user_name in $( ls /var/spool/at/spool ); do
              user_check=$( grep ''$user_name'' $check_file )
              if [ "$user_check" != "$user_name" ]; then
                echo "$user_name" >> $check_file
              fi
            done
          fi
        fi
      fi
    fi
    check_file_perms $check_file 0640 root root
    if [ "$os_name" = "Linux" ]; then
      for dir_name in /etc/cron.d /etc/cron.hourly /etc/cron.daily /etc/cron.yearly; do
        check_file_perms $dir_name 0700 root root
      done
      for file_name in /etc/crontab /etc/anacrontab /etc/cron.allow /etc/at.allow; do
        check_file_perms $check_file 0600 root root
      done
    fi
  fi
}
