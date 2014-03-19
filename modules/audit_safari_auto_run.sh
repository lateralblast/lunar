# audit_safari_auto_run
#
# Safari will automatically run or execute what it considers safe files.
# This can include installers and other files that execute on the operating
# system. Safari bases files safety on the files type. The files considered
# safe include word files, PDF documents, and picture files.
# Hackers have taken advantage of this setting via drive-by attacks.
# These attacks occur when a user visits a legitimate website that has been
# corrupted. The user unknowingly downloads a malicious file either by closing
# an infected pop-up or hovering over a malicious banner. The attackers make
# sure that the malicious file type will fall within Safari's safe files
# policy and will download and run without user input.
#
# Refer to Section 6.3 Page(s) 78 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_safari_auto_run() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Safari Auto-run"
    funct_defaults_check com.apple.Safari AutoOpenSafeDownloads 0 int
  fi
}
