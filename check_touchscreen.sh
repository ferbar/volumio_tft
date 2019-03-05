#!/bin/bash

#Event: time 1551643730.945362, -------------- EV_SYN ------------
#Event: time 1551643730.975349, type 3 (EV_ABS), code 0 (ABS_X), value 2259
#Event: time 1551643730.975349, type 3 (EV_ABS), code 1 (ABS_Y), value 1623

event_device=$(grep -A 4 ADS7846 /proc/bus/input/devices | grep -o -P 'event\d' )
if [ -z "$event_device" ] ; then
	echo "Error: event * not found - ADS7846 module loaded?"
	exit 1
fi

X=0
Y=0

while true ; do
	while read line ; do
		echo "<<<<$line>>>>>"
		if echo $line | grep -q -e '-------------- EV_SYN ------------' ; then
			echo "X:$X Y:$Y"
			break;
		fi
		regex='type [0-9]+ \(([A-Z_]+)\), code [0-9]+ \(([A-Z_]+)\), value ([0-9]+)'
		if [[ $line =~ $regex ]] ; then
			#echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]} ${BASH_REMATCH[3]}"
			type="${BASH_REMATCH[1]}"
			code="${BASH_REMATCH[2]}"
			value="${BASH_REMATCH[3]}"
			echo "type:$type code:$code value:$value"
			case $type in 
				"EV_ABS")
					case $code in
						"ABS_X")
							X=$value
							;;
						"ABS_Y")
							Y=$value
							;;
					esac
					;;
				"EV_KEY")
					case $code in
						"BTN_TOUCH")
							if [[ "$value" == 0 ]] ; then
								echo "ABS_PRESSURE"
								curl -s 'localhost:3000/api/v1/commands/?cmd=toggle'
							fi
						;;
					esac
					;;

			esac

		else
			echo "Error: no match"
		fi
		# 330 (BTN_TOUCH), value 1
	done

done < <(evtest /dev/input/$event_device)
