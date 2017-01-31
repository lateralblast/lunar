# audit_aws_inspector
#
# Refer to 
# Refer to 
#.

audit_aws_inspector () {
  # check for templates
  templates=`aws inspector list-assessment-templates 2> /dev/null --output text`
  if [ "$templates" ]; then
    # check for subscriptions to templates
    check=`aws inspector list-event-subscriptions --region $aws_region --query subscriptions --output text`
    total=`expr $total + 1`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Inspectors have subscriptions [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Inspectors do not have subscriptions [$insecure Warnings]"
    fi
    for template in $templates; do
      names=`aws inspector describe-assessment-templates --region $aws_region --assessment-template-arns $template --query 'assessmentTemplates[].name' --output text`
      for name in $names; do
        instances=`aws ec2 describe-instances --region $aws_region --query 'Reservations[].Instances[].InstanceId' --output text`
        for instance in $instances; do
          check=`aws ec2 describe-instances --region $aws_region --instance-id $instance --query 'Reservations[].Instances[].Tags' |grep $name`
          total=`expr $total + 1`
          if [ "$check" ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Instance $instance has an inspector tag [$secure Passes]"
          else
            insecure=`expr $insecure + 1`
            echo "Warning:   Instance $instance does not have an inspector tag [$insecure Warnings]"
          fi
        done
      done
    done
    assessments=`aws inspector list-findings --output text`
    total=`expr $total + 1`
    if [ "$assessments" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Inspector has been run recently [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Inspector has not been run recently [$insecure Warnings]"
    fi
  else
    total=`expr $total + 1`
    insecure=`expr $insecure + 1`
    echo "Warning:   No inspector templates exist [$insecure Warnings]"
  fi
}

