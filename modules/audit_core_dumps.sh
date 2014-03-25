# audit_core_dumps
#
# Solaris:
#
# Restrict Core Dumps to Protected Directory
#
# Although /etc/coreadm.conf isn't strictly needed,
# creating it and importing it makes it easier to
# enable or disable changes
#
# Example /etc/coreadm.conf
#
# COREADM_GLOB_PATTERN=/var/cores/core_%n_%f_%u_%g_%t_%p
# COREADM_INIT_PATTERN=core
# COREADM_GLOB_ENABLED=yes
# COREADM_PROC_ENABLED=no
# COREADM_GLOB_SETID_ENABLED=yes
# COREADM_PROC_SETID_ENABLED=no
# COREADM_GLOB_LOG_ENABLED=yes
#
# The action described in this section creates a protected directory to store
# core dumps and also causes the system to create a log entry whenever a regular
# process dumps core.
# Core dumps, particularly those from set-UID and set-GID processes, may contain
# sensitive data.
#
# Linux:
#
# A core dump is the memory of an executable program. It is generally used to
# determine why a program aborted. It can also be used to glean confidential
# information from a core file. The system provides the ability to set a soft
# limit for core dumps, but this can be overridden by the user.
#
# Setting a hard limit on core dumps prevents users from overriding the soft
# variable. If core dumps are required, consider setting limits for user groups
# (see limits.conf(5)). In addition, setting the fs.suid_dumpable variable to 0
# will prevent setuid programs from dumping core.
#
# Refer to Section 1.6.1 Page(s) 44-45 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section 4.1 Page(s) 16 CIS FreeBSD Benchmark v1.0.5
#.

audit_core_dumps () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "Core Dumps"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" != "6" ]; then
        cores_dir="/var/cores"
        check_file="/etc/coreadm.conf"
        cores_check=`coreadm |head -1 |awk '{print $5}'`
        total=`expr $total + 1`
        if [ `expr "$cores_check" : "/var/cores"` != 10 ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   Cores are not restricted to a private directory [$score]"
          else
            if [ "$audit_mode" = 0 ]; then
              echo "Setting:   Making sure restricted to a private directory"
              if [ -f "$check_file" ]; then
                echo "Saving:    File $check_file to $work_dir$check_file"
                find $check_file | cpio -pdm $work_dir 2> /dev/null
              else
                touch $check_file
                find $check_file | cpio -pdm $work_dir 2> /dev/null
                rm $check_file
                log_file="$work_dir/$check_file"
                coreadm | sed -e 's/^ *//g' |sed 's/ /_/g' |sed 's/:_/:/g' |awk -F: '{ print $1" "$2 }' | while read option value; do
                  if [ "$option" = "global_core_file_pattern" ]; then
                    echo "COREADM_GLOB_PATTERN=$value" > $log_file
                  fi
                  if [ "$option" = "global_core_file_content" ]; then
                    echo "COREADM_GLOB_CONTENT=$value" >> $log_file
                  fi
                  if [ "$option" = "init_core_file_pattern" ]; then
                    echo "COREADM_INIT_PATTERN=$value" >> $log_file
                  fi
                  if [ "$option" = "init_core_file_content" ]; then
                    echo "COREADM_INIT_CONTENT=$value" >> $log_file
                  fi
                  if [ "$option" = "global_core_dumps" ]; then
                    if [ "$value" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_GLOB_ENABLED=$value" >> $log_file
                  fi
                  if [ "$option" = "per-process_core_dumps" ]; then
                    if [ "$value" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_PROC_ENABLED=$value" >> $log_file
                  fi
                  if [ "$option" = "global_setid_core_dumps" ]; then
                    if [ "$value" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_GLOB_SETID_ENABLED=$value" >> $log_file
                  fi
                  if [ "$option" = "per-process_setid_core_dumps" ]; then
                    if [ "$value" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_PROC_SETID_ENABLED=$value" >> $log_file
                  fi
                  if [ "$option" = "global_core_dump_logging" ]; then
                    if [ "$value" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_GLOB_LOG_ENABLED=$value" >> $log_file
                  fi
                done
              fi
              coreadm -g /var/cores/core_%n_%f_%u_%g_%t_%p -e log -e global -e global-setid -d process -d proc-setid
            fi
            if [ ! -d "$cores_dir" ]; then
              mkdir $cores_dir
              chmod 700 $cores_dir
              chown root:root $cores_dir
            fi
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    Cores are restricted to a private directory [$score]"
          fi
        fi
        if [ "$audit_mode" = 2 ]; then
          funct_restore_file $check_file $restore_dir
          restore_file="$restore_dir$check_file"
          if [ -f "$restore_file" ]; then
            coreadm -u
          fi
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      funct_verbose_message "Core Dumps"
      for service_name in kdump; do
        funct_chkconfig_service $service_name 3 off
        funct_chkconfig_service $service_name 5 off
      done
      check_file="/etc/security/limits.conf"
      funct_append_file $check_file "* hard core 0"
      check_file="/etc/sysctl.conf"
      funct_file_value $check_file fs.suid_dumpable eq 0 hash
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/sysctl.conf"
      funct_file_value $check_file kern.coredump eq 0 hash
    fi
  fi
}
