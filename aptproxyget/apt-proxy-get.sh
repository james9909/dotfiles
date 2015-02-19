#!/bin/bash
while getopts "carh" opt; do
	case $opt in
		c)
			if [ -e "/etc/apt/apt.conf.d/01proxy" ]; then
				echo "/etc/apt/apt.conf.d/01proxy exists."
				echo "Contents: "
				cat /etc/apt/apt.conf.d/01proxy
			else
				echo "/etc/apt/apt.conf.d/01proxy does not currently exist"
			fi
			;;
		a)
                        sudo cp ~/.aptproxyget/01proxy.aptproxyget.data /etc/apt/apt.conf.d/01proxy
			;;
		r)
                        if [ -e "/etc/apt/apt.conf.d/01proxy" ]; then
                                sudo rm /etc/apt/apt.conf.d/01proxy
                        else
                                echo "/etc/apt/apt.conf.d/01proxy does not exist"
                        fi
			;;
		h)
			echo "Commands:"
			echo "          -c              Checks /etc/apt/apt.conf.d/01proxy existence and outputs the contents of the file"
			echo "          -a              Adds /etc/apt/apt.conf.d/01proxy and the rules for the NYCBOE proxy"
			echo "          -r              Removed /etc/apt/apt.conf.d/01proxy if it exists"
			echo "          -h              Displays this message"
			;;
	esac
done
