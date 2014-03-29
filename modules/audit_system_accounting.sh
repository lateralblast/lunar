# audit_system_accounting
#
# System accounting gathers baseline system data (CPU utilization, disk I/O,
# etc.) every 20 minutes. The data may be accessed with the sar command, or by
# reviewing the nightly report files named /var/adm/sa/sar*.
# Note: The sys id must be added to /etc/cron.allow to run the system
# accounting commands..
# Once a normal baseline for the system has been established, abnormalities
# can be investigated to detect unauthorized activity such as CPU-intensive
# jobs and activity outside of normal usage hours.
#
# Configure System Accounting (auditd):
#
# System auditing, through auditd, allows system administrators to monitor
# their systems such that they can detect unauthorized access or modification
# of data. By default, auditd will audit SELinux AVC denials, system logins,
# account modifications, and authentication events. Events will be logged to
# /var/log/audit/audit.log. The recording of these events will use a modest
# amount of disk space on a system. If significantly more events are captured,
# additional on system or off system storage may need to be allocated.
#
# Note: For 64 bit systems that have arch as a rule parameter, you will need
# two rules: one for 64 bit and one for 32 bit systems.
# For 32 bit systems, only one rule is needed.
#
# Configure Data Retention:
#
# When auditing, it is important to carefully configure the storage
# requirements for audit logs.
#
# Configure Audit Log Storage Size
#
# Configure the maximum size of the audit log file. Once the log reaches the
# maximum size, it will be rotated and a new log file will be started.
# It is important that an appropriate size is determined for log files so that
# they do not impact the system and audit data is not lost.
#
# Disable System on Audit Log Full:
#
# The auditd daemon can be configured to halt the system when the audit logs
# are full.
# In high security contexts, the risk of detecting unauthorized access or
# nonrepudiation exceeds the benefit of the system's availability.
# Normally, auditd will hold 4 logs of maximum log file size before deleting
# older log files.
# In high security contexts, the benefits of maintaining a long audit history
# exceed the cost of storing the audit history.
#
# Keep All Auditing Information:
#
# Normally, auditd will hold 4 logs of maximum log file size before deleting
# older log files.
# In high security contexts, the benefits of maintaining a long audit history
# exceed the cost of storing the audit history.
#
# Enable auditd Service:
#
# Turn on the auditd daemon to record system events.
# The capturing of system events provides system administrators with
# information to allow them to determine if unauthorized access to their
# system is occurring.
#
# Enable Auditing for Processes That Start Prior to auditd:
#
# Configure grub so that processes that are capable of being audited can be
# audited even if they start up prior to auditd startup.
# Audit events need to be captured on processes that start up prior to auditd,
# so that potential malicious activity cannot go undetected.
#
# Record Events That Modify Date and Time Information:
#
# Capture events where the system date and/or time has been modified.
# The parameters in this section are set to determine if the adjtimex
# (tune kernel clock), settimeofday (Set time, using timeval and timezone
# structures) stime (using seconds since 1/1/1970) or clock_settime (allows
# for the setting of several internal clocks and timers) system calls have
# been executed and always write an audit record to the /var/log/audit.log
# file upon exit, tagging the records with the identifier "time-change"
# Unexpected changes in system data and/or time could be a sign of malicious
# activity on the system.
#
# Record Events That Modify User/Group Information:
#
# Record events affecting the group, passwd (user IDs), shadow and gshadow
# (passwords) or /etc/security/opasswd (old passwords, based on remember
# parameter in the PAM configuration) files. The parameters in this section
# will watch the files to see if they have been opened for write or have had
# attribute changes (e.g. permissions) and tag them with the identifier
# "identity" in the audit log file.
# Unexpected changes to these files could be an indication that the system has
# been compromised and that an unauthorized user is attempting to hide their
# activities or compromise additional accounts.
#
# Record Events That Modify the System's Network Environment:
#
# Record changes to network environment files or system calls.
# The below parameters monitor the sethostname (set the systems host name) or
# setdomainname (set the systems domainname) system calls, and write an audit
# event on system call exit. The other parameters monitor the /etc/issue and
# /etc/issue.net files (messages displayed pre- login), /etc/hosts (file
# containing host names and associated IP addresses) and /etc/sysconfig/network
# (directory containing network interface scripts and configurations) files.
# Monitoring sethostname and setdomainname will identify potential unauthorized
# changes to host and domainname of a system. The changing of these names could
# potentially break security parameters that are set based on those names.
# The /etc/hosts file is monitored for changes in the file that can indicate
# an unauthorized intruder is trying to change machine associations with IP
# addresses and trick users and processes into connecting to unintended
# machines. Monitoring /etc/issue and /etc/issue.net is important, as intruders
# could put disinformation into those files and trick users into providing
# information to the intruder. Monitoring /etc/sysconfig/network is important
# as it can show if network interfaces or scripts are being modified in a way
# that can lead to the machine becoming unavailable or compromised.
# All audit records will be tagged with the identifier "system-locale."
#
# Record Events That Modify the System's Mandatory Access Controls:
#
# Monitor SELinux mandatory access controls. The parameters below monitor any
# write access (potential additional, deletion or modification of files in the
# directory) or attribute changes to the /etc/selinux directory.
# Changes to files in this directory could indicate that an unauthorized user
# is attempting to modify access controls and change security contexts, leading
# to a compromise of the system.
#
# Collect Login and Logout Events:
#
# Monitor login and logout events. The parameters below track changes to files
# associated with login/logout events. The file /var/log/faillog tracks failed
# events from login. The file /var/log/lastlog maintain records of the last
# time a user successfully logged in. The file /var/log/btmp keeps track of
# failed login attempts and can be read by entering the command:
# /usr/bin/last -f /var/log/btmp.
# All audit records will be tagged with the identifier "logins."
#
# Collect Session Initiation Information:
#
# Monitor session initiation events. The parameters in this section track
# changes to the files associated with session events. The file /var/run/utmp
# file tracks all currently logged in users. The /var/log/wtmp file tracks
# logins, logouts, shutdown and reboot events. All audit records will be tagged
# with the identifier "session."
# Monitoring these files for changes could alert a system administrator to
# logins occurring at unusual hours, which could indicate intruder activity
# (i.e. a user logging in at a time when they do not normally log in).
#
# Collect Discretionary Access Control Permission Modification Events:
#
# Monitor changes to file permissions, attributes, ownership and group.
# The parameters in this section track changes for system calls that affect
# file permissions and attributes. The chmod, fchmod and fchmodat system calls
# affect the permissions associated with a file. The chown, fchown, fchownat
# and lchown system calls affect owner and group attributes on a file.
# The setxattr, lsetxattr, fsetxattr (set extended file attributes) and
# removexattr, lremovexattr, fremovexattr (remove extended file attributes)
# control extended file attributes. In all cases, an audit record will only be
# written for non-system userids (auid >= 500) and will ignore Daemon events
# (auid = 4294967295). All audit records will be tagged with the identifier
# "perm_mod."
#
# Collect Unsuccessful Unauthorized Access Attempts to Files:
#
# Monitor for unsuccessful attempts to access files. The parameters below are
# associated with system calls that control creation (creat), opening (open,
# openat) and truncation (truncate, ftruncate) of files. An audit log record
# will only be written if the user is a non- privileged user (auid > = 500),
# is not a Daemon event (auid=4294967295) and if the system call returned
# EACCES (permission denied to the file) or EPERM (some other permanent error
# associated with the specific system call). All audit records will be tagged
# with the identifier "access."
# Failed attempts to open, create or truncate files could be an indication
# that an individual or process is trying to gain unauthorized access to the
# system.
#
# Collect Use of Privileged Commands:
#
# Monitor privileged programs (thos that have the setuid and/or setgid bit set
# on execution) to determine if unprivileged users are running these commands.
# Execution of privileged commands by non-privileged users could be an
# indication of someone trying to gain unauthorized access to the system.
#
# Collect Successful File System Mounts:
#
# Monitor the use of the mount system call. The mount (and umount) system call
# controls the mounting and unmounting of file systems. The parameters below
# configure the system to create an audit record when the mount system call is
# used by a non-privileged user
# It is highly unusual for a non privileged user to mount file systems to the
# system. While tracking mount commands gives the system administrator evidence
# that external media may have been mounted (based on a review of the source of
# the mount and confirming it's an external media type), it does not
# conclusively indicate that data was exported to the media. System
# administrators who wish to determine if data were exported, would also have
# to track successful open, creat and truncate system calls requiring write
# access to a file under the mount point of the external media file system.
# This could give a fair indication that a write occurred. The only way to
# truly prove it, would be to track successful writes to the external media.
# Tracking write system calls could quickly fill up the audit log and is not
# recommended. Recommendations on configuration options to track data export
# to media is beyond the scope of this document.
#
# Collect File Deletion Events by User:
#
# Monitor the use of system calls associated with the deletion or renaming of
# files and file attributes. This configuration statement sets up monitoring
# for the unlink (remove a file), unlinkat (remove a file attribute), rename
# (rename a file) and renameat (rename a file attribute) system calls and tags
# them with the identifier "delete".
# Monitoring these calls from non-privileged users could provide a system
# administrator with evidence that inappropriate removal of files and file
# attributes associated with protected files is occurring. While this audit
# option will look at all events, system administrators will want to look for
# specific privileged files that are being deleted or altered.
#
# Collect Changes to System Administration Scope (sudoers):
#
# Monitor scope changes for system administrations. If the system has been
# properly configured to force system administrators to log in as themselves
# first and then use the sudo command to execute privileged commands, it is
# possible to monitor changes in scope. The file /etc/sudoers will be written
# to when the file or its attributes have changed. The audit records will be
# tagged with the identifier "scope."
# Changes in the /etc/sudoers file can indicate that an unauthorized change
# has been made to scope of system administrator activity.
#
# Collect Changes to System Administration Scope (sudolog):
#
# Monitor the sudo log file. If the system has been properly configured to
# disable the use of the su command and force all administrators to have to
# log in first and then use sudo to execute privileged commands, then all
# administrator commands will be logged to /var/log/sudo.log.
# Any time a command is executed, an audit event will be triggered as the
# /var/log/sudo.log file will be opened for write and the executed
# administration command will be written to the log.
# Changes in /var/log/sudo.log indicate that an administrator has executed a
# command or the log file itself has been tampered with. Administrators will
# want to correlate the events written to the audit trail with the records
# written to /var/log/sudo.log unauthorized commands have been executed.
#
# Collect Kernel Module Loading and Unloading:
#
# Monitor the loading and unloading of kernel modules. The programs insmod
# (install a kernel module), rmmod (remove a kernel module), and modprobe
# (a more sophisticated program to load and unload modules, as well as some
# other features) control loading and unloading of modules. The init_module
# (load a module) and delete_module (delete a module) system calls control
# loading and unloading of modules. Any execution of the loading and unloading
# module programs and system calls will trigger an audit record with an
# identifier of "modules".
# Monitoring the use of insmod, rmmod and modprobe could provide system
# administrators with evidence that an unauthorized user loaded or unloaded a
# kernel module, possibly compromising the security of the system.
# Monitoring of the init_module and delete_module system calls would reflect
# an unauthorized user attempting to use a different program to load and
# unload modules.
#
# Make the Audit Configuration Immutable:
#
# Set system audit so that audit rules cannot be modified with auditctl.
# Setting the flag "-e 2" forces audit to be put in immutable mode. Audit
# changes can only be made on system reboot.
# In immutable mode, unauthorized users cannot execute changes to the audit
# system to potential hide malicious activity and then put the audit rules
# back. Users would most likely notice a system reboot and that could alert
# administrators of an attempt to make unauthorized audit changes.
#
# Refer to Section(s) 4.2.1.1-18 Page(s) 77-96 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 5.2 Page(s) 18 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.11.4-5,17 Page(s) 194-5,202 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 4.8 Page(s) 71-2 CIS Solaris 10 v5.1.0
#.

