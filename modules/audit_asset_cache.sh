# audit_asset_cache
#
# The main use case for Mac computers is as mobile user endpoints. P2P sharing
# services should not be enabled on laptops that are using untrusted networks. Content
# Caching can allow a computer to be a server for local nodes on an untrusted network.
# While there are certainly logical controls that could be used to mitigate risk, they add to
# the management complexity. Since the value of the service is in specific use cases,
#
# Refer to Section(s) 2.3.3.9 Page(s) 111-3 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_asset_cache () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 13 ]; then
      verbose_message "Asset Cache"
      if [ "$audit_mode" != 2 ]; then
        check_value=$( /usr/bin/sudo /usr/bin/AssetCacheManagerUtil status 2>&1 |grep Activated |awk '{print $2}' )
        if [ "$check_value" = "$asset_cache" ]; then
          increment_secure "Content Caching is set to $asset_cache"
        else
          increment_insecure "Content Caching is not set to $asset_cache"
        fi
      fi
    fi
  fi
}
