#!/usr/bin/env bash

# Change marzzzello here to your preferred default nickname
default_name="marzzzello"
# The default is to look the 10 minutes before and after your finish
default_time="10"

dir="${BASH_SOURCE%/*}"
cd "$dir" || exit
db="ddnet.sqlite"
ddtime="ddtime.sh"

download() {
	while true; do
		read -p "Do you wish to download the current $db from ddnet.tw? [y/n]" yn
		case $yn in
		[Yy]*)
			mv "${db}.zip" "${db}_old.zip" 2>/dev/null && echo "Moved ${db}.zip to ${db}_old.zip"
			wget "https://ddnet.tw/stats/$db.zip" -q --show-progress
			mv "$db" "${db}_old" 2>/dev/null && echo "Moved ${db} to ${db}_old"
			unzip "$db.zip" && rm "$db.zip"
			break
			;;
		[Nn]*) exit ;;
		*) echo "Please answer yes or no." ;;
		esac
	done
}

if age="$(date +%s -r $db 2>/dev/null)"; then
	diff="$(($(date +%s) - age))"
	days="$((diff / (3600 * 24)))"
	if [[ $days -ge 1 ]]; then
		echo "The database is $days days old."
		download
	fi
else
	echo "$db not found!"
	# echo "Make sure that you have downloaded the database and put it in the same folder as $ddtime ($dir)"
	download
fi

map="$1"
name="$2"

if [[ -z $2 ]]; then
	name="$default_name"
fi

t="$3"
if [[ -z $3 ]]; then
	t="$default_time"
fi

if [[ -z $1 ]]; then
	echo "Usage: ./$ddtime map [name (default: $name)] [difftime in minutes (default: $t)]"
	exit
fi

IFS=$'\n'
for OUTPUT in $(echo "select timestamp from race where name='$name' and map='$map'
order by Timestamp asc;" | sqlite3 "$db" --noheader); do

	echo $OUTPUT
	echo "select Name,
    round((strftime('%s', Timestamp) - strftime('%s', '$OUTPUT')) / 60.0,1) as 'Difference in minutes',
    round(Time/60) as 'Finish time in minutes'
    from race where Map='$map'
    AND Timestamp >= datetime('$OUTPUT', '-$t minutes')
    AND Timestamp <= datetime('$OUTPUT', '+$t minutes')
    order by Timestamp asc;" | sqlite3 "$db" --column --header

done
