# audit_home_ownership
#
# *** This code needs a clean up ***
#
# Check That Users Are Assigned Home Directories
# Check That Defined Home Directories Exist
# Check User Home Directory Ownership
#
# The /etc/passwd file defines a home directory that the user is placed in upon
# login. If there is no defined home directory, the user will be placed in "/"
# and will not be able to write any files or have local environment variables set.
# All users must be assigned a home directory in the /etc/passwd file.
#
# Users can be defined to have a home directory in /etc/passwd, even if the
# directory does not actually exist.
# If the user's home directory does not exist, the user will be placed in "/"
# and will not be able to write any files or have local environment variables set.
#
# The user home directory is space defined for the particular user to set local
# environment variables and to store personal files.
# Since the user is accountable for files stored in the user home directory,
# the user must be the owner of the directory.
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
#.

audit_home_ownership() {
  if [ "$os_name" = "SunOS" ] || [  "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Ownership of Home Directories"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Ownership of home directories"
    fi
    home_check=0
    total=`expr $total + 1`
    if [ "$os_name" = "AIX" ]; then
      if [ "$audit_mode" != 2 ]; then
        lsuser -c ALL | grep -v "^#name" | cut -f1 -d: | while read check_user; do
          if [ `lsuser -f $check_user | grep id | cut -f2 -d=` -ge 200 ]; then
            found=0
            home_dir=`lsuser -a home $check_user | cut -f 2 -d =`
          else
            found=1
          fi
          if [ "$found" = 0 ]; then
            home_check=1
            if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
              if [ "$audit_mode" = 1 ];then
                insecure=`expr $insecure + 1`
                echo "Warning:   User $check_user has no home directory defined [$insecure Warnings]"
              fi
            else
              if [ -d "$home_dir" ]; then
                dir_owner=`ls -ld $home_dir/. | awk '{ print $3 }'`
                if [ "$dir_owner" != "$check_user" ]; then
                  if [ "$audit_mode" = 1 ];then
                    insecure=`expr $insecure + 1`
                    echo "Warning:   Home Directory for $check_user is owned by $dir_owner [$insecure Warnings]"
                  fi
                else
                  if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
                    if [ "$audit_mode" = 1 ];then
                      insecure=`expr $insecure + 1`
                      echo "Warning:   User $check_user has no home directory [$insecure Warnings]"
                    fi
                  fi
                fi
              fi
            fi
          fi
        done
        if [ "$home_check" = 0 ]; then
          if [ "$audit_mode" = 1 ];then
            secure=`expr $secure + 1`
            echo "Secure:    No ownership issues with home directories [$secure Passes]"
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
                insecure=`expr $insecure + 1`
                echo "Warning:   User $check_user has no home directory defined [$insecure Warnings]"
              fi
            else
              if [ -d "$home_dir" ]; then
                dir_owner=`ls -ld $home_dir/. | awk '{ print $3 }'`
                if [ "$dir_owner" != "$check_user" ]; then
                  if [ "$audit_mode" = 1 ];then
                    insecure=`expr $insecure + 1`
                    echo "Warning:   Home Directory for $check_user is owned by $dir_owner [$insecure Warnings]"
                  fi
                else
                  if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
                    if [ "$audit_mode" = 1 ];then
                      insecure=`expr $insecure + 1`
                      echo "Warning:   User $check_user has no home directory [$insecure Warnings]"
                    fi
                  fi
                fi
              fi
            fi
          fi
        done
        if [ "$home_check" = 0 ]; then
          if [ "$audit_mode" = 1 ];then
            secure=`expr $secure + 1`
            echo "Secure:    No ownership issues with home directories [$secure Passes]"
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
                insecure=`expr $insecure + 1`
                echo "Warning:   User $check_user has no home directory defined [$insecure Warnings]"
              fi
            else
              if [ -d "$home_dir" ]; then
                dir_owner=`ls -ld $home_dir/. | awk '{ print $3 }'`
                if [ "$dir_owner" != "$check_user" ]; then
                  if [ "$audit_mode" = 1 ];then
                    insecure=`expr $insecure + 1`
                    echo "Warning:   Home Directory for $check_user is owned by $dir_owner [$insecure Warnings]"
                  fi
                else
                  if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
                    if [ "$audit_mode" = 1 ];then
                      insecure=`expr $insecure + 1`
                      echo "Warning:   User $check_user has no home directory [$insecure Warnings]"
                    fi
                  fi
                fi
              fi
            fi
          fi
        done
        if [ "$home_check" = 0 ]; then
          if [ "$audit_mode" = 1 ];then
            secure=`expr $secure + 1`
            echo "Secure:    No ownership issues with home directories [$secure Passes]"
          fi
        fi
      fi
    fi
  fi
}
