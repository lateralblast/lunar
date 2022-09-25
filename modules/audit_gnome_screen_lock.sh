# audit_gnome_screen_lock
#
# Refer to Section(s) 6.12  Page(s) 55-56 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.8   Page(s) 92-3  CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 1.8.4 Page(s) 162-3 CIS Ubuntu 22.04 Benchmaek v1.0.0
#.

audit_gnome_screen_lock () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Screen Lock for GNOME Users"
    check_file="/usr/openwin/lib/app-defaults/XScreenSaver"
    check_file_value is $check_file "*timeout:" space "0:10:00" bang
    check_file_value is $check_file "*lockTimeout:" space "0:00:00" bang
  fi
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Screen Lock for GNOME Users"
    check_gsettings_value org.gnome.desktop.session idle-delay "uint32 900"
    check_gsettings_value org.gnome.desktop.screensaver lock-delay "uint32 5" 
  fi
}
