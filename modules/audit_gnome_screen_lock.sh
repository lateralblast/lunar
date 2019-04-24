# audit_gnome_screen_lock
#
# Refer to Section(s) 6.12 Page(s) 55-56 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.8  Page(s) 92-3  CIS Solaris 10 Benchmark v5.1.0
#.

audit_gnome_screen_lock () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Screen Lock for GNOME Users"
    check_file="/usr/openwin/lib/app-defaults/XScreenSaver"
    check_file_value is $check_file "*timeout:" space "0:10:00" bang
    check_file_value is $check_file "*lockTimeout:" space "0:00:00" bang
  fi
}
