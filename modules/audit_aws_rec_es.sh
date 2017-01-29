# audit_aws_rec_es
#
# Refer to https://www.cloudconformity.com/conformity-rules/Elasticsearch/elasticsearch-dedicated-master-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/Elasticsearch/general-purpose-ssd-volume.html
#.

audit_aws_rec_es () {
  domains=`aws es list-domain-names --region $aws_region --query "DomainNames[].DomainName" --output text`
  for domain in $domains; do
    # Check that ES domains have dedicated masters
    total=`expr $total + 1`
    check=`aws es describe-elasticsearch-domain --domain-name $domain --query "DomainStatus.ElasticsearchClusterConfig.DedicatedMasterEnabled" |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Pass:      Elasticsearch doamin $domain has dedicated master nodes [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Elasticsearch domain $domain does not have dedicated master nodes [$insecure Warnings]"
    fi
    # Check that ES domains are using cost effective storage
    total=`expr $total + 1`
    check=`aws es describe-elasticsearch-domain --domain-name $domain --query 'DomainStatus.EBSOptions.VolumeType' |grep "gp2"`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Pass:      Elasticsearch doamin $domain is using General Purpose SSD [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Elasticsearch domain $domain is not using General Purpose SSD [$insecure Warnings]"
      vol_size=`aws es describe-elasticsearch-domain --domain-name $domain --query 'DomainStatus.EBSOptions.VolumeSize' --output text`
      funct_verbose_message "" fix
      funct_verbose_message "aws es update-elasticsearch-domain-config --region $aws_region --domain-name $domain --ebs-options EBSEnabled=true,VolumeType=\"gp2\",VolumeSize=$vol_size" fix
      funct_verbose_message "" fix
    fi
    # Check that ES domains have cross zone awareness
    total=`expr $total + 1`
    check=`aws es describe-elasticsearch-domain --domain-name $domain --query "DomainStatus.ElasticsearchClusterConfig.ZoneAwarenessEnabled" |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Pass:      Elasticsearch doamin $domain has cross zone awareness [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Elasticsearch domain $domain does not have cross zone awareness [$insecure Warnings]"
    fi
  done
}

