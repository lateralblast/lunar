# check_rpm
#
# Check if an rpm is installed, if so rpm_check will be be set with name of rpm,
# otherwise it will be empty
#.

check_rpm () {
  if [ $os_name = "Linux" ]; then
    package_name=$1
    if [ "$linux_dist" = "debian" ]; then
      check_debian_package $package_name
    else
      rpm_check=$( rpm -qi $package_name | grep $package_name | grep Name | awk '{print $3}' )
    fi
  fi
}
