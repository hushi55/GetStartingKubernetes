#export JAVA_OPTS="-Xmx10g -Xms10g -XX:+UseG1GC"
#export ES_HEAP_SIZE="10"


bin/elasticsearch -d -Xmx10g -Xms10g -XX:+UseG1GC

#/kingdee/elasticsearch-1.7.1/bin/elasticsearch -d -Xmx10g -Xms10g -XX:+UseG1GC




## T_LoginOut
java -Xmx2g -Xms2g -Dkingdee.elatis.import.monogdb.dbname=logstat -Dkingdee.elatis.import.monogdb.collection=T_LoginOut  -Dkingdee.elatis.import.pagesize=3000 -cp ./elastic-import-1.0.jar  kingdee.elastic.stat.FullImport
## microblog
java -Xmx2g -Xms2g -Dkingdee.elatis.import.monogdb.dbname=snsDev -Dkingdee.elatis.import.monogdb.collection=T_MicroBlog  -Dkingdee.elatis.import.pagesize=3000 -cp ./elastic-import-1.0.jar  kingdee.elastic.stat.FullImport

## clock in 打卡
java -Xmx2g -Xms2g -Dkingdee.elatis.import.monogdb.dbname=attDev  -Dkingdee.elatis.import.monogdb.collection=T_ClockIn  -Dkingdee.elatis.import.pagesize=3000 -cp ./elastic-import-1.0.jar  kingdee.elastic.stat.FullImport

## userNetwork
java -Xmx2g -Xms2g -Dkingdee.elatis.import.monogdb.dbname=ossDev  -Dkingdee.elatis.import.monogdb.collection=T_UserNetwork  -Dkingdee.elatis.import.pagesize=3000 -cp ./elastic-import-1.0.jar  kingdee.elastic.stat.FullImport
## network
java -Xmx2g -Xms2g -Dkingdee.elatis.import.monogdb.dbname=ossDev  -Dkingdee.elatis.import.monogdb.collection=T_Network  -Dkingdee.elatis.import.pagesize=3000 -cp ./elastic-import-1.0.jar  kingdee.elastic.stat.FullImport
## user
java -Xmx2g -Xms2g -Dkingdee.elatis.import.monogdb.dbname=ossDev  -Dkingdee.elatis.import.monogdb.collection=T_User   -Dkingdee.elatis.import.pagesize=3000 -cp ./elastic-import-1.0.jar  kingdee.elastic.stat.FullImport



## 导入完成后开启
curl -XPUT http://192.168.1.237:9200/_refresh
curl -XPOST 'http://192.168.1.237:9200/stat/_optimize'

## 关闭副本
## 关闭 refresh 
curl -XPUT http://192.168.1.237:9200/stat/_settings -d '{
	"refresh_interval": "-1",
	"index": { "number_of_replicas" : 0 }
}'
curl -XPUT http://192.168.1.237:9200/kdstat/_settings -d '{
	"refresh_interval": "-1",
	"index": { "number_of_replicas" : 0 }
}'


## remove index rebuild
## delete index

curl -XPUT http://192.168.1.237:9200/_refresh
curl -XDELETE http://172.20.10.220:9200/kdstat
curl -XPUT http://172.20.10.220:9200/kdstat
curl -XPUT http://172.20.10.220:9200/kdstat/_settings -d '{
	"refresh_interval": "-1",
	"index": { "number_of_replicas" : 0 }
}'

curl -XPUT http://172.20.10.220:9200/kdstat/_mapping/T_UserNetwork -d ''
curl -XPUT http://172.20.10.220:9200/kdstat/_mapping/T_MicroBlog -d ''
curl -XPUT http://172.20.10.220:9200/kdstat/_mapping/item -d ''


curl -XDELETE http://172.20.10.220:9200/test
curl -XPUT http://172.20.10.220:9200/test
curl -XPUT http://172.20.10.220:9200/test/_settings -d '{
	"refresh_interval": "-1",
	"index": { "number_of_replicas" : 0 }
}'


curl -XPUT http://172.20.10.220:9200/test/_mapping/item -d ''
