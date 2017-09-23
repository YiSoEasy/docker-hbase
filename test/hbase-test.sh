$HBASE_HOME/bin/hbase pe --rows=1000 --table=testHBase --nomapred increment 3
echo "run bin/hbase shell and then run count 'testHBase'"
echo "check if total number of row of table testHBase = 1000"