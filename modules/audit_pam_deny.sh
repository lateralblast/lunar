# audit_pam_deny
#
# Add pam.deny to pam config files
#
# Refer to Section(s) 6.7 Page(s) 23 CIS FreeBSD Benchmark v1.0.5
#.

audit_pam_deny () {
  if [ "$os_name" = "FreeBSD" ]; then
    if [ "$os_version" < 5 ]; then
      funct_verbose_message "PAM Weak Authentication Services"
      check_file="/etc/pam.conf"
      funct_append_file $check_file "rexecd\tauth\trequired\tpam_deny.so"
      funct_append_file $check_file "rsh\tauth\trequired\tpam_deny.so"
    else
      # Need to insert code here
      # sed -i .preCIS -e 's/nologin/deny/g' /etc/pam.d/rsh /etc/pam.d/rexecd
    fi
  fi
}
