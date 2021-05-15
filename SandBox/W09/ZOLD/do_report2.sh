#!/bin/bash
# Fri 14 May 14:29:10 WIB 2021

WEEK="09"
SLEEP="6"
FILE2="WEEK$WEEK-REPORT2.txt"
WEEKDIR="$HOME/RESULT/W$WEEK/"
LFSDIR="/mnt/lfs"
INPUTTOKEN="$(whoami)W$WEEK"

byebye()   { echo $1; exit -1;}
chktokenn() {
    STAMP=$(date +%M%S)
    echo "$(whoami) $STAMP-$(echo $STAMP$(whoami)$1 | sha1sum  | cut -c1-4 | tr '[:lower:]' '[:upper:]'  )"
}
verifyTokenn() {
    DATE="$(echo $3 | cut -d' ' -f2 | cut -d'-' -f1)"
    SHA="$(echo  $3 | cut -d' ' -f2 | cut -d'-' -f2 )"
    RESULT="$(echo $DATE$2$1 | sha1sum  | cut -c1-4 | tr '[:lower:]' '[:upper:]' )"
    [ $SHA == $RESULT ] && echo "Verified"  || echo "Error"
}

[ -d $WEEKDIR ] && cd $WEEKDIR || byebye "Error: No $WEEKDIR"
echo "ZCZC pwd $(pwd)"                                 > $FILE2
echo "ZCZC date3 $(date +%y%m%d-%H%M)"                >> $FILE2
echo "ZCZC hostname $(hostname)"                      >> $FILE2
echo "ZCZC username $(whoami)"                        >> $FILE2
echo "ZCZC INPUTTOKEN $INPUTTOKEN"                    >> $FILE2
TOKEN=$(chktokenn $INPUTTOKEN)
echo "ZCZC chktokenn $TOKEN"                          >> $FILE2
VERIFY=$(verifyTokenn $INPUTTOKEN $TOKEN)
echo "ZCZC verifyTokenn $INPUTTOKEN $TOKEN $VERIFY"   >> $FILE2
MAXLFS=0
MAXROOT=0
MAXMEMORY=0
MAXSWAP="-1"
NEXTDATE=0
while true ; do
    TMP1=$(date +%y%m%d-%H%M)
    [[ "$TMP1" != "$NEXTDATE" ]] && {
        NEXTDATE=$TMP1
        echo "ZCZC dateX $NEXTDATE =========="        >> $FILE2
    }
    TMP1=$(free | awk '/Mem:/ {print $3}')
    ((TMP1/=1024))
    (( "$TMP1" > "$MAXMEMORY" )) && {
        MAXMEMORY=$TMP1
        echo "ZCZC MAXMEMORY $MAXMEMORY"              >> $FILE2
    }
    TMP1=$(free | awk '/Swap:/ {print $3}')
    ((TMP1/=1024))
    (( "$TMP1" > "$MAXSWAP" )) && {
        MAXSWAP=$TMP1
        echo "ZCZC MAXSWAP $MAXSWAP"                  >> $FILE2
    }
    TMP1=$(df | awk '/\/$/ {print $3}')
    ((TMP1/=1024))
    (( "$TMP1" > "$MAXROOT" )) && {
        MAXROOT=$TMP1
        echo "ZCZC MAXROOT $MAXROOT"                  >> $FILE2
    }
    TMP1=$(df | awk '/\/mnt\/lfs$/ {print $3}')
    ((TMP1/=1024 ))
    (("$TMP1" > "$MAXLFS")) && {
        MAXLFS=$TMP1
        echo "ZCZC MAXLFS $MAXLFS"                    >> $FILE2
    }
    sleep $SLEEP
done

exit

