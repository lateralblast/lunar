# audit_home_ownership
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
#.

audit_home_ownership () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Ownership of Home Directories"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Ownership of home directories"
    fi
    home_check=0
    total=`expr $total + 1`
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
              score=`expr $score - 1`
              echo "Warning:   User $check_user has no home directory defined [$score]"
            fi
          else
            if [ -d "$home_dir" ]; then
              dir_owner=`ls -ld $home_dir/. | awk '{ print $3 }'`
              if [ "$dir_owner" != "$check_user" ]; then
                if [ "$audit_mode" = 1 ];then
                  score=`expr $score - 1`
                  echo "Warning:   Home Directory for $check_user is owned by $dir_owner [$score]"
                fi
              else
                if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
                  if [ "$audit_mode" = 1 ];then
                    score=`expr $score - 1`
                    echo "Warning:   User $check_user has no home directory [$score]"
                  fi
                fi
              fi
            fi
          fi
        fi
      done
      if [ "$home_check" = 0 ]; then
        if [ "$audit_mode" = 1 ];then
          score=`expr $score + 1`
          echo "Secure:    No ownership issues with home directories [$score]"
        fi
      fi
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Ownership of Home Directories"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Ownership of home directories"
    fi
    home_check=0
    total=`expr $total + 1`
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
              score=`expr $score - 1`
              echo "Warning:   User $check_user has no home directory defined [$score]"
            fi
          else
            if [ -d "$home_dir" ]; then
              dir_owner=`ls -ld $home_dir/. | awk '{ print $3 }'`
              if [ "$dir_owner" != "$check_user" ]; then
                if [ "$audit_mode" = 1 ];then
                  score=`expr $score - 1`
                  echo "Warning:   Home Directory for $check_user is owned by $dir_owner [$score]"
                fi
              else
                if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
                  if [ "$audit_mode" = 1 ];then
                    score=`expr $score - 1`
                    echo "Warning:   User $check_user has no home directory [$score]"
                  fi
                fi
              fi
            fi
          fi
        fi
      done
      if [ "$home_check" = 0 ]; then
        if [ "$audit_mode" = 1 ];then
          score=`expr $score + 1`
          echo "Secure:    No ownership issues with home directories [$score]"
        fi
      fi
    fi
  fi
}
