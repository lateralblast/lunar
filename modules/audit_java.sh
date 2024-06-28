#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_java
#
# Check Java
#
# Refer to Section 2.11 Page(s) 82 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_java () {
  minimum=7
  if [ "$os_name" = "Darwin" ]; then
    if [ "$audit_mode" != 2 ]; then
      java_bin=$( command -v java )
      if [ -n "$java_bin" ]; then
        verbose_message "Java version" "check"
        version=$( java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -f1 -d. )
        if [ "$version" -ge "$minimum" ]; then
          increment_secure   "Java version is greater than \"$minimum\""
        else
          increment_insecure "Java version is less than \"$minimum\""
        fi
      fi
    fi
  fi
}
