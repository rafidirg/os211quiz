#!/bin/bash
# Fri 14 May 14:29:10 WIB 2021

WEEK="09"
FILE1="WEEK$WEEK-REPORT1.txt"
WEEKDIR="$HOME/RESULT/W$WEEK/"
LFSDIR="/mnt/lfs"
INPUTTOKEN="$(whoami)W$WEEK"

byebye()   { echo $1; exit -1;}
chktokenn() {
    STAMP=$(date +%M%S)
    echo "$(whoami) $STAMP-$(echo $STAMP$(whoami)$1 | sha1sum  | cut -c1-4 | tr '[:lower:]' '[:upper:]' )"
}
diskSpace() {
    SPACE=$(df | awk '/\/mnt\/lfs$/ {print $3}')
    (( SPACE = SPACE / 1024 ))
    echo $SPACE
}
okSources() {
    pushd $LFSDIR/sources/                         2>&1 > /dev/null
    md5sum -c md5sums | grep OK | wc -l
    popd                                           2>&1 > /dev/null
}
verifyTokenn() {
    DATE="$(echo $3 | cut -d' ' -f2 | cut -d'-' -f1)"
    SHA="$(echo  $3 | cut -d' ' -f2 | cut -d'-' -f2 )"
    RESULT="$(echo $DATE$2$1 | sha1sum  | cut -c1-4 | tr '[:lower:]' '[:upper:]' )"
    [ $SHA == $RESULT ] && echo "Verified"  || echo "Error"
}

rm    -rf $WEEKDIR
mkdir -p  $WEEKDIR
[ -d $WEEKDIR ] && cd $WEEKDIR || byebye "Error: No $WEEKDIR"
[ -d $LFSDIR ]                 || byebye "Error: No $LFSDIR"
[ -d $LFSDIR/sources/ ]        || byebye "Error: No $LFSDIR/sources/"
[ -f $LFSDIR/sources/md5sums ] || byebye "Error: No $LFSDIR/sources/md5sums"
echo "ZCZC pwd $(pwd)"                                 > $FILE1
echo "ZCZC date1 $(date +%y%m%d-%H%M)"                >> $FILE1
echo "ZCZC dirSources $LFSDIR/sources/"               >> $FILE1
echo "ZCZC okSources $(okSources)"                    >> $FILE1
echo "ZCZC diskSpace $(diskSpace) MB"                 >> $FILE1
echo "ZCZC hostname $(hostname)"                      >> $FILE1
echo "ZCZC username $(whoami)"                        >> $FILE1
echo "ZCZC INPUTTOKEN $INPUTTOKEN"                    >> $FILE1
TOKEN=$(chktokenn $INPUTTOKEN)
echo "ZCZC chktokenn $TOKEN"                          >> $FILE1
VERIFY=$(verifyTokenn $INPUTTOKEN $TOKEN)
echo "ZCZC verifyTokenn $INPUTTOKEN $TOKEN $VERIFY"   >> $FILE1
echo "ZCZC date2 $(date +%y%m%d-%H%M)"                >> $FILE1

exit


