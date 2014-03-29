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
# Refer to Section(s) 9.2.16 Page(s) 174-5 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.12.16 Page(s) 219 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.15,18 Page(s) 82-3,5 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.15,18 Page(s) 128-9,131 CIS Solaris 10 v1.1.0
#.

audit_duplicate_users () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Duplicate Users"
    audit_duplicate_ids 1 users name /etc/passwd
    audit_duplicate_ids 3 users id /etc/passwd
  fi
}
