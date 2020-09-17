# audit_aws_rec_es
#
# Refer to https://www.cloudconformity.com/conformity-rules/Elasticsearch/elasticsearch-dedicated-master-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/Elasticsearch/general-purpose-ssd-volume.html
#.

audit_aws_rec_es () {
  verbose_message "Elasticsearch Recommendations"
  domains=$( aws es list-domain-names --region $aws_region --query "DomainNames[].DomainName" --output text )
  for domain in $domains; do
    # Check that ES domains have dedicated masters
    check=$( aws es describe-elasticsearch-domain --domain-name $domain --query "DomainStatus.ElasticsearchClusterConfig.DedicatedMasterEnabled" | grep true )
    if [ "$check" ]; then
      increment_secure "Elasticsearch doamin $domain has dedicated master nodes"
    else
      increment_insecure "Elasticsearch domain $domain does not have dedicated master nodes"
    fi
    # Check that ES domains are using cost effective storage
    check=$( aws es describe-elasticsearch-domain --domain-name $domain --query 'DomainStatus.EBSOptions.VolumeType' | grep "gp2" )
    if [ "$check" ]; then
      increment_secure "Elasticsearch doamin $domain is using General Purpose SSD"
    else
      increment_insecure "Elasticsearch domain $domain is not using General Purpose SSD"
      vol_size=$( aws es describe-elasticsearch-domain --domain-name $domain --query 'DomainStatus.EBSOptions.VolumeSize' --output text )
      verbose_message "" fix
      verbose_message "aws es update-elasticsearch-domain-config --region $aws_region --domain-name $domain --ebs-options EBSEnabled=true,VolumeType=\"gp2\",VolumeSize=$vol_size" fix
      verbose_message "" fix
    fi
    # Check that ES domains have cross zone awareness
    check=$( aws es describe-elasticsearch-domain --domain-name $domain --query "DomainStatus.ElasticsearchClusterConfig.ZoneAwarenessEnabled" | grep true )
    if [ "$check" ]; then
      increment_secure "Elasticsearch doamin $domain has cross zone awareness"
    else
      increment_insecure "Elasticsearch domain $domain does not have cross zone awareness"
    fi
  done
}

