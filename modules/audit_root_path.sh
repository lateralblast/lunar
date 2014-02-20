# audit_root_path
#
# The root user can execute any command on the system and could be fooled into
# executing programs unemotionally if the PATH is not set correctly.
# Including the current working directory (.) or other writable directory in
# root's executable path makes it likely that an attacker can gain superuser
# access by forcing an administrator operating as root to execute a Trojan
# horse program.
#.

audit_root_path () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Root PATH Environment Integrity"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Root PATH"
      if [ "$audit_mode" = 1 ]; then
        if [ "`echo $PATH | grep :: `" != "" ]; then
          total=`expr $total + 1`
          score=`expr $score - 1`
          echo "Warning:   Empty directory in PATH [$score]"
        else
          total=`expr $total + 1`
          score=`expr $score + 1`
          echo "Secure:    No empty directory in PATH [$score]"
        fi
        if [ "`echo $PATH | grep :$`"  != "" ]; then
          total=`expr $total + 1`
          score=`expr $score - 1`
          echo "Warning:   Trailing : in PATH [$score]"
        else
          total=`expr $total + 1`
          score=`expr $score + 1`
          echo "Secure:    No trailing : in PATH [$score]"
        fi
        for dir_name in `echo $PATH | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g'`; do
          if [ "$dir_name" = "." ]; then
            total=`expr $total + 1`
            score=`expr $score - 1`
            echo "Warning:   PATH contains . [$score]"
          fi
          if [ -d "$dir_name" ]; then
            dir_perms=`ls -ld $dir_name | cut -f1 -d" "`
            if [ "`echo $dir_perms | cut -c6`" != "-" ]; then
              total=`expr $total + 1`
              score=`expr $score - 1`
              echo "Warning:   Group write permissions set on directory $dir_name [$score]"
            else
              total=`expr $total + 1`
              score=`expr $score + 1`
              echo "Secure:    Group write permission not set on directory $dir_name [$score]"
            fi
            if [ "`echo $dir_perms | cut -c9`" != "-" ]; then
              total=`expr $total + 1`
              score=`expr $score - 1`
              echo "Warning:   Other write permissions set on directory $dir_name [$score]"
            else
              total=`expr $total + 1`
              score=`expr $score + 1`
              echo "Secure:    Other write permission not set on directory $dir_name [$score]"
            fi
          fi
        done
      fi
    fi
  fi
}
