# audit_mount_setuid
#
# If the volume manager (vold) is enabled to permit users to mount external
# devices, the administrator can force these file systems to be mounted with
# the nosuid option to prevent users from bringing set-UID programs onto the
# system via CD-ROMs, floppy disks, USB drives or other removable media.
# Removable media is one vector by which malicious software can be introduced
# onto the system. The risk can be mitigated by forcing use of the nosuid
# option. Note that this setting is included in the default rmmount.conf file
# for Solaris 8 and later.
#.

audit_mount_setuid () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      check_file="/etc/rmmount.conf"
      if [ -f "$check_file" ]; then
        funct_verbose_message "# Set-UID on User Monunted Devices"
        nosuid_check=`cat $check_file |grep -v "^#" |grep "\-o nosuid"`
        log_file="$work_dir/$check_file"
        total=`expr $total + 1`
        if [ `expr "$nosuid_check" : "[A-z]"` != 1 ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   Set-UID not restricted on user mounted devices [$score]"
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Set-UID restricted on user mounted devices"
            funct_backup_file $check_file
            funct_append_file $check_file "mount * hsfs udfs ufs -o nosuid" hash
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    Set-UID not restricted on user mounted devices [$score]"
          fi
          if [ "$audit_mode" = 2 ]; then
            funct_restore_file $check_file $restore_dir
          fi
        fi
      fi
    fi
  fi
}
