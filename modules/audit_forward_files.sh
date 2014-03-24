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
# Refer to Section 9.2.19 Page(s) 176-7 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_forward_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "User Forward Files"
    audit_dot_files .forward
  fi
}
