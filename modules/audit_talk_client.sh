# audit_talk_client
#
# The talk software makes it possible for users to send and receive messages
# across systems through a terminal session.
# The talk client (allows initialization of talk sessions) is installed by
# default.
#
# Refer to Section 2.1.10 Page(s) 53-54 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_talk_client () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      funct_verbose_message "Talk Client"
      funct_linux_package uninstall talk
    fi
  fi
}
