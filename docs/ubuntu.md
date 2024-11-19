## Ubuntu Upgrade Guide

To perform a **quiet upgrade** of Ubuntu, follow the steps below to configure the system and execute the upgrade process.

### 1. Configure `apt` for Non-Interactive Operation

Create a configuration file named `/etc/apt/apt.conf.d/local` with the following content:

```plaintext
Dpkg::Options {
   "--force-confdef";  # Use default options for modified configuration files
   "--force-confold";  # Keep the current configuration files
};
APT::Get::Assume-Yes "true";  # Automatically answer 'yes' to all prompts
```

This ensures that the upgrade process proceeds without user interaction, applying default or existing configurations.

### 2. Run the Upgrade Command

Execute the upgrade with the following command:

```bash
do-release-upgrade --frontend=DistUpgradeViewNonInteractive
```

This will:
- Perform a distribution upgrade.
- Use the **non-interactive frontend**, ensuring no user prompts disrupt the process.

### Notes:

- **Backup**: Always back up important data before upgrading your system to avoid data loss in case of unexpected issues.
- **Reboot**: After the upgrade, a system reboot may be required to complete the process.
- **Logs**: The upgrade process logs can be reviewed in `/var/log/dist-upgrade/` for troubleshooting if any issues arise.
