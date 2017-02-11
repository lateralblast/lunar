# audit_java
#
# Refer to Section 2.11 Page(s) 82 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_java () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Java"
    if [ "$audit_mode" != 2 ]; then
      java_bin=`which java`
      if [ "$java_bin" ]; then
        echo "Checking:  Java version"
        version=`java -version 2>&1 | awk -F '"' '/version/ {print $2}' |cut -f2 -d.`
        check=7
        if [ "$version" -ge "$check" ]; then
          increment_secure "Java version is greater than $check"
        else
          increment_insecure "Java version is greater than $check"
        fi
      fi
    fi
  fi
}
