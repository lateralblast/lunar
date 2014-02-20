# audit_gdm_conf
#
# Gnome Display Manager should not be used on a server, but if it is it
# should be locked down to disable root access.
#.

audit_gdm_conf () {
  if [ "$os_name" = "Linux" ]; then
    check_file="/etc/X11/gdm/gdm.conf"
    if [ -e "$check_file" ]; then
      funct_verbose_message "GDM Configuration"
      funct_file_value $check_file AllowRoot eq false hash
      funct_file_value $check_file AllowRemoteRoot eq false hash
      funct_file_value $check_file Use24Clock eq true hash
      funct_check_perms $check_file 0644 root root
    fi
  fi
}
