# audit_login_delay
#
# The SLEEPTIME variable in the /etc/default/login file controls the number of
# seconds to wait before printing the "login incorrect" message when a bad
# password is provided.
# Delaying the "login incorrect" message can help to slow down brute force
# password-cracking attacks.
#.

audit_login_delay () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Delay between Failed Login Attempts"
    check_file="/etc/default/login"
    funct_file_value $check_file SLEEPTIME eq 4 hash
  fi
}
