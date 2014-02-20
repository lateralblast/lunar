# audit_telnet_banner
#
# The BANNER variable in the file /etc/default/telnetd can be used to display
# text before the telnet login prompt. Traditionally, it has been used to
# display the OS level of the target system.
# The warning banner provides information that can be used in reconnaissance
# for an attack. By default, Oracle distributes this file with the BANNER
# variable set to null. It is not necessary to create a separate warning banner
# for telnet if a warning is set in the /etc/issue file.
#.

audit_telnet_banner () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Telnet Banner"
    check_file="/etc/default/telnetd"
    funct_file_value $check_file BANNER eq /etc/issue hash
  fi
}
