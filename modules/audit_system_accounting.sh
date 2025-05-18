#!/bin/sh

# -> Needs fixing

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2046
# shellcheck disable=SC2154

# audit_system_accounting
#
# Check system accounting
#
# Refer to Section(s) 4.2.1.1-18            Page(s) 77-96         CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 5.3.1.1-21            Page(s) 113-136       CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 5.2.1.1-18            Page(s) 86-9,100-120  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 4.1.1.1-3,4.2.1-18    Page(s) 164-191       CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 8.1.1.1-18            Page(s) 86-106        CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.2                   Page(s) 18            CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.11.4-5,17           Page(s) 194-5,202     CIS AIX Benchmark v1.1.0
# Refer to Section(s) 4.8                   Page(s) 71-2          CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 4.1.1.1-3,4.2.1-18    Page(s) 148-75        CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 4.1.1.1-3,4.1.2-18    Page(s) 159-86        CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 4.1.2.1-3-4.1.3.29    Page(s) 440-527       CIS Ubuntu 22.04 Benchmark v1.0.0
# Refer to Section(s) 4.1.2.1-3-4.1.3.29    Page(s) 440-527       CIS Ubuntu 22.04 Benchmark v1.0.0
# Refer to Section(s) 6.2.2.1-4,6.2.3.1-21  Page(s) 807-97        CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_system_accounting () {
  print_module "audit_system_accounting"
  max_log_file="8"
  max_log_file_action="keep_logs"
  disk_full_action="single"
  disk_error_action="single"
  space_left_action="single"
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message "System Accounting" "check"
    if [ "${os_name}" = "AIX" ]; then
      check_file_perms "/var/adm/sa"         "0755" "adm"  "adm"
      check_file_perms "/etc/security/audit" "0750" "root" "audit"
      check_file_perms "/audit"              "0750" "root" "audit"
    fi
    if [ "${os_name}" = "FreeBSD" ]; then
      check_file_exists "/var/account/acct" "yes"
      check_file_value  "is" "/etc/rc.conf" "accounting_enable" "eq" "YES" "hash"
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_append_file   "/etc/audit/audit.rules" "-w /var/log/sudo.log -p wa -k actions" "hash"
      check_linux_package "install" "sysstat"
      log_file="sysstat.log"
      if [ "${os_vendor}" = "Debian" ] || [ "${os_vendor}" = "Ubuntu" ]; then
        check_file_value "is" "/etc/default/sysstat" "ENABLED" "eq" "true" "hash"
      fi
      if [ "${package_name}" != "sysstat" ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "System accounting not enabled"
          if [ "${os_vendor}" = "Red" ] || [ "${os_vendor}" = "CentOS" ]; then
            verbose_message "yum -y install ${package_check}" "fix"
          fi
          if [ "${os_vendor}" = "SuSE" ]; then
            verbose_message "zypper install ${package_check}" "fix"
          fi
          if [ "${os_vendor}" = "Debian" ] || [ "${os_vendor}" = "Ubuntu" ]; then
            verbose_message "apt-get install ${package_check}" "fix"
          fi
        fi
        if [ "${audit_mode}" = 0 ]; then
          verbose_message "System Accounting to enabled" "set"
          log_file="${work_dir}/${log_file}"
          echo "Installed sysstat" >> "${log_file}"
          check_linux_package "install" "sysstat"
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          
          increment_secure "System accounting enabled"
        fi
        if [ "${audit_mode}" = 2 ]; then
          restore_file="${restore_dir}/${log_file}"
          check_linux_package "restore" "sysstat" "${restore_file}"
        fi
      fi
      check_file="/etc/audit/rules.d/audit.rules"
      # Set failure mode to syslog notice
      check_append_file "${check_file}" "-f 1" "hash"
      # Things that could affect time
      check_append_file "${check_file}" "" "hash"
      # Things that modify time
      check_append_file "${check_file}" "-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime,stime -k time-change" "hash"
      if [ "${os_platform}" = "x86_64" ]; then
        check_append_file "${check_file}" "-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k time-change"     "hash"
      fi
      check_append_file "${check_file}" "-w /etc/localtime -p wa -k time-change" "hash"
      # Things that affect identity
      check_append_file "${check_file}" "-w /etc/group -p wa -k identity"   "hash"
      check_append_file "${check_file}" "-w /etc/passwd -p wa -k identity"  "hash"
      check_append_file "${check_file}" "-w /etc/gshadow -p wa -k identity" "hash"
      check_append_file "${check_file}" "-w /etc/shadow -p wa -k identity"  "hash"
      check_append_file "${check_file}" "-w /etc/security/opasswd -p wa -k identity" "hash"
      # Things that could affect system locale
      check_append_file "${check_file}" "-a exit,always -F arch=b32 -S sethostname,setdomainname -k system-locale"   "hash"
      if [ "${os_platform}" = "x86_64" ]; then
        check_append_file "${check_file}" "-a exit,always -F arch=b64 -S sethostname,setdomainname -k system-locale" "hash"
      fi
      check_append_file "${check_file}" "-w /etc/issue -p wa -k system-locale"     "hash"
      check_append_file "${check_file}" "-w /etc/issue.net -p wa -k system-locale" "hash"
      check_append_file "${check_file}" "-w /etc/hosts -p wa -k system-locale"     "hash"
      check_append_file "${check_file}" "-w /etc/sysconfig/network -p wa -k system-locale" "hash"
      # Things that could affect MAC policy
      check_append_file "${check_file}" "-w /etc/selinux/ -p wa -k MAC-policy"    "hash"
      # Things that could affect apparmor
      check_append_file "${check_file}" "-w /etc/apparmor/ -p wa -k MAC-policy"   "hash"
      check_append_file "${check_file}" "-w /etc/apparmor.d/ -p wa -k MAC-policy" "hash"
      # Things that could affect logins
      check_append_file "${check_file}" "-w /var/log/faillog -p wa -k logins"     "hash"
      check_append_file "${check_file}" "-w /var/log/lastlog -p wa -k logins"     "hash"
      if [ "${os_vendor}" = "Ubuntu" ] && [ "${os_version}" -ge 16 ]; then
        check_append_file "${check_file}" "-w /var/run/faillock -p wa -k logins"  "hash"
      fi
      # Process and session initiation (unsuccessful and successful)
      check_append_file "${check_file}" "-w /var/run/utmp -p wa -k session" "hash"
      check_append_file "${check_file}" "-w /var/log/btmp -p wa -k session" "hash"
      check_append_file "${check_file}" "-w /var/log/wtmp -p wa -k session" "hash"
      # Record chchon command usage
      check_append_file "${check_file}" "-a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=1000 -F auid!=unset -k perm_chng" "hash"
      # Discretionary access control permission modification (unsuccessful and successful use of chown/chmod)
      check_append_file "${check_file}" "-a always,exit -S all -F path=/usr/bin/chcon -F perm=x -F auid>=1000 -F auid!=-1 -F key=perm_chng" "hash"
      check_append_file "${check_file}" "-a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid>=1000 -F auid!=unset -k perm_chng"       "hash"
      check_append_file "${check_file}" "-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k user_emulation"                "hash"
      if [ "${os_platform}" = "x86_64" ]; then
        check_append_file "${check_file}" "-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k user_emulation" "hash"
      fi
      check_append_file "${check_file}" "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod"   "hash"
      if [ "${os_platform}" = "x86_64" ]; then
        check_append_file "${check_file}" "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod" "hash"
      fi
      check_append_file "${check_file}" "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod"   "hash"
      if [ "${os_platform}" = "x86_64" ]; then
        check_append_file "${check_file}" "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod" "hash"
      fi
      check_append_file "${check_file}" "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod"   "hash"
      if [ "${os_platform}" = "x86_64" ]; then
        check_append_file "${check_file}" "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" "hash"
      fi
      #- Unauthorized access attempts to files (unsuccessful)
      check_append_file "${check_file}" "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access"   "hash"
      check_append_file "${check_file}" "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access"    "hash"
      if [ "${os_platform}" = "x86_64" ]; then
        check_append_file "${check_file}" "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" "hash"
        check_append_file "${check_file}" "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access"  "hash"
      fi
      #- Use of privileged commands (unsuccessful and successful)
      #check_append_file "${check_file}" "-a always,exit -F path=/bin/ping -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged" "hash"
      check_append_file "${check_file}" "-a always,exit -F path=/usr/bin/chacl -F perm=x -F auid>=1000 -F auid!=unset -k priv_cmd" "hash"
      check_append_file "${check_file}" "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k export"   "hash"
      if [ "${os_platform}" = "x86_64" ]; then
        check_append_file "${check_file}" "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k export" "hash"
      fi
      #- Files and programs deleted by the user (successful and unsuccessful)
      check_append_file "${check_file}" "-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=1000 -F auid!=unset -k usermod" "hash"
      check_append_file "${check_file}" "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete"   "hash"
      if [ "${os_platform}" = "x86_64" ]; then
        check_append_file "${check_file}" "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete" "hash"
      fi
      #- All system administration actions
      check_append_file "${check_file}" "-w /etc/sudoers -p wa -k scope"   "hash"
      check_append_file "${check_file}" "-w /etc/sudoers.d -p wa -k scope" "hash"
      check_append_file "${check_file}" "-w /etc/sudoers -p wa -k actions" "hash"
      check_append_file "${check_file}" "-w /var/log/sudo.log -p wa -k sudo_log_file" "hash"
      #- Make sue kernel module loading and unloading is recorded
      check_append_file "${check_file}" "-w /sbin/insmod -p x -k modules"   "hash"
      check_append_file "${check_file}" "-w /sbin/rmmod -p x -k modules"    "hash"
      check_append_file "${check_file}" "-w /sbin/modprobe -p x -k modules" "hash"
      if [ "${os_platform}" = "x86_64" ]; then
        check_append_file "${check_file}" "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module,create_module,query_module -F auid>=1000 -F auid!=unset -k kernel_modules" "hash"
      fi
      check_append_file "${check_file}" "-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=1000 -F auid!=unset - k kernel_modules" "hash"
      check_append_file "${check_file}" "-a always,exit -S init_module -S delete_module -k modules" "hash"
      #- Tracks successful and unsuccessful mount commands
      if [ "${os_platform}" = "x86_64" ]; then
        check_append_file "${check_file}" "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts" "hash"
      fi
      check_append_file "${check_file}" "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts"   "hash"
      #check_append_file "${check_file}" "" "hash"
      #- Manage and retain logs
      check_append_file "${check_file}" "space_left_action = ${space_left_action}"       "hash"
      check_append_file "${check_file}" "action_mail_acct = email"        "hash"
      check_append_file "${check_file}" "admin_space_left_action = ${admin_space_left_action}" "hash"
      check_append_file "${check_file}" "disk_full_action = ${disk_full_action}" hash
      check_append_file "${check_file}" "disk_error_action= ${disk_error_action}" hash
      check_append_file "${check_file}" "max_log_file = ${max_log_file}" "hash"
      check_append_file "${check_file}" "max_log_file_action = ${max_log_file_action}" "hash"
      #- Make file immutable - MUST BE LAST!
      check_append_file "${check_file}" "-e 2" "hash"
      for service_name in sysstat auditd; do
        check_linux_service "${service_name}" "on"
      done
    fi
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ]; then
        check_file="/var/spool/cron/crontabs/sys"
        check_append_file "${check_file}" "" ""
        if [ -f "${check_file}" ]; then
          sar_check=$( grep -v "^#" "${check_file}" | grep "sa2" )
        fi
        if [ $( expr "${sar_check}" : "[A-z]" ) != 1 ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "System Accounting is not enabled"
            verbose_message    "echo \"0,20,40 * * * * /usr/lib/sa/sa1\" >> ${check_file}" "fix"
            verbose_message    "echo \"45 23 * * * /usr/lib/sa/sa2 -s 0:00 -e 23:59 -i 1200 -A\" >> ${check_file}" "fix"
            verbose_message    "chown sys:sys /var/adm/sa/*" "fix"
            verbose_message    "chmod go-wx /var/adm/sa/*" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            verbose_message "Setting:   System Accounting to enabled"
            if [ ! -f "${log_file}" ]; then
              echo "Saving:    File ${check_file} to ${work_dir}${check_file}"
              find "${check_file}" | cpio -pdm "${work_dir}" 2> /dev/null
            fi
            echo "0,20,40 * * * * /usr/lib/sa/sa1" >> "${check_file}"
            echo "45 23 * * * /usr/lib/sa/sa2 -s 0:00 -e 23:59 -i 1200 -A" >> "${check_file}"
            chown sys:sys /var/adm/sa/*
            chmod go-wx /var/adm/sa/*
            if [ "${os_version}" = "10" ]; then
              pkgchk -f -n -p "${check_file}" 2> /dev/null
            else
              pkg fix $( pkg search "${check_file}" | grep pkg | awk '{print $4}' )
            fi
          fi
        else
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "System Accounting is already enabled"
          fi
          if [ "${audit_mode}" = 2 ]; then
            restore_file "${check_file}" "${restore_dir}"
          fi
        fi
      fi
    fi
  fi
}
