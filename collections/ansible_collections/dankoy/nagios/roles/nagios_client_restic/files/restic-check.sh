#!/bin/bash

usage() { echo -e "\e[1mUsage:\e[0m $0 [-w warning ] [-c critical ] [ -h ]
\e[96mw \e[39m - amount of days for warning.
\e[96mc \e[39m - amount of days for crit.
\e[96mh \e[39m - print this help." 1>&2; exit 1; }

while getopts ":w:c:h:" o; do
    case "${o}" in
        w)
            WARN=${OPTARG}
            ;;
        c)
            CRIT=${OPTARG}
            ;;
        h | *)
            usage
            ;;
    esac
done

if [ -z ${WARN} ] || [ -z ${CRIT} ]; then
    usage
    exit 1
fi

# Source data for repo
source /root/.s3.creds
# Get current date
TODAY=$(date +%s)

# Get last made snapshots
LAST_SNAPSHOTS=$(restic snapshots --last --compact --quiet --no-lock)
NUMLINES=$(printf "$LAST_SNAPSHOTS" | wc -l)
FINALNUMLINES=$(( $NUMLINES + 1 - 2 ))
#printf "$LAST_SNAPSHOTS\n"
#printf "$FINALNUMLINES\n\n"
PRETTY_SNAPSHOTS=$(printf "$LAST_SNAPSHOTS" | awk -v start="2" -v end="$FINALNUMLINES" 'NR > start { print } NR >= end { exit }')
#echo "$PRETTY_SNAPSHOTS"

# Array of tags
declare tags
declare date

for (( i=0; i<=$(( $FINALNUMLINES - 2)); i++ )); do
    TAG=$(printf "$PRETTY_SNAPSHOTS" | awk -v ln="$i" 'NR==ln {print $5}')
    MYDATE=$(printf "$PRETTY_SNAPSHOTS" | awk -v ln="$i" 'NR==ln {print $2}')
    tags[$i]=${TAG}
    date[$i]=${MYDATE}
done

declare WARN_BACKUPS
declare CRIT_BACKUPS

for (( i=1; i<=$(( $FINALNUMLINES - 2)); i++ )); do
    BACKUPDATE=$(date -d "${date[$i]}" +%s)
    DIFFER=$(( ($TODAY - $BACKUPDATE )/(86400) )) #(86400=60*60*24)
    
    if  [ "$DIFFER" -eq "$WARN" ]; then
        WARN_BACKUPS[$i]="Last backup was made ${DIFFER} days ago for ${tags[$i]};"
    elif [ "$DIFFER" -ge "$CRIT" ]; then
        CRIT_BACKUPS[$i]="Last backup was made ${DIFFER} days ago for ${tags[$i]};"
    fi

done

if [ "${#CRIT_BACKUPS[@]}" -ne 0 ]; then
    echo "CRITICAL: ${CRIT_BACKUPS[@]}"
    exit 2
elif [ "${#WARN_BACKUPS[@]}" -ne 0 ]; then
    echo "WARNING: ${WARN_BACKUPS[@]}"
    exit 1
else
    echo "OK"
    exit 0
fi
