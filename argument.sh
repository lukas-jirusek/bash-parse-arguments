#!/bin/bash

# defaultSetting:
showHelp=0
showVersion=0
output='~/default'

# parse arguments:
awaitingArgument=0
anotherArguments=''	
for i in $(seq $#)
do	
	previousArg="$arg"
	arg=$(echo ${!i})
	argCharOne=$(echo "$arg" | head -c 1)
	argCharTwo=$(echo "$arg" | head -c 2 | tail -c 1)

	if [[ $awaitingArgument -eq 1 ]]
	then
		if [[ "$argCharOne" == '-' || -z "$arg" ]]
		then 
			echo 'Option: '"$previousArg"' requires argument.'
			exit 5
		else
			output="$arg"
			awaitingArgument=0
		fi
	else
		if [[ "$argCharOne" == '-' ]]
		then	
			case "$arg" in
			-h | --help )						# bez argumentu
				showHelp=1
			;;
			-v | --version )
				showVersion=1
			;;
			-o | --output )						# s argumentem
				if [[ $i -eq $# ]]
				then
					echo 'Option: '"$arg"' requires argument.'
					exit 5
				else
					awaitingArgument=1
				fi
			;;
			* )
				echo 'Unknown option: '"$arg"'. To show help, start with --help.'
				exit 5
			;; 
			esac
		else
			if [[ -z $anotherArguments ]]
			then
				anotherArguments="$arg"
			else
				anotherArguments="$anotherArguments"' ; '"$arg"
			fi
		fi
	fi
done

echo Help: "$showHelp" ';' Version: "$showVersion" ';' Output: "$output"
echo Another arguments: "$anotherArguments"

exit 0
