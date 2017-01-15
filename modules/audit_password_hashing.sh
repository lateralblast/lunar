# audit_password_hashing
#
# Check that password hashing is set to SHA512.
#
# The SHA-512 algorithm provides much stronger hashing than MD5, thus providing
# additional protection to the system by increasing the level of effort for an
# attacker to successfully determine passwords.
#
# Refer to Section(s) 6.3.1 Page(s) 138-9 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.3.4 Page(s) 162-3 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.3.1 Page(s) 141-2 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 5.3.4 Page(s) 234-5 CIS Red Hat Linux 7 Benchmark v1.2.0
# Refer to Section(s) 5.3.4 Page(s) 224-5 CIS Amazon Linux Benchmark v1.2.0
#.

audit_password_hashing () {
  if [ "$os_name" = "Linux" ]; then
    hashing=$1
    if [ "$1" = "" ]; then
      hashing="sha512"
    fi
    if [ "$os_name" = "Linux" ]; then
      if [ -f "/usr/sbin/authconfig" ]; then
        funct_verbose_message "Password Hashing"
        if [ "$audit_mode" != 2 ]; then
          log_file="hashing.log"
          echo "Checking:  Password hashing is set to $hashing"
          total=`expr $total + 1`
          check_value=`authconfig --test |grep hashing |awk '{print $5}'`
          if [ "$check_value" != "$hashing" ]; then
            if [ "$audit_mode" = "1" ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Password hashing not set to $hashing [$insecure Warnings]"
              funct_verbose_message "" fix
              funct_verbose_message "authconfig --passalgo=$hashing" fix
              funct_verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              echo "Setting:   Password hashing to $hashing"
              log_file="$work_dir/$log_file"
              echo "$check_value" > $log_file
              authconfig --passalgo=$hashing
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              secure=`expr $secure + 1`
              echo "Secure:    Password hashing set to $hashing [$secure Passes]"
            fi
          fi
        else
          restore_file="$restore_dir/$log_file"
          if [ -f "$restore_file" ]; then
            check_value=`cat $restore_file`
            echo "Restoring: Password hashing to $check_value"
            authconfig --passalgo=$check_value
          fi
        fi
      fi
    fi
  fi
}
