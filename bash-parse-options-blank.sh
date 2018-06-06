#!/bin/bash
# START PARSE OPTIONS:
argumentAwaiting=0
argumentAnotherArray=''
for i in $(seq $#)
do
    argumentPrevious="$argumentWhole"
    argumentWhole="$(echo "${!i}")"
    argumentFirstCharacter=$(echo "$argumentWhole" | head -c 1)
	argumentSecondCharacter=$(echo "$argumentWhole" | head -c 2 | tail -c 1)
	argumentWithEquals="$(echo "$argumentWhole" | grep -E '=.*$')"
	if [[ -z "$argumentWithEquals" ]]
	then
		if [[ "$argumentFirstCharacter" == '-' && "$argumentSecondCharacter" != '-' && "${#argumentWhole}" -gt 2 ]]
		then
			read -a argumentArray <<< $(echo "$argumentWhole" | sed 's/./& /g')
			argumentLetterIndex=1
			while [[ argumentLetterIndex -lt ${#argumentArray[@]} ]]
			do
				case ${argumentArray[argumentLetterIndex]} in
### **ADDARG1** 				FORMAT (7)
### END **ADDARG1**
				* )
					echo 'Invalid option: -'"${argumentArray[argumentLetterIndex]}"'.'
					exit 5
				;;
				esac
				argumentLetterIndex=$(( $argumentLetterIndex + 1 ))
			done
		else
			if [[ $argumentAwaiting -eq 1 ]]
			then
				if [[ "$argumentFirstCharacter" == '-' || -z "$argumentWhole" ]]
				then
					echo 'Option: '"$argumentPrevious"' requires argument.'
					exit 5
				else
					case "$argumentInto" in								# adds argument to option
### **ADDARG2**					FORMAT (3) (4)
### END **ADDARG**
					* )
						echo This should not be possible. If you see this message, something went TERRIBLY wrong.
						exit 1
					;;
					esac
					argumentAwaiting=0
				fi
			else
				if [[ "$argumentFirstCharacter" == '-' ]]
				then
					case "$argumentWhole" in
### **ADDARG3**					FORMAT (1) (2) (3) (4)
### END **ADDARG3**
					* )
						echo 'Unknown option: '"$argumentWhole"'.'
						exit 5
					;;
					esac
				else
					if [[ -z $argumentAnotherArray ]]
					then
						argumentAnotherIndex=0
						argumentAnotherArray[argumentAnotherIndex]="$argumentWhole"
						argumentAnotherIndex="$(( $argumentAnotherIndex + 1 ))"
					else
						argumentAnotherArray[argumentAnotherIndex]="$argumentWhole"
						argumentAnotherIndex="$(( $argumentAnotherIndex + 1 ))"
					fi
				fi
			fi
		fi
	else
		argumentSpecified="$(echo "$argumentWithEquals" | cut -d'=' -f1)"
		argumentSpecifiedOption="$(echo "$argumentWithEquals" | cut -d'=' -f2)"
		case "$argumentSpecified" in
### **ADDARG4**					FORMAT (5) (6)
### END **ADDARG4**
		* )
			echo 'Unknown option: '"$argumentSpecified"'.'
			exit 5
		;;
		esac
		argumentWithEquals=''
	fi
done
# END PARSE OPTIONS

if [[ ! -z "$argumentAnotherArray" ]]
then
    echo 'Arguments stored in array '"'"'argumentAnotherArray'"'"': '"${argumentAnotherArray[*]}"'. Number of another arguments: '"${#argumentAnotherArray[*]}"
fi
exit 0