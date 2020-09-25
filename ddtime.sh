#!/bin/bash
map="$1";

name="$2";
if [[ -z $2 ]]; then
	name="marzzzello"; #Change marzzzello here to your preferred default nickname
fi

t="$3"; 
if [[ -z $3 ]]; then
	t="10"; 		#The default is to look the 10 minutes before and after your finish
fi

if [[ -z $1 ]]; then
	echo "Usage: ./time.sh map [name (default: $name)] [difftime in minutes (default: $t)]";
	exit;
fi

dir="`pwd`"
 
echo "select Name, 
(SELECT round((strftime('%s', Timestamp) - strftime('%s',(select timestamp from race where name='$name' and map='$map') )) / 60.0,1)) as 'Difference in minutes',
round(Time/60) as 'Finish time in minutes' from race where Map='$map' 
AND Timestamp >= (select datetime(timestamp, '-$t minutes') from race where name='$name' and map='$map') 
AND Timestamp <= (select datetime(timestamp, '+$t minutes') from race where name='$name' and map='$map') 
order by Timestamp asc;" | sqlite3 "$dir/ddnet.sqlite" --column --header
 