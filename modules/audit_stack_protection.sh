# audit_stack_protection
#
# Stack Protection
#
# Checks for the following values in /etc/system:
#
# set noexec_user_stack=1
# set noexec_user_stack_log=1
#
# Buffer overflow exploits have been the basis for many highly publicized
# compromises and defacements of large numbers of Internet connected systems.
# Many of the automated tools in use by system attackers exploit well-known
# buffer overflow problems in vendor-supplied and third-party software.
#
# Enabling stack protection prevents certain classes of buffer overflow
# attacks and is a significant security enhancement. However, this does not
# protect against buffer overflow attacks that do not execute code on the
# stack (such as return-to-libc exploits).
#.

audit_stack_protection () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Stack Protection"
    check_file="/etc/system"
    funct_file_value $check_file "set noexec_user_stack" eq 1 star
    funct_file_value $check_file "set noexec_user_stack_log" eq 1 star
  fi
}
