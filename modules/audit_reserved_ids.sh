# audit_reserved_ids
#
# Traditionally, Unix systems establish "reserved" UIDs (0-99 range) that are
# intended for system accounts.
# If a user is assigned a UID that is in the reserved range, even if it is not
# presently in use, security exposures can arise if a subsequently installed
# application uses the same UID.
#
# Refer to Section(s) 9.2.17 Page(s) 202-3 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.17 Page(s) 84-5 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.17 Page(s) 130-1 CIS Solaris 10 v1.1.0
#.

audit_reserved_ids () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Reserved IDs"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Whether reserved UUIDs are assigned to system accounts"
    fi
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      getent passwd | awk -F: '($3 < 100) { print $1" "$3 }' | while read check_user check_uid; do
        found=0
        for test_user in root daemon bin sys adm lp uucp nuucp smmsp listen \
        gdm webservd postgres svctag nobody noaccess nobody4 unknown; do
          if [ "$check_user" = "$test_user" ]; then
            found=1
          fi
        done
        if [ "$found" = 0 ]; then
          uuid_check=1
          if [ "$audit_mode" = 1 ];then
            insecure=`expr $insecure + 1`
            echo "Warning:   User $check_user has a reserved UID ($check_uid) [$insecure Warnings]"
          fi
        fi
      done
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Reserved IDs"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Whether reserved UUIDs are assigned to system accounts"
    fi
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      getent passwd | awk -F: '($3 < 500) { print $1" "$3 }' | while read check_user check_uid; do
        found=0
        for test_user in root bin daemon adm lp sync shutdown halt mail news uucp \
          operator games gopher ftp nobody nscd vcsa rpc mailnull smmsp pcap \
          dbus sshd rpcuser nfsnobody haldaemon distcache apache \
          oprofile webalizer dovecot squid named xfs gdm sabayon; do
          if [ "$check_user" = "$test_user" ]; then
            found=1
          fi
        done
        if [ "$found" = 0 ]; then
          uuid_check=1
          if [ "$audit_mode" = 1 ];then
            insecure=`expr $insecure + 1`
            echo "Warning:   User $check_user has a reserved UID ($check_uid) [$insecure Warnings]"
          fi
        fi
      done
    fi
  fi
}
