#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_cron_allow
#
# Check cron allow
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
    verbose_message "At/Cron Authorized Users" "check"
    if [ "$os_name" = "FreeBSD" ]; then
      cron_base_dir="/var/cron"
      at_base_dir="/var/at"
      cron_group="wheel"
      check_file="/etc/crontab"
      check_file_perms "$check_file" "0640" "root" "$cron_group"
    else
      if [ "$os_name" = "AIX" ]; then
        cron_base_dir="/var/adm/cron"
        at_base_dir="/var/adm/cron"
        cron_group="cron"
      else
        if [ "$os_name" = "SunOS" ] && [ "$os_version" = "11" ] || [ "$os_name" = "Linux" ]; then
          cron_base_dir="/etc/cron.d"
          at_base_dir="/etc/cron.d"
          cron_group="root"
        else
          cron_base_dir="/etc"
          at_base_dir="/etc"
          cron_group="root"
        fi
      fi
    fi
    check_file_exists "$cron_base_dir/cron.deny"  "no"
    check_file_exists "$at_base_dir/at.deny"      "no"
    check_file_exists "$cron_base_dir/cron.allow" "yes"
    check_file_perms  "$cron_base_dir/cron.allow" "0400" "root" "$cron_group"
    check_file_exists "$at_base_dir/at.allow"     "yes"
    check_file_perms  "$at_base_dir/at.allow"     "0400" "root" "$cron_group"
    if [ "$audit_mode" = 0 ]; then
      for dir_name in var/spool/cron var/spool/cron/crontabs ; do
        if [ -d "$dir_name" ]; then
          user_list=$( find "$dir_name" -maxdepth 1 -type f -exec basename {} \; )
          for user_name in $user_list; do
            check_id=$( grep '^$user_name' /etc/passwd | cut -f 1 -d: )
            if [ "$check_id" = "$user_name" ]; then
              echo "$user_name" >> "$cron_file"
              echo "$user_name" >> "$at_file"
            fi
          done
        fi
      done
      for dir_name in /etc/cron.d /etc/cron.hourly /etc/cron.daily /etc/cron.yearly; do
        if [ -d "$dir_name" ]; then
          user_list=$( find "$dir_name" -type f -not -user root -printf '%u\n' | sort -u )
          for user_name in $user_list; do
            user_check=$( grep "'$user_name" "$check_file" )
            if [ "$user_check" != "$user_name" ]; then
              echo "$user_name" >> "$at_base_dir/at.allow"
              echo "$user_name" >> "$cron_base_dir/cron.allow"    
            fi
          done
        fi
      done
    fi
    check_file_perms "$check_file" "0640" "root" "root"
    check_file="/etc/at.allow"
    check_file_exists $check_file yes
    if [ "$audit_mode" = 0 ]; then
      if [ "$os_name" = "SunOS" ]; then
        f_check=$( cat "$check_file" | wc -l | sed "s/ //g" )
        if [ "$f_check" = "0" ]; then
          dir_name="/var/spool/cron/atjobs"
          if [ -d "$dir_name" ]; then
            user_list=$( find "$dir_name" -depth  )
            for user_name in $( ls $dir_name ); do
              user_check=$( grep ''$user_name'' $check_file )
              if [ "$user_check" != "$user_name" ]; then
                echo "$user_name" >> "$check_file"
              fi
            done
          fi
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        f_check=$( cat "$check_file" | wc -l | sed "s/ //g" )
        if [ "$f_check" = "0" ]; then
          dir_name="/var/spool/at/spool"
          if [ -d "$dir_name" ]; then
            for user_name in $( ls /var/spool/at/spool ); do
              user_check=$( grep ''$user_name'' $check_file )
              if [ "$user_check" != "$user_name" ]; then
                echo "$user_name" >> "$check_file"
              fi
            done
          fi
        fi
      fi
    fi
    check_file_perms "$check_file" "0640" "root" "root"
    if [ "$os_name" = "Linux" ]; then
      for dir_name in /etc/cron.d /etc/cron.hourly /etc/cron.daily /etc/cron.yearly; do
        check_file_perms "$dir_name" "0700" "root" "root"
      done
      for file_name in /etc/crontab /etc/anacrontab /etc/cron.allow /etc/at.allow; do
        check_file_perms "$check_file" "0600" "root" "root"
      done
    fi
  fi
}
