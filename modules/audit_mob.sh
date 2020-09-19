# audit_mob
#
# Refer to http://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.vsphere.security.doc%2FGUID-0EF83EA7-277C-400B-B697-04BDC9173EA3.html
#.

audit_mob () {
  if [ "$os_name" = "VMkernel" ]; then
    verbose_message "Managed Object Browser"
    log_file="mob_status"
    backup_file="$work_dir/$log_file"
    current_value=$( vim-cmd proxysvc/service_list | grep "/mob" | awk '{print $3}' | cut -f1 -d, | sed 's/"//g' )
    if [ "$current_value" = "/mob" ]; then
      current_value="enabled"
    else
      current_value="disabled"
    fi
    if [ "$audit_mode" != "2" ]; then
      if [ "$current_value" != "disabled" ]; then
        if [ "$audit_mode" = "0" ]; then
          if [ "$syslog_server" != "" ]; then
            echo "enabled" > $backup_file
            verbose_message "Setting:   Managed Object Browser to disabled"
            vim-cmd proxysvc/remove_service "/mob" "httpsWithRedirect"
          fi
        fi
        if [ "$audit_mode" = "1" ]; then
          increment_insecure "Managed Object Browser enabled"
          verbose_message "" fix
          verbose_message "vim-cmd proxysvc/remove_service \"/mob\" \"httpsWithRedirect\"" fix
          verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          increment_secure "Managed Object Browser disabled"
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        previous_value=$( cat $restore_file )
        if [ "$previous_value" = "enabled" ]; then
          verbose_message "Restoring: Managed Object Browser to enabled"
          vim-cmd proxysvc/add_np_service "/mob" httpsWithRedirect /var/run/vmware/proxy-mob
        fi
      fi
    fi
  fi
}
