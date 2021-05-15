#!/bin/bash
# Fri 14 May 14:29:10 WIB 2021

WEEK="09"
FILEX="WEEK$WEEK-REPORTX.txt"
WEEKDIR="$HOME/RESULT/W$WEEK/"
LFSDIR="/mnt/lfs"
INPUTTOKEN="$(whoami)W$WEEK"

byebye()   { echo $1; exit -1;}
chktokenn() {
    STAMP=$(date +%M%S)
    echo "$(whoami) $STAMP-$(echo $STAMP$(whoami)$1 | sha1sum  | cut -c1-4 | tr '[:lower:]' '[:upper:]'  )"
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

[ -d $WEEKDIR ] && cd $WEEKDIR || byebye "Error: No $WEEKDIR"
[ -d $LFSDIR ]                 || byebye "Error: No $LFSDIR"
[ -d $LFSDIR/sources/ ]        || byebye "Error: No $LFSDIR/sources/"
[ -f $LFSDIR/sources/md5sums ] || byebye "Error: No $LFSDIR/sources/md5sums"
echo "ZCZC pwd $(pwd)"                                 > $FILEX
echo "ZCZC date4 $(date +%y%m%d-%H%M)"                >> $FILEX
echo "ZCZC diskSpace $(diskSpace) MB"                 >> $FILEX
echo "ZCZC hostname $(hostname)"                      >> $FILEX
echo "ZCZC username $(whoami)"                        >> $FILEX
echo "ZCZC INPUTTOKEN $INPUTTOKEN"                    >> $FILEX
TOKEN=$(chktokenn $INPUTTOKEN)
echo "ZCZC chktokenn $TOKEN"                          >> $FILEX
VERIFY=$(verifyTokenn $INPUTTOKEN $TOKEN)
echo "ZCZC verifyTokenn $INPUTTOKEN $TOKEN $VERIFY"   >> $FILEX
echo "ZCZC date5 $(date +%y%m%d-%H%M)"                >> $FILEX

