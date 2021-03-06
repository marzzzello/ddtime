# ddtime
ddtime is a script that helps you to find out with which other tees you finished a map in team 0 in DDNet.

## Prerequisite
Install sqlite3 if you haven't: 
- Arch-Linux: `pacman -S sqlite`
- Debian/Ubuntu: `apt install sqlite3`

~~Download the DDNet Sqlite database [here](https://ddnet.tw/stats/ddnet.sqlite.zip) and put it in the same folder as `ddtime.sh`.~~  
ddtime will download the sqlite database if it's not available or outdated.  
Make sure `ddtime.sh` has executable permissions. If not do `chmod +x ddtime.sh`.  


## Usage
```
./ddtime.sh map [name (default: marzzzello)] [difftime in minutes (default: 10)]
```
Only the mapname is mandatory. You can change the default nickname and the default time by editing `ddtime.sh`.

## Output
```
./ddtime Kobra        
Name        Difference in minutes  Finish time in minutes
----------  ---------------------  ----------------------
marzzzello  0.0                    42.0                  
Karl' s     0.0                    40.0                  
ɅùҲ☢        0.1                    29.0                  
nameless t  0.1                    27.0   
```

## Tip
Create an alias in your `.bashrc` or `.zshrc` or whatever to use ddtime in every directory.
```
alias ddtime='~/projects/ddtime/ddtime.sh'
```
