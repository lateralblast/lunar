# funct_deb_check
#
# Check if a deb is installed, if so rpm_check will be be set with name of dep,
# otherwise it will be empty
#.

funct_deb_check () {
  package_name=$1
  rpm_check=`dpkg -l $package_name 2>&1 |grep $package_name |awk '{print $2}' |grep "^$package_name$"`
}
