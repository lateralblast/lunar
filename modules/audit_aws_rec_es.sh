# audit_aws_rec_es
#
# Ensure that your AWS Elasticsearch Service (ES) clusters are using
# dedicated master nodes to improve their environmental stability by
# offloading all the management tasks from the cluster data nodes.
#
# Using Elasticsearch dedicated master nodes to separate management tasks from
# index and search requests will improve the clusters ability to manage easily
# different types of workload and make them more resilient in production.
#
# Refer to https://www.cloudconformity.com/conformity-rules/Elasticsearch/elasticsearch-dedicated-master-enabled.html
#
# Ensure that your Amazon Elasticsearch (ES) clusters are using General Purpose
# SSD (gp2) data nodes instead of Provisioned IOPS SSD (io1) nodes for cost
# effective storage that fits a broad range of workloads. 
#
# Using General Purpose SSD (gp2) data nodes instead of Provisioned IOPS SSD
# (io1) nodes represents a good strategy to cut down on Elasticsearch service
# storage costs because for gp2-type nodes you only pay for the storage compared
# to io1 nodes where you pay for both storage and I/O operations. Converting
# existing io1 resources to gp2 is often possible by configuring larger storage
# which gives higher baseline performance of IOPS for a lower cost.
#
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

