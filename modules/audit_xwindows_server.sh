# audit_xwindows_server
#
# The X Windows system provides a Graphical User Interface (GUI) where users
# can have multiple windows in which to run programs and various add on.
# The X Windows system is typically used on desktops where users login,
# but not on servers where users typically do not login.
#
# Refer to Section(s) 3.2 Page(s) 59-60 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.3 Page(s) 72-3  CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.2 Page(s) 62-3  CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.1 Page(s) 52    CIS SLES 11 Benchmark v1.0.0
#.

audit_xwindows_server () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      funct_verbose_message "X Windows Server"
      yum groupremove "X Window System"
    fi
  fi
}
