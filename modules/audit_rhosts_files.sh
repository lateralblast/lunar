# audit_rhosts_files
#
# The /.rhosts, /.shosts, and /etc/hosts.equiv files enable a weak form of
# access control. Attackers will often target these files as part of their
# exploit scripts. By linking these files to /dev/null, any data that an
# attacker writes to these files is simply discarded (though an astute
# attacker can still remove the link prior to writing their malicious data).
#.

audit_rhosts_files () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Rhosts Files"
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  Rhosts files"
      fi
      for check_file in /.rhosts /.shosts /etc/hosts.equiv; do
        funct_file_exists $check_file no
      done
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Rhosts files"
    fi
    for check_file in /.rhosts /.shosts /etc/hosts.equiv; do
      funct_file_exists $check_file no
    done
  fi
}
