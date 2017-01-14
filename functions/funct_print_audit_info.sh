# funct_print_audit_info
#
# This function searches the script for the information associated
# with a function.
# It finds the line starting with # function_name
# then reads until it finds a #.
#.

funct_print_audit_info () {
  if [ "$verbose" = 1 ]; then
    module=$1
    comment_text=0
    dir_name=`pwd`
    file_name="$dir_name/modules/$module.sh"
    if [ -f "$file_name" ] ; then
      echo "# Module: $module"
      while read line ; do
        if [ "$line" == "# $module" ]; then
          comment_text=1
        else
          if [ "$comment_text" = 1 ]; then
            if [ "$line" == "#." ]; then
              echo ""
              comment_text=0
            fi
            if [ "$comment_text" == 1 ]; then
              if [ "$line" == "#" ]; then
                echo ""
              else
                echo "$line"
              fi
            fi
          fi
        fi
      done < $file_name
   fi 
  fi
}
