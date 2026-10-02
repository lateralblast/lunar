# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project does not strictly follow Semantic Versioning; version numbers
are bumped roughly once per change.

## [16.6.1] - 2026-10-02
### Fixed
- Relabeled the Azure SQL Database "Auditing" check to "Customer-Managed Key", matching the keyVaultKeyUri property it actually queries

## [16.6.0] - 2026-10-02
### Fixed
- Fixed Azure Recovery Services Vaults "Soft Delete" and "Customer Managed Keys" checks having their query paths swapped (same bug as Backup Vaults)

## [16.5.9] - 2026-10-02
### Fixed
- Fixed Azure Backup Vaults "Soft Delete" and "Customer Managed Keys" checks having their query paths swapped, so each reported on and fixed the wrong setting

## [16.5.8] - 2026-10-02
### Fixed
- Fixed invalid `az redis enterprise show` command (should be `az redisenterprise show`) in the Redis Enterprise cache audit

## [16.5.7] - 2026-10-02
### Fixed
- Fixed the Function App Deployment Slots Python version check using `az webapp` commands with `--id` instead of `az functionapp` commands with `--name`, and corrected its copied-over "No App Service Deployment Slots found" message

## [16.5.6] - 2026-10-02
### Fixed
- Fixed the Solaris NetBackup filesystem search check: renamed undefined funct_file_value to check_file_value, added the missing operator argument, checked /etc/hosts.deny instead of /etc/hosts.allow, and corrected the per-service parameter names for bpcd/vnetd/vopied/bpjava-msvc

## [16.5.5] - 2026-10-02
### Fixed
- Removed dead call to nonexistent audit_aws_iam_policies from the full AWS audit (superseded by audit_aws_iam)

## [16.5.4] - 2026-10-02
### Fixed
- Fixed the Azure App Service Deployment Slots dispatcher calling an abbreviated, undefined basic-auth function name instead of audit_azure_app_service_deployment_slots_basic_authentication_publishing_credentials

## [16.5.3] - 2026-10-02
### Fixed
- Renamed the Azure App Service Deployment Slots HTTP check to audit_azure_app_service_deployment_slots_http_values so it matches its filename and the dispatcher's call (was defined as ..._http_versions)

## [16.5.2] - 2026-10-02
### Fixed
- Fixed the Azure Storage Services dispatcher calling audit_azure_storage_accounts_locks (undefined) instead of audit_azure_storage_account_locks

## [16.5.1] - 2026-10-02
### Fixed
- Fixed the Azure Function Deployment Slots private endpoints check calling the App Service Deployment Slots variant instead of its own audit_azure_function_deployment_slots_private_endpoints

## [16.5.0] - 2026-10-02
### Fixed
- Renamed funct_check_pkg to check_solaris_package so the cross-platform package check dispatcher can find it on SunOS

## [16.4.9] - 2026-10-02
### Fixed
- Renamed the xinetd per-service check from audit_xinetd_service to check_xinetd_service so it matches its filename and caller

## [16.4.8] - 2026-10-02
### Fixed
- Fixed the FTP server audit calling undefined check_launchctl instead of check_launchctl_service on Darwin

## [16.4.7] - 2026-10-02
### Fixed
- Fixed funct_file_perms typos in the syslog server audit (should be check_file_perms)

## [16.4.6] - 2026-10-02
### Fixed
- Fixed Azure database/storage value-check calls missing the azure_ prefix (Cosmos DB, MySQL, PostgreSQL, SQL DB, Redis Cache, Redis Enterprise Cache, Data Factory), which left those checks entirely unrun

## [16.4.5] - 2026-10-02
### Fixed
- Fixed check_azure_network_watcher_flow_logs_value naming mismatch (defined as check_azure_network_watcher_flow_log_value) in the Network Watcher flow log audit

## [16.4.4] - 2026-10-02
### Fixed
- Defined check_docker, check_multipass, and check_all so `--checkenv docker|multipass|all` no longer invoke undefined functions

## [16.4.3] - 2026-10-02
### Fixed
- Corrected the update_log function's parameter documentation (PR #167)

