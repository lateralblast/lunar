# audit_system_auth_password_hashing
#
# Audit password hashing
#
# The commands below change password encryption from md5 to sha512
# (a much stronger hashing algorithm).
# All existing accounts will need to perform a password change to
# upgrade the stored hashes to the new algorithm.
#
# The SHA-512 algorithm provides much stronger hashing than MD5,
# thus providing additional protection to the system by increasing
# the level of effort for an attacker to successfully determine passwords.
#
# Note that these change only apply to accounts configured on the local system.
#
# Refer to Section(s) 5.3.4 Page(s) 243   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.3.4 Page(s) 224   CIS Amazon Linux Benchmark v2.0.0
#.

audit_system_auth_password_hashing () {
  auth_string=$1
  search_string=$2
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
        if [ -f "$check_file" ]; then
          echo "Checking:  Password minimum strength enabled in $check_file"
          total=`expr $total + 1`
          check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk '{print $8}'`
          if [ "$check_value" != "$search_string" ]; then
            if [ "$audit_mode" = "1" ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Password strength settings not enabled in $check_file [$insecure Warnings]"
              funct_verbose_message "cp $check_file $temp_file" fix
              funct_verbose_message "cat $temp_file |sed 's/^password\ssufficient\spam_unix.so/password sufficient pam_unix.so sha512/g' > $check_file" fix
              funct_verbose_message "rm $temp_file"
            fi
            if [ "$audit_mode" = 0 ]; then
              funct_backup_file $check_file
              echo "Setting:   Password minimum length in $check_file"
              cp $check_file $temp_file
              cat $temp_file |sed 's/^password\ssufficient\spam_unix.so/password sufficient pam_unix.so sha512/g' > $check_file
              rm $temp_file
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              secure=`expr $secure + 1`
              echo "Secure:    Password strength settings enabled in $check_file [$secure Passes]"
            fi
          fi
        done
      fi
    else
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
        funct_restore_file $check_file $restore_dir
      done
    fi
  fi
}
