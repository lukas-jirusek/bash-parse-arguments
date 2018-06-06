# bash-parse-options
## Description:   
Processes short and long options with or without arguments.
### Accepted formats:   
```bash
$ ./script.sh -h -v --help -o argument --output argument -o=argument --output=argument -hv
```
#### Explained:
```bash
$ ./script.sh (1)-h (1)-v (2)--help (3)-o argument (4)--output argument (5)-o=argument (6)--output=argument (7)-hv
```
> (1) - short option (single dash)   
> (2) - long option (double dash)   
> (3) - short option with argument separated with ' '   
> (4) - long option with argument separated with ' '   
> (5) - short option with argument joined with '='   
> (6) - long option with argument joined with '='   
> (7) - multiple short options at once (single dash)   
> Any other arguments is stored in separated array.

## Usage:
To use this way of parsing options and arguments, copy this script at the beginning of your script. Then add your own options as
as described in next chapter.   
You can use [THIS](./bash-parse-options-blank.sh) blank script, which does not have any predefined options. [[RAW]](https://raw.githubusercontent.com/lukas-jirusek/bash-parse-options/master/bash-parse-options.sh)

### Adding yout own options:   
> a) Without argument: ( MUST COMPLETE a.1 AND a.2 )   
> 	a.1) short and long option   
>		Into '### \*\*ADDARG3\*\*' (copy and search)   
>			example:
```bash
		-h | --help )														#<-- CHANGE HERE - short and long option
			showHelp=1														#<-- CHANGE HERE - variable for further usage
		;;
```   
> a.2) only short option   
>		Into '### \*\*ADDARG1\*\*' (copy and search)   
>			example:   
 ```bash
		h )																	#<-- CHANGE HERE - short option; WARNING - NO DASH
			showHelp=1														#<-- CHANGE HERE - variable for further usage
		;;
```   
> b) With arguments: ( MUST COMPLETE b.1, b.2 AND b.3 )   
>	b.1) short and long option   
>		Into '### \*\*ADDARG3\*\*' (copy and search)   
>			example:   
 ```bash
		-o | --output )														#<-- CHANGE HERE - short and long option
			if [[ $i -eq $# ]]
			then
				echo 'Option: '"$argumentWhole"' requires argument.'
				exit 5
			else
				argumentAwaiting=1
				argumentInto='o'											#<-- CHANGE HERE - MUST MATCH LETTER IN STEP b.3
			fi
		;;
```   
>	b.2) short and long option   
>		Into '### \*\*ADDARG4\*\*' (copy and search)   
>			example:   
```bash
		-o | --output )														#<-- CHANGE HERE - short and long option
			if [[ -z "$argumentSpecifiedOption" ]]
			then 
				echo 'Option '"$argumentSpecified"' requires argument.'
				exit 5
			else
				output="$argumentSpecifiedOption"							#<-- CHANGE HERE - variable for further usage
			fi
		;;
```   
>	b.3) finishing b.1   
>		Into '### \*\*ADDARG2\*\*' (copy and search)   
>			example:   
 ```bash
		o )																	#<-- CHANGE HERE - MUST MATCH LETTER IN STEP b.1
			output="$argumentWhole"											#<-- CHANGE HERE - variable for further usage
		;;
```   
## Example
[THIS](./bash-parse-option.sh) script parses 4 options: [[RAW]](https://raw.githubusercontent.com/lukas-jirusek/bash-parse-options/master/bash-parse-options.sh)   
Two options without argument: -h (or --help) and -v (--version) and   
two options with arguments: -o argument (--output="argument") and -t=argument (--text argument).   
#### Code:
```bash
#!/bin/bash
# defaultValues:
showHelp=0
showVersion=0
output='~/default'
text='default'

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
				h )
					showHelp=1
				;;
				v )
					showVersion=1
				;;
### END **ADDARG1**
				* )
					echo 'Invalid option: -'"${argumentArray[argumentLetterIndex]}"'. Use --help to show help.'
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
					o )
						output="$argumentWhole"
					;;
					t )
						text="$argumentWhole"
					;;
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
					-h | --help )                                           # without argument
						showHelp=1
					;;
					-v | --version )										# without argument
						showVersion=1
					;;
					-o | --output )                                         # with argument
						if [[ $i -eq $# ]]
						then
							echo 'Option: '"$argumentWhole"' requires argument.'
							exit 5
						else
							argumentAwaiting=1
							argumentInto='o'
						fi
					;;
					-t | --text )                                        	# with argument
						if [[ $i -eq $# ]]
						then
							echo 'Option: '"$argumentWhole"' requires argument.'
							exit 5
						else
							argumentAwaiting=1
							argumentInto='t'
						fi
					;;
### END **ADDARG3**
					* )
						echo 'Unknown option: '"$argumentWhole"'. To show help, start with --help.'
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
		-o | --output )
			if [[ -z "$argumentSpecifiedOption" ]]
			then 
				echo 'Option '"$argumentSpecified"' requires argument.'
				exit 5
			else
				output="$argumentSpecifiedOption"
			fi
		;;
		-t | --text )
			if [[ -z "$argumentSpecifiedOption" ]]
			then 
				echo 'Option '"$argumentSpecified"' requires argument.'
				exit 5
			else
				text="$argumentSpecifiedOption"
			fi
		;;
### END **ADDARG4**
		* )
			echo 'Unknown option: '"$argumentSpecified"'. Start with --help to show help.'
			exit 5
		;;
		esac
		argumentWithEquals=''
	fi
done
# END PARSE OPTIONS

echo Help: "$showHelp" ';' Version: "$showVersion" ';' Output: "$output" ';' Text: "$text"

if [[ ! -z "$argumentAnotherArray" ]]
then
    echo Another arguments: "${argumentAnotherArray[*]}"'. Number of another arguments: '"${#argumentAnotherArray[*]}"
fi
exit 0
```   
Script uses several variables and arrays, they are listed here:   
> argumentWhole - stores currently processed argument   
> argumentAwaiting - tell if previous option expects argument   
> argumentAnotherArray - stores arguments that do not belong to any option   
> argumentPrevious - stores previously stored argument   
> argumentFirstCharacter - stores first character of currently processed argument   
> argumentSecondCharacter - stores second character of currently processed argument   
> argumentWithEquals - stores argument containing character '='   
> argumentArray - stores values of enabled short options in array   
> argumentLetterIndex - stores index of array with short options (see argumentArray)   
> argumentInto - stores letter which helps with associating argument with option   
> argumentSpecified - stores part before '=' from argument with '=' (see argumentWithEquals)   
> argumentSpecifiedOption - stores part after '=' from argument with '=' (see argumentWithEquals)   
> argumentAnotherIndex - stores index of array of arguments without options (see argumentAnother)   

Used commands:   
echo, grep, head, tail, seq, cut, read   

NOTE: I know this script is slow, but since getopts can't do long options and getopt (no 's') should not be used, I decided to make my own script.   
Feel free to use, modify, share, whatever you want, just do not hold me responsible.   
If you feel like contacting me, here is my email: [lukas.jirusek33@gmail.com](mailto:lukas.jirusek33@gmail.com)


