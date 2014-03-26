# funct_lslpp_check
#
# Check if an AIX package is installed, if so rpm_check will be be set with
# name of rpm, otherwise it will be empty
#.

funct_lslpp_check () {
  package_name=$1
  if [ $os_name = "AIX" ]; then
    lslpp_check="lslpp -L |grep \"$package_name\""
  fi
}
