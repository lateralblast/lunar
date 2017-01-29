# audit_aws_rec_dynamodb
#
# Refer to https://www.cloudconformity.com/conformity-rules/DynamoDB/unused-dynamodb-tables.html
#.

audit_aws_rec_dynamodb () {
  # Check for zero length tables
  total=`expr $total + 1`
  tables=`aws dynamodb list-tables --region $aws_region --query 'TableNames' --output text`
  for table in $tables; do
    size=`aws dynamodb describe-table --region $aws_region --table-name $table --query 'Table.ItemCount' --output text`
    if [ ! "$size" -eq 0 ]; then
      secure=`expr $secure + 1`
      echo "Pass:      DynamoDB table $table is not empty [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   DynameDB table $table is empty [$insecure Warnings]"
    fi
  done
}

