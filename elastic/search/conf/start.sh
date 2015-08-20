#!/bin/sh

/kingdee/jdk/bin/java -Xmx2g -Xms2g \
	-Dkingdee.elatis.import.monogdb.host=172.20.10.65 \
	-Dkingdee.elatis.import.monogdb.dbname=attDev \
	-Dkingdee.elatis.import.monogdb.collection=T_ClockIn  \
	-Dkingdee.elatis.import.pagesize=3000 \
	-cp ./elastic-import-1.0.jar  kingdee.elastic.stat.FullImport