# audit_security_banner
#
# Presenting a warning message prior to the normal user login may assist the
# prosecution of trespassers on the computer system. Changing some of these
# login banners also has the side effect of hiding OS version information and
# other detailed system information from attackers attempting to target
# specific exploits at a system.
# Guidelines published by the US Department of Defense require that warning
# messages include at least the name of the organization that owns the system,
# the fact that the system is subject to monitoring and that such monitoring
# is in compliance with local statutes, and that use of the system implies
# consent to such monitoring. It is important that the organization's legal
# counsel review the content of all messages before any system modifications
# are made, as these warning messages are inherently site-specific.
# More information (including citations of relevant case law) can be found at
# http://www.justice.gov/criminal/cybercrime/
#
# Refer to Section(s) 7.4 Page(s) 25 CIS FreeBSD Benchmark v1.0.5
#.

audit_security_banner () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "Warnings for Standard Login Services"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Security banners"
    fi
    check_file="/etc/motd"
    funct_file_exists $check_file yes
    if [ -f "$check_file" ]; then
      funct_check_perms $check_file 0644 root root
    fi
    check_file="/etc/issue"
    funct_file_exists $check_file yes
    if [ -f "$check_file" ]; then
      funct_check_perms $check_file 0644 root root
    fi
  fi
}
