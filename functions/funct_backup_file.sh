# funct_backup_file
#
# Backup file
#.

funct_backup_file () {
  check_file=$1
  backup_file="$work_dir$check_file"
  if [ ! -f "$backup_file" ]; then
    echo "Saving:    File $check_file to $backup_file"
    find $check_file | cpio -pdm $work_dir 2> /dev/null
  fi
}
