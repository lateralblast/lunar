# audit_xwindows_server
#
# The X Windows system provides a Graphical User Interface (GUI) where users
# can have multiple windows in which to run programs and various add on.
# The X Windows system is typically used on desktops where users login,
# but not on servers where users typically do not login.
#
# Refer to Section 3.2 Page(s) 59-60 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_xwindows_server () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ]; then
      funct_verbose_message "X Windows Server"
      yum groupremove "X Window System"
    fi
  fi
}