## [16.4.2] - 2026-10-02
### Fixed
- Fixed the Azure Function Apps verbose label to match the function definition (PR #165)

## [16.4.1] - 2026-10-02
### Fixed
- Fixed the EC2 Name tag recommendation to target the current VPC ID (PR #160)

## [16.4.0] - 2026-10-02
### Fixed
- Fixed the RDS recommendation to recognize a nonempty gp2 match as General Purpose SSD (PR #158)

## [16.3.9] - 2026-10-02
### Fixed
- Fixed the EC2 snapshot retention audit to iterate over each returned snapshot ID (PR #156)

## [16.3.8] - 2026-10-02
### Fixed
- Fixed the Redshift reserved-node expiration audit to use the current node ID (PR #154)

## [16.3.7] - 2026-10-02
### Fixed
- Fixed the DynamoDB unused-table recommendation to iterate over each returned table name (PR #152)

## [16.3.6] - 2026-10-02
### Fixed
- Removed the undefined check_aws call from selective AWS audit dispatch (PR #150)

## [16.3.5] - 2026-10-02
### Fixed
- Removed undefined check_aws/check_azure calls from the AWS/Azure audit wrappers (PR #148)

## [16.3.4] - 2026-10-02
### Fixed
- Fixed the Azure Blob Storage helper's verbose output label (PR #146)

## [16.3.3] - 2026-10-02
### Fixed
- Fixed -K|--function|--test to run the requested function via the selective audit path (PR #120)

## [16.3.2] - 2026-10-02
### Fixed
- Fixed -B|--basedir to recompute derived work/temp/CSV paths while honoring explicit -M/-T/-F overrides (PR #144)

## [16.3.1] - 2026-10-02
### Fixed
- Fixed -c|--codename|--distro to control the Docker Compose image and Multipass release codename (PR #142)

## [16.3.0] - 2026-10-02
### Fixed
- Fixed -R|--moduleinfo|--testinfo to print module descriptions without requiring verbose mode (PR #140)

## [16.2.9] - 2026-10-02
### Fixed
- Fixed audit score summaries to show N/A instead of dividing by zero when no checks ran (PR #138)

## [16.2.8] - 2026-10-02
### Fixed
- Fixed --strict/--shellcheck to aggregate and propagate ShellCheck failures across all scanned scripts (PR #136)

## [16.2.7] - 2026-10-02
### Fixed
- Fixed remote audits to run from a copied checkout instead of in place (PR #134)

## [16.2.6] - 2026-10-02
### Fixed
- Fixed --moduleinfo to resolve nested/bare module identifiers under modules_dir (PR #132)

## [16.2.5] - 2026-10-02
### Fixed
- Fixed -S|--unixtests to list non-AWS UNIX modules (PR #130)

## [16.2.4] - 2026-10-02
### Fixed
- Fixed verbose test module descriptions to resolve the source file from the discovered module path (PR #128)

## [16.2.3] - 2026-10-02
### Fixed
- Fixed print_changes to strip base/date prefixes so original file paths resolve correctly (PR #126)

## [16.2.2] - 2026-10-02
### Fixed
- Fixed print_changes to check base_dir as a directory instead of a file (PR #124)

## [16.2.1] - 2026-10-02
### Fixed
- Fixed -3|--printfunct to print function names even outside verbose mode (PR #122)

## [16.2.0] - 2026-10-02
### Fixed
- Accepted the documented --shellcheck alias and corrected the README's -9|--checkenv entry (PR #118)

## [16.1.9] - 2026-10-02
### Fixed
- Fixed bare --list and --tests options being rejected before reaching their default behavior (PR #116)

## [16.1.8] - 2026-10-02
### Fixed
- Fixed --strict to invoke ShellCheck and added --shellcheck as a direct alias (PR #114)

## [16.1.7] - 2026-10-02
### Fixed
- Fixed Darwin Java installation reporting to only report Java missing when actually absent (PR #112)

## [16.1.6] - 2026-10-02
### Fixed
- Avoided restarting the Solaris name-service cache during audit mode (PR #110)

## [16.1.5] - 2026-10-02
### Fixed
- Fixed unconfined daemon audit findings, which had secure/insecure classification reversed (PR #108)

## [16.1.4] - 2026-10-02
### Fixed
- Fixed the Postfix loopback-only audit value (misspelled "loopbank-only") (PR #106)

## [16.1.3] - 2026-10-02
### Fixed
- Fixed the Solaris logadm audit to use the captured command result instead of an unset variable (PR #104)

## [16.1.2] - 2026-10-02
### Fixed
- Fixed Solaris power suspend restore to read poweradm.log from the restore directory (PR #102)

## [16.1.1] - 2026-10-02
### Fixed
- Fixed the iptables non-root audit to avoid claiming unaudited rules are secure (PR #100)

## [16.1.0] - 2026-10-02
### Fixed
- Fixed the system account shell lockdown command, which used an unset value in lockdown mode (PR #98)

## [16.0.9] - 2026-10-02
### Fixed
- Fixed the Amazon Linux telnet check to match on os_vendor (PR #96)

## [16.0.8] - 2026-10-02
### Fixed
- Marked missing AIX FTP authorization banners as insecure (PR #94)

## [16.0.7] - 2026-10-02
### Fixed
- Fixed the AIX DNS server check to run by adding AIX to the supported OS gate (PR #92)

## [16.0.6] - 2026-10-02
### Fixed
- Fixed cron allow list output paths to derive cron_file/at_file from the selected base directory (PR #90)

## [16.0.5] - 2026-10-02
### Fixed
- Fixed Linux cron permission checks to use the enumerated file path for each check (PR #88)

## [16.0.4] - 2026-10-02
### Fixed
- Fixed auditd GRUB option detection (misspelled variable, boolean helper, missing file handling) (PR #86)

## [16.0.3] - 2026-10-02
### Fixed
- Fixed CDE screen lock discovery to use portable shell globbing instead of unsupported find flags (PR #84)

## [16.0.2] - 2026-10-02
### Fixed
- Treated missing or empty mount policy as insecure instead of creating an empty policy during audit (PR #82)

## [16.0.1] - 2026-10-02
### Fixed
- Fixed the GNOME automount dconf lock file to include all three media-handling lock entries (PR #80)

## [16.0.0] - 2026-10-02
### Fixed
- Avoided creating the SAR directory during audits; it is now only created during lockdown (PR #78)

## [15.9.9] - 2026-10-02
### Fixed
- Fixed xinetd enabled service detection by expanding the configuration file glob (PR #76)

## [15.9.8] - 2026-10-02
### Fixed
- Fixed generated systemd Ansible task enablement to derive from the normalized requested status (PR #74)

## [15.9.7] - 2026-10-02
### Fixed
- Fixed the generated AIX Ansible inittab task to emit the name argument and correct disabled state (PR #72)

## [15.9.6] - 2026-10-02
### Fixed
- Fixed AIX inittab presence detection in audit and restore paths (PR #71)

## [15.9.5] - 2026-10-02
### Fixed
- Fixed the Ubuntu 11.10 codename mapping used by the Multipass image-selection path (PR #68)

## [15.9.4] - 2026-10-02
### Fixed
- Fixed CSV field escaping and selected the default output filename before creating its parent directory (PR #65)

## [15.9.3] - 2026-09-21
### Changed
- Standardised shebang lines to #!/bin/sh across all scripts

## [15.9.2] - 2026-09-21
### Fixed
- Fixed copy-pasted function names in Azure Function App, App Service slot, and password hints checks

## [15.9.1] - 2026-03-19
### Fixed
- Fixed Bluetooth check

## [15.9.0] - 2026-03-19
### Added
- Added percentage calculation to print_info

## [15.8.9] - 2026-03-19
### Added
- Added platform check to XD/NX Support check

## [15.8.8] - 2026-03-19
### Changed
- Cleaned up AWS module directory structure

## [15.8.7] - 2026-03-18
### Changed
- Function name cleanup

## [15.8.6] - 2026-03-18
### Changed
- Split out Azure Function App Cross-Origin Resource Sharing check

## [15.8.5] - 2026-03-18
### Changed
- Split out Azure Function App Virtual Network Integration and VNet checks

## [15.8.4] - 2026-03-18
### Changed
- Split out Azure Function App Public Network Access check

## [15.8.3] - 2026-03-18
### Changed
- Split out Azure Function App Managed Identities check

## [15.8.2] - 2026-03-18
### Changed
- Split out Azure Function App Service Authentication check

## [15.8.1] - 2026-03-18
### Changed
- Split out Azure Function App Client Certificates check

## [15.8.0] - 2026-03-18
### Changed
- Split out Azure Function App Remote Debugging check

## [15.7.9] - 2026-03-17
### Changed
- Split out Azure Function App TLS values check

## [15.7.8] - 2026-03-17
### Changed
- Split out Azure Function App HTTP values check

## [15.7.7] - 2026-03-17
### Changed
- Split out Azure Function App FTP State check

## [15.7.6] - 2026-03-17
### Changed
- Split out Azure Function App Basic Authentication Publishing Credentials check

## [15.7.5] - 2026-03-17
### Changed
- Split out Azure Function App Python versions check

## [15.7.4] - 2026-03-17
### Changed
- Split out Azure Function App Java versions check

## [15.7.3] - 2026-03-17
### Changed
- Directory structure clean up

## [15.7.2] - 2026-03-17
### Changed
- Split out Azure Function App Deployment Slots Private Endpoints check

## [15.7.1] - 2026-03-17
### Changed
- Split out Azure Function App Deployment Slots CORS check

## [15.7.0] - 2026-03-17
### Changed
- Split out Azure Function App Deployment Slots Virtual Network Integration and VNet check

## [15.6.9] - 2026-03-17
### Changed
- Split out Azure Function App Deployment Slots Public Network Access check

## [15.6.8] - 2026-03-17
### Changed
- Split out Azure Function App Deployment Slots Managed Identities check

## [15.6.7] - 2026-03-17
### Changed
- Split out Azure Function App Deployment Slots Client Certificates check

## [15.6.6] - 2026-03-17
### Changed
- Split out Azure Function App Deployment Slots Remote Debugging check

## [15.6.5] - 2026-03-17
### Changed
- Formatting fixes for Azure App Service Deployment Slots

## [15.6.4] - 2026-03-16
### Changed
- Formatting fixes for Azure Function App Deployment Slots

## [15.6.3] - 2026-03-16
### Changed
- Split out Azure Function App Deployment Slots TLS values check

## [15.6.2] - 2026-03-16
### Changed
- Split out Azure Function App Deployment Slots HTTP Version and HTTPS Only check

## [15.6.1] - 2026-03-16
### Changed
- Split out Azure Function App Deployment Slots FTP State check

## [15.6.0] - 2026-03-16
### Changed
- Split out Azure Function App Deployment Slots Basic Authentication Publishing Credentials check

## [15.5.9] - 2026-03-16
### Changed
- Split out Azure Function App Deployment Slots Python version check

## [15.5.8] - 2026-03-16
### Changed
- Split out Azure Function App Deployment Slots Java version check

## [15.5.7] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot Private Endpoints check

## [15.5.6] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot CORS check

## [15.5.5] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot VNet Content Share check

## [15.5.4] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot VNet Image Pull check

## [15.5.3] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot Virtual Network Integration check

## [15.5.2] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot Public Network Access check

## [15.5.1] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot Managed Identities check

## [15.5.0] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot Client Certificates check

## [15.4.9] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot Remote Debugging check

## [15.4.8] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot TLS values check

## [15.4.7] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot HTTPS Only check

## [15.4.6] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot HTTP Version check

## [15.4.5] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot FTP State check

## [15.4.4] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot Basic Auth check

## [15.4.3] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot PHP version check

## [15.4.2] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot Python version check

## [15.4.1] - 2026-03-16
### Changed
- Split azure directories into sub directories

## [15.4.0] - 2026-03-16
### Changed
- Split out Azure App Service Deployment Slot Java version check

## [15.3.9] - 2026-03-13
### Changed
- Split out Azure App Service Plan SKU check

## [15.3.8] - 2026-03-13
### Fixed
- Fixed Azure App Service Plan SKU check

## [15.3.7] - 2026-03-13
### Fixed
- Fixed Azure Private Endpoint check

## [15.3.6] - 2026-03-13
### Changed
- Split out Azure WebApps Private Endpoint check

## [15.3.5] - 2026-03-13
### Changed
- Split out Azure WebApps CORS check

## [15.3.4] - 2026-03-13
### Changed
- Split out Azure WebApps VNet checks

## [15.3.3] - 2026-03-13
### Changed
- Split out Azure WebApps Virtual Network Integration check

## [15.3.2] - 2026-03-13
### Changed
- Split out Azure WebApps Private DNS Zones check

## [15.3.1] - 2026-03-13
### Changed
- Split out Azure WebApps Public Network Access check

## [15.3.0] - 2026-03-13
### Changed
- Split out Azure WebApps Managed Identities check

## [15.2.9] - 2026-03-13
### Changed
- Split out Azure WebApps Authentication check

## [15.2.8] - 2026-03-13
### Changed
- Split out Azure WebApps Client Certificates check

## [15.2.7] - 2026-03-13
### Changed
- Split out Azure WebApps Remote Debugging check

## [15.2.6] - 2026-03-13
### Changed
- Split out Azure WebApps TLS values check

## [15.2.5] - 2026-03-13
### Changed
- Split out Azure WebApps HTTP values check

## [15.2.4] - 2026-03-13
### Fixed
- Fixed Azure WebApps Basic Authentication Publishing Credentials check

## [15.2.3] - 2026-03-13
### Changed
- Split out Azure WebApps Basic Authentication Publishing Credentials check

## [15.2.2] - 2026-03-13
### Changed
- Split out Azure WebApps FTP state check

## [15.2.1] - 2026-03-13
### Changed
- Split out Azure WebApps PHP version check

## [15.2.0] - 2026-03-13
### Changed
- Split out Azure WebApps Python version check

## [15.1.9] - 2026-03-13
### Changed
- Updated Azure WebApps value check

## [15.1.8] - 2026-03-13
### Changed
- Split out Azure WebApps Java version check

## [15.1.7] - 2026-03-12
### Changed
- Formatting fixes

## [15.1.6] - 2026-03-12
### Changed
- Shellcheck fixes

## [15.1.5] - 2026-03-12
### Changed
- Formatting fixes

## [15.1.4] - 2026-03-12
### Changed
- Typo fixes

## [15.1.3] - 2026-03-11
### Changed
- Formatting fixes

## [15.1.2] - 2026-03-11
### Changed
- Improved module listing

## [15.1.1] - 2026-03-10
### Changed
- Improved Azure CLI extension checking

## [15.1.0] - 2026-03-10
### Added
- Added switch value checking

## [15.0.9] - 2026-03-04
### Changed
- More formatting fixes

## [15.0.8] - 2026-03-02
### Changed
- Formatting fixes

## [15.0.7] - 2026-03-02
### Changed
- Formatting fixes

## [15.0.6] - 2026-02-28
### Changed
- Formatting fixes

## [15.0.5] - 2026-02-28
### Changed
- Updates and improvements

## [15.0.4] - 2026-02-28
### Added
- Added Azure Virtual Machines function

## [15.0.3] - 2026-02-28
### Added
- Added Azure Virtual Machines audit module

## [15.0.2] - 2026-02-27
### Changed
- Updates and improvements

## [15.0.1] - 2026-02-27
### Added
- Added Azure Batch check for public network access

## [15.0.0] - 2026-02-27
### Added
- Added Azure Batch check for private endpoints

## [14.9.9] - 2026-02-27
### Added
- Added Azure Batch check for local authentication methods

## [14.9.8] - 2026-02-27
### Added
- Added Azure Batch check for pool disk encryption

## [14.9.7] - 2026-02-27
### Added
- Added Azure Batch check for customer managed keys

## [14.9.6] - 2026-02-27
### Added
- Added Azure Batch function

## [14.9.5] - 2026-02-27
### Added
- Added Azure Batch audit module

## [14.9.4] - 2026-02-27
### Added
- Added Azure CycleCloud audit module

## [14.9.3] - 2026-02-27
### Added
- Added Azure Container Instances check for Managed Identity

## [14.9.2] - 2026-02-27
### Added
- Added Azure Container Instances check for Private Virtual Networks

## [14.9.1] - 2026-02-27
### Added
- Added Azure Container Instances function

## [14.9.0] - 2026-02-27
### Added
- Added Azure Container Instances audit module

## [14.8.9] - 2026-02-27
### Added
- Added Azure App Service ASE check for TLS cipher suite ordering configured

## [14.8.8] - 2026-02-27
### Added
- Added Azure App Service ASE check for TLS 1.0 and 1.1 disabled

## [14.8.7] - 2026-02-27
### Added
- Added Azure App Service ASE check for internal encryption

## [14.8.6] - 2026-02-27
### Added
- Added Azure App Service ASE check for ASE version

## [14.8.5] - 2026-02-27
### Added
- Added Azure App Service ASE check for internal load balancing mode

## [14.8.4] - 2026-02-27
### Added
- Added Azure App Service ASE function

## [14.8.3] - 2026-02-27
### Added
- Added Azure App Service ASE audit module

## [14.8.2] - 2026-02-27
### Changed
- Updates and improvements

## [14.8.1] - 2026-02-27
### Added
- Added Azure Key Vault Secrets audit module

## [14.8.0] - 2026-02-27
### Added
- Added Azure Key Vault Certificates audit module

## [14.7.9] - 2026-02-26
### Changed
- Updates and improvements

## [14.7.8] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for Cross-Origin Resource Sharing

## [14.7.7] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for VNet Content Share

## [14.7.6] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for VNet Image Pull

## [14.7.5] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for Virtual Network Integration

## [14.7.4] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for Public Network Access

## [14.7.3] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for Managed Identities

## [14.7.2] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for Authentication

## [14.7.1] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for Client Certificates

## [14.7.0] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for Remote Debugging

## [14.6.9] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for end to end TLS encryption

## [14.6.8] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for Minimum Inbound TLS Version

## [14.6.7] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for HTTPS only

## [14.6.6] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for HTTP version

## [14.6.5] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for FTP state

## [14.6.4] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for Basic Authentication Publishing Credentials

## [14.6.3] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for PHP version

## [14.6.2] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for Python version

## [14.6.1] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot check for Java version

## [14.6.0] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot function

## [14.5.9] - 2026-02-26
### Added
- Added Azure Function App Deployment Slot audit module

## [14.5.8] - 2026-02-26
### Changed
- Updates and improvements

## [14.5.7] - 2026-02-26
### Added
- Added Azure Function App check for Cross-Origin Resource Sharing

## [14.5.6] - 2026-02-26
### Added
- Added Azure Function App check for VNet Content Share

## [14.5.5] - 2026-02-26
### Added
- Added Azure Function App check for VNet Image Pull

## [14.5.4] - 2026-02-26
### Added
- Added Azure Function App check for Virtual Network Integration

## [14.5.3] - 2026-02-26
### Added
- Added Azure Function App check for Private DNS Zone

## [14.5.2] - 2026-02-26
### Added
- Added Azure Function App check for Private Endpoints

## [14.5.1] - 2026-02-26
### Added
- Added Azure Function App check for App Service Plan SKU

## [14.5.0] - 2026-02-26
### Added
- Added Azure Function App check for Public Network Access

## [14.4.9] - 2026-02-26
### Added
- Added Azure Function App check for Managed Identities

## [14.4.8] - 2026-02-26
### Added
- Added Azure Function App check for Authentication

## [14.4.7] - 2026-02-26
### Added
- Added Azure Function App check for Client Certificates

## [14.4.6] - 2026-02-26
### Added
- Added Azure Function App check for Remote Debugging

## [14.4.5] - 2026-02-26
### Added
- Added Azure Function App check for end to end TLS encryption

## [14.4.4] - 2026-02-26
### Added
- Added Azure Function App check for Minimum Inbound TLS Version

## [14.4.3] - 2026-02-26
### Added
- Added Azure Function App check for HTTPS only

## [14.4.2] - 2026-02-26
### Added
- Added Azure Function App check for HTTP version

## [14.4.1] - 2026-02-26
### Added
- Added Azure Function App check for FTP state

## [14.4.0] - 2026-02-26
### Added
- Added Azure Function App check for Basic Authentication Publishing Credentials

## [14.3.9] - 2026-02-26
### Added
- Added Azure Function App check for PHP version

## [14.3.8] - 2026-02-26
### Added
- Added Azure Function App check for Python version

## [14.3.7] - 2026-02-26
### Added
- Added Azure Function App check for Java version

## [14.3.6] - 2026-02-26
### Added
- Added Azure Function App function

## [14.3.5] - 2026-02-26
### Added
- Added Azure Function App module

## [14.3.4] - 2026-02-26
### Changed
- Updates and improvements

## [14.3.3] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot Cross-Origin Resource Sharing check

## [14.3.2] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot VNet Routing check

## [14.3.1] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot VNet check

## [14.3.0] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot Public Network Access check

## [14.2.9] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot Managed Identities check

## [14.2.9] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot Client Certificates check

## [14.2.9] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot Remote Debugging check

## [14.2.8] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot end to end TLS encryptions check

## [14.2.7] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot TLS version check

## [14.2.6] - 2026-02-26
### Added
- Added Azure App Service Deployment HTTPs check

## [14.2.5] - 2026-02-26
### Added
- Added Azure App Service Deployment HTTP version check

## [14.2.4] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot FTP state check

## [14.2.4] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot Basic Authentication Publishing Credentials

## [14.2.3] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot PHP version check

## [14.2.2] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot Python version check

## [14.2.1] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot Java version check

## [14.2.0] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot function

## [14.1.9] - 2026-02-26
### Added
- Added Azure App Service Deployment Slot audit module

## [14.1.8] - 2026-02-26
### Added
- Added Azure App Service App check for Cross-Origin Resource Sharing

## [14.1.7] - 2026-02-26
### Added
- Added Azure App Service App check for VNet Content Share

## [14.1.6] - 2026-02-26
### Added
- Added Azure App Service App check for VNet Image Pull

## [14.1.5] - 2026-02-26
### Added
- Added Azure App Service App check for Virtual Network Integration

## [14.1.4] - 2026-02-26
### Added
- Added Azure App Service App check for Private DNS Zone

## [14.1.3] - 2026-02-25
### Added
- Added Azure App Service App check for Private Endpoints

## [14.1.2] - 2026-02-25
### Added
- Added Azure App Service App check for App Service Plan SKU

## [14.1.1] - 2026-02-25
### Added
- Added Azure App Service App check for Public Network Access

## [14.1.0] - 2026-02-25
### Added
- Added Azure App Service App check for Managed Identities

## [14.0.9] - 2026-02-25
### Added
- Added Azure App Service App check for Authentication

## [14.0.8] - 2026-02-25
### Added
- Added Azure App Service App check for Client Certificates

## [14.0.7] - 2026-02-25
### Added
- Added Azure App Service App check for Remote Debugging

## [14.0.6] - 2026-02-25
### Added
- Added Azure App Service App check for end to end TLS encryption

## [14.0.5] - 2026-02-25
### Added
- Added Azure App Service App check for Minimum Inbound TLS Version

## [14.0.4] - 2026-02-25
### Added
- Added Azure App Service App check for HTTPS Only

## [14.0.3] - 2026-02-25
### Added
- Added Azure App Service App check for HTTP Version

## [14.0.2] - 2026-02-25
### Fixed
- Bug fixes

## [14.0.1] - 2026-02-25
### Added
- Added Azure App Service App check for FTP State

## [14.0.0] - 2026-02-25
### Added
- Added Azure App Service App check for Basic Authentication Publishing Credentials

## [13.9.9] - 2026-02-25
### Added
- Added Azure App Service App check for PHP

## [13.9.8] - 2026-02-25
### Added
- Added Azure App Service App check for Python

## [13.9.7] - 2026-02-25
### Changed
- Updates and improvements

## [13.9.6] - 2026-02-25
### Added
- Added Azure App Service App check for Java

## [13.9.5] - 2026-02-25
### Changed
- Formating updates

## [13.9.4] - 2026-02-25
### Added
- Added initial Azure App Service App function

## [13.9.3] - 2026-02-25
### Added
- Added initial Azure App Service App module

## [13.9.2] - 2026-02-24
### Changed
- Updates and improvements

## [13.9.1] - 2026-02-24
### Changed
- Updates and improvements

## [13.9.0] - 2026-02-24
### Added
- Added initial Azure SQL DB function

## [13.8.9] - 2026-02-24
### Added
- Added initial Azure SQL DB module

## [13.8.8] - 2026-02-24
### Changed
- Updates and improvements

## [13.8.7] - 2026-02-24
### Changed
- Add initial Azure PostgreSQL DB checks

## [13.8.6] - 2026-02-24
### Added
- Added initial support for Azure PostgreSQL Single Server

## [13.8.5] - 2026-02-24
### Added
- Added initial support for Azure PostgreSQL Flexible Server

## [13.8.4] - 2026-02-24
### Added
- Added initial Azure PostgreSQL DB module

## [13.8.3] - 2026-02-22
### Added
- Added check stub for Azure MySQL DB TLS Version

## [13.8.2] - 2026-02-22
### Added
- Added check stub for Azure MySQL DB Require Secure Transport

## [13.8.1] - 2026-02-22
### Added
- Added check stub for Azure MySQL DB Error Server Log File

## [13.8.0] - 2026-02-22
### Added
- Added check stub for Azure MySQL DB Audit Log connection

## [13.7.9] - 2026-02-22
### Added
- Added check stub for Azure MySQL DB Audit Log

## [13.7.8] - 2026-02-22
### Added
- Added check for Azure MySQL DB Private Endpoints

## [13.7.7] - 2026-02-22
### Added
- Added check for Azure MySQL DB Public Network Access

## [13.7.6] - 2026-02-22
### Changed
- Updates and improvements

## [13.7.5] - 2026-02-22
### Added
- Added check for Azure MySQL DB Microsoft Entra Authentication

## [13.7.4] - 2026-02-22
### Added
- Added check for Azure MySQL DB Customer-Managed Keys

## [13.7.3] - 2026-02-22
### Added
- Added support for Azure MySQL Single Server

## [13.7.2] - 2026-02-22
### Added
- Added support for Azure MySQL Flexible Server

## [13.7.1] - 2026-02-22
### Added
- Added initial Azure MySQL DB function

## [13.7.0] - 2026-02-22
### Added
- Added initial Azure MySQL DB module

## [13.6.9] - 2026-02-22
### Changed
- Updates and improvements

## [13.6.8] - 2026-02-22
### Added
- Added Azure Data Factory Using RBAC check

## [13.6.7] - 2026-02-21
### Added
- Added Azure Data Factory Using Azure Key Vault check

## [13.6.6] - 2026-02-21
### Added
- Added Azure Data Factory Managed Identities check

## [13.6.5] - 2026-02-21
### Added
- Added Azure Data Factory Customer-Managed Keys check

## [13.6.4] - 2026-02-21
### Added
- Added Azure Data Factory module check

## [13.6.3] - 2026-02-21
### Added
- Added Azure Cosmos DB Logging check

## [13.6.2] - 2026-02-20
### Added
- Added Azure Cosmos DB Firewalls & Networks IP Rules check

## [13.6.1] - 2026-02-20
### Added
- Added Azure Cosmos DB Customer-Managed Keys check

## [13.6.0] - 2026-02-20
### Changed
- Updates and improvements

## [13.5.9] - 2026-02-20
### Added
- Added Azure Cosmos DB Disable Local Auth check

## [13.5.8] - 2026-02-20
### Added
- Added Azure Cosmos DB Private Endpoints check

## [13.5.7] - 2026-02-20
### Added
- Added Azure Cosmos DB Firewalls & Networks check

## [13.5.6] - 2026-02-20
### Added
- Added Azure Redis Cache Update Channel check

## [13.5.5] - 2026-02-20
### Added
- Added Azure Redis Cache Access Keys Authentication check

## [13.5.4] - 2026-02-20
### Added
- Added Azure Redis Enterprise Cache Customer-Managed Keys check

## [13.5.3] - 2026-02-20
### Added
- Added Azure Redis Enterprise function

## [13.5.2] - 2026-02-20
### Added
- Added Azure redisenterprise extension check

## [13.5.1] - 2026-02-20
### Added
- Added Azure Redis Cache Private Link check

## [13.5.0] - 2026-02-20
### Added
- Added Azure Redis Cache Public Network Access check

## [13.4.9] - 2026-02-20
### Added
- Added Azure Redis Cache TLS check

## [13.4.8] - 2026-02-20
### Changed
- Updates and improvements

## [13.4.7] - 2026-02-20
### Added
- Added initial Redis Cache tests

## [13.4.6] - 2026-02-19
### Changed
- Updates and improvements

## [13.4.5] - 2026-02-19
### Added
- Added Azure Storage Account Read-only Locks check

## [13.4.4] - 2026-02-19
### Added
- Added Azure Storage Account Delete Locks check

## [13.4.3] - 2026-02-19
### Changed
- Updates and improvements

## [13.4.2] - 2026-02-19
### Added
- Added Azure Storage Logging check for tables

## [13.4.1] - 2026-02-18
### Added
- Added Azure Storage Logging check for blobs

## [13.4.0] - 2026-02-18
### Added
- Added Azure Storage Logging check for queues

## [13.3.9] - 2026-02-18
### Changed
- Updates and improvements

## [13.3.8] - 2026-02-18
### Added
- Added Azure Storage Blob Policy Value check

## [13.3.7] - 2026-02-18
### Changed
- Updates and improvements

## [13.3.6] - 2026-02-18
### Changed
- Updates and improvements

## [13.3.5] - 2026-02-18
### Added
- Added Azure Databox check

## [13.3.4] - 2026-02-18
### Added
- Added Azure Databox extension check

## [13.3.3] - 2026-02-17
### Changed
- Improved Arch Linux support

## [13.3.2] - 2026-02-17
### Added
- Added additional Azure Elastic SAN checks

## [13.3.1] - 2026-02-17
### Changed
- Updates and improvements

## [13.3.0] - 2026-02-17
### Added
- Added Azure NetApp Files check

## [13.2.9] - 2026-02-17
### Changed
- Updates and improvements

## [13.2.8] - 2026-02-17
### Added
- Added Azure File Shares check for NFS Root Squash

## [13.2.7] - 2026-02-17
### Changed
- Updated Azure Recovery Services Vault check

## [13.2.6] - 2026-02-16
### Changed
- Updates and improvements

## [13.2.5] - 2026-02-16
### Added
- Added Azure Recovery Services Vault check

## [13.2.4] - 2026-02-16
### Added
- Added additional checks to Azure Backup Vaults check

## [13.2.3] - 2026-02-16
### Changed
- Updates and improvements

## [13.2.2] - 2026-02-16
### Added
- Added additional checks to Azure Backup Vaults check

## [13.2.1] - 2026-02-16
### Added
- Added additional checks to Azure Backup Vaults check

## [13.2.0] - 2026-02-16
### Added
- Added Azure Backup Vaults check

## [13.1.9] - 2026-02-16
### Added
- Added Azure allow no subscriptions support

## [13.1.8] - 2026-02-16
### Added
- Added Azure tenant ID support

## [13.1.7] - 2026-02-16
### Changed
- Applied shellcheck recommendations to several modules

## [13.1.6] - 2026-02-16
### Changed
- Applied shellcheck recommendations to azure modules

## [13.1.5] - 2026-02-16
### Changed
- Updates and improvements

## [13.1.4] - 2026-02-16
### Changed
- Applied shellcheck recommendation to azure functions

## [13.1.3] - 2026-02-16
### Fixed
- Fixed check_shellcheck to use find instead of ls

## [13.1.2] - 2026-02-16
### Changed
- Updates and Improvements

## [13.1.1] - 2026-02-14
### Added
- Added initial code for Azure Data Protection Backup Vault check

## [13.1.0] - 2026-02-14
### Added
- Added Azure dataprotection extension check

## [13.0.9] - 2026-02-14
### Added
- Added Azure Storage File System check

## [13.0.8] - 2026-02-14
### Added
- Added Azure Managed Lustre check

## [13.0.7] - 2026-02-13
### Added
- Added Azure amlfs extension check

## [13.0.6] - 2026-02-13
### Added
- Added Azure Network Private Endpoints check

## [13.0.5] - 2026-02-13
### Added
- Added Azure Virtual Network Access Rules check

## [13.0.4] - 2026-02-13
### Added
- Added Azure Recovery Service Vaults check

## [13.0.3] - 2026-02-13
### Added
- Added Azure Site Recovery module check

## [13.0.2] - 2026-02-12
### Added
- Added Azure Elastic SAN check

## [13.0.1] - 2026-02-12
### Added
- Added execute_command function

## [13.0.0] - 2026-02-12
### Changed
- Updated and improvements

## [12.9.9] - 2026-02-12
### Added
- Added Azure Elastic SAN module check

## [12.9.8] - 2026-02-12
### Changed
- Updated and improvements

## [12.9.7] - 2026-02-10
### Changed
- Updates and improvements

## [12.9.6] - 2026-02-10
### Added
- Added Azure Storage SAS token expiration check stub

## [12.9.5] - 2026-02-10
### Added
- Added Azure Storage SAS HTTPS Only check

## [12.9.4] - 2026-02-10
### Added
- Added Azure Storage SAS check

## [12.9.3] - 2026-02-10
### Changed
- Replaced regex with case statement in several functions

## [12.9.2] - 2026-02-08
### Added
- Added Azure Network Security Perimeter check

## [12.9.1] - 2026-02-08
### Added
- Added Azure Network Security Perimeter module check

## [12.9.0] - 2026-02-08
### Added
- Added Azure WAF Inspection Policy check

## [12.8.9] - 2026-02-07
### Added
- Added Azure WAF Request Body check

## [12.8.8] - 2026-02-07
### Added
- Added Azure WAF HTTP2 check

## [12.8.7] - 2026-02-07
### Added
- Added Azure WAF SSL Policy check

## [12.8.6] - 2026-02-06
### Added
- Added Azure VNet check

## [12.8.5] - 2026-02-06
### Added
- Added Azure WAF check

## [12.8.4] - 2026-02-06
### Added
- Added Azure Authentication Type check stub

## [12.8.3] - 2026-02-06
### Changed
- Updated Azure Network Watcher Flow Logs check

## [12.8.2] - 2026-02-06
### Added
- Added Azure Network Watcher Flow Logs check

## [12.8.1] - 2026-02-06
### Added
- Added Azure Public IPs check

## [12.8.0] - 2026-02-06
### Changed
- Documentation updates

## [12.7.9] - 2026-02-06
### Added
- Added Azure Network Watcher check

## [12.7.8] - 2026-02-06
### Changed
- Updated documentation for Azure NSG Security Rules check

## [12.7.7] - 2026-02-06
### Added
- Added Azure NSG Security Rules check for HTTP(S)

## [12.7.6] - 2026-02-05
### Added
- Added Azure NSG Security Rules check for UDP access

## [12.7.5] - 2026-02-05
### Changed
- Improved Azure NSG Security Rules check

## [12.7.4] - 2026-02-05
### Added
- Added Azure NSG Security Rules check for RDP and SSH access

## [12.7.3] - 2026-02-04
### Fixed
- Bug fixes and improvements

## [12.7.2] - 2026-02-04
### Added
- Added command_message support to modules in fs directory

## [12.7.1] - 2026-02-04
### Added
- Added command_message support to modules in firewall directory

## [12.7.0] - 2026-02-04
### Added
- Added command_message support to modules in esxi directory

## [12.6.9] - 2026-02-04
### Added
- Added command_message support to modules in audit directory

## [12.6.8] - 2026-02-04
### Changed
- Updates and bug fixes for AWS modules

## [12.6.7] - 2026-02-03
### Changed
- Updates and bug fixes

## [12.6.6] - 2026-02-03
### Changed
- Typo fixes

## [12.6.5] - 2026-02-03
### Changed
- Improved user account check for shells

## [12.6.4] - 2026-02-03
### Changed
- Updated more modules to use command_message

## [12.6.3] - 2026-02-03
### Changed
- Updated audit_system_accounts.sh to allow single ! in shadow field

## [12.6.2] - 2026-02-03
### Changed
- Update some more functions to use command_message

## [12.6.1] - 2026-02-03
### Fixed
- Fixed typo in audit_wireless.sh

## [12.6.0] - 2026-02-03
### Changed
- Improved output for modules in other directories

## [12.5.9] - 2026-02-02
### Changed
- Improved output for modules in fs directory

## [12.5.8] - 2026-02-02
### Changed
- Improved output for some checks

## [12.5.7] - 2026-02-02
### Fixed
- Fixed typo

## [12.5.6] - 2026-02-02
### Changed
- Commit some of the command_message changes

## [12.5.5] - 2026-02-02
### Added
- Added command_message support to modules in linux directory

## [12.5.4] - 2026-02-02
### Added
- Added command_message support to modules in login directory

## [12.5.3] - 2026-02-02
### Added
- Added command_message support to modules in logs directory

## [12.5.2] - 2026-02-02
### Added
- Added command_message support to modules in mail directory

## [12.5.1] - 2026-02-02
### Added
- Added command_message support to modules in mounts directory

## [12.5.0] - 2026-02-02
### Added
- Added command_message support to modules in nis directory

## [12.4.9] - 2026-02-02
### Added
- Added command_message support to modules in pam directory

## [12.4.8] - 2026-02-02
### Added
- Added command_message support to modules in password directory

## [12.4.7] - 2026-02-01
### Added
- Added command_message support to modules in power directory

## [12.4.6] - 2026-02-01
### Added
- Added command_message support to modules in print directory

## [12.4.5] - 2026-02-01
### Added
- Added command_message support to modules in remote directory

## [12.4.4] - 2026-02-01
### Added
- Added command_message support to modules in services directory

## [12.4.3] - 2026-02-01
### Added
- Added command_message support to modules in ssh directory

## [12.4.2] - 2026-02-01
### Added
- Added command_message support to modules in telnet directory

## [12.4.1] - 2026-02-01
### Added
- Added command_message support to modules in tcp directory

## [12.4.0] - 2026-02-01
### Added
- Added command_message support to modules in talk directory

## [12.3.9] - 2026-02-01
### Added
- Added command_message support to modules in syslog directory

## [12.3.8] - 2026-02-01
### Added
- Added command_message support to modules in sunos directory

## [12.3.7] - 2026-02-01
### Added
- Added command_message support to modules in sudo directory

## [12.3.6] - 2026-02-01
### Added
- Added command_message support to modules in wheel directory

## [12.3.5] - 2026-02-01
### Added
- Added command_message support to modules in users directory

## [12.3.4] - 2026-01-31
### Added
- Added command_message support to check_environment

## [12.3.3] - 2026-01-31
### Added
- Added command_message support to more Azure modules/functions

## [12.3.2] - 2026-01-31
### Changed
- Updated Azure Key Vault logging check

## [12.3.1] - 2026-01-31
### Changed
- Updated Azure Key Vault check

## [12.3.0] - 2026-01-31
### Changed
- Updated Azure Activity Log Alerts check

## [12.2.9] - 2026-01-30
### Changed
- Updated Azure Monitor Diagnostic Settings check

## [12.2.8] - 2026-01-30
### Added
- Added Azure login check

## [12.2.7] - 2026-01-30
### Changed
- Improved environment checking

## [12.2.6] - 2026-01-30
### Changed
- Cleaned up some Azure storage checks

## [12.2.5] - 2026-01-30
### Changed
- Cleaned up Azure User Access Administrator Role check

## [12.2.4] - 2026-01-30
### Fixed
- Fixed Azure Application Insights check

## [12.2.3] - 2026-01-30
### Changed
- Updated documentation

## [12.2.2] - 2026-01-30
### Added
- Started adding command_message function support

## [12.2.1] - 2026-01-30
### Fixed
- Fixed Azure Databricks check

## [12.2.0] - 2026-01-30
### Added
- Added key vault check for key rotation

## [12.1.9] - 2026-01-30
### Added
- Added command_message function

## [12.1.8] - 2026-01-29
### Added
- Added Azure Key Vault Private Endpoint check

## [12.1.7] - 2026-01-29
### Added
- Added Azure Key Vault Public Network Access check

## [12.1.6] - 2026-01-29
### Changed
- Function variable alignment for azure checks

## [12.1.5] - 2026-01-29
### Added
- Added Azure Key Vault RBAC check

## [12.1.4] - 2026-01-29
### Added
- Added Azure Key Vault Purge Protection check

## [12.1.3] - 2026-01-29
### Changed
- Updated checks for Azure Key Vault keys

## [12.1.2] - 2026-01-29
### Changed
- Updated output for checks to be more consistent

## [12.1.1] - 2026-01-29
### Added
- Added Azure Key Vault check for key expiry date

## [12.1.0] - 2026-01-29
### Added
- Added Azure Key Vault check for key enabled status

## [12.0.9] - 2026-01-28
### Changed
- Improved Microsoft Defender check

## [12.0.8] - 2026-01-28
### Added
- Added Azure Security Contact check for alert notifications severity

## [12.0.7] - 2026-01-28
### Changed
- Updated documentation

## [12.0.6] - 2026-01-28
### Added
- Added Azure Security Contact check for alert notifications

## [12.0.5] - 2026-01-28
### Added
- Added Azure Security Contact check for email address

## [12.0.4] - 2026-01-28
### Added
- Added Azure Security Contact check

## [12.0.3] - 2026-01-28
### Added
- Added check for Microsoft Defender for Resource Manager

## [12.0.2] - 2026-01-27
### Added
- Added check for Microsoft Defender for Azure Key Vault

## [12.0.1] - 2026-01-27
### Added
- Added check for Microsoft Defender for SQL Servers on Machines

## [12.0.0] - 2026-01-27
### Added
- Added check for Microsoft Defender for SQL Server

## [11.9.9] - 2026-01-27
### Changed
- Updated documentation

## [11.9.8] - 2026-01-27
### Added
- Added check for Microsoft Defender for Open-Source RDBMS

## [11.9.7] - 2026-01-27
### Added
- Added check for Microsoft Defender for Azure Cosmos DB

## [11.9.6] - 2026-01-27
### Added
- Added check for Microsoft Defender for App Services

## [11.9.5] - 2026-01-27
### Added
- Added check for Microsoft Defender for Storage

## [11.9.4] - 2026-01-27
### Added
- Added check for Microsoft Defender for Containers

## [11.9.3] - 2026-01-27
### Added
- Added check that agentless scanning is enabled

## [11.9.2] - 2026-01-27
### Added
- Added check that enpoint protection is enabled

## [11.9.1] - 2026-01-27
### Added
- Added error handling to systemctl commands

## [11.9.0] - 2026-01-27
### Changed
- Typo fixes

## [11.8.9] - 2026-01-27
### Changed
- Code cleanup

## [11.8.8] - 2026-01-27
### Added
- Added function to check Azure security setting values

## [11.8.7] - 2026-01-27
### Added
- Added Azure Microsoft Defender check for Defender for Servers

## [11.8.6] - 2026-01-27
### Added
- Added status check to Microsoft Defender check

## [11.8.5] - 2026-01-27
### Added
- Added Azure Microsoft Defender check for CWP

## [11.8.4] - 2026-01-27
### Added
- Added Azure Microsoft Defender check for CSPM

## [11.8.3] - 2026-01-27
### Changed
- Updated documentation

## [11.8.2] - 2026-01-27
### Added
- Added Azure Extensions check

## [11.8.1] - 2026-01-27
### Changed
- Updated documentation

## [11.8.0] - 2026-01-27
### Added
- Added Azure SKU Basic/Consumption check

## [11.7.9] - 2026-01-27
### Added
- Added Azure Resource Logging check

## [11.7.8] - 2026-01-27
### Added
- Added Azure Application Insights check

## [11.7.7] - 2026-01-27
### Added
- Added Azure Activity Log Alerts Service Health check

## [11.7.6] - 2026-01-27
### Added
- Added Azure Activity Log Alerts Delete Public IP Address rule check

## [11.7.5] - 2026-01-27
### Added
- Added Azure Activity Log Alerts Create or Update Public IP Address rule check

## [11.7.4] - 2026-01-27
### Added
- Added Azure Activity Log Alerts Delete SQL Server Firewall Rule check

## [11.7.3] - 2026-01-27
### Added
- Added Azure Activity Log Alerts Create or Update SQL Server Firewall Rule check

## [11.7.2] - 2026-01-27
### Added
- Added Azure Activity Log Alerts Delete Security Solution check

## [11.7.1] - 2026-01-27
### Added
- Added Azure Activity Log Alerts Create or Update Security Solution check

## [11.7.0] - 2026-01-27
### Added
- Added Azure Activity Log Alerts Delete Network Security Group check

## [11.6.9] - 2026-01-26
### Added
- Added Azure Activity Log Alerts Create or Update Network Security Group check

## [11.6.8] - 2026-01-26
### Added
- Added Azure Activity Log Alerts Delete Policy Assignment check

## [11.6.7] - 2026-01-26
### Added
- Added Azure Activity Log Alerts Create Policy Assignment check

## [11.6.6] - 2026-01-26
### Added
- Added stub for Azure Intune Logs check

## [11.6.5] - 2026-01-26
### Added
- Added stub for Azure Graph Diagnostic Settings check

## [11.6.4] - 2026-01-26
### Added
- Added stub for Azure Entra Diagnostic Settings check

## [11.6.3] - 2026-01-26
### Added
- Added stub for Azure Virtual Network Flow Logs check

## [11.6.2] - 2026-01-26
### Changed
- Documentation and formatting updates

## [11.6.1] - 2026-01-26
### Added
- Added stub for Azure AppService HTTP logs check

## [11.6.0] - 2026-01-26
### Added
- Added stub for Azure NSG Flow Logs check

## [11.5.9] - 2026-01-26
### Added
- Added Azure Key Vault Logging check

## [11.5.8] - 2026-01-26
### Changed
- Split out Azure Diagnostic Settings checks into multiple routines

## [11.5.7] - 2026-01-25
### Added
- Added Azure Survey check

## [11.5.6] - 2026-01-25
### Added
- Added check to ensure Diagnostic Logs are encrypted

## [11.5.5] - 2026-01-25
### Added
- Added check to ensure Diagnostic Setting captures appropriate categories

## [11.5.4] - 2026-01-25
### Added
- Added Azure Subscription Diagnostic Settings check

## [11.5.3] - 2026-01-25
### Added
- Added Azure Subscription Owners check

## [11.5.2] - 2026-01-25
### Added
- Added Azure Custom Subscription Admin Roles check

## [11.5.1] - 2026-01-25
### Added
- Added Azure User Access Administrator Role check

## [11.5.0] - 2026-01-24
### Added
- Added Azure Guest Users check

## [11.4.9] - 2026-01-24
### Added
- Added Azure Storage Services check stub

## [11.4.8] - 2026-01-24
### Added
- Added Azure Security Services check stub

## [11.4.7] - 2026-01-24
### Added
- Added Azure Networking Services check stub

## [11.4.6] - 2026-01-24
### Added
- Added Azure Logging and Monitoring check stub

## [11.4.5] - 2026-01-24
### Added
- Added Azure Identity Services check stub

## [11.4.4] - 2026-01-24
### Added
- Added Azure Database Services check stub

## [11.4.3] - 2026-01-24
### Added
- Added Azure Compute Services check stub

## [11.4.2] - 2026-01-24
### Added
- Added Azure Databricks Private Endpoints check

## [11.4.1] - 2026-01-24
### Added
- Added Azure Databricks Private Link check

## [11.4.0] - 2026-01-24
### Added
- Added Azure Databricks No Public IP check

## [11.3.9] - 2026-01-24
### Added
- Added Azure Databricks TBD check list

## [11.3.8] - 2026-01-24
### Added
- Added Azure Monitor check routine

## [11.3.7] - 2026-01-24
### Added
- Added Azure Databricks check routine

## [11.3.6] - 2026-01-23
### Added
- Added Azure CLI extension checks

## [11.3.5] - 2026-01-23
### Added
- Added check for Azure File Shares SMB Channel Encryption

## [11.3.4] - 2026-01-23
### Added
- Added check for Azure File Shares SMB Protocol Version

## [11.3.3] - 2026-01-23
### Added
- Added check for Azure File Shares Days Retained

## [11.3.2] - 2026-01-23
### Added
- Added check for Azure File Shares Soft Delete

## [11.3.1] - 2026-01-23
### Added
- Added check of Azure File Shares

## [11.2.9] - 2026-01-23
### Added
- Added check for Azure Storage Container Versioning

## [11.2.8] - 2026-01-23
### Added
- Added check for Azure Storage Container Days Retained

## [11.2.7] - 2026-01-23
### Added
- Added check for Azure Storage Container Soft Delete

## [11.2.6] - 2026-01-23
### Added
- Added check_azure_storage_container_value function

## [11.2.5] - 2026-01-23
### Added
- Added Azure auth mode

## [11.2.4] - 2026-01-23
### Added
- Added check for Azure Storage Blob Days Retained

## [11.2.3] - 2026-01-23
### Added
- Added check for Azure Storage Blob Soft Delete

## [11.2.2] - 2026-01-23
### Added
- Added check_azure_storage_blob_value function

## [11.2.1] - 2026-01-23
### Fixed
- Bug fixes and improvements

## [11.2.0] - 2026-01-23
### Added
- Added Azure Storage Accounts Redundancy check

## [11.1.9] - 2026-01-23
### Added
- Added Azure Resource Manager ReadOnly locks check for Storage Accounts

## [11.1.8] - 2026-01-23
### Added
- Added Azure Resource Manager Delete locks check for Storage Accounts

## [11.1.7] - 2026-01-23
### Added
- Added check_azure_resource_manager_locks function

## [11.1.6] - 2026-01-22
### Added
- Added Minimum TLS version check for Storage Accounts

## [11.1.5] - 2026-01-22
### Added
- Added check to verify Allow blob public access for Storage Accounts

## [11.1.4] - 2026-01-22
### Added
- Added check to verify Cross Tenant Replication for Storage Accounts

## [11.1.3] - 2026-01-22
### Added
- Added check to verify Secure transfer required for Storage Accounts

## [11.1.2] - 2026-01-22
### Added
- Added check to verify Azure services on the trusted services list for Storage Accounts

## [11.1.1] - 2026-01-22
### Changed
- Improved check_azure_storage_account_value function

## [11.1.0] - 2026-01-22
### Added
- Added check to verify Microsoft Entra authorization for Storage Accounts

## [11.0.9] - 2026-01-22
### Added
- Added generic check_azure_storage_account_value function

## [11.0.8] - 2026-01-22
### Added
- Added check to verify default network access rule for Storage Accounts

## [11.0.7] - 2026-01-22
### Added
- Added fix commands for some Storage Accounts tests

## [11.0.6] - 2026-01-22
### Added
- Added Public Network Access check for Storage Accounts

## [11.0.5] - 2026-01-22
### Added
- Added Private Endpoint check for Storage Accounts

## [11.0.4] - 2026-01-22
### Added
- Added command_message routine

## [11.0.3] - 2026-01-22
### Added
- Added Azure Storage Accounts Key Regeneration check

## [11.0.2] - 2026-01-22
### Fixed
- Fixed Azure Storage Accounts Key Expiration check

## [11.0.1] - 2026-01-21
### Added
- Added Azure Storage Accounts Key Expiration check

## [11.0.0] - 2026-01-21
### Added
- Added Azure Storage Accounts audit stub

## [10.9.9] - 2026-01-19
### Added
- Added initial Azure stub

## [10.9.8] - 2026-01-15
### Fixed
- Fixed typo

## [10.9.7] - 2026-01-15
### Added
- Added initial CSV output

## [10.9.6] - 2026-01-15
### Added
- Added hostname and domainname to OS info

## [10.9.5] - 2026-01-15
### Added
- Added output file and format options for future improvements

## [10.9.4] - 2026-01-15
### Changed
- Improved virtual check

## [10.9.3] - 2026-01-15
### Fixed
- Fixed OS version check in aide check

## [10.9.2] - 2026-01-15
### Changed
- Updated Ubuntu codenames

## [10.9.1] - 2025-05-31
### Changed
- Updated documentation

## [10.9.0] - 2025-05-31
### Changed
- More shellcheck recommendations

## [10.8.9] - 2025-05-31
### Fixed
- Fixes based on POSIX sh recommendations from shellcheck

## [10.8.8] - 2025-05-31
### Fixed
- Fixed bug with module_name being recast

## [10.8.7] - 2025-05-31
### Changed
- Improved check_file_value routine

## [10.8.6] - 2025-05-31
### Changed
- Stopped check_environment running multiple times

## [10.8.5] - 2025-05-31
### Fixed
- Fixed check_file_value routine logging

## [10.8.4] - 2025-05-30
### Changed
- Cleaned up some variable names

## [10.8.3] - 2025-05-30
### Changed
- Improved report

## [10.8.2] - 2025-05-30
### Changed
- More improvements

## [10.8.1] - 2025-05-30
### Changed
- Improved restore function

## [10.8.0] - 2025-05-30
### Changed
- Sudo improvements

## [10.7.9] - 2025-05-29
### Changed
- Output improvements

## [10.7.8] - 2025-05-29
### Added
- Added lockdown/restore counting

## [10.7.7] - 2025-05-29
### Changed
- Improved listing of backups

## [10.7.6] - 2025-05-29
### Fixed
- Fixed lockdown check

## [10.7.5] - 2025-05-29
### Added
- Added dryrun switch

## [10.7.4] - 2025-05-29
### Added
- Added lockdown check

## [10.7.3] - 2025-05-29
### Changed
- Improved print_audit_info routine

## [10.7.2] - 2025-05-19
### Fixed
- Fixed typos

## [10.7.1] - 2025-05-19
### Added
- Added function to print module and function names

## [10.7.0] - 2025-05-18
### Changed
- Updated formating of some tests

## [10.6.9] - 2025-05-15
### Changed
- Updated formating of some tests

## [10.6.8] - 2025-05-15
### Changed
- Updated xlogin test and some other tests

## [10.6.7] - 2025-05-15
### Changed
- Cleaned up some variable names

## [10.6.6] - 2025-05-15
### Added
- Added sudo check to some tests

## [10.6.5] - 2025-05-12
### Changed
- Updated lockdown and restore commands in some modules

## [10.6.4] - 2025-05-12
### Changed
- Updated lockdown and restore commands in some modules

## [10.6.3] - 2025-05-12
### Changed
- Updated lockdown and restore commands in some modules

## [10.6.2] - 2025-05-12
### Changed
- Updated lockdown and restore commands in functions

## [10.6.1] - 2025-05-09
### Fixed
- Fixed dot files test

## [10.6.0] - 2025-05-09
### Changed
- Updated AppArmor test

## [10.5.9] - 2025-05-08
### Changed
- Updated some ansible stanzas

## [10.5.8] - 2025-05-07
### Changed
- Updated Solaris audit class check

## [10.5.7] - 2025-05-07
### Changed
- Updated touch ID test

## [10.5.6] - 2025-05-05
### Added
- Added file comment function and updated ansible in some tests

## [10.5.5] - 2025-05-04
### Added
- Added ansible output for some tests

## [10.5.4] - 2025-05-03
### Changed
- Shellcheck fixes

## [10.5.3] - 2025-05-03
### Changed
- Moved shellcheck function to core

## [10.5.2] - 2025-05-03
### Changed
- More formatting cleanup

## [10.5.1] - 2025-05-02
### Changed
- Formatting cleanup

## [10.5.0] - 2025-05-02
### Added
- Added SSH permissions test

## [10.4.9] - 2025-05-02
### Changed
- Updated SSH config tests

## [10.4.8] - 2025-05-02
### Changed
- Updated sudo tests

## [10.4.7] - 2025-05-02
### Added
- Added sudo NOPASSWD test

## [10.4.6] - 2025-05-02
### Added
- Added sudo authenticate test

## [10.4.5] - 2025-05-01
### Changed
- Documentation and test updates

## [10.4.4] - 2025-05-01
### Changed
- Updated password quality documentation and tests

## [10.4.3] - 2025-05-01
### Changed
- Updated tests and documentation

## [10.4.2] - 2025-05-01
### Changed
- Updated tests and documentation

## [10.4.1] - 2025-05-01
### Changed
- Updated tests and documentation and add ftp client package test

## [10.4.0] - 2025-05-01
### Changed
- Updated java test

## [10.3.9] - 2025-05-01
### Changed
- Renamed chkconfig test to make it more generic and updated documentation

## [10.3.8] - 2025-05-01
### Changed
- Updated tests and documentation

## [10.3.7] - 2025-05-01
### Changed
- Updated documentation and password quality tests

## [10.3.6] - 2025-04-30
### Changed
- Cleaned up PAM tests and added authtok test

## [10.3.5] - 2025-04-30
### Added
- Started adding addition pam checks

## [10.3.4] - 2025-04-29
### Changed
- Updated documentation

## [10.3.3] - 2025-04-29
### Added
- Added inactive password lock test

## [10.3.2] - 2025-04-29
### Added
- Added password history test

## [10.3.1] - 2025-04-29
### Added
- Added non root GID 0 test

## [10.3.0] - 2025-04-29
### Added
- Added non root UID 0 test

## [10.2.9] - 2025-04-29
### Added
- Added root access test

## [10.2.8] - 2025-04-29
### Changed
- Updated documentation

## [10.2.7] - 2025-04-29
### Changed
- Updated shell check

## [10.2.6] - 2025-04-29
### Added
- Added shell timeout check

## [10.2.5] - 2025-04-29
### Changed
- Updated journald test

## [10.2.4] - 2025-04-29
### Changed
- Updated rsyslog log rotate test

## [10.2.3] - 2025-04-29
### Changed
- Updated audit tests and documentation

## [10.2.2] - 2025-04-28
### Changed
- Broke out functions from main script

## [10.2.1] - 2025-04-27
### Changed
- Updated documentation and gdm test

## [10.2.0] - 2025-04-27
### Changed
- Updated virtual memory test and added ptrace test

## [10.1.9] - 2025-04-27
### Changed
- Updated documentation

## [10.1.8] - 2025-04-27
### Changed
- Updated AppArmor test

## [10.1.7] - 2025-04-27
### Changed
- Updated filesystem checks

## [10.1.6] - 2025-04-27
### Changed
- Updated modprobe filesystem kernel modules check

## [10.1.5] - 2025-04-27
### Changed
- Documentation updates

## [10.1.4] - 2025-04-27
### Fixed
- Fixed keychain sync check

## [10.1.3] - 2025-04-26
### Fixed
- Fixes recommended by Shellcheck

## [10.1.2] - 2025-04-26
### Changed
- Updated switch processing

## [10.1.1] - 2025-04-26
### Changed
- More code cleanup

## [10.1.0] - 2025-04-25
### Changed
- Updated help routine

## [10.0.9] - 2025-04-25
### Changed
- Code cleanup

## [10.0.8] - 2024-07-22
### Fixed
- Fix for old users check

## [10.0.7] - 2024-07-22
### Fixed
- Fix for systemctl check

## [10.0.6] - 2024-07-22
### Fixed
- Bug fixes

## [10.0.5] - 2024-07-15
### Changed
- Updated output

## [10.0.4] - 2024-07-14
### Changed
- Improved select function/module handling

## [10.0.3] - 2024-07-14
### Removed
- Removed check_rpm function

## [10.0.2] - 2024-07-14
### Changed
- More improvements to gsettings check

## [10.0.1] - 2024-07-14
### Changed
- Improved gsettings check

## [10.0.0] - 2024-07-14
### Removed
- Removed may need to be run as root warning for help and version switches

## [9.9.9] - 2024-07-14
### Changed
- Improved systemctl check

## [9.9.8] - 2024-07-14
### Added
- Added select switch to select

## [9.9.7] - 2024-07-14
### Added
- Added debug switch to multipass

## [9.9.6] - 2024-07-14
### Fixed
- Fixed multipass VM check

## [9.9.5] - 2024-07-13
### Changed
- Updated documentation

## [9.9.4] - 2024-07-13
### Fixed
- Fixed safari warning check

## [9.9.3] - 2024-07-13
### Fixed
- Fixed safari history check

## [9.9.2] - 2024-07-13
### Fixed
- Fixed APFS check

## [9.9.1] - 2024-07-13
### Fixed
- Fixed touch ID check

## [9.9.0] - 2024-07-13
### Fixed
- Fixed application permissions check

## [9.8.9] - 2024-07-13
### Fixed
- Fixed keychain lock check

## [9.8.8] - 2024-07-13
### Fixed
- Fixed safe downloads check

## [9.8.7] - 2024-07-13
### Fixed
- Fixed remote management check

## [9.8.6] - 2024-07-13
### Fixed
- Fixed dscl check

## [9.8.5] - 2024-07-13
### Changed
- Improved MacOS defaults check

## [9.8.4] - 2024-07-13
### Fixed
- Fixed pmset check

## [9.8.3] - 2024-07-13
### Changed
- More firewall setting check fixes

## [9.8.2] - 2024-07-13
### Fixed
- Fixed firewall setting check

## [9.8.1] - 2024-07-13
### Fixed
- Fixed file sharing check

## [9.8.0] - 2024-07-13
### Fixed
- Fixes for MacOS defaults checks

## [9.7.9] - 2024-07-13
### Changed
- More fixes for MacOS

## [9.7.8] - 2024-07-13
### Fixed
- Fixes for MacOS

## [9.7.7] - 2024-07-13
### Fixed
- Fixed ntp check

## [9.7.6] - 2024-07-13
### Fixed
- Fixed kernel accounting check

## [9.7.5] - 2024-07-13
### Fixed
- Fixed password strength test

## [9.7.4] - 2024-07-13
### Fixed
- Fixed SSH sandbox check

## [9.7.3] - 2024-07-13
### Fixed
- Fixed dmidecode check

## [9.7.2] - 2024-07-13
### Fixed
- Fixed version detection on MacOS

## [9.7.1] - 2024-07-13
### Changed
- Documentation updates

## [9.7.0] - 2024-07-13
### Fixed
- Fixed SPARC hardware check

## [9.6.9] - 2024-07-13
### Fixed
- Fixed apport check

## [9.6.8] - 2024-07-13
### Fixed
- Fixed dhcp server test

## [9.6.7] - 2024-07-13
### Fixed
- Fixed chrony check

## [9.6.6] - 2024-07-13
### Fixed
- Fixed SNMP test

## [9.6.5] - 2024-07-13
### Fixed
- Fixed syslog server check

## [9.6.4] - 2024-07-13
### Fixed
- Fixed filesystem mount check

## [9.6.3] - 2024-07-13
### Fixed
- Fixed NFS check

## [9.6.2] - 2024-07-13
### Fixed
- Fixed mount setuid check

## [9.6.1] - 2024-07-13
### Fixed
- Fixed avahi daemon check

## [9.6.0] - 2024-07-13
### Fixed
- Fixed NIS entries check

## [9.5.9] - 2024-07-13
### Fixed
- Fixed krb5 check

## [9.5.8] - 2024-07-13
### Fixed
- Fixed gnome banner check

## [9.5.7] - 2024-07-13
### Fixed
- Fixed xlogin check

## [9.5.6] - 2024-07-13
### Fixed
- Fixed shadow group check

## [9.5.5] - 2024-07-13
### Fixed
- Fixed cron check and added anacron switch

## [9.5.4] - 2024-07-13
### Fixed
- Fixed old users check

## [9.5.3] - 2024-07-13
### Fixed
- Fixed file permissions check

## [9.5.2] - 2024-07-13
### Added
- Added wheel group and password hashing switches

## [9.5.1] - 2024-07-13
### Fixed
- Fixed wheel group check

## [9.5.0] - 2024-07-13
### Fixed
- Fixed daemon umask check

## [9.4.9] - 2024-07-13
### Fixed
- Fixed reserved ID check

## [9.4.8] - 2024-07-13
### Fixed
- Fixed password fields check

## [9.4.7] - 2024-07-13
### Fixed
- Fixed user dot files check

## [9.4.6] - 2024-07-12
### Fixed
- Fixed duplicate users check

## [9.4.5] - 2024-07-12
### Fixed
- Fixed ssh root key check

## [9.4.4] - 2024-07-12
### Fixed
- Fixed sendmail daemon check

## [9.4.3] - 2024-07-12
### Fixed
- Fixed apparmor check

## [9.4.2] - 2024-07-12
### Fixed
- Fixed iptables check

## [9.4.1] - 2024-07-12
### Fixed
- Bug fixes

## [9.4.0] - 2024-07-12
### Fixed
- Bug fixes

## [9.3.9] - 2024-07-12
### Fixed
- Bug fixes and improvements

## [9.3.8] - 2024-07-11
### Fixed
- Fixed return code in check_systemctl_service

## [9.3.7] - 2024-07-11
### Added
- Added strict and debug switches

## [9.3.6] - 2024-07-10
### Fixed
- Bug fixes and improvements

## [9.3.5] - 2024-07-10
### Fixed
- Bug fixes

## [9.3.4] - 2024-07-10
### Changed
- Improved dialog

## [9.3.3] - 2024-07-09
### Changed
- Cleaned up tests/list options, added some multipass support for testing and updated documentation

## [9.3.2] - 2024-07-09
### Fixed
- Bug fixes

## [9.3.1] - 2024-07-09
### Added
- Initial clean up of options to allow other containers besides docker

## [9.3.0] - 2024-07-08
### Changed
- Improved tcp_wrappers check

## [9.2.9] - 2024-07-08
### Changed
- Improved aide check

## [9.2.8] - 2024-07-07
### Changed
- Made file warnings consistent when file doesn't exist

## [9.2.7] - 2024-07-07
### Changed
- Improved file backup function

## [9.2.6] - 2024-07-06
### Changed
- Improved gsettings function

## [9.2.5] - 2024-07-06
### Changed
- Improved cron allow test

## [9.2.4] - 2024-07-06
### Changed
- Improved gnome screen lock test

## [9.2.3] - 2024-07-06
### Changed
- Improved gnome automount test

## [9.2.2] - 2024-07-06
### Fixed
- Fixed find command in cron test

## [9.2.1] - 2024-07-06
### Fixed
- Fixed wheel group test

## [9.2.0] - 2024-07-06
### Fixed
- Bug fixes

## [9.1.9] - 2024-07-06
### Added
- Added file checks for deleting some files

## [9.1.8] - 2024-07-06
### Changed
- Disable results output when running in restore mode

## [9.1.7] - 2024-07-06
### Fixed
- Fixed temp_file assignment

## [9.1.6] - 2024-07-06
### Changed
- Cleaned up some commands

## [9.1.5] - 2024-07-06
### Changed
- Updated documentation

## [9.1.4] - 2024-07-06
### Added
- Initial clean up of defaults

## [9.1.3] - 2024-07-05
### Added
- Added directory check to file append

## [9.1.2] - 2024-07-05
### Added
- Added directory check to file check

## [9.1.1] - 2024-07-05
### Fixed
- Fixed bug with systemctl command

## [9.1.0] - 2024-07-05
### Changed
- Output format improvements

## [9.0.9] - 2024-07-05
### Changed
- Improved avahi conf check

## [9.0.8] - 2024-07-05
### Changed
- Formatting and bug fixes

## [9.0.7] - 2024-06-28
### Fixed
- Bug fixes

## [9.0.6] - 2024-06-28
### Changed
- Improved select function check

## [9.0.5] - 2024-06-28
### Fixed
- Fixed bug with daemon unmask check

## [9.0.4] - 2024-06-28
### Fixed
- Fixed bug with old users check

## [9.0.3] - 2024-06-28
### Changed
- Major cleanup of code underway

## [9.0.2] - 2024-06-19
### Changed
- Improvements to reporting output

## [9.0.1] - 2024-06-19
### Changed
- Improvements to reporting output

## [9.0.0] - 2024-06-19
### Changed
- Improvements to reporting output

## [8.9.9] - 2024-06-18
### Changed
- Improved systemctl check

## [8.9.8] - 2024-06-18
### Changed
- Updated defaults

## [8.9.7] - 2024-06-18
### Changed
- Updated command line handling

## [8.9.6] - 2024-06-18
### Fixed
- Fixed code to print module info

## [8.9.5] - 2024-06-17
### Changed
- Improved syslog check

## [8.9.4] - 2024-06-17
### Fixed
- Fixes for auditd checks

## [8.9.3] - 2024-06-17
### Changed
- Updated ssh config check

## [8.9.2] - 2024-06-17
### Changed
- Updated motd secure message check

## [8.9.1] - 2024-06-17
### Changed
- Improved wireless test

## [8.9.0] - 2024-06-14
### Fixed
- Fixed PAE check

## [8.8.9] - 2024-06-09
### Fixed
- Fixed check_file_perms.sh find depth

## [8.8.8] - 2023-11-12
### Changed
- More fixes for PAM checks

## [8.8.7] - 2023-11-12
### Fixed
- Fixed PAM based account lockout issue

## [8.8.6] - 2023-11-04
### Changed
- Improved verbose output

## [8.8.5] - 2023-11-04
### Changed
- Improved tcpwrappers check

## [8.8.4] - 2023-11-04
### Added
- Added check for gsettings when running gnome checks

## [8.8.3] - 2023-11-03
### Changed
- Improved MacOS version handling

## [8.8.2] - 2023-11-03
### Changed
- Code cleanup for MacOS defaults function

## [8.8.1] - 2023-11-03
### Added
- Added MacOS Administrative login to another session check

## [8.8.0] - 2023-11-03
### Added
- Added Safari status bar check

## [8.7.9] - 2023-11-03
### Added
- Added Safari Javascript check

## [8.7.8] - 2023-11-03
### Added
- Added Safari allow popups check

## [8.7.7] - 2023-11-03
### Added
- Added Safari auto fill check

## [8.7.6] - 2023-11-03
### Added
- Added Safari show full URL check

## [8.7.5] - 2023-11-02
### Added
- Added Safari Advertising Privacy Protection check

## [8.7.4] - 2023-11-02
### Added
- Added Hide IP Address in Safari check

## [8.7.3] - 2023-11-02
### Added
- Added Safari Tracking check

## [8.7.2] - 2023-11-02
### Added
- Added Safari Fradulent Website Warning check

## [8.7.1] - 2023-11-02
### Added
- Added Safari history limit check

## [8.7.0] - 2023-11-02
### Changed
- Updated documentation

## [8.6.9] - 2023-11-02
### Changed
- Updated documentation

## [8.6.8] - 2023-11-02
### Added
- Added sudoers timestamp check

## [8.6.7] - 2023-11-02
### Changed
- Updated sudoers timeout check

## [8.6.6] - 2023-11-02
### Added
- Added Core Storage encrypted volume checks

## [8.6.5] - 2023-11-02
### Added
- Added APFS encrypted volume checks

## [8.6.4] - 2023-11-02
### Changed
- Updated MacOS password policy check for Sonoma

## [8.6.3] - 2023-11-02
### Added
- Added MacOS /System permissions check

## [8.6.2] - 2023-11-02
### Added
- Added MacOS Sealed System Volume check

## [8.6.1] - 2023-11-02
### Added
- Added Apple Mobile File Integrity check

## [8.6.0] - 2023-11-02
### Changed
- Updated documentation

## [8.5.9] - 2023-11-01
### Changed
- Updated web sharing and NFS check for MacOS Sonoma

## [8.5.8] - 2023-11-01
### Changed
- Updated bonjour advertising test for MacOS Sonoma

## [8.5.7] - 2023-11-01
### Changed
- Updated firewall logging test for MacOS Sonoma

## [8.5.6] - 2023-11-01
### Changed
- Updated kernel accounting test for MacOS Sonoma

## [8.5.5] - 2023-11-01
### Changed
- Updated documentation

## [8.5.4] - 2023-11-01
### Added
- Added MacOS SMB guest sharing check

## [8.5.3] - 2023-11-01
### Added
- Added MacOS check sysadminctl function

## [8.5.2] - 2023-10-31
### Changed
- Documentation updates

## [8.5.1] - 2023-10-31
### Added
- Added Touch ID checks

## [8.5.0] - 2023-10-31
### Changed
- Updated documentation

## [8.4.9] - 2023-10-31
### Added
- Added screen idle time check

## [8.4.8] - 2023-10-31
### Added
- Added powernap check to sleep checks

## [8.4.7] - 2023-10-31
### Added
- Added filevault check to sleep checks

## [8.4.6] - 2023-10-31
### Added
- Added additional MocOS sleep checks for Apple Silicon

## [8.4.5] - 2023-10-31
### Added
- Added additional MocOS sleep checks for Intel

## [8.4.4] - 2023-10-30
### Added
- Added MacOS universal control check

## [8.4.3] - 2023-10-30
### Added
- Added MacOS screen corner setting check

## [8.4.2] - 2023-10-30
### Added
- Added MacOS Lockdown check

## [8.4.1] - 2023-10-30
### Changed
- Updated documentation

## [8.4.0] - 2023-10-30
### Added
- Added MacOS Ad Tracking check and updated test feedback

## [8.3.9] - 2023-10-30
### Added
- Added MacOS Usage data check

## [8.3.8] - 2023-10-30
### Added
- Added additional location services check

## [8.3.7] - 2023-10-30
### Fixed
- Bug fixes

## [8.3.6] - 2023-10-30
### Added
- Added MacOS defaults function to handle user defaults

## [8.3.5] - 2023-10-30
### Added
- Added MacOS Location Services check

## [8.3.4] - 2023-10-30
### Added
- Added MacOS Siri checks

## [8.3.3] - 2023-10-29
### Added
- Added additional MacOS wireless check

## [8.3.2] - 2023-10-29
### Added
- Added additional MacOS wireless check

## [8.3.1] - 2023-10-29
### Added
- Added MacOS Time Machine check

## [8.3.0] - 2023-10-29
### Added
- Added additional MacOS check for bluetooth sharing

## [8.2.9] - 2023-10-29
### Added
- Added MacOS check for media sharing

## [8.2.8] - 2023-10-29
### Added
- Added MacOS check for asset caching

## [8.2.7] - 2023-10-29
### Changed
- Documentation updates

## [8.2.6] - 2023-10-29
### Changed
- Updates for MacOS Sonoma

## [8.2.5] - 2023-10-29
### Changed
- Documentation fixes

## [8.2.4] - 2023-10-29
### Added
- Added Air Play Receiver check

## [8.2.3] - 2023-10-29
### Added
- Added Air Drop check

## [8.2.2] - 2023-10-29
### Changed
- Documentation cleanup

## [8.2.1] - 2023-10-29
### Fixed
- Fixed issue with OS version/release handling

## [8.2.0] - 2023-10-28
### Added
- Added keychain sync test for macOS Sonoma

## [8.1.9] - 2023-10-28
### Added
- Added addition shoftware update checks for macOS Sonoma

## [8.1.8] - 2023-10-28
### Added
- Added more checks for when not running as root

## [8.1.7] - 2023-10-28
### Added
- Added non root user check for reading shadow file

## [8.1.6] - 2023-10-28
### Added
- Added check for nmcli

## [8.1.5] - 2023-10-28
### Added
- Added check for iptables

## [8.1.4] - 2023-10-27
### Fixed
- Bug fixes

## [8.1.3] - 2023-10-27
### Fixed
- Bug fixes for auditd check

## [8.1.2] - 2023-10-27
### Fixed
- Bug fix for OS X defaults check

## [8.1.1] - 2023-10-27
### Fixed
- Bug fix for apparmor check

## [8.1.0] - 2023-10-27
### Fixed
- Bug fixes for aide check

## [8.0.9] - 2023-10-27
### Changed
- Moved home directory check to be a part of filesystem check option

## [8.0.8] - 2022-10-01
### Added
- Added check for auditing chchon

## [8.0.7] - 2022-10-01
### Added
- Added sudo check to audit

## [8.0.6] - 2022-10-01
### Added
- Added check for audit log of running command as another user

## [8.0.5] - 2022-09-29
### Changed
- Various updates to system logging and auditing checks

## [8.0.4] - 2022-09-29
### Added
- Added additional aide checks

## [8.0.3] - 2022-09-29
### Added
- Added auditd log_group check

## [8.0.2] - 2022-09-29
### Added
- Added additional checks to system accounting/auditing

## [8.0.1] - 2022-09-29
### Added
- Added faillock to auditing

## [8.0.0] - 2022-09-29
### Fixed
- Fixed audit max log file size

## [7.9.9] - 2022-09-29
### Added
- Added audit log size check

## [7.9.8] - 2022-09-28
### Added
- Added grub check for audit flag

## [7.9.7] - 2022-09-27
### Added
- Added audispd-plugins package check

## [7.9.6] - 2022-09-27
### Added
- Added some UFW checks for Ubuntu Linux

## [7.9.5] - 2022-09-27
### Added
- Added wireless check for Linux

## [7.9.4] - 2022-09-27
### Added
- Added exim check

## [7.9.3] - 2022-09-26
### Added
- Added PAE/NX check

## [7.9.2] - 2022-09-26
### Fixed
- Fixed prelink and aide checks

## [7.9.1] - 2022-09-26
### Changed
- Updated Gnome autorun check and added Gnome XDMCP check

## [7.9.0] - 2022-09-26
### Added
- Added Gnome autorun check

## [7.8.9] - 2022-09-26
### Added
- Added Gnome automount check

## [7.8.8] - 2022-09-26
### Changed
- Updated GDM lock check for Linux

## [7.8.7] - 2022-09-25
### Changed
- Updated GDM lock check for Linux

## [7.8.6] - 2022-09-25
### Added
- Added GDM lock check for Linux

## [7.8.5] - 2022-09-25
### Fixed
- Fixed bug with apparmor module

## [7.8.4] - 2022-09-25
### Added
- Added initial code for gsettings function

## [7.8.3] - 2022-09-25
### Added
- Added gnome defaults check for GDM3

## [7.8.2] - 2022-09-25
### Added
- Added grub config/menu file check to Apparmor test

## [7.8.1] - 2022-09-24
### Added
- Added grub check to Apparmor check

## [7.8.0] - 2022-09-23
### Fixed
- Fixed AppArmor check for Ubuntu

## [7.7.9] - 2022-09-23
### Added
- Added check for apport service on Ubuntu 22.04

## [7.7.8] - 2022-09-23
### Changed
- Updated check for tally2 PAM module which has been replaced with faillock PAM module in Ubuntu 22.04

## [7.7.7] - 2022-01-31
### Changed
- Updated security banner based on suggestion from Mark Lane so it can be grepped out easier

## [7.7.6] - 2021-04-22
### Added
- Added code to deal with issue #61

## [7.7.5] - 2021-04-22
### Changed
- Cleaned up linux service check code as per issue #37

## [7.7.4] - 2020-09-20
### Fixed
- Fixed AWS password policy module

## [7.7.3] - 2020-09-19
### Fixed
- Fix big with AIX Retry Limit code

## [7.7.2] - 2020-09-18
### Fixed
- Fixed duplicate options

## [7.7.1] - 2020-09-16
### Removed
- Removed elfsign

## [7.7.0] - 2020-09-16
### Fixed
- Fix for filesystem searches on Linux

## [7.6.9] - 2020-05-18
### Changed
- More Apache support

## [7.6.8] - 2020-05-04
### Changed
- More ansible output tweaks

## [7.6.7] - 2020-05-03
### Changed
- More ansible output tweaks

## [7.6.6] - 2020-05-03
### Changed
- Ansible output tweaks

## [7.6.5] - 2020-05-03
### Added
- Added in function to check_file_value to cater for multiple parameters in a line

## [7.6.4] - 2020-05-03
### Changed
- Formating cleanup

## [7.6.3] - 2020-05-03
### Fixed
- Fixed bug with filesystem partitions check

## [7.6.2] - 2020-02-18
### Fixed
- Fixes for RedHat/Centos 8.x using chrony by default as suggested in issue 35

## [7.6.1] - 2020-02-18
### Fixed
- Fixes and improvements as suggesting in issue 36

## [7.6.0] - 2020-01-23
### Added
- Added more ansible stanzas

## [7.5.9] - 2020-01-23
### Added
- Added more ansible stanzas

## [7.5.8] - 2020-01-22
### Fixed
- Bug fixes and code cleanup

## [7.5.7] - 2020-01-22
### Added
- Added more ansible stanzas

## [7.5.6] - 2020-01-22
### Fixed
- Bug fixes and code cleanup

## [7.5.5] - 2020-01-22
### Fixed
- Bug fixes

## [7.5.4] - 2020-01-22
### Fixed
- Bug fixes and initial ansbile output

## [7.5.3] - 2019-07-31
### Fixed
- Fixes for date on Linux

## [7.5.2] - 2019-07-31
### Changed
- Additional fix for Debian unstable

## [7.5.1] - 2019-07-30
### Fixed
- Fixes for Debian

## [7.5.0] - 2019-06-11
### Changed
- Execshield fix

## [7.4.9] - 2019-04-24
### Added
- Added additional kubernetes checks

## [7.4.8] - 2019-04-24
### Changed
- Updated check file value function

## [7.4.7] - 2019-04-24
### Changed
- Minor cleanup

## [7.4.6] - 2019-04-24
### Added
- Added additional kubernetes checks

## [7.4.5] - 2019-04-24
### Added
- Added additional kubernetes checks

## [7.4.4] - 2019-04-24
### Added
- Added support of hyphens in parameter names in file value checks

## [7.4.3] - 2019-04-23
### Added
- Initial Kubernetes support

## [7.4.2] - 2019-04-23
### Added
- Added file check to securetty test

## [7.4.1] - 2019-04-23
### Changed
- Improved handling for beta releases of Red Hat Linux

## [7.4.0] - 2019-04-23
### Changed
- More bug fixes

## [7.3.9] - 2019-04-23
### Added
- Added initial docker test matrix

## [7.3.8] - 2019-04-23
### Changed
- More fixes

## [7.3.7] - 2019-04-23
### Changed
- Made code more portable

## [7.3.6] - 2019-04-23
### Fixed
- Fixed bug with module check

## [7.3.5] - 2019-04-21
### Added
- Added group package check

## [7.3.4] - 2019-04-21
### Added
- Initial bug fix for X Windows System package group being installed

## [7.3.3] - 2019-04-21
### Fixed
- Fixed bug with file value check and check values starting in hyphens

## [7.3.2] - 2019-04-21
### Fixed
- Fixed bug with sulogin check

## [7.3.1] - 2019-04-21
### Changed
- Cleanup and bug fixes

## [7.3.0] - 2019-04-21
### Added
- Added initial code for detecting virtual platform and fixed separate filesystems check

## [7.2.9] - 2019-04-21
### Fixed
- Fixed Java version check and some other bugs

## [7.2.8] - 2019-02-09
### Fixed
- Fixed a bug with chkconfig on Centos

## [7.2.7] - 2017-12-27
### Fixed
- Fixed uname and stat on OS X

## [7.2.6] - 2017-09-09
### Changed
- Cleaned up command line argument handling

## [7.2.5] - 2017-02-12
### Changed
- Code cleanup

## [7.2.4] - 2017-02-11
### Changed
- Updated documentation

## [7.2.3] - 2017-02-11
### Added
- Added System Integrity Protection test for OS X

## [7.2.2] - 2017-02-11
### Added
- Added system preferences check for OS X

## [7.2.1] - 2017-02-11
### Changed
- Updated OS X login policy test and documentation

## [7.2.0] - 2017-02-11
### Changed
- Updated OS X keychain check

## [7.1.9] - 2017-02-11
### Changed
- Updated OS X password policy test

## [7.1.8] - 2017-02-11
### Changed
- Updated OS X password policy test

## [7.1.7] - 2017-02-11
### Added
- Added Application permission checks for OS X

## [7.1.6] - 2017-02-11
### Added
- Added NFS daemon check for OS X

## [7.1.5] - 2017-02-11
### Added
- Added wireless check for OS X

## [7.1.4] - 2017-02-11
### Added
- Added addition system log tests for OS X and updated documentation

## [7.1.3] - 2017-02-11
### Added
- Added addition system log tests for OS X and updated documentation

## [7.1.2] - 2017-02-11
### Added
- Added system log test for OS X

## [7.1.1] - 2017-02-11
### Added
- Added Java test for OS X

## [7.1.0] - 2017-02-11
### Changed
- Updated SSH support to include sandbox for privilege separation

## [7.0.9] - 2017-02-11
### Changed
- Code cleanup

## [7.0.8] - 2017-02-10
### Changed
- Code cleanup

## [7.0.7] - 2017-02-10
### Added
- Added sleep check for OS X and updated documentation

## [7.0.6] - 2017-02-10
### Added
- Added remote login check for OS X

## [7.0.5] - 2017-02-10
### Added
- Added screen sharing test for OS X

## [7.0.4] - 2017-02-10
### Changed
- Code cleanup

## [7.0.3] - 2017-02-10
### Fixed
- Bug fixes and documentation updates

## [7.0.2] - 2017-02-10
### Changed
- Updates for OS X 10.12

## [7.0.1] - 2017-02-09
### Changed
- Updated documentation

## [7.0.0] - 2017-02-09
### Fixed
- Bug fixes and documenation updates

## [6.9.9] - 2017-02-09
### Fixed
- Bug fixes and documenation updates

## [6.9.8] - 2017-02-09
### Fixed
- Bug fixes and documenation updates

## [6.9.7] - 2017-02-09
### Fixed
- Bug fixes and documenation updates

## [6.9.6] - 2017-02-09
### Changed
- Code cleanup and bug fixes

## [6.9.5] - 2017-02-09
### Changed
- Updated GRUB test

## [6.9.4] - 2017-02-09
### Added
- Added option to list Docker reports

## [6.9.3] - 2017-02-08
### Added
- Added Docker socket mount test

## [6.9.2] - 2017-02-08
### Added
- Added Docker UsernsMode test

## [6.9.1] - 2017-02-08
### Added
- Added Docker default bridge test

## [6.9.0] - 2017-02-08
### Added
- Added Docker Health test

## [6.8.9] - 2017-02-08
### Added
- Added Docker SecurityOpt tests

## [6.8.8] - 2017-02-08
### Added
- Added Docker CgroupParent test

## [6.8.7] - 2017-02-08
### Added
- Added Docker exec commands with user option check

## [6.8.6] - 2017-02-08
### Changed
- Cleaned up Docker tests

## [6.8.5] - 2017-02-08
### Added
- Added Docker exec commands with privileged option check

## [6.8.4] - 2017-02-08
### Added
- Added Docker UTSMode check

## [6.8.3] - 2017-02-08
### Added
- Added Docker mount propagation check

## [6.8.2] - 2017-02-08
### Added
- Added Docker Ulimits check

## [6.8.1] - 2017-02-08
### Added
- Added Docker Devices check

## [6.8.0] - 2017-02-08
### Added
- Added Docker IpcMode check

## [6.7.9] - 2017-02-08
### Added
- Added Docker PidMode check

## [6.7.8] - 2017-02-08
### Changed
- More Docker fixes

## [6.7.7] - 2017-02-08
### Added
- Added Docker Ports check and cleaned up code

## [6.7.6] - 2017-02-08
### Added
- Added Docker Memory and CpuShares tests

## [6.7.5] - 2017-02-08
### Changed
- Additional Docker code cleanup

## [6.7.4] - 2017-02-08
### Added
- Initial Docker code cleanup

## [6.7.3] - 2017-02-08
### Added
- Added Docker memory usage limit test

## [6.7.2] - 2017-02-08
### Added
- Added Docker host network namespace check

## [6.7.1] - 2017-02-08
### Added
- Added Docker privileged container check

## [6.7.0] - 2017-02-08
### Added
- Added Docker capabilities test

## [6.6.9] - 2017-02-08
### Added
- Added Docker SELinux test

## [6.6.8] - 2017-02-08
### Added
- Added Docker AppArmor test

## [6.6.7] - 2017-02-08
### Added
- Added Docker Healthcheck test

## [6.6.6] - 2017-02-08
### Added
- Added Docker container user test

## [6.6.5] - 2017-02-08
### Added
- Added Docker file permission tests

## [6.6.4] - 2017-02-08
### Added
- Added Docker swarm unlock key test

## [6.6.3] - 2017-02-08
### Added
- Added Docker seccomp profile test

## [6.6.2] - 2017-02-08
### Added
- Added Docker encrypted network traffic check

## [6.6.1] - 2017-02-08
### Added
- Added Docker userland proxy test

## [6.6.0] - 2017-02-08
### Added
- Added Docker liver restore check

## [6.5.9] - 2017-02-08
### Added
- Added Docker legacy registry check

## [6.5.8] - 2017-02-08
### Added
- Added additional Docker logging tests

## [6.5.7] - 2017-02-08
### Added
- Added Docker daemon storage option and authorisation plugin checks

## [6.5.6] - 2017-02-08
### Added
- Added Docker user namespace support test

## [6.5.5] - 2017-02-08
### Fixed
- Fixed Docker daemon test

## [6.5.4] - 2017-02-08
### Added
- Added more Docker tests and updated SSH TCP forwarding test

## [6.5.3] - 2017-02-07
### Added
- Added Docker network bridge test

## [6.5.2] - 2017-02-07
### Added
- Added additional Docker support

## [6.5.1] - 2017-02-07
### Added
- Added initial support for Docker

## [6.5.0] - 2017-01-31
### Added
- Added check for AWS Inspector assessment recommendation (CVEs)

## [6.4.9] - 2017-01-31
### Added
- Added check for AWS Inspector being used

## [6.4.8] - 2017-01-30
### Added
- Added check for AWS Redshift reserved instances about to expire

## [6.4.7] - 2017-01-30
### Added
- Added check for AWS Redshift being publicly available

## [6.4.6] - 2017-01-30
### Added
- Added check for AWS Redshift paramter groups requiring SSL

## [6.4.5] - 2017-01-30
### Added
- Added check for AWS Redshift using EC2-VPC domains rather than EC2-Classic

## [6.4.4] - 2017-01-30
### Added
- Added check for AWS Redshift using KMS keys

## [6.4.3] - 2017-01-30
### Added
- Added check for AWS Redshift encryption being enabled

## [6.4.2] - 2017-01-30
### Added
- Added check for AWS Redshift logging being enabled

## [6.4.1] - 2017-01-30
### Added
- Added check for AWS Redshift upgrades being enabled

## [6.4.0] - 2017-01-29
### Added
- Added check for AWS CloudWatch alarm for EC2 instance size changes

## [6.3.9] - 2017-01-29
### Added
- Added check for AWS CloudWatch alarm for EC2 instance changes

## [6.3.8] - 2017-01-29
### Added
- Added check for AWS Cloudfront using HTTP only

## [6.3.7] - 2017-01-29
### Added
- Added check for AWS Cloudfront using deprecate SSL version

## [6.3.6] - 2017-01-29
### Added
- Added check for AWS Cloudfront logging being enabled

## [6.3.5] - 2017-01-29
### Added
- Added check for AWS Cloudfront WAF integration being enabled

## [6.3.4] - 2017-01-29
### Added
- Added check for AWS ElastiCache reserved instances expiring

## [6.3.3] - 2017-01-29
### Added
- Added check for AWS ElastiCache having HA enabled

## [6.3.2] - 2017-01-29
### Added
- Added check for AWS CloudFormation stacks having policies

## [6.3.1] - 2017-01-29
### Added
- Added check for AWS CloudFormation stacks using SNS

## [6.3.0] - 2017-01-29
### Added
- Added check for AWS SNS topic being publicly accessible

## [6.2.9] - 2017-01-29
### Added
- Added check for AWS inactive KMS keys

## [6.2.8] - 2017-01-29
### Added
- Added check for AWS CloudTrail recording global events

## [6.2.7] - 2017-01-29
### Added
- Added check for AWS EC2 EBS volume snapshots being taken

## [6.2.6] - 2017-01-29
### Added
- Added check for AWS EC2 EBS volumes having KMS keys

## [6.2.5] - 2017-01-29
### Added
- Added check for AWS RDS backup retention period

## [6.2.4] - 2017-01-29
### Added
- Added check for AWS RDS registered instances expiring

## [6.2.3] - 2017-01-28
### Added
- Added check for AWS RDS instances using default master username

## [6.2.2] - 2017-01-28
### Added
- Added check for AWS RDS instances being on a public facing subnet

## [6.2.1] - 2017-01-28
### Added
- Added check for AWS RDS using General Purpose SSD to be cost effective

## [6.2.0] - 2017-01-28
### Added
- Added check for AWS RDS using KMS key

## [6.1.9] - 2017-01-28
### Added
- Added check for AWS RDS Security Groups

## [6.1.8] - 2017-01-28
### Added
- Added check for AWS RDS having Multi-AZ enabled

## [6.1.7] - 2017-01-28
### Added
- Added check for AWS RDS encryption

## [6.1.6] - 2017-01-28
### Added
- Added check for AWS RDS automated backups

## [6.1.5] - 2017-01-28
### Added
- Added check for AWS RDS auto minor version upgrade

## [6.1.4] - 2017-01-28
### Added
- Added check for AWS SES and DKIM

## [6.1.3] - 2017-01-28
### Added
- Added check for AWS S3 bucket versioning

## [6.1.2] - 2017-01-28
### Added
- Added check for AWS S3 bucket logging

## [6.1.1] - 2017-01-28
### Added
- Added check for AWS S3 bucket grants

## [6.1.0] - 2017-01-28
### Added
- Added check for AWS VPC / VPN redundancy

## [6.0.9] - 2017-01-27
### Added
- Added check for AWS VPC names

## [6.0.8] - 2017-01-27
### Added
- Added check for AWC VPC exposed endpoints

## [6.0.7] - 2017-01-27
### Added
- Added check for AWC EC2 unattached volumes to be cost effective

## [6.0.6] - 2017-01-27
### Added
- Added check for AWS EC2 snapshots older than 30 days

## [6.0.5] - 2017-01-27
### Added
- Added check for AWS EC2 volume names

## [6.0.4] - 2017-01-27
### Added
- Added check for unencrypted AWS EC2 volumes

## [6.0.3] - 2017-01-27
### Added
- Added check for out of service AWS ELB instances

## [6.0.2] - 2017-01-27
### Added
- Added check for AWS ELB SGs being open on port 80

## [6.0.1] - 2017-01-27
### Added
- Added check for AWS ELB having at least 2 instances

## [6.0.0] - 2017-01-27
### Added
- Added check for AWS ELB using HTTP rather than HTTPS

## [5.9.9] - 2017-01-27
### Added
- Added check for AWS ELB using deprecated protocols

## [5.9.8] - 2017-01-27
### Added
- Added check for AWS ELB using deprecated ciphers

## [5.9.7] - 2017-01-26
### Added
- Added check for AWS ELB cross zone balancing being enabled

## [5.9.6] - 2017-01-26
### Added
- Added check for AWS ELB connection draining being enabled

## [5.9.5] - 2017-01-26
### Added
- Added check for AWS ELB logging being enabled

## [5.9.4] - 2017-01-26
### Added
- Added check for empty DynamoDB tables to be cost effective

## [5.9.3] - 2017-01-26
### Added
- Added more tag checks for AWS EC2 instances

## [5.9.2] - 2017-01-26
### Added
- Added check for AWS ES domains being cross zone aware

## [5.9.1] - 2017-01-26
### Added
- Added check for AWS ES domains using General Purpose SSD to be cost effective

## [5.9.0] - 2017-01-26
### Added
- Added check for AWS ES domains having dedicated master nodes

## [5.8.9] - 2017-01-26
### Added
- Added check for AWS ES domains having IP access policy

## [5.8.8] - 2017-01-26
### Added
- Added check for AWS ES domains being publicly accessible

## [5.8.7] - 2017-01-26
### Added
- Added check for AWS users with attached policies

## [5.8.6] - 2017-01-26
### Added
- Added check for AWS SGs with open Telnet

## [5.8.5] - 2017-01-26
### Added
- Added check for AWS SGs with open SMTP

## [5.8.4] - 2017-01-26
### Added
- Added check for AWS SGs with open ICMP

## [5.8.3] - 2017-01-26
### Added
- Added check for AWS SGs with open RPC ports

## [5.8.2] - 2017-01-26
### Added
- Added check for AWS SGs with open MongoDB ports

## [5.8.1] - 2017-01-26
### Added
- Added check for AWS SGs with various open ports

## [5.8.0] - 2017-01-26
### Added
- Added check for AWS SGs with open FTP ports

## [5.7.9] - 2017-01-26
### Added
- Added check for AWS SGs with open DNS ports

## [5.7.8] - 2017-01-26
### Added
- Added check for AWS SGs with open CIFS ports

## [5.7.7] - 2017-01-26
### Changed
- Split out AWS VPC and SG checks

## [5.7.6] - 2017-01-26
### Added
- Added check against recommended Security Group name

## [5.7.5] - 2017-01-26
### Added
- Added check for publicly shared AWS AMIs

## [5.7.4] - 2017-01-25
### Added
- Added check to see if instances have IAM profiles

## [5.7.3] - 2017-01-25
### Added
- Added check for AWS instance termination protection

## [5.7.2] - 2017-01-25
### Added
- Added check against recommended Instance name

## [5.7.1] - 2017-01-25
### Added
- Added check for AWS EC2-Classic instances

## [5.7.0] - 2017-01-25
### Added
- Added check for AWS instances using the default security group

## [5.6.9] - 2017-01-25
### Added
- Added check for number of AWS EIPs consumer

## [5.6.8] - 2017-01-25
### Added
- Added check for AWS instance image ID owner

## [5.6.7] - 2017-01-25
### Added
- Added check for AWS Route53 Domain Transfer Lock

## [5.6.6] - 2017-01-25
### Added
- Added check for AWS Route53 Zone SPF records

## [5.6.5] - 2017-01-25
### Added
- Added check for AWS Route53 Domain expiration

## [5.6.4] - 2017-01-25
### Added
- Added check for AWS Route53 Domain renewals

## [5.6.3] - 2017-01-25
### Added
- Added check for inactive AWS IAM accounts

## [5.6.2] - 2017-01-25
### Added
- Added check for expired AWS certificates

## [5.6.1] - 2017-01-24
### Added
- Added AWS IAM empty group check

## [5.6.0] - 2017-01-24
### Added
- Added AWS IAM SSH Public Keys check

## [5.5.9] - 2017-01-24
### Added
- Added initial support for AWS recommendations

## [5.5.8] - 2017-01-24
### Added
- Added additional support for setting AWS region

## [5.5.7] - 2017-01-24
### Added
- Added initial ability to set AWS region on command line

## [5.5.6] - 2017-01-24
### Added
- Added some fix information for CloudTrail bucket permissions

## [5.5.5] - 2017-01-24
### Added
- Added some fix information for AWS Config

## [5.5.4] - 2017-01-24
### Added
- Added some fix information for S3 bucket logging

## [5.5.3] - 2017-01-24
### Changed
- Updated AWS CloudTrail Key fix information

## [5.5.2] - 2017-01-24
### Added
- Added some fix information for SNS check

## [5.5.1] - 2017-01-24
### Added
- Added some fix information for VPC checks

## [5.5.0] - 2017-01-24
### Changed
- Cleaned up AWS CloudTrail checks

## [5.4.9] - 2017-01-21
### Added
- Added fix information for AWS Access Keys

## [5.4.8] - 2017-01-20
### Added
- Added AWS CloudTrail, Console, Key, S3, Config, NACL, Security Group, Gateway, Route and VPC alarm and subscriber checks

## [5.4.7] - 2017-01-20
### Added
- Added AWS IAM alarm and subscriber checks

## [5.4.6] - 2017-01-20
### Added
- Added AWS alarm and subscriber checks

## [5.4.5] - 2017-01-20
### Added
- Added initial AWS monitoring checks

## [5.4.4] - 2017-01-20
### Added
- Added initial AWS SNS checks

## [5.4.3] - 2017-01-20
### Added
- Added AWS Security Group check for open SSH / RDP ports

## [5.4.2] - 2017-01-20
### Added
- Added AWS VPC flow log check

## [5.4.1] - 2017-01-20
### Added
- Added Inbound / Outbond check for AWS Security Groups

## [5.4.0] - 2017-01-20
### Added
- Added AWS VPC peering check

## [5.3.9] - 2017-01-20
### Added
- Added AWS Key check

## [5.3.8] - 2017-01-19
### Added
- Added AWS CloudTrail KMS Key check

## [5.3.7] - 2017-01-19
### Added
- Added AWS CloudTrail S3 Bucket logging check

## [5.3.6] - 2017-01-19
### Added
- Added initial support for AWS Config check

## [5.3.5] - 2017-01-19
### Added
- Added AWS CloudTrail CloudWatch Logs integration check

## [5.3.4] - 2017-01-19
### Added
- Added AWS CloudTrail bucket policy check

## [5.3.3] - 2017-01-19
### Fixed
- Fixed various AWS bugs

## [5.3.2] - 2017-01-19
### Added
- Added AWS IAM Master / Manager account check

## [5.3.1] - 2017-01-19
### Added
- Added AWS CloudTrail bucket permissions check

## [5.3.0] - 2017-01-19
### Added
- Added AWS CloudTrail LogFileValidation check

## [5.2.9] - 2017-01-19
### Added
- Added AWS CloudTrail MultiRegion check

## [5.2.8] - 2017-01-19
### Added
- Added AWS full administrative privileges check

## [5.2.7] - 2017-01-19
### Added
- Added AWS access keys check

## [5.2.6] - 2017-01-19
### Added
- Added AWS support role check

## [5.2.5] - 2017-01-18
### Added
- Added AWS user policy check

## [5.2.4] - 2017-01-18
### Added
- Added AWS root account MFA check

## [5.2.3] - 2017-01-18
### Added
- Added AWS password policy check

## [5.2.2] - 2017-01-18
### Added
- Added AWS credential rotation check

## [5.2.1] - 2017-01-18
### Added
- Added AWS credentials check

## [5.2.0] - 2017-01-18
### Added
- Initial code for AWS Foundation Security audit

## [5.1.9] - 2017-01-17
### Changed
- Updated Linux package handling code

## [5.1.8] - 2017-01-16
### Fixed
- Fixed code to use . rather than source on Ubuntu and Debian (sh is actually bash)

## [5.1.7] - 2017-01-16
### Changed
- Cleaned up reporting

## [5.1.6] - 2017-01-16
### Fixed
- Bug fixes

## [5.1.5] - 2017-01-16
### Fixed
- Fix for Amazon Linux

## [5.1.4] - 2017-01-16
### Fixed
- Bug fixes

## [5.1.3] - 2017-01-15
### Fixed
- Bug fixes

## [5.1.2] - 2017-01-15
### Changed
- More updates for Amazon Linux and Centos / RHEL 7

## [5.1.1] - 2017-01-15
### Changed
- Documentation cleanup

## [5.1.0] - 2017-01-15
### Changed
- More updated for Amazon Linux and Centos / RHEL 7

## [5.0.9] - 2017-01-15
### Changed
- More updates for Amazon Linux and Centos / RHEL 7

## [5.0.8] - 2017-01-15
### Changed
- More updates for Amazon Linux and Centos / RHEL 7

## [5.0.7] - 2017-01-15
### Changed
- Updates for Amazon Linux and Centos / RHEL 7

## [5.0.6] - 2017-01-14
### Changed
- Code cleanup

## [5.0.5] - 2017-01-14
### Fixed
- Fixed code to print module information

## [5.0.4] - 2017-01-14
### Fixed
- Fixed audit select function

## [5.0.3] - 2017-01-14
### Added
- Initial Amazon Linux support

## [5.0.2] - 2017-01-14
### Added
- Start adding support for Amazon Linux and added vfat to modprobe check

## [5.0.1] - 2015-04-28
### Removed
- Removed call to audit_root_account as it was split into several audit_root_* subroutines

## [5.0.0] - 2014-06-11
### Changed
- Updated license

## [4.9.9] - 2014-05-31
### Changed
- Minor code cleanup

## [4.9.8] - 2014-05-31
### Added
- Added Lockdown check for ESXi

## [4.9.7] - 2014-05-31
### Added
- Added DCUI, SSH and ESXi Shell tests fo ESXi

## [4.9.6] - 2014-05-30
### Added
- Added Dvfilter test for ESXi

## [4.9.5] - 2014-05-30
### Added
- Added Managed Object Browser test for ESXi

## [4.9.4] - 2014-05-30
### Added
- Added software update test for ESXi

## [4.9.3] - 2014-05-30
### Added
- Added Syslog directory test for ESXi

## [4.9.2] - 2014-05-30
### Added
- Added shell timeout tests for ESXi

## [4.9.1] - 2014-05-30
### Added
- Added signed kernel module test for ESXi

## [4.9.0] - 2014-05-30
### Added
- Added NTP check for ESXi and made further improvements to scoring

## [4.8.9] - 2014-05-29
### Changed
- Improved scoring and added SNMP and Syslog tests for ESX

## [4.8.8] - 2014-05-29
### Fixed
- Bug fixes and inital ESXi support (no tests)

## [4.8.7] - 2014-05-15
### Removed
- Deleted duplicate root group test

## [4.8.6] - 2014-05-14
### Changed
- Minor updates

## [4.8.5] - 2014-05-08
### Fixed
- Fixed cron allow test for Solaris 11, Linux and FreeBSD

## [4.8.4] - 2014-05-06
### Changed
- Minor fixes

## [4.8.3] - 2014-04-27
### Fixed
- Fixed audit_system_auth_use_uid

## [4.8.2] - 2014-04-25
### Fixed
- Fixed some bugs

## [4.8.1] - 2014-04-13
### Removed
- Removed duplicate auto logout module

## [4.8.0] - 2014-04-13
### Changed
- Reference updates and bug fixes

## [4.7.9] - 2014-04-12
### Changed
- Reference updates

## [4.7.8] - 2014-04-12
### Changed
- Reference updates

## [4.7.7] - 2014-04-03
### Changed
- Updated AppArmour test for SuSE Linux

## [4.7.6] - 2014-04-02
### Changed
- More bug fixes

## [4.7.5] - 2014-04-02
### Fixed
- Fixed bugs (thanks to Mark Lane for testing)

## [4.7.4] - 2014-04-01
### Added
- Added EEEPROM password test for SPARC

## [4.7.3] - 2014-04-01
### Added
- Added gdm-autologin PAM check for Solaris 11

## [4.7.2] - 2014-04-01
### Added
- Added shadow group member test for SuSE Linux

## [4.7.1] - 2014-04-01
### Added
- Added SuSEfirewall2 test

## [4.7.0] - 2014-04-01
### Added
- Added AppArmour and biosdevname test for SuSE Linux

## [4.6.9] - 2014-04-01
### Added
- Added kernel-pae test and CIS reference for SuSE Linux

## [4.6.8] - 2014-04-01
### Added
- Added interactive boot test

## [4.6.7] - 2014-03-31
### Changed
- More CIS references for Linux

## [4.6.6] - 2014-03-31
### Added
- Added noexec tmpfs test for Linux

## [4.6.5] - 2014-03-31
### Added
- Added more CIS references for Linux

## [4.6.4] - 2014-03-31
### Added
- Added inactive user test for Linux

## [4.6.3] - 2014-03-31
### Added
- Added pam_deny and pam_ccred tests for Linux

## [4.6.2] - 2014-03-30
### Changed
- Updated syslog and rsyslog test for Linux

## [4.6.1] - 2014-03-30
### Added
- Added CIS references and updated syslog configuration for Linux

## [4.6.0] - 2014-03-30
### Fixed
- Fixed xinetd test for Linux

## [4.5.9] - 2014-03-30
### Added
- Added code to remove talk client on Linux

## [4.5.8] - 2014-03-30
### Added
- Added various client package tests for Linux

## [4.5.7] - 2014-03-30
### Added
- Added kernel-PAE package check

## [4.5.6] - 2014-03-30
### Added
- Added more CIS references for Linux tests and cleaned up some Linux test conditions

## [4.5.5] - 2014-03-30
### Added
- Added more CIS references for Solaris tests

## [4.5.4] - 2014-03-29
### Added
- Added numerous CIS references for Solaris tests

## [4.5.3] - 2014-03-28
### Added
- Added legacy services tests and CIS references for AIX

## [4.5.2] - 2014-03-28
### Added
- Added code to drive subserver on AIX

## [4.5.1] - 2014-03-28
### Added
- Added network kernel tuning parameter test and CIS references for AIX

## [4.5.0] - 2014-03-28
### Added
- Added code to drive no on AIX

## [4.4.9] - 2014-03-28
### Added
- Added hosts.equiv tests and CIS references for AIX

## [4.4.8] - 2014-03-28
### Added
- Added .rhosts tests and CIS references for AIX

## [4.4.7] - 2014-03-28
### Added
- Added .netrc tests and CIS references for AIX

## [4.4.6] - 2014-03-28
### Added
- Added NPD tests and CIS references for AIX

## [4.4.5] - 2014-03-28
### Added
- Added aixmibd test and CIS reference for AIX

## [4.4.4] - 2014-03-28
### Added
- Added snmpdmibd test and CIS reference for AIX

## [4.4.3] - 2014-03-28
### Added
- Added hostmibd test and CIS reference for AIX

## [4.4.2] - 2014-03-28
### Added
- Added dpid2 test and CIS reference for AIX

## [4.4.1] - 2014-03-28
### Added
- Added timed test and CIS reference for AIX

## [4.4.0] - 2014-03-28
### Added
- Added rwhod test and CIS reference for AIX

## [4.3.9] - 2014-03-28
### Added
- Added routed test and CIS reference for AIX

## [4.3.9] - 2014-03-28
### Added
- Added named test and CIS reference for AIX

## [4.3.8] - 2014-03-28
### Added
- Added mrouted test and CIS reference for AIX

## [4.3.7] - 2014-03-28
### Added
- Added gated test and CIS reference for AIX

## [4.3.6] - 2014-03-28
### Added
- Added autoconf6 test and CIS reference for AIX

## [4.3.5] - 2014-03-28
### Added
- Added dhcpsd test and CIS reference for AIX

## [4.3.4] - 2014-03-28
### Added
- Added dhcprd test and CIS reference for AIX

## [4.3.3] - 2014-03-28
### Added
- Added dhcpcd test and CIS reference for AIX

## [4.3.2] - 2014-03-28
### Added
- Added sendmail disable variable

## [4.3.1] - 2014-03-28
### Added
- Added snmp test and CIS reference for AIX

## [4.3.0] - 2014-03-28
### Added
- Added sendmail test and CIS reference for AIX

## [4.2.9] - 2014-03-28
### Added
- Added code to drive rctcp on AIX

## [4.2.8] - 2014-03-27
### Added
- Added Initial TCP Wrappers test and CIS references for AIX

## [4.2.7] - 2014-03-27
### Added
- Added various file/directory permissions tests and CIS references for AIX

## [4.2.6] - 2014-03-27
### Added
- Added snmp and ras permissions test and CIS reference for AIX

## [4.2.5] - 2014-03-27
### Added
- Added /var/adm/sa ownership test and CIS reference for AIX

## [4.2.4] - 2014-03-27
### Added
- Added user home directory tests and CIS references for AIX

## [4.2.3] - 2014-03-27
### Added
- Added serial login test and CIS reference for AIX

## [4.2.2] - 2014-03-27
### Added
- Added i4ls test and CIS reference of AIX

## [4.2.1] - 2014-03-27
### Added
- Added NCS test and CIS reference for AIX

## [4.2.0] - 2014-03-27
### Added
- Added online documentation daemon test and CIS reference for httpdlite on AIX

## [4.1.9] - 2014-03-27
### Added
- Added power management test and CIS reference for AIX

## [4.1.8] - 2014-03-27
### Added
- Added writesrv test and CIS reference for AIX

## [4.1.7] - 2014-03-27
### Added
- Added mesgn test and CIS reference for AIX

## [4.1.6] - 2014-03-27
### Added
- Added sar accounting test and CIS reference for AIX

## [4.1.5] - 2014-03-27
### Added
- Added FTP users test and CIS reference for AIX

## [4.1.4] - 2014-03-27
### Added
- Added FTP daemon umask test and CIS reference for AIX

## [4.1.3] - 2014-03-27
### Added
- Added FTP banner test and CIS reference for AIX

## [4.1.2] - 2014-03-27
### Added
- Added security motd test and CIS reference for AIX

## [4.1.1] - 2014-03-27
### Added
- Added cron/at allow tests and CIS references for AIX

## [4.1.0] - 2014-03-27
### Added
- Added empty password field test and CIS reference for AIX

## [4.0.9] - 2014-03-27
### Added
- Added duplicate user test and CIS reference for AIX

## [4.0.8] - 2014-03-27
### Added
- Added duplicate group test and CIS reference for AIX

## [4.0.7] - 2014-03-27
### Added
- Added root PATH check and CIS reference for AIX

## [4.0.6] - 2014-03-27
### Added
- Added code to check AIX package is installed

## [4.0.5] - 2014-03-27
### Added
- Added Trusted Execution tests and CIS reference for AIX

## [4.0.4] - 2014-03-27
### Added
- Added Trusted Execution handling code for AIX

## [4.0.3] - 2014-03-26
### Added
- Added setuid files test and CIS reference for AIX

## [4.0.2] - 2014-03-26
### Added
- Added unowned files test and CIS reference for AIX

## [4.0.1] - 2014-03-26
### Added
- Added world writable files test and CIS reference for AIX

## [4.0.0] - 2014-03-26
### Added
- Added rcnfs test and CIS reference for AIX

## [3.9.9] - 2014-03-26
### Added
- Added dt test and CIS reference for AIX

## [3.9.8] - 2014-03-26
### Added
- Added lpd and piobe test and CIS reference for AIX

## [3.9.7] - 2014-03-26
### Added
- Added qdaemon test and CIS reference for AIX

## [3.9.6] - 2014-03-26
### Added
- Added code to drive [rm,ls,ch]itab on AIX

## [3.9.5] - 2014-03-26
### Added
- Added system user rlogin test and CIS reference for AIX

## [3.9.4] - 2014-03-26
### Added
- Added code to drive chuser and added su group test and CIS reference for AIX

## [3.9.3] - 2014-03-26
### Added
- Added rlogin test and CIS reference for AIX

## [3.9.2] - 2014-03-26
### Added
- Added login retry limit test and CIS references for AIX

## [3.9.1] - 2014-03-26
### Added
- Added password parameter tests and CIS references for AIX

## [3.9.0] - 2014-03-26
### Added
- Added initial AIX support

## [3.8.9] - 2014-03-26
### Added
- Added X wrapper test and CIS reference for FreeBSD

## [3.8.8] - 2014-03-26
### Added
- Added single user password test and CIS reference for FreeBSD

## [3.8.7] - 2014-03-26
### Added
- Added serial logins test and CIS reference for FreeBSD

## [3.8.6] - 2014-03-26
### Added
- Added password algorithm test and CIS reference for FreeBSD

## [3.8.5] - 2014-03-26
### Added
- Added mesg n test and CIS reference for FreeBSD

## [3.8.4] - 2014-03-26
### Added
- Added umask test and CIS reference for FreeBSD

## [3.8.3] - 2014-03-26
### Added
- Added uid 0 test and CIS reference for FreeBSD

## [3.8.2] - 2014-03-26
### Added
- Added toor account test and CIS reference for FreeBSD

## [3.8.1] - 2014-03-26
### Added
- Added system account test and CIS reference for FreeBSD

## [3.8.0] - 2014-03-26
### Added
- Added X11 listen test and CIS reference for FreeBSD

## [3.7.9] - 2014-03-25
### Added
- Added security banner test and CIS references for FreeBSD

## [3.7.8] - 2014-03-25
### Added
- Added cron/at test and CIS references for FreeBSD

## [3.7.7] - 2014-03-25
### Added
- Added dotfiles test and CIS reference for FreeBSD

## [3.7.6] - 2014-03-25
### Added
- Added initial PAM test and CIS reference for FreeBSD

## [3.7.5] - 2014-03-25
### Added
- Added unowned files test and CIS reference for FreeBSD

## [3.7.4] - 2014-03-25
### Added
- Added user homde directory permissions test and CIS reference for FreeBSD

## [3.7.3] - 2014-03-25
### Added
- Added suid and sgid files test and CIS reference for FreeBSD

## [3.7.2] - 2014-03-25
### Added
- Added world writable files test and CIS reference for FreeBSD

## [3.7.1] - 2014-03-25
### Added
- Added sticky bit test and CIS reference for FreeBSD

## [3.7.0] - 2014-03-25
### Added
- Added passwd and group permissions test and CIS reference for FreeBSD

## [3.6.9] - 2014-03-25
### Added
- Added nosuid mount test and CIS reference for FreeBSD

## [3.6.8] - 2014-03-25
### Added
- Added newsyslog and CIS reference for FreeBSD

## [3.6.7] - 2014-03-25
### Added
- Added TCP/UDP packet logging code and CIS reference for FreeBSD

## [3.6.6] - 2014-03-25
### Added
- Added system accounting code and CIS reference for FreeBSD

## [3.6.5] - 2014-03-25
### Added
- Added syslog logging entry and CIS reference for FreeBSD while fixing bug with Syslog server code

## [3.6.4] - 2014-03-25
### Added
- Added kernel parameters code and CIS reference for FreeBSD

## [3.6.3] - 2014-03-25
### Added
- Added core dump test and CIS reference for FreeBSD

## [3.6.2] - 2014-03-25
### Added
- Added printing test and CIS reference for FreeBSD

## [3.6.1] - 2014-03-25
### Added
- Added NIS test and CIS reference for FreeBSD

## [3.6.0] - 2014-03-25
### Added
- Added NFS test and CIS reference for FreeBSD

## [3.5.9] - 2014-03-25
### Added
- Added bind test and CIS reference for FreeBSD

## [3.5.8] - 2014-03-25
### Added
- Added sendmail test and CIS reference for FreeBSD

## [3.5.7] - 2014-03-25
### Added
- Added syslog and CIS reference for FreeBSD

## [3.5.6] - 2014-03-25
### Added
- Added daemon umask test and CIS reference for FreeBSD

## [3.5.5] - 2014-03-25
### Added
- Added inet/init code and CIS reference for FreeBSD

## [3.5.4] - 2014-03-25
### Added
- Added ipfw code and CIS reference for FreeBSD

## [3.5.3] - 2014-03-25
### Added
- Added CIS reference for FreeBSD for TCP Wrappers and added inetd flag test for FreeBSD

## [3.5.2] - 2014-03-25
### Added
- Added FreeBSD support and CIS reference to SSH test

## [3.5.1] - 2014-03-25
### Added
- Added rc.conf and loader.conf support to file functions

## [3.5.0] - 2014-03-25
### Added
- Initial FreeBSD support

## [3.4.9] - 2014-03-25
### Added
- Added code to disable mDNS on OS X

## [3.4.8] - 2014-03-25
### Added
- Added Xgrid check

## [3.4.7] - 2014-03-25
### Added
- Added CIS reference for SSH for OS X

## [3.4.6] - 2014-03-25
### Added
- Added apache config lockdown tests

## [3.4.5] - 2014-03-25
### Added
- Added samba config lockdown tests

## [3.4.4] - 2014-03-25
### Changed
- Improved launchctl function to be able to turn off and on services

## [3.4.3] - 2014-03-25
### Added
- Added code to add NTP pool servers to config file

## [3.4.2] - 2014-03-25
### Added
- Added CIS NTP reference for OS X

## [3.4.1] - 2014-03-25
### Added
- Added firmware password test for OS X

## [3.4.0] - 2014-03-25
### Fixed
- Fixed printer sharing test for OS X

## [3.3.9] - 2014-03-25
### Fixed
- Fixed CD sharing test for OS X

## [3.3.8] - 2014-03-25
### Fixed
- Fixed screen lock test for OS X

## [3.3.7] - 2014-03-25
### Added
- Added CIS reference for user .forward test

## [3.3.6] - 2014-03-24
### Added
- Added CIS reference for duplicate users test

## [3.3.5] - 2014-03-24
### Added
- Added CIS reference for duplicate gids test

## [3.3.4] - 2014-03-24
### Added
- Added CIS reference for duplicate ids test

## [3.3.3] - 2014-03-24
### Added
- Added CIS reference for group test

## [3.3.2] - 2014-03-24
### Added
- Added CIS reference for user .rhosts test

## [3.3.1] - 2014-03-24
### Added
- Added CIS reference for user .netrc test

## [3.3.0] - 2014-03-24
### Added
- Added CIS reference for user dot files test

## [3.2.9] - 2014-03-24
### Added
- Added CIS reference for user home permissions test

## [3.2.8] - 2014-03-24
### Added
- Added CIS reference for root path test

## [3.2.7] - 2014-03-24
### Added
- Added CIS reference for reserved id test

## [3.2.6] - 2014-03-24
### Added
- Added CIS reference for legacy NIS entries test

## [3.2.5] - 2014-03-24
### Added
- Added CIS reference for password field test

## [3.2.4] - 2014-03-24
### Added
- Added CIS reference for suid system executables test

## [3.2.3] - 2014-03-24
### Added
- Added CIS reference for unowned file check

## [3.2.2] - 2014-03-24
### Added
- Added CIS reference for world writable files test

## [3.2.1] - 2014-03-24
### Added
- Added code to test Gnome login message on Linux

## [3.2.0] - 2014-03-24
### Added
- Added CIS reference for user default umask test

## [3.1.9] - 2014-03-24
### Added
- Added CIS reference for default root group test

## [3.1.8] - 2014-03-24
### Added
- Added CIS reference for system account test

## [3.1.7] - 2014-03-24
### Added
- Added CIS reference for password expiry test

## [3.1.6] - 2014-03-24
### Added
- Added CIS reference for pam wheel test

## [3.1.5] - 2014-03-24
### Added
- Added CIS reference for remote console test

## [3.1.4] - 2014-03-24
### Added
- Added CIS reference for password reuse test

## [3.1.3] - 2014-03-24
### Added
- Added CIS reference for account lockout timeout test

## [3.1.2] - 2014-03-24
### Added
- Added CIS reference to password policy test

## [3.1.1] - 2014-03-24
### Added
- Added CIS reference to password hashing algorithm test

## [3.1.0] - 2014-03-24
### Added
- Added CIS reference to SSH test

## [3.0.9] - 2014-03-24
### Changed
- Cleaned up crow.allow test and added CIS reference

## [3.0.8] - 2014-03-24
### Added
- Added CIS reference to cron permissions check

## [3.0.7] - 2014-03-24
### Added
- Added iptables check

## [3.0.6] - 2014-03-23
### Added
- Added CIS references to TCP wrappers check

## [3.0.5] - 2014-03-23
### Added
- Added CIS references to sysctl check

## [3.0.4] - 2014-03-23
### Added
- Added CIS references to logrotate check

## [3.0.3] - 2014-03-23
### Added
- Added CIS references to system accounting check

## [3.0.2] - 2014-03-23
### Added
- Added code to install and configure rsyslog on Linux

## [3.0.1] - 2014-03-23
### Added
- Added CIS reference to Postfix check and code to check local-only agent mode on Linux

## [3.0.0] - 2014-03-23
### Added
- Added CIS reference to SNMP check and code to remove package on Linux

## [2.9.9] - 2014-03-23
### Added
- Added CIS reference to Squid server check and code to remove package on Linux

## [2.9.8] - 2014-03-23
### Added
- Added CIS reference to Samba server check and code to remove package on Linux

## [2.9.7] - 2014-03-23
### Added
- Added CIS reference for Dovecot check and code to remove package on Linux

## [2.9.6] - 2014-03-23
### Added
- Added CIS reference to HTTP server check and code to remove package on Linux

## [2.9.5] - 2014-03-23
### Added
- Added CIS reference to FTP server check and code to remove package on Linux

## [2.9.4] - 2014-03-23
### Added
- Added package uninstall disable/enable variable

## [2.9.3] - 2014-03-23
### Added
- Added CIS reference to NIS server check and code to remove package on Linux

## [2.9.2] - 2014-03-23
### Changed
- Minor bug fixes

## [2.9.1] - 2014-03-21
### Added
- Added CIS reference for NFS check

## [2.9.0] - 2014-03-21
### Added
- Added code to remove openldap-servers package on Linux

## [2.8.9] - 2014-03-21
### Added
- Added CIS reference for NTP

## [2.8.8] - 2014-03-21
### Added
- Added code to remove dhcp server package on Linux

## [2.8.7] - 2014-03-21
### Changed
- Moved Avahi server code to separate module and added CIS reference

## [2.8.6] - 2014-03-21
### Fixed
- Fixed bugs with OS vendor determination

## [2.8.5] - 2014-03-21
### Added
- Added code to remove X Windows package on Linux

## [2.8.4] - 2014-03-21
### Added
- Added CIS reference for daemon umask check

## [2.8.3] - 2014-03-21
### Added
- Added CIS references for various xinetd based services for Linux

## [2.8.2] - 2014-03-21
### Added
- Added code to remove xinetd-server package on Linux

## [2.8.1] - 2014-03-21
### Added
- Added code to remove talk-server package on Linux

## [2.8.0] - 2014-03-21
### Added
- Added /etc/netboot check for Solaris 11

## [2.7.9] - 2014-03-21
### Added
- Added code to remove tftp-server package on Linux

## [2.7.8] - 2014-03-21
### Added
- Added code to remove YP/NIS server packages on Linux

## [2.7.7] - 2014-03-21
### Added
- Added code to remove rsh-server on package Linux

## [2.7.6] - 2014-03-21
### Added
- Added code to remove telnet-server package on Linux

## [2.7.4] - 2014-03-21
### Added
- Added execshield check

## [2.7.3] - 2014-03-21
### Added
- Added core dumps restriction to Linux and added CIS reference

## [2.7.2] - 2014-03-21
### Added
- Added CIS reference to single user mode test

## [2.7.1] - 2014-03-21
### Added
- Added permissions check for /etc/grub to SELinux test

## [2.7.0] - 2014-03-21
### Added
- Added CIS reference to unconfined daemons test

## [2.6.9] - 2014-03-20
### Changed
- Updated SELinux check

## [2.6.8] - 2014-03-20
### Added
- Added support to old users check to use last rather than finger if finger is not available

## [2.6.7] - 2014-03-20
### Changed
- Moved grouped function files to full_* to better distinguish them

## [2.6.8] - 2014-03-20
### Added
- Added aide check for Linux

## [2.6.7] - 2014-03-20
### Fixed
- Fixed system log check

## [2.6.6] - 2014-03-20
### Added
- Added nosuid filesystem mount check for Linux

## [2.6.5] - 2014-03-19
### Added
- Added swap to nodev check

## [2.6.4] - 2014-03-19
### Changed
- More bug fixes

## [2.6.3] - 2014-03-19
### Changed
- Improved ability to run script as non root user in audit only mode

## [2.6.2] - 2014-03-19
### Changed
- Various bug fixes

## [2.6.1] - 2014-03-19
### Fixed
- Fixed bug with gatekeeper and wake on lan check

## [2.6.0] - 2014-03-19
### Fixed
- Fixed bug with launchctl check

## [2.5.9] - 2014-03-19
### Added
- Added Safari Auto-run check for OS X

## [2.5.8] - 2014-03-19
### Added
- Added file extensions check for OS X

## [2.5.7] - 2014-03-19
### Added
- Added CIS reference for guest file sharing check for OS X

## [2.5.6] - 2014-03-19
### Added
- Added CIS reference for guest account check for OS X

## [2.5.5] - 2014-03-19
### Added
- Added password hints check for OS X

## [2.5.4] - 2014-03-19
### Added
- Added CIS reference to account login details check for OS X

## [2.5.3] - 2014-03-19
### Added
- Added password complexity checks for OS X

## [2.5.2] - 2014-03-19
### Added
- Added pwpolicy function for OS X

## [2.5.1] - 2014-03-19
### Added
- Added autologout check for OS X

## [2.5.0] - 2014-03-19
### Added
- Added autologin check for OS X

## [2.4.9] - 2014-03-19
### Added
- Added user home directory permisions check for OS X

## [2.4.8] - 2014-03-18
### Added
- Added Keychain Lock time check for OS X

## [2.4.7] - 2014-03-18
### Added
- Added sudo timeout check

## [2.4.6] - 2014-03-18
### Added
- Added code to check bonjour advertising on OS X

## [2.4.5] - 2014-03-18
### Added
- Added code to check system log retention on OS X

## [2.4.4] - 2014-03-18
### Changed
- Cleaned up some code

## [2.4.3] - 2014-03-18
### Added
- Added OX Security Auditing check

## [2.4.2] - 2014-03-18
### Changed
- Cleaned up some defaults checks for OS X

## [2.4.1] - 2014-03-18
### Added
- Added Secure Empty Trash check for OS X

## [2.4.0] - 2014-03-18
### Added
- Added Secure Keyboard Entry check for OS X

## [2.3.9] - 2014-03-18
### Changed
- Updated CIS reference for firewall settings fo OS X

## [2.3.8] - 2014-03-18
### Added
- Added Safe Downloads list check for OS X

## [2.3.7] - 2014-03-17
### Added
- Added Gatekeeper check for OS X

## [2.3.6] - 2014-03-17
### Added
- Added File Vault check for OS X

## [2.3.5] - 2014-03-17
### Added
- Added Wake on Lan check for OS X

## [2.3.4] - 2014-03-17
### Added
- Added DVD/CDo sharing check for OS X

## [2.3.3] - 2014-03-17
### Added
- Added SSH check for OS X

## [2.3.2] - 2014-03-17
### Added
- Added hot corner check to screen lock check for OS X

## [2.3.1] - 2014-03-17
### Added
- Added Printer Sharing code for OS X

## [2.3.0] - 2014-03-14
### Added
- Added Account Lockout code for OS X

## [2.2.9] - 2014-03-14
### Added
- Added Internet Sharing code for OS X

## [2.2.8] - 2014-03-13
### Added
- Added Apple Remote Events code for OS X

## [2.2.7] - 2014-03-13
### Fixed
- Fixed Launchctl check for OS X

## [2.2.6] - 2014-03-13
### Fixed
- Fixed Login Warning for OS X

## [2.2.5] - 2014-03-12
### Changed
- Various typo fixes

## [2.2.4] - 2014-02-20
### Changed
- Split code out to be more manageable

## [2.2.3] - 2014-01-15
### Changed
- Minor bug fixes

## [2.2.2] - 2014-01-15
### Fixed
- Fixed bug with shadow check on OS X

## [2.2.1] - 2013-10-10
### Fixed
- Fixed security banner check scoring

## [2.2.0] - 2013-10-10
### Fixed
- Fixed scoring for file permissions check

## [2.1.9] - 2013-10-10
### Fixed
- Fixed output for check that file ${exists}

## [2.1.8] - 2013-10-10
### Fixed
- Fixed console report on Solaris

## [2.1.7] - 2013-10-09
### Fixed
- Fixed scoring on inactive user account check

## [2.1.6] - 2013-10-09
### Fixed
- Fixed message for inactive user account check

## [2.1.5] - 2013-10-09
### Fixed
- Fixed two SunOS checks

## [2.1.4] - 2013-10-09
### Fixed
- Fixed set command on Solaris

## [2.1.3] - 2013-10-09
### Fixed
- Fixed other grep commands

## [2.1.2] - 2013-10-09
### Fixed
- Fixed grep command in audit_shells

## [2.1.1] - 2013-10-09
### Added
- Added check for disabled account to system account check

## [2.1.0] - 2013-10-09
### Fixed
- Fixed "==" evaluation

## [2.0.9] - 2013-10-09
### Fixed
- Fixed source on Solaris

## [2.0.8] - 2013-10-09
### Fixed
- Fixed call to check_inetd_service

## [2.0.7] - 2013-10-09
### Fixed
- Fixed id check under Solaris

## [2.0.6] - 2013-10-09
### Changed
- Moved directory check

## [2.0.5] - 2013-09-21
### Changed
- Improved linux password history audit

## [2.0.4] - 2013-09-20
### Changed
- Cleaned up linux PAM audit

## [2.0.3] - 2013-09-20
### Added
- Added better handling for *credit password parameters under Linux

## [2.0.2] - 2013-09-18
### Added
- Added RSA SecurID PAM check

## [2.0.1] - 2013-09-17
### Changed
- Improved SNMP daemon check on Linux

## [2.0.0] - 2013-09-17
### Changed
- Numerous bug fixes

## [1.9.9] - 2013-09-17
### Fixed
- Fixed scoring for System Account audit

## [1.9.8] - 2013-09-17
### Changed
- Improved checking for old user logins

## [1.9.7] - 2013-09-17
### Fixed
- Fixed scoring for old user logins test

## [1.9.6] - 2013-09-17
### Fixed
- Fixed scoring in reserved UID check

## [1.9.5] - 2013-09-16
### Fixed
- Fixed scoring for empty password field testing

## [1.9.4] - 2013-09-16
### Fixed
- Fixed scoring for root PATH check

## [1.9.3] - 2013-09-16
### Fixed
- Fix dot file checking

## [1.9.2] - 2013-09-16
### Fixed
- Fixed home directory permissions check

## [1.9.1] - 2013-09-16
### Added
- Added fix information to root SSH key check

## [1.9.0] - 2013-09-16
### Fixed
- Fixed scoring on root group check

## [1.8.9] - 2013-09-16
### Fixed
- Fixed logrotate check

## [1.8.8] - 2013-09-16
### Fixed
- Bug fixes

## [1.8.7] - 2013-09-12
### Added
- Added ability to load modules

## [1.8.6] - 2013-09-03
### Added
- Added check to make sure shells in /etc/shells exist

## [1.8.5] - 2013-09-03
### Added
- Added check for LoginGraceTime 120 in /etc/ssh/sshd_config

## [1.8.4] - 2013-09-03
### Added
- Added check for PrintMotd no in /etc/ssh/sshd_config

## [1.8.3] - 2013-09-03
### Added
- Added check for UsePrivilegeSeparation yes in /etc/ssh/sshd_config

## [1.8.2] - 2013-09-03
### Added
- Added check for MINDIGIT = 1 in /etc/default/passwd

## [1.8.1] - 2013-09-03
### Added
- Added check for SYSLOG = YES in /etc/default/su

## [1.8.0] - 2013-08-31
### Added
- Added check for PASSREQ = YES in /etc/default/login

## [1.7.9] - 2013-08-30
### Added
- Added restore function to wheel checks

## [1.7.8] - 2013-08-30
### Added
- Added code to check wheel group users

## [1.7.7] - 2013-08-30
### Added
- Added default crypto check

## [1.7.6] - 2013-08-29
### Added
- Added check for users that have never logged in to make sure accounts are locked

## [1.7.5] - 2013-08-29
### Added
- Added su wheel group check

## [1.7.4] - 2013-08-25
### Fixed
- Fixed ssh key check code

## [1.7.3] - 2013-08-21
### Added
- Added check for LOG_FROM_REMOTE=NO in /etc/default/syslogd for Solaris

## [1.7.2] - 2013-08-21
### Added
- Added DISABLETIME flag to /etc/default/login check for Solaris

## [1.7.1] - 2013-08-21
### Added
- Added check for SYSLOG=YES in /etc/default/login for Solaris

## [1.7.0] - 2013-08-21
### Added
- Added check for root SSH keys

## [1.6.9] - 2013-06-13
### Changed
- support

## [1.6.8] - 2013-06-13
### Added
- Added Postfix check

## [1.6.7] - 2013-06-13
### Added
- Added Cyrus and Qpopper check

## [1.6.6] - 2013-06-13
### Added
- Added OS X support

## [1.6.5] - 2013-06-12
### Added
- Added inital SUSE support

## [1.6.4] - 2013-06-12
### Fixed
- Fixed NTP test and added audit test information

## [1.6.3] - 2013-06-11
### Changed
- Updated documentation and added verbose mode

## [1.6.2] - 2013-06-09
### Changed
- Improved documentation

## [1.6.1] - 2013-06-09
### Added
- Added some file checks

## [1.6.0] - 2013-05-25
### Changed
- Improved Debian/Ubuntu support

## [1.5.9] - 2013-05-25
### Changed
- Improved Debian/Ubuntu support

## [1.5.8] - 2013-05-24
### Changed
- Improved Debian/Ubuntu support

## [1.5.7] - 2013-05-24
### Added
- Initial Debian/Ubuntu support

## [1.5.6] - 2013-05-03
### Fixed
- Fixed minor bug with for loop

## [1.5.5] - 2013-02-22
### Changed
- Cleaned up code for selective audit

## [1.5.4] - 2013-02-21
### Added
- Added rpm check code

## [1.5.3] - 2013-02-21
### Changed
- Improved code to fix cron

## [1.5.2] - 2013-02-21
### Fixed
- Fixed code to update files

## [1.5.1] - 2013-02-20
### Fixed
- Fixed file append function

## [1.5.0] - 2013-02-20
### Added
- Added handling for [at,cron].[deny,allow]

## [1.4.9] - 2013-02-20
### Added
- Added system account shell check

## [1.4.8] - 2013-02-20
### Added
- Added root primary group audit

## [1.4.7] - 2013-02-20
### Changed
- Simplified RPM verify routine

## [1.4.6] - 2013-02-19
### Added
- Added lockout for failed password attempts

## [1.4.5] - 2013-02-19
### Added
- Added yum config check

## [1.4.4] - 2013-02-19
### Added
- Added selinux

## [1.4.3] - 2013-02-19
### Added
- Added selective function to run individual tests

## [1.4.2] - 2013-02-19
### Added
- Added code to check NTP running as ntp user

## [1.4.1] - 2013-02-19
### Added
- Added sendmail local-only mode check

## [1.4.0] - 2013-02-19
### Added
- Added modprobe.conf check

## [1.3.9] - 2013-02-19
### Added
- Added module loading and mounting to auditd

## [1.3.8] - 2013-02-19
### Added
- Added logrotate configuration

## [1.3.7] - 2013-02-19
### Added
- Added Cipher directive to SSH config

## [1.3.6] - 2013-02-19
### Added
- Added password strength testing on Linux

## [1.3.5] - 2013-02-19
### Added
- Added file verification for Linux

## [1.3.4] - 2013-02-18
### Changed
- Improved file octal derivation on Solaris

## [1.3.3] - 2013-02-18
### Added
- Added X11 nolisten

## [1.3.2] - 2013-02-18
### Added
- Added Linux FDI audit

## [1.3.1] - 2013-02-18
### Added
- Added Linux nodev audit

## [1.3.0] - 2013-02-18
### Added
- Added gdm.conf audit

## [1.2.9] - 2013-02-18
### Added
- Added Linux core dumps and rhosts for PAM

## [1.2.8] - 2013-02-18
### Added
- Added X11 warning messages

## [1.2.7] - 2013-02-18
### Added
- Added warning banners

## [1.2.6] - 2013-02-17
### Added
- Added auditd config

## [1.2.5] - 2013-02-17
### Added
- Added securetty check for Linux

## [1.2.4] - 2013-02-17
### Added
- Added code for vsftpd banner

## [1.2.3] - 2013-02-17
### Added
- Added code for sendmail greeting

## [1.2.2] - 2013-02-16
### Added
- Added pam options for Linux

## [1.2.1] - 2013-02-16
### Changed
- Updated file update to support tabs

## [1.2.0] - 2013-02-16
### Added
- Added ftpd logging checking for Linux

## [1.1.9] - 2013-02-16
### Added
- Added sysctl audit for Linux

## [1.1.8] - 2013-02-15
### Changed
- Linux xinetd and chkconfig support added

## [1.1.7] - 2013-02-14
### Added
- Initial Linux support

## [1.1.6] - 2012-12-22
### Changed
- Updated documentation

## [1.1.5] - 2012-12-22
### Fixed
- Fixed Solaris 9 update version detection

## [1.1.4] - 2012-12-22
### Fixed
- Fixed bug with inetd code

## [1.1.3] - 2012-12-22
### Fixed
- Fixed bug with home directory check

## [1.1.2] - 2012-12-22
### Fixed
- Fixed bugs with parameter value checking

## [1.1.1] - 2012-12-21
### Added
- Initial Solaris 9 testing completed

## [1.1.0] - 2012-12-20
### Changed
- Cleaned up formating

## [1.0.9] - 2012-12-20
### Added
- Added -A and -L switches and moved filesystem searches to it

## [1.0.8] - 2012-12-20
### Fixed
- Fixed problem with inetadm command

## [1.0.7] - 2012-11-19
### Added
- Added initial support for Solaris versions less than 10

## [1.0.6] - 2012-11-19
### Changed
- Solaris 10 and 11 support mostly done - some minor additions could be made

## [1.0.5] - 2012-11-17
### Added
- Added echo services

## [1.0.4] - 2012-11-16
### Changed
- Updated Solaris 11 support, Initial re-commit to new repository

## [1.0.3] - 2012-11-15
### Added
- Initial Solaris 11 support

## [1.0.2] - 2012-11-12
### Changed
- Additional cleanup

## [1.0.1] - 2012-11-12
### Changed
- Formating fixes

## [1.0.0] - 2012-11-12
### Added
- Initial Github Commit

## [0.0.4] - 2012-11-10
### Added
- Added kernel accounting

## [0.0.3] - 2012-11-08
### Added
- Added restore code

## [0.0.2] - 2012-11-02
### Added
- Created subroutines for updating files and parameters

## [0.0.1] - 2012-11-01
### Added
- Added initial audit code

## [0.0.0] - 2012-10-25
### Added
- Initial version
