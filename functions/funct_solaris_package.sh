# funct_check_pkg
#
# Check is a package is installed
#
# Install package if it's not installed and in the pkg dir under the base dir
# Needs some more work
#.

funct_check_pkg () {
  if [ "$os_name" = "SunOS" ]; then
    pkg_name=$1
    pkg_check=`pkginfo $1`
    log_file="$work_dir/pkg.log"
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Package $pkg_name is installed"
    fi
    if [ `expr "$pkg_check" : "ERROR"` != 5 ]; then
      if [ "$audit_mode" = 1 ]; then
        score=`expr $score + 1`
        echo "Secure:    Package $pkg_name is already installed [$score]"
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        score=`expr $score - 1`
        echo "Warning:   Package $pkg_name is not installed [$score]"
        if [ "$os_version" = "11" ]; then
          funct_verbose_message "" fix
          funct_verbose_message  "pkgadd $pkg_name" fix
          funct_verbose_message "" fix
        else
          funct_verbose_message "" fix
          funct_verbose_message  "pkgadd -d $base_dir/pkg $pkg_name" fix
          funct_verbose_message "" fix
        fi
      fi
      if [ "$audit_mode" = 0 ]; then
        pkg_dir="$base_dir/pkg/$pkg_name"
        if [ -d "$pkg_dir" ]; then
          echo "Installing: $pkg_name"
          if [ "$os_version" = "11" ]; then
            pkgadd $pkg_name
          else
            pkgadd -d $base_dir/pkg $pkg_name
            pkg_check=`pkginfo $1`
          fi
          if [ `expr "$pkg_check" : "ERROR"` != 5 ]; then
            echo "$pkg_name" >> $log_file
          fi
        fi
      fi
    fi
    if [ "$audit_mode" = 2 ]; then
      restore_file="$restore_dir/pkg.log"
      if [ -f "$restore_file" ]; then
        restore_check=`cat $restore_file |grep "^$pkg_name$" |head -1`
        if [ "$restore_check" = "$pkg_name" ]; then
          echo "Removing:   $pkg_name"
          if [ "$os_version" = "11" ]; then
            pkg uninstall $pkg_name
          else
            pkgrm $pkg_name
          fi
        fi
      fi
    fi
  fi
}
