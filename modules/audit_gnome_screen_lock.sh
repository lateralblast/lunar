# audit_gnome_screen_lock
#
# The default timeout is 30 minutes of keyboard and mouse inactivity before a
# password-protected screen saver is invoked by the Xscreensaver application
# used in the GNOME windowing environment.
# Many organizations prefer to set the default timeout value to 10 minutes,
# though this setting can still be overridden by individual users in their
# own environment.
#.

audit_gnome_screen_lock () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Screen Lock for GNOME Users"
    check_file="/usr/openwin/lib/app-defaults/XScreenSaver"
    funct_file_value $check_file "*timeout:" space "0:10:00" bang
    funct_file_value $check_file "*lockTimeout:" space "0:00:00" bang
  fi
}
