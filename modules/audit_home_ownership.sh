# audit_home_ownership
#
# Refer to Section(s) 9.2.7,12,3 Page(s) 166-7,171-2   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.7,12-4 Page(s) 192-3,197-200 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.7,12-4 Page(s) 170,174-6     CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.7,9    Page(s) 281,3         CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 13.12-3    Page(s) 162-3         CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.11.18-20 Page(s) 202-6         CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.12-4     Page(s) 80-1          CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.12-4     Page(s) 126-8         CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.7,9    Page(s) 259,61        CIS Amazon Linux Benchmark v1.0.0
# Refer to Section(s) 6.2.7,9    Page(s) 273,5         CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_home_ownership() {
  if [ "$os_name" = "SunOS" ] || [  "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Ownership of Home Directories"
    home_check=0
    if [ "$os_name" = "AIX" ]; then
      if [ "$audit_mode" != 2 ]; then
        lsuser -c ALL | grep -v "^#name" | cut -f1 -d: | while read check_user; do
          if [ $( lsuser -f $check_user | grep id | cut -f2 -d= ) -ge 200 ]; then
            found=0
            home_dir=$( lsuser -a home $check_user | cut -f 2 -d = )
          else
            found=1
          fi
          if [ "$found" = 0 ]; then
            home_check=1
            if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
              if [ "$audit_mode" = 1 ];then
                increment_insecure "User $check_user has no home directory defined"
              fi
            else
              if [ -d "$home_dir" ]; then
                dir_owner=$( ls -ld $home_dir/. | awk '{ print $3 }' )
                if [ "$dir_owner" != "$check_user" ]; then
                  if [ "$audit_mode" = 1 ];then
                    increment_insecure "Home Directory for $check_user is owned by $dir_owner"
                  fi
                else
                  if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
                    if [ "$audit_mode" = 1 ];then
                      increment_insecure "User $check_user has no home directory"
                    fi
                  fi
                fi
              fi
            fi
          fi
        done
        if [ "$home_check" = 0 ]; then
          if [ "$audit_mode" = 1 ];then
            increment_secure "No ownership issues with home directories"
          fi
        fi
      fi
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$audit_mode" != 2 ]; then
        getent passwd | awk -F: '{ print $1" "$6 }' | while read check_user home_dir; do
          found=0
          for test_user in root daemon bin sys adm lp uucp nuucp smmsp listen \
            gdm webservd postgres svctag nobody noaccess nobody4 unknown; do
            if [ "$check_user" = "$test_user" ]; then
              found=1
            fi
          done
          if [ "$found" = 0 ]; then
            home_check=1
            if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
              if [ "$audit_mode" = 1 ];then
                increment_insecure "User $check_user has no home directory defined"
              fi
            else
              if [ -d "$home_dir" ]; then
                dir_owner=$( ls -ld $home_dir/. | awk '{ print $3 }' )
                if [ "$dir_owner" != "$check_user" ]; then
                  if [ "$audit_mode" = 1 ];then
                    increment_insecure "Home Directory for $check_user is owned by $dir_owner"
                  fi
                else
                  if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
                    if [ "$audit_mode" = 1 ];then
                      increment_insecure "User $check_user has no home directory"
                    fi
                  fi
                fi
              fi
            fi
          fi
        done
        if [ "$home_check" = 0 ]; then
          if [ "$audit_mode" = 1 ];then
            increment_secure "No ownership issues with home directories"
          fi
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      if [ "$audit_mode" != 2 ]; then
        getent passwd | awk -F: '{ print $1" "$6 }' | while read check_user home_dir; do
          found=0
          for test_user in root bin daemon adm lp sync shutdown halt mail news uucp \
            operator games gopher ftp nobody nscd vcsa rpc mailnull smmsp pcap \
            dbus sshd rpcuser nfsnobody haldaemon distcache apache \
            oprofile webalizer dovecot squid named xfs gdm sabayon; do
            if [ "$check_user" = "$test_user" ]; then
              found=1
            fi
          done
          if [ "$found" = 0 ]; then
            home_check=1
            if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
              if [ "$audit_mode" = 1 ];then
                increment_insecure "User $check_user has no home directory defined"
              fi
            else
              if [ -d "$home_dir" ]; then
                dir_owner=$( ls -ld $home_dir/. | awk '{ print $3 }' )
                if [ "$dir_owner" != "$check_user" ]; then
                  if [ "$audit_mode" = 1 ];then
                    increment_insecure "Home Directory for $check_user is owned by $dir_owner"
                  fi
                else
                  if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
                    if [ "$audit_mode" = 1 ];then
                      increment_insecure "User $check_user has no home directory"
                    fi
                  fi
                fi
              fi
            fi
          fi
        done
        if [ "$home_check" = 0 ]; then
          if [ "$audit_mode" = 1 ];then
            increment_secure "No ownership issues with home directories"
          fi
        fi
      fi
    fi
  fi
}
