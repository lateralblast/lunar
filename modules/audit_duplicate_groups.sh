# audit_duplicate_groups
#
# Duplicate groups may result in escalation of privileges through administative
# error.
# Although the groupadd program will not let you create a duplicate Group ID
# (GID), it is possible for an administrator to manually edit the /etc/group
# file and change the GID field.
#
# Although the groupadd program will not let you create a duplicate group name,
# it is possible for an administrator to manually edit the /etc/group file and
# change the group name.
# If a group is assigned a duplicate group name, it will create and have access
# to files with the first GID for that group in /etc/groups. Effectively, the
# GID is shared, which is a security problem.
#
# Refer to Section(s) 9.2.15,17 Page(s) 173-5        CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.16,19 Page(s) 204-5        CIS Red Hat Enterprise Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.15,17 Page(s) 176-9        CIS Red Hat Enterprise Linux 6 Benchmark v1.2.0
# Refer to Section(s) 10.15,17  Page(s) 164-7        CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.2.17    Page(s) 220          CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.16,19   Page(s) 83-4,5-6     CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.16,19   Page(s) 129-30,131-2 CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.17,19 Page(s) 270,72       CIS Amazon Linux Benchmark v2.0.0
#.

audit_duplicate_groups () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Duplicate Groups"
    audit_duplicate_ids 1 groups name /etc/group
    audit_duplicate_ids 3 groups id /etc/group
  fi
}
