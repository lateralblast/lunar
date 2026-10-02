#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
test_dir=$(mktemp -d)
saved_path=${PATH}
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM

cat > "${test_dir}/java" <<'EOF'
#!/bin/sh
printf 'java version "17.0.1"\n' >&2
EOF
chmod +x "${test_dir}/java"

. "${script_dir}/../modules/darwin/audit_java.sh"

os_name=Darwin
audit_mode=1
secure_messages=""
insecure_messages=""
print_function() { :; }
check_message() { :; }
command_message() { :; }
verbose_message() { :; }
inc_secure() { secure_messages="${secure_messages}${1}\n"; }
inc_insecure() { insecure_messages="${insecure_messages}${1}\n"; }

PATH="${test_dir}:${PATH}"
export PATH
audit_java

case "${secure_messages}" in
  *"Java not installed"*)
    echo "Installed Java was also reported as not installed" >&2
    exit 1
    ;;
esac
case "${secure_messages}" in
  *"Java version is greater than"*) ;;
  *)
    echo "Installed Java version was not reported: ${secure_messages}" >&2
    exit 1
    ;;
esac

secure_messages=""
empty_path="${test_dir}/empty"
mkdir -p "${empty_path}"
PATH="${empty_path}"
export PATH
if audit_java; then :; fi
case "${secure_messages}" in
  *"Java not installed"*) ;;
  *)
    echo "Missing Java installation was not reported: ${secure_messages}" >&2
    exit 1
    ;;
esac
PATH=${saved_path}
export PATH

echo "Darwin Java installation reporting passed"