audit_system_accounting () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "SunOS" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "System Accounting"
    if [ "$os_name" = "AIX" ]; then
      check_dir="/var/adm/sa"
      funct_check_perms $check_dir 0755 adm adm
      check_dir="/etc/security/audit"
      funct_check_perms $check_dir 0750 root audit
      check_dir="/audit"
      funct_check_perms $check_dir 0750 root audit
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/var/account/acct"
      funct_file_exists $check_file yes
      check_file="/etc/rc.conf"
      funct_file_value $check_file accounting_enable eq YES hash
    fi
    if [ "$os_name" = "Linux" ]; then
      total=`expr $total + 1`
      log_file="sysstat.log"
      funct_linux_package check sysstat
      if [ "$linux_dist" = "debian" ]; then
        check_file="/etc/default/sysstat"
        funct_file_value $check_file ENABLED eq true hash
      fi
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  System accounting is enabled"
      fi
      if [ "$package_name" != "sysstat" ]; then
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score - 1`
          echo "Warning:   System accounting not enabled [$score]"
          funct_verbose_message "" fix
          if [ "$linux_dist" = "redhat" ]; then
            funct_verbose_message "yum -y install $package_check" fix
          fi
          if [ "$linux_dist" = "redhat" ]; then
            funct_verbose_message "zypper install $package_check" fix
          fi
          if [ "$linux_dist" = "debian" ]; then
            funct_verbose_message "apt-get install $package_check" fix
          fi
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          echo "Setting:   System Accounting to enabled"
          log_file="$work_dir/$log_file"
          echo "Installed sysstat" >> $log_file
          funct_linux_package install sysstat
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score + 1`
          echo "Secure:    System accounting enabled [$score]"
        fi
        if [ "$audit_mode" = 2 ]; then
          restore_file="$restore_dir/$log_file"
          funct_linux_package restore sysstat $restore_file
        fi
      fi
      check_file="/etc/audit/audit.rules"
      # Set failure mode to syslog notice
      funct_append_file $check_file "-f 1" hash
      # Things that could affect time
      funct_append_file $check_file "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" hash
      if [ "$os_platform" = "x86_64" ]; then
        funct_append_file $check_file "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change" hash
      fi
      funct_append_file $check_file "-a always,exit -F arch=b32 -S clock_settime -k time-change" hash
      if [ "$os_platform" = "x86_64" ]; then
        funct_append_file $check_file "-a always,exit -F arch=b64 -S clock_settime -k time-change" hash
      fi
      funct_append_file $check_file "-w /etc/localtime -p wa -k time-change" hash
      # Things that affect identity
      funct_append_file $check_file "-w /etc/group -p wa -k identity" hash
      funct_append_file $check_file "-w /etc/passwd -p wa -k identity" hash
      funct_append_file $check_file "-w /etc/gshadow -p wa -k identity" hash
      funct_append_file $check_file "-w /etc/shadow -p wa -k identity" hash
      funct_append_file $check_file "-w /etc/security/opasswd -p wa -k identity" hash
      # Things that could affect system locale
      funct_append_file $check_file "-a exit,always -F arch=b32 -S sethostname -S setdomainname -k system-locale" hash
      if [ "$os_platform" = "x86_64" ]; then
        funct_append_file $check_file "-a exit,always -F arch=b64 -S sethostname -S setdomainname -k system-locale" hash
      fi
      funct_append_file $check_file "-w /etc/issue -p wa -k system-locale" hash
      funct_append_file $check_file "-w /etc/issue.net -p wa -k system-locale" hash
      funct_append_file $check_file "-w /etc/hosts -p wa -k system-locale" hash
      funct_append_file $check_file "-w /etc/sysconfig/network -p wa -k system-locale" hash
      # Things that could affect MAC policy
      funct_append_file $check_file "-w /etc/selinux/ -p wa -k MAC-policy" hash
      # Things that could affect logins
      funct_append_file $check_file "-w /var/log/faillog -p wa -k logins" hash
      funct_append_file $check_file "-w /var/log/lastlog -p wa -k logins" hash
      #- Process and session initiation (unsuccessful and successful)
      funct_append_file $check_file "-w /var/run/utmp -p wa -k session" hash
      funct_append_file $check_file "-w /var/log/btmp -p wa -k session" hash
      funct_append_file $check_file "-w /var/log/wtmp -p wa -k session" hash
      #- Discretionary access control permission modification (unsuccessful and successful use of chown/chmod)
      funct_append_file $check_file "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
      if [ "$os_platform" = "x86_64" ]; then
        funct_append_file $check_file "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
      fi
      funct_append_file $check_file "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod" hash
      if [ "$os_platform" = "x86_64" ]; then
        funct_append_file $check_file "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod" hash
      fi
      funct_append_file $check_file "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
      if [ "$os_platform" = "x86_64" ]; then
        funct_append_file $check_file "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
      fi
      #- Unauthorized access attempts to files (unsuccessful)
      funct_append_file $check_file "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" hash
      funct_append_file $check_file "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" hash
      if [ "$os_platform" = "x86_64" ]; then
        funct_append_file $check_file "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" hash
        funct_append_file $check_file "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" hash
      fi
      #- Use of privileged commands (unsuccessful and successful)
      #funct_append_file $check_file "-a always,exit -F path=/bin/ping -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged" hash
      funct_append_file $check_file "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k export" hash
      if [ "$os_platform" = "x86_64" ]; then
        funct_append_file $check_file "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k export" hash
      fi
      #- Files and programs deleted by the user (successful and unsuccessful)
      funct_append_file $check_file "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete" hash
      if [ "$os_platform" = "x86_64" ]; then
        funct_append_file $check_file "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete" hash
      fi
      #- All system administration actions
      funct_append_file $check_file "-w /etc/sudoers -p wa -k scope" hash
      funct_append_file $check_file "-w /etc/sudoers -p wa -k actions" hash
      #- Make sue kernel module loading and unloading is recorded
      funct_append_file $check_file "-w /sbin/insmod -p x -k modules" hash
      funct_append_file $check_file "-w /sbin/rmmod -p x -k modules" hash
      funct_append_file $check_file "-w /sbin/modprobe -p x -k modules" hash
      funct_append_file $check_file "-a always,exit -S init_module -S delete_module -k modules" hash
      #- Tracks successful and unsuccessful mount commands
      if [ "$os_platform" = "x86_64" ]; then
        funct_append_file $check_file "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts" hash
      fi
      funct_append_file $check_file "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts" hash
      #funct_append_file $check_file "" hash
      #funct_append_file $check_file "" hash
      funct_append_file $check_file "" hash
      #- Manage and retain logs
      funct_append_file $check_file "space_left_action = email" hash
      funct_append_file $check_file "action_mail_acct = email" hash
      funct_append_file $check_file "admin_space_left_action = email" hash
      #funct_append_file $check_file "" hash
      funct_append_file $check_file "max_log_file = MB" hash
      funct_append_file $check_file "max_log_file_action = keep_logs" hash
      #- Make file immutable - MUST BE LAST!
      funct_append_file $check_file "-e 2" hash
      service_name="sysstat"
      funct_chkconfig_service $service_name 3 on
      funct_chkconfig_service $service_name 5 on
      service_bname="auditd"
      funct_chkconfig_service $service_name 3 on
      funct_chkconfig_service $service_name 5 on
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        cron_file="/var/spool/cron/crontabs/sys"
        funct_verbose_message "System Accounting"
        if [ -f "$check_file" ]; then
          sar_check=`cat $check_file |grep -v "^#" |grep "sa2"`
        fi
        total=`expr $total + 1`
        if [ `expr "$sar_check" : "[A-z]"` != 1 ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   System Accounting is not enabled [$score]"
            funct_verbose_message "" fix
            funct_verbose_message "echo \"0,20,40 * * * * /usr/lib/sa/sa1\" >> $check_file" fix
            funct_verbose_message "echo \"45 23 * * * /usr/lib/sa/sa2 -s 0:00 -e 23:59 -i 1200 -A\" >> $check_file" fix
            funct_verbose_message "chown sys:sys /var/adm/sa/*" fix
            funct_verbose_message "chmod go-wx /var/adm/sa/*" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   System Accounting to enabled"
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
              pkg fix `pkg search $check_file |grep pkg |awk '{print $4}'`
            fi
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    System Accounting is already enabled [$score]"
          fi
          if [ "$audit_mode" = 2 ]; then
            funct_restore_file $check_file $restore_dir
          fi
        fi
      fi
    fi
  fi
}
