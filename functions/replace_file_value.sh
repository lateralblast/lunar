# replace_file_value
#
# Replace a value in a file with the correct value
#
# As there is no interactive sed on Solaris, ie sed -i
# pipe through sed to a temporary file, then replace original file
# Some handling is added to replace / when searching so sed works
#
# check_file    = File to replace value in
# check_value   = Value to check for
# correct_value = What the value should be
# position      = Position of value in the line
#.

replace_file_value () {
  check_file=$1
  check_value=$2
  new_check_value="$check_value"
  correct_value=$3
  new_correct_value="$correct_value"
  position=$4
  if [ "$position" = "start" ]; then
    position="^"
  else
    position=""
  fi
  string_check=$( expr "$check_value" : "\/" )
  if [ "$string_check" = 1 ]; then
    new_check_value=$( echo "$check_value" |sed 's,/,\\\/,g' )
  fi
  string_check=$( expr "$correct_value" : "\/" )
  if [ "$string_check" = 1 ]; then
    new_correct_value=$( echo "$correct_value" |sed 's,/,\\\/,g' )
  fi
  new_check_value="$position$new_check_value"
  if [ "$audit_mode" != 2 ]; then
    string="File $check_file contains $correct_value rather than $check_value"
    verbose_message "$string"
  fi
  if [ -f "$check_file" ]; then
    check_dfs=$( cat $check_file | grep -c "$new_check_value" | sed "s/ //g" )
  fi
  if [ "$check_dfs" != 0 ]; then
    if [ "$audit_mode" != 2 ]; then
      if [ "$ansible" = 1 ]; then
        echo ""
        echo "- name: Checking $string"
        echo "  lineinfile:"
        echo "    path: $check_file"
        echo "    regexp: '$new_check_value"
        echo "    replace: '$new_correct_value"
        echo ""
      fi
      increment_insecure "File $check_file contains \"$check_value\" rather than \"$correct_value\""
      backup_file $check_file
      lockdown_command  "sed -e \"s/$new_check_value/$new_correct_value/\" < $check_file > $temp_file ; cp $temp_file $check_file ; rm $temp_file" "Setting:   Share entries in $check_file to be secure"
      if [ "$os_version" != "11" ]; then
        pkgchk -f -n -p $check_file 2> /dev/null
      else
        pkg fix $( pkg search $check_file |grep pkg |awk '{print $4}' )
      fi
    else
      restore_file $check_file $restore_dir
    fi
  else
    increment_secure "File $check_file contains \"$correct_value\" rather than \"$check_value\""
  fi
}
