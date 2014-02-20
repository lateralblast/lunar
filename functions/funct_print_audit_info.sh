# funct_print_audit_info
#
# This function searches the script for the information associated
# with a function.
# It finds the line starting with # function_name
# then reads until it finds a #.
#.

funct_print_audit_info () {
  if [ "$verbose" = 1 ]; then
    function=$1
    comment_text=0
    while read line
    do
      if [ "$line" = "# $function" ]; then
        comment_text=1
      else
        if [ "$comment_text" = 1 ]; then
          if [ "$line" = "#." ]; then
            echo ""
            comment_text=0
          fi
          if [ "$comment_text" = 1 ]; then
            if [ "$line" = "#" ]; then
              echo ""
            else
              echo "$line"
            fi
          fi
        fi
      fi
    done < $0
  fi
}
