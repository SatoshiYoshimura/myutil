#!/bash/bin

gdbtrace() {
  LOG=gdb.log
  echo "start gdb: " `date` >> LOG
  PID=`cat /var/lib/mysql/mysql.pid`
  STACKDUMP=/tmp/stackdump.$$
  echo 'thread aplly all bt' > $STACKDUMP
  echo 'detach' >> $STACKDUMP
  echo 'quit' >> $STACKDUMP
  if [ -z "$PID" ]
  then
    echo "Cannot find $BINARY in processlist."
    exit 1
  fi
  gdb --batch --pid=$PID -x $STACKDUMP < /dev/null >> $LOG
  echo "end gdb: " `date` >> $LOG
  rm -f $STACKDUMP
}

for i in `seq 1 10000`
do
CONNN=`netstat -an | grep 3306 | grep ESTABLISHED | wc | awk '{print$1}'`
if [ $CONN -gt 70 ]; then
  gdbtrace
  echo "recorded"
fi
  sleep 5
done
