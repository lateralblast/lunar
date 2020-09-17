# audit_aws_rec_dynamodb
#
# Refer to https://www.cloudconformity.com/conformity-rules/DynamoDB/unused-dynamodb-tables.html
#.

audit_aws_rec_dynamodb () {
  # Check for zero length tables
  verbose_message "DynamoDB"
  tables=$( aws dynamodb list-tables --region $aws_region --query 'TableNames' --output text )
  for table in $tables; do
    size=$( aws dynamodb describe-table --region $aws_region --table-name $table --query 'Table.ItemCount' --output text )
    if [ ! "$size" -eq 0 ]; then
      increment_secure "DynamoDB table $table is not empty"
    else
      increment_insecure "DynamoDB table $table is empty"
    fi
  done
}

