# audit_duplicate_users
#
# Although the useradd program will not let you create a duplicate User ID
# (UID), it is possible for an administrator to manually edit the /etc/passwd
# file and change the UID field.
# Users must be assigned unique UIDs for accountability and to ensure
# appropriate access protections.
#
# Although the useradd program will not let you create a duplicate user name,
# it is possible for an administrator to manually edit the /etc/passwd file
# and change the user name.
# If a user is assigned a duplicate user name, it will create and have access
# to files with the first UID for that username in /etc/passwd. For example,
# if "test4" has a UID of 1000 and a subsequent "test4" entry has a UID of 2000,
# logging in as "test4" will use UID 1000. Effectively, the UID is shared, which
# is a security problem.
#
# Refer to Section(s) 9.2.16,17 Page(s) 174-5     CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.15,18 Page(s) 201,203-4 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.16,17 Page(s) 177-8     CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 13.14,16  Page(s) 164-5     CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.12.16   Page(s) 219       CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.15,18   Page(s) 82-3,5    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.15,18   Page(s) 128-9,131 CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.16,18 Page(s) 269,71    CIS Amazon Linux Benchmark v2.0.0
#.

audit_duplicate_users () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Duplicate Users"
    audit_duplicate_ids 1 users name /etc/passwd
    audit_duplicate_ids 3 users id /etc/passwd
  fi
}
