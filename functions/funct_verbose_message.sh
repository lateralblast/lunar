# funct_verbose_message
#
# Print a message if verbose mode enabled
#.

funct_verbose_message () {
  if [ "$verbose" = 1 ]; then
    audit_text=$1
    audit_style=$2
    if [ "$audit_style" = "fix" ]; then
      if [ "$audit_text" = "" ]; then
        echo ""
      else
        echo "[ Fix ]    $audit_text"
      fi
    else
      echo ""
      echo "# $audit_text"
      echo ""
    fi
  fi
}
