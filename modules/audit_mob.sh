# audit_mob
#
# The managed object browser (MOB) provides a way to explore the object model
# used by the VMkernel to manage the host; it enables configurations to be
# changed as well. This interface is meant to be used primarily for debugging
# the vSphere SDK but because there are no access controls it could also be
# used as a method obtain information about a host being targeted for
# unauthorized access.
#
# Refer to:
#
# http://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.vsphere.security.doc%2FGUID-0EF83EA7-277C-400B-B697-04BDC9173EA3.html
#.

audit_mob () {
  if [ "$os_name" = "VMkernel" ]; then
    funct_verbose_message "Managed Object Browser"
    total=`expr $total + 1`
    log_file="mob_status"
    backup_file="$work_dir/$log_file"
    current_value=`vim-cmd proxysvc/service_list |grep "/mob" |awk '{print $3}' |cut -f1 -d, |sed 's/"//g'`
    if [ "$current_value" = "/mob" ]; then
      current_value="enabled"
    else
      current_value="disabled"
    fi
    if [ "$audit_mode" != "2" ]; then
      if [ "$current_value" != "disabled" ]; then
        if [ "$audit_more" = "0" ]; then
          if [ "$syslog_server" != "" ]; then
            echo "enabled" > $backup_file
            vim-cmd proxysvc/remove_service "/mob" "httpsWithRedirect"
          fi
        fi
        if [ "$audit_mode" = "1" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Managed Object Browser enabled [$insecure Warnings]"
          funct_verbose_message "" fix
          funct_verbose_message "vim-cmd proxysvc/remove_service \"/mob\" \"httpsWithRedirect\"" fix
          funct_verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Managed Object Browser disabled [$secure Passes]"
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        previous_value=`cat $restore_file`
        if [ "$previous_value" = "enabled" ]; then
          vim-cmd proxysvc/add_np_service "/mob" httpsWithRedirect /var/run/vmware/proxy-mob
        fi
      fi
    fi
  fi
}
