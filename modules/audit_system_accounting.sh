# audit_system_accounting
#
# Refer to Section(s) 4.2.1.1-18         Page(s) 77-96        CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 5.3.1.1-21         Page(s) 113-136      CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 5.2.1.1-18         Page(s) 86-9,100-120 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 4.1.1.1-3,4.2.1-18 Page(s) 164-191      CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 8.1.1.1-18         Page(s) 86-106       CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.2                Page(s) 18           CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.11.4-5,17        Page(s) 194-5,202    CIS AIX Benchmark v1.1.0
# Refer to Section(s) 4.8                Page(s) 71-2         CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 4.1.1.1-3,4.2.1-18 Page(s) 148-75       CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 4.1.1.1-3,4.1.2-18 Page(s) 159-86       CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_system_accounting () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "SunOS" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "System Accounting"
    if [ "$os_name" = "AIX" ]; then
      check_dir="/var/adm/sa"
      check_file_perms $check_dir 0755 adm adm
      check_dir="/etc/security/audit"
      check_file_perms $check_dir 0750 root audit
      check_dir="/audit"
      check_file_perms $check_dir 0750 root audit
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/var/account/acct"
      check_file_exists $check_file yes
      check_file="/etc/rc.conf"
      check_file_value is $check_file accounting_enable eq YES hash
    fi
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/audit/audit.rules"
      check_append_file $check_file "-w /var/log/sudo.log -p wa -k actions"
      log_file="sysstat.log"
      check_linux_package install sysstat
      if [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
        check_file="/etc/default/sysstat"
        check_file_value is $check_file ENABLED eq true hash
      fi
      if [ "$package_name" != "sysstat" ]; then
        if [ "$audit_mode" = 1 ]; then
          
          increment_insecure "System accounting not enabled"
          verbose_message "" fix
          if [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "CentOS" ]; then
            verbose_message "yum -y install $package_check" fix
          fi
          if [ "$os_vendor" = "SuSE" ]; then
            verbose_message "zypper install $package_check" fix
          fi
          if [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
            verbose_message "apt-get install $package_check" fix
          fi
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          verbose_message "Setting:   System Accounting to enabled"
          log_file="$work_dir/$log_file"
          echo "Installed sysstat" >> $log_file
          check_linux_package install sysstat
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          
          increment_secure "System accounting enabled"
        fi
        if [ "$audit_mode" = 2 ]; then
          restore_file="$restore_dir/$log_file"
          check_linux_package restore sysstat $restore_file
        fi
      fi
      check_file="/etc/audit/audit.rules"
      # Set failure mode to syslog notice
      check_append_file $check_file "-f 1" hash
      # Things that could affect time
      check_append_file $check_file "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" hash
      if [ "$os_platform" = "x86_64" ]; then
        check_append_file $check_file "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change" hash
      fi
      check_append_file $check_file "-a always,exit -F arch=b32 -S clock_settime -k time-change" hash
      if [ "$os_platform" = "x86_64" ]; then
        check_append_file $check_file "-a always,exit -F arch=b64 -S clock_settime -k time-change" hash
      fi
      check_append_file $check_file "-w /etc/localtime -p wa -k time-change" hash
      # Things that affect identity
      check_append_file $check_file "-w /etc/group -p wa -k identity" hash
      check_append_file $check_file "-w /etc/passwd -p wa -k identity" hash
      check_append_file $check_file "-w /etc/gshadow -p wa -k identity" hash
      check_append_file $check_file "-w /etc/shadow -p wa -k identity" hash
      check_append_file $check_file "-w /etc/security/opasswd -p wa -k identity" hash
      # Things that could affect system locale
      check_append_file $check_file "-a exit,always -F arch=b32 -S sethostname -S setdomainname -k system-locale" hash
      if [ "$os_platform" = "x86_64" ]; then
        check_append_file $check_file "-a exit,always -F arch=b64 -S sethostname -S setdomainname -k system-locale" hash
      fi
      check_append_file $check_file "-w /etc/issue -p wa -k system-locale" hash
      check_append_file $check_file "-w /etc/issue.net -p wa -k system-locale" hash
      check_append_file $check_file "-w /etc/hosts -p wa -k system-locale" hash
      check_append_file $check_file "-w /etc/sysconfig/network -p wa -k system-locale" hash
      # Things that could affect MAC policy
      check_append_file $check_file "-w /etc/selinux/ -p wa -k MAC-policy" hash
      # Things that could affect logins
      check_append_file $check_file "-w /var/log/faillog -p wa -k logins" hash
      check_append_file $check_file "-w /var/log/lastlog -p wa -k logins" hash
      #- Process and session initiation (unsuccessful and successful)
      check_append_file $check_file "-w /var/run/utmp -p wa -k session" hash
      check_append_file $check_file "-w /var/log/btmp -p wa -k session" hash
      check_append_file $check_file "-w /var/log/wtmp -p wa -k session" hash
      #- Discretionary access control permission modification (unsuccessful and successful use of chown/chmod)
      check_append_file $check_file "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
      if [ "$os_platform" = "x86_64" ]; then
        check_append_file $check_file "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
      fi
      check_append_file $check_file "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod" hash
      if [ "$os_platform" = "x86_64" ]; then
        check_append_file $check_file "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod" hash
      fi
      check_append_file $check_file "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
      if [ "$os_platform" = "x86_64" ]; then
        check_append_file $check_file "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
      fi
      #- Unauthorized access attempts to files (unsuccessful)
      check_append_file $check_file "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" hash
      check_append_file $check_file "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" hash
      if [ "$os_platform" = "x86_64" ]; then
        check_append_file $check_file "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" hash
        check_append_file $check_file "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" hash
      fi
      #- Use of privileged commands (unsuccessful and successful)
      #check_append_file $check_file "-a always,exit -F path=/bin/ping -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged" hash
      check_append_file $check_file "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k export" hash
      if [ "$os_platform" = "x86_64" ]; then
        check_append_file $check_file "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k export" hash
      fi
      #- Files and programs deleted by the user (successful and unsuccessful)
      check_append_file $check_file "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete" hash
      if [ "$os_platform" = "x86_64" ]; then
        check_append_file $check_file "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete" hash
      fi
      #- All system administration actions
      check_append_file $check_file "-w /etc/sudoers -p wa -k scope" hash
      check_append_file $check_file "-w /etc/sudoers -p wa -k actions" hash
      #- Make sue kernel module loading and unloading is recorded
      check_append_file $check_file "-w /sbin/insmod -p x -k modules" hash
      check_append_file $check_file "-w /sbin/rmmod -p x -k modules" hash
      check_append_file $check_file "-w /sbin/modprobe -p x -k modules" hash
      check_append_file $check_file "-a always,exit -S init_module -S delete_module -k modules" hash
      #- Tracks successful and unsuccessful mount commands
      if [ "$os_platform" = "x86_64" ]; then
        check_append_file $check_file "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts" hash
      fi
      check_append_file $check_file "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts" hash
      #check_append_file $check_file "" hash
      #check_append_file $check_file "" hash
      check_append_file $check_file "" hash
      #- Manage and retain logs
      check_append_file $check_file "space_left_action = email" hash
      check_append_file $check_file "action_mail_acct = email" hash
      check_append_file $check_file "admin_space_left_action = email" hash
      #check_append_file $check_file "" hash
      check_append_file $check_file "max_log_file = MB" hash
      check_append_file $check_file "max_log_file_action = keep_logs" hash
      #- Make file immutable - MUST BE LAST!
      check_append_file $check_file "-e 2" hash
      service_name="sysstat"
      check_chkconfig_service $service_name 3 on
      check_chkconfig_service $service_name 5 on
      service_name="auditd"
      check_chkconfig_service $service_name 3 on
      check_chkconfig_service $service_name 5 on
      check_systemctl_service enable sysstat
      check_systemctl_service enable auditd
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        cron_file="/var/spool/cron/crontabs/sys"
        if [ -f "$check_file" ]; then
          sar_check=$( grep -v "^#" $check_file | grep "sa2" )
        fi
        if [ $( expr "$sar_check" : "[A-z]" ) != 1 ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "System Accounting is not enabled"
            verbose_message "" fix
            verbose_message "echo \"0,20,40 * * * * /usr/lib/sa/sa1\" >> $check_file" fix
            verbose_message "echo \"45 23 * * * /usr/lib/sa/sa2 -s 0:00 -e 23:59 -i 1200 -A\" >> $check_file" fix
            verbose_message "chown sys:sys /var/adm/sa/*" fix
            verbose_message "chmod go-wx /var/adm/sa/*" fix
            verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            verbose_message "Setting:   System Accounting to enabled"
            if [ ! -f "$log_file" ]; then
              echo "Saving:    File $check_file to $work_dir$check_file"
              find $check_file | cpio -pdm $work_dir 2> /dev/null
            fi
            echo "0,20,40 * * * * /usr/lib/sa/sa1" >> $check_file
            echo "45 23 * * * /usr/lib/sa/sa2 -s 0:00 -e 23:59 -i 1200 -A" >> $check_file
            chown sys:sys /var/adm/sa/*
            chmod go-wx /var/adm/sa/*
            if [ "$os_version" = "10" ]; then
              pkgchk -f -n -p $check_file 2> /dev/null
            else
              pkg fix $( pkg search $check_file | grep pkg | awk '{print $4}' )
            fi
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "System Accounting is already enabled"
          fi
          if [ "$audit_mode" = 2 ]; then
            restore_file $check_file $restore_dir
          fi
        fi
      fi
    fi
  fi
}
