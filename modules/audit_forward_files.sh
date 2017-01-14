# audit_forward_files
#
# .forward files should be inspected to make sure information is not leaving
# the organisation
#
# The .forward file specifies an email address to forward the user's mail to.
# Use of the .forward file poses a security risk in that sensitive data may be
# inadvertently transferred outside the organization. The .forward file also
# poses a risk as it can be used to execute commands that may perform unintended
# actions.
#
# Refer to Section(s) 9.2.19 Page(s) 176-7 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.21 Page(s) 206-7 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.20 Page(s) 180-1 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 13.19  Page(s) 167-8 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 9.21   Page(s) 87    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.21   Page(s) 133-4 CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.11 Page(s) 263   CIS Amazon Linux Benchmark v1.0.0
#.

audit_forward_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "User Forward Files"
    audit_dot_files .forward
  fi
}
