# audit_dfstab
#
# The commands in the dfstab file are executed via the /usr/sbin/shareall
# script at boot time, as well as by administrators executing the shareall
# command during the uptime of the machine.
# It seems prudent to use the absolute pathname to the share command to
# protect against any exploits stemming from an attack on the administrator's
# PATH environment, etc. However, if an attacker is able to corrupt root's path
# to this extent, other attacks seem more likely and more damaging to the
# integrity of the system
#.

audit_dfstab () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Full Path Names in Exports"
    funct_replace_value /etc/dfs/dfstab share /usr/bin/share start
  fi
}
