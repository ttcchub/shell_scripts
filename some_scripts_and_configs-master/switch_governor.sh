#!/bin/sh

set -e


ARG=$1

# If no arguments where specified, guess, what the current power mode is
if [ -z "$ARG" ]; then
	if [ `cat /sys/class/power_supply/ACAD/online` -eq 1 ]; then
		ARG=performance
	else
		ARG=powersave
	fi
fi


# Choose governor based on the argument (either specified or guessed)
case "$ARG" in
	performance)
		GOVERNOR=performance
		;;
	powersave)
		GOVERNOR=powersave
		;;
	*)
		echo "Incorrect cmd-line argument" 1>&2
		exit 101
		;;
esac


# Set governor
for i in $(seq 0 $((`nproc` - 1)))  # Not `nproc --ignore`, because there could be just one cpu
do
	sudo cpufreq-set --cpu $i --governor $GOVERNOR;
done
