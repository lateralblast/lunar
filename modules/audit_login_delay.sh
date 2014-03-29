# audit_login_delay
#
# The SLEEPTIME variable in the /etc/default/login file controls the number of
# seconds to wait before printing the "login incorrect" message when a bad
# password is provided.
# Delaying the "login incorrect" message can help to slow down brute force
# password-cracking attacks.
#
# Refer to Section(s) 6.10 Page(s) 53-4 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 6.6 Page(s) 91 CIS Solaris 10 v5.1.0
#.

audit_login_delay () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Delay between Failed Login Attempts"
    check_file="/etc/default/login"
    funct_file_value $check_file SLEEPTIME eq 4 hash
  fi
}
