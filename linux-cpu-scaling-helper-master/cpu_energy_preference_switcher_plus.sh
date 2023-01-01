#!/bin/bash

# The name of this file is quite long and hard to type quickly. When putting to my machine,
# I typically rename it to something shorter, e.g. just "cpu"


GLOBAL_DIR="/sys/devices/system/cpu/cpufreq/"


# FIXME: Help message looks bad when printed out
HELP_MESSAGE="This utility allows you to switch CPU energy performance preference.
\n\n
It interacts with the files located in the directories /sys/devices/system/cpu/cpufreq/policy\*
\n\n\n
The following usages are available:
\n\n
$0 help - display this help message and exit
\n\n
$0 list - get available performance preferences (print the energy_performance_available_preferences file of policy0)
\n\n
$0 get_current - get currently selected performance preferences of all policies (contents of the
energy_performance_preference files)
\n\n
$0 get - synonym of get_current
\n\n
$0 set <performance_mode> - write <performance_mode> to the energy_performance_preference files of all policies
\n\n
$0 extreme - (extreme powersave mode) force constant lowest possible frequency: set frequency upper limit to the
lowest value alowed by hardware (copy contents of cpuinfo_min_freq to file scaling_max_freq for each policy)
\n\n
$0 unextreme - reset frequency upper limit (back?) to the highest value allowed by hardware (copy contents of
cpuinfo_max_freq to file scaling_max_freq for each policy)
"

# WARNING: there must be write permissions for the
# `/sys/devices/system/cpu/cpufreq/policy*/{energy_performance_preference,scaling_max_freq}` files for this script in
# order to work correctly

case "$1" in
	""|help|-h|--help)
		exec echo -e "$HELP_MESSAGE"
		;;
	list)
		exec cat $GLOBAL_DIR/policy0/energy_performance_available_preferences
		;;
	get_current|get)
		# Using `tail -n +0` instead of `cat` to have filenames printed
		exec tail -n +0 $GLOBAL_DIR/policy*/energy_performance_preference
		;;
	set)
		echo "$2" | tee "$GLOBAL_DIR"/policy*/energy_performance_preference
		exit $?
		;;
	extreme)
		for policy in $GLOBAL_DIR/policy*; do
			# Forcefully disallow any freequency changes
			cat "$policy/cpuinfo_min_freq" > "$policy/scaling_max_freq"
		done
		;;
	unextreme)
		for policy in $GLOBAL_DIR/policy*; do
			cat "$policy/cpuinfo_max_freq" > "$policy/scaling_max_freq"
		done
		;;
	*)
		echo "Error: unknown command. See help (run \`$0 help\`)" 1>&2
		exit 101
		;;
esac
