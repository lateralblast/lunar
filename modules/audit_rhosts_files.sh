# audit_rhosts_files
#
# The /.rhosts, /.shosts, and /etc/hosts.equiv files enable a weak form of
# access control. Attackers will often target these files as part of their
# exploit scripts. By linking these files to /dev/null, any data that an
# attacker writes to these files is simply discarded (though an astute
# attacker can still remove the link prior to writing their malicious data).
#
# Refer to Section(s) 1.5.2 Page(s) 102-3 CIS AIX Benchmark v1.1.0
#.

audit_rhosts_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Rhosts Files"
    for check_file in /.rhosts /.shosts /root/.rhosts /root/.shosts /etc/hosts.equiv; do
      funct_file_exists $check_file no
    done
  fi
}
