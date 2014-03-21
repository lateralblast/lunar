# audit_virtual_memory
#
# Set the system flag to force randomized virtual memory region placement.
#
# Randomly placing virtual memory regions will make it difficult for to write
# memory page exploits as the memory placement will be consistently shifting.
#
# Refer to Section 1.6.3 Page(s) 46 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_virtual_memory () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] && [ "$os_version" = "6" ]; then
      check_file="/etc/sysctl.conf"
      funct_file_vale $check_file kernel.randomize_va_space eq 2 hash
    fi
  fi
}
