# audit_duplicate_ids
#
# Code to check for duplicate IDs
# Routine to check a file for duplicates
# Takes:
# field:      Field number
# function:   String describing action, eg users
# term:       String describing term, eg name
# check_file: File to parse
#
# Although the useradd program will not let you create a duplicate User ID
# (UID), it is possible for an administrator to manually edit the /etc/passwd
# file and change the UID field.
#
#.

audit_duplicate_ids () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Duplicate IDs"
    field=$1
    function=$2
    term=$3
    duplicate=0
    check_file=$4
    if [ "$audit_mode" != 2 ]; then
      for file_info in $( cat $check_file | cut -f$field -d":" | sort -n | uniq -c |awk '{ print $1":"$2 }' ); do
        file_check=$( expr "$file_info" : "[A-z,0-9]" )
        if [ "$file_check" = 1 ]; then
          file_check=$( expr "$file_info" : "2" )
          if [ "$file_check" = 1 ]; then
            file_id=$( echo "$file_info" |cut -f2 -d":" )
            if [ "$audit_mode" = 1 ];then
              increment_insecure "There are multiple $function with $term $file_id"
              duplicate=1
            fi
          fi
        fi
      done
      if [ "$audit_mode" = 1 ]; then
        if [ "$duplicate" = 0 ];then
          increment_secure "No $function with duplicate $term"
        fi
      fi
    fi
  fi
}
