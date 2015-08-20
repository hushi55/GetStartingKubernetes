

{
    "aggs" : {
        "registrationTime" : {
            "histogram" : {
                "field" : "registrationTime",
                "interval" : 50
            }
        }
    }
}

curl -XGET 'http://192.168.1.237:9200/kdstat/T_User/_search' -d '{
    "aggs" : {
        "min_userSequence" : { 
        	"min" : {"type" : "T_User", "field" : "userSequence" 
        	} 
        }
    }
}'

curl -XGET 'http://192.168.1.237:9200/kdstat/T_User/_search' -d '{
    "aggs" : {
        "min_userSequence" : { 
        	"min" : { "field" : "userSequence" 
        	} 
        }
    }
}'



curl -XGET 'http://192.168.1.237:9200/kdstat/T_User/_search' -d '{
    "aggs" : {
        "registerDate_his" : {
            "date_histogram" : {
                "field" : "registerDate",
                "interval" : "1M",
                "format" : "yyyy-MM-dd"
            }
        }
    }
}'
curl -XGET 'http://192.168.1.237:9200/kdstat/T_UserNetwork/_search' -d '{
    "aggs" : {
        "articles_over_time" : {
            "date_histogram" : {
                "field" : "joinDate",
                "interval" : "month",
                "format" : "yyyy-MM-dd"
            }
        }
    }
}'

curl -XGET 'http://192.168.1.237:9200/kdstat/T_User/_search' -d '{
    "aggs" : {
        "grades_count" : { "value_count" : { "field" : "defaultNetwork" } }
    }
}'
curl -XGET 'http://192.168.1.237:9200/kdstat/T_UserNetwork/_search' -d '{
	"aggs": {
	    "group_by_networkId": {
	      "terms": {
	        "field": "networkId",
	        "order" : { "_count" : "desc" },
	        "size" : 10
	      }
	    },
	      "aggs" : {
		        "articles_over_time" : {
		            "date_histogram" : {
		                "field" : "joinDate",
		                "interval" : "month",
		                "format" : "yyyy-MM-dd"
		            }
		        }
		   }
	}
}'

curl -XGET 'http://192.168.1.237:9200/kdstat/T_MicroBlog/_search' -d '{
	"aggregations" : {
        "myLarge-GrainGeoHashGrid" : {
            "geohash_grid" : {
                "field" : "T_MicroBlog.location_geo",
                "precision" : 10
            }
        }
    }
}'


{
    "query" : {
        T_User.registerDate:>2015-06-01 AND T_User.registerDate:<2015-06-10
    },
     "filtered": {
	    "filter": {
	      "script": {
	        "script": "doc['T_LoginOut.userId'].value =  doc['_id'].value"
	      }
	    }
	  }
}






















curl -XGET 'http://172.20.10.119:9200/test/item/_search' -d '
{
  "aggs" : {
      "months" : {
        "date_histogram": {
          "field": "user.registerDate",
          "interval": "day"
        },
        "aggs": {
          "distinct_user" : {
              "cardinality" : {
                "field" : "T_LoginOut.userId"
              }
          }
        }
      }
  }
}'