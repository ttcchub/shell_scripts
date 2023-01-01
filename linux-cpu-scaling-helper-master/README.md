# CPU energy preference switcher (plus)

This tool lets you switch performance preferences for a CPU on Linux with cpufreq driver
(`cpufreq-utils` is not needed). Features:

-  Get current modes for CPU cores
-  Set new mode for all cores
-  Switch to "extreme powersave mode": force the lowest possible frequency for all cores

## Preparation (running manually)

To use the script, you should have write permissions on a couple of files inside /sys. You can either
always run the script as root, or create a group and give it appropriate permissions. For the latter:

1.  Create a new group: `groupadd cpu_tuners`
2.  Add user(s) to it: `usermod -aG cpu_tuners $USER`
3.  Create a systemd service to give permissions:
    -  Put the service file to /etc/systemd/system/
    -  Run `systemctl enable --now update_sysfs_cpu_permissions.service` (you need that because the
       permissions of virtual files are reset on every reboot)

## Preparation (running automatically when charger state is changed)

TODO: This section is coming soon (if you need this, just ping me in the issues)

## Usage

Just run the script! Examples:
```
./cpu_energy_preference_switcher.sh get          # View current preferences
./cpu_energy_preference_switcher.sh list        # List valid options for `set` (for the first core)
./cpu_energy_preference_switcher.sh set default  # Set a mode for all cores
./cpu_energy_preference_switcher.sh extreme      # Enter extreme powersave mode (force lowest possible frequency)
./cpu_energy_preference_switcher.sh unextreme    # Exit extreme powersave mode
```
