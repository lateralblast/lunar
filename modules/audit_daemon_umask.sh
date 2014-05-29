# audit_daemon_umask
#
# Solaris:
#
# The umask (1) utility overrides the file mode creation mask as specified by
# the CMASK value in the /etc/default/init file. The most permissive file
# permission is mode 666 ( 777 for executable files). The CMASK value subtracts
# from this value. For example, if CMASK is set to a value of 022, files
# created will have a default permission of 644 (755 for executables).
# See the umask (1) manual page for a more detailed description.
# Note: There are some known bugs in the following daemons that are impacted by
# changing the CMASK parameter from its default setting:
# (Note: Current or future patches may have resolved these issues.
# Consult with your Oracle Support representative)
# 6299083 picld i initialise picld_door file with wrong permissions after JASS
# 4791006 ldap_cachemgr initialise i ldap_cache_door file with wrong permissions
# 6299080 nscd i initialise name_service_door file with wrong permissions after
# JASS
# The ldap_cachemgr issue has been fixed but the others are still unresolved.
# While not directly related to this, there is another issue related to 077
# umask settings:
# 2125481 in.lpd failed to print files when the umask is set 077
# Set the system default file creation mask (umask) to at least 022 to prevent
# daemon processes from creating world-writable files by default. The NSA and
# DISA recommend a more restrictive umask values of 077 (Note: The execute bit
# only applies to executable files). This may cause problems for certain
# applications- consult vendor documentation for further information.
# The default setting for Solaris is 022.
#
# Linux and FreeBSD
#
# Set the default umask for all processes started at boot time.
# The settings in umask selectively turn off default permission when a file is
# created by a daemon process.
# Setting the umask to 027 will make sure that files created by daemons will
# not be readable, writable or executable by any other than the group and
# owner of the daemon process and will not be writable by the group of the
# daemon process. The daemon process can manually override these settings if
# these files need additional permission.
#
# Refer to Section(s) 3.1 Page(s) 58-9 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.2 Page(s) 72 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.1 Page(s) 61-2 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 3.3 Page(s) 9-10 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.1 Page(s) 75-6 CIS Solaris 10 v5.1.0
#.

audit_daemon_umask () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "11" ]; then
        funct_verbose_message "Daemon Umask"
        umask_check=`svcprop -p umask/umask svc:/system/environment:init`
        umask_value="022"
        log_file="umask.log"
        total=`expr $total + 1`
        if [ "$umask_check" != "$umask_value" ]; then
          log_file="$work_dir/$log_file"
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   Default service file creation mask not set to $umask_value [$score]"
            funct_verbose_message "" fix
            funct_verbose_message "svccfg -s svc:/system/environment:init setprop umask/umask = astring:  \"$umask_value\"" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Default service file creation mask to $umask_value"
            if [ ! -f "$log_file" ]; then
              echo "$umask_check" >> $log_file
            fi
            svccfg -s svc:/system/environment:init setprop umask/umask = astring:  "$umask_value"
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    Default service file creation mask set to $umask_value [$score]"
          fi
          if [ "$audit_mode" = 2 ]; then
            restore_file="$restore_dir/$log_file"
            if [ -f "$restore_file" ]; then
              restore_value=`cat $restore_file`
              if [ "$restore_value" != "$umask_check" ]; then
                echo "Restoring:  Default service file creation mask to $restore_vaule"
                svccfg -s svc:/system/environment:init setprop umask/umask = astring:  "$restore_value"
              fi
            fi
          fi
        fi
      else
        if [ "$os_version" = "7" ] || [ "$os_version" = "6" ]; then
          funct_verbose_message "Daemon Umask"
          check_file="/etc/init.d/umask.sh"
          funct_file_value $check_file umask space 022 hash
          if [ "$audit_mode" = "0" ]; then
            if [ -f "$check_file" ]; then
              funct_check_perms $check_file 0744 root sys
              for dir_name in /etc/rc?.d; do
                link_file="$dir_name/S00umask"
                if [ ! -f "$link_file" ]; then
                  ln -s $check_file $link_file
                fi
              done
            fi
          fi
        else
          check_file="/etc/default/init"
          funct_file_value $check_file CMASK eq 022 hash
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/sysconfig/init"
      funct_file_value $check_file umask space 027 hash
      if [ "$audit_mode" = "0" ]; then
        if [ -f "$check_file" ]; then
          funct_check_perms $check_file 0755 root root
        fi
      fi
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      for check_file in `find /etc -type f |xargs grep 'umask' |cut -f1 -d:`; do
        if -f [ "$check_file" ]; then
          funct_file_value $check_file umask space 077 hash
        fi
      done
      for check_file in `find /usr/local/etc -type f |xargs grep 'umask' |cut -f1 -d:`; do
        if -f [ "$check_file" ]; then
          funct_file_value $check_file umask space 077 hash
        fi
      done
    fi
  fi
}
