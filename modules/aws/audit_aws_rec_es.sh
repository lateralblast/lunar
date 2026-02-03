#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_rec_es
#
# Check Elasticsearch Recommendations
#
# Refer to https://www.cloudconformity.com/conformity-rules/Elasticsearch/elasticsearch-dedicated-master-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/Elasticsearch/general-purpose-ssd-volume.html
#.

audit_aws_rec_es () {
  print_function  "audit_aws_rec_es"
  verbose_message "Elasticsearch Recommendations" "check"
  command="aws es list-domain-names --region \"${aws_region}\" --query \"DomainNames[].DomainName\" --output text"
  command_message "${command}"
  domains=$( eval "${command}" )
  for domain in ${domains}; do
    # Check that ES domains have dedicated masters
    command="aws es describe-elasticsearch-domain --domain-name \"${domain}\" --query \"DomainStatus.ElasticsearchClusterConfig.DedicatedMasterEnabled\" | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure   "Elasticsearch doamin \"${domain}\" has dedicated master nodes"
    else
      increment_insecure "Elasticsearch domain \"${domain}\" does not have dedicated master nodes"
    fi
    # Check that ES domains are using cost effective storage
    command="aws es describe-elasticsearch-domain --domain-name \"${domain}\" --query \"DomainStatus.EBSOptions.VolumeType\" | grep \"gp2\""
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure   "Elasticsearch doamin \"${domain}\" is using General Purpose SSD"
    else
      increment_insecure "Elasticsearch domain \"${domain}\" is not using General Purpose SSD"
      command="aws es describe-elasticsearch-domain --domain-name \"${domain}\" --query \"DomainStatus.EBSOptions.VolumeSize\" --output text"
      command_message "${command}"
      vol_size=$( eval "${command}" )
      verbose_message    "aws es update-elasticsearch-domain-config --region \"${aws_region}\" --domain-name \"${domain}\" --ebs-options EBSEnabled=true,VolumeType=\"gp2\",VolumeSize=$vol_size" "fix"
    fi
    # Check that ES domains have cross zone awareness
    command="aws es describe-elasticsearch-domain --domain-name \"${domain}\" --query \"DomainStatus.ElasticsearchClusterConfig.ZoneAwarenessEnabled\" | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure   "Elasticsearch doamin \"${domain}\" has cross zone awareness"
    else
      increment_insecure "Elasticsearch domain \"${domain}\" does not have cross zone awareness"
    fi
  done
}

