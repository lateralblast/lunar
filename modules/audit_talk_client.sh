# audit_talk_client
#
# The talk software makes it possible for users to send and receive messages
# across systems through a terminal session.
# The talk client (allows initialization of talk sessions) is installed by
# default.
#
# Refer to Section(s) 2.1.9 Page(s) 53 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.9 Page(s) 61 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.9 Page(s) 55-6 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

audit_talk_client () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      funct_verbose_message "Talk Client"
      funct_linux_package uninstall talk
    fi
  fi
}
