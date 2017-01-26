# audit_aws_rec_dynamodb
#
# Identify any unused Amazon DynamoDB tables available within your AWS account
# and remove them to help lower the cost of your monthly AWS bill. A DynamoDB
# table is considered unused if it’s ItemCount parameter, which describes the
# number of items in the table, is equal to 0 (zero).
#
# You are being charged for AWS DynamoDB Read & Write capacity, regardless
# whether or not you use the provisioned capacity units for your tables. 
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

