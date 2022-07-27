`开源的、高性能的列式存储在线数据分析数据库管理系统，可以使用 SQL 进行实时数据分析。`

* 软件源
```
sudo rpm --import https://repo.clickhouse.com/CLICKHOUSE-KEY.GPG
sudo yum-config-manager --add-repo https://repo.clickhouse.com/rpm/clickhouse.repo
```

* 部署
```
sudo yum install -y clickhouse-server clickhouse-client
```

* 启动
```
sudo /etc/init.d/clickhouse-server start
clickhouse-client

ClickHouse client version 21.11.3.6 (official build).
Connecting to localhost:9000 as user default.
Connected to ClickHouse server version 21.11.3 revision 54450.
```

* 数据集
```
# 1.hits_v1.tsv.xz 802.08MB
curl https://datasets.clickhouse.com/hits/tsv/hits_v1.tsv.xz | unxz --threads=`nproc` > hits_v1.tsv
# 2.visits_v1.tsv.xz 405.28MB
curl https://datasets.clickhouse.com/visits/tsv/visits_v1.tsv.xz | unxz --threads=`nproc` > visits_v1.tsv
```

* 建立库/表
- - hits：点击事件表，记录了所有用户的每一个操作；
- - visits：访问会话表，记录了每个会话的信息。
```
clickhouse-client --query "CREATE DATABASE IF NOT EXISTS tutorial"

```

* 导数据
```
clickhouse-client --query "INSERT INTO tutorial.hits_v1 FORMAT TSV" --max_insert_block_size=100000 < hits_v1.tsv
clickhouse-client --query "INSERT INTO tutorial.visits_v1 FORMAT TSV" --max_insert_block_size=100000 < visits_v1.tsv
```

* 查询
```
SELECT StartURL AS URL, AVG(Duration) AS AvgDuration FROM tutorial.visits_v1 WHERE StartDate BETWEEN '2014-03-23' AND '2014-03-30'GROUP BY URL ORDER BY AvgDuration DESC LIMIT 10

SELECT
    StartURL AS URL,
    AVG(Duration) AS AvgDuration
FROM tutorial.visits_v1
WHERE (StartDate >= '2014-03-23') AND (StartDate <= '2014-03-30')
GROUP BY URL
ORDER BY AvgDuration DESC
LIMIT 10


Progress: 1.44 million rows, 113.46 MB (10.33 million rows/s., 815.97 MB/s.)  
10 rows in set. Elapsed: 0.140 sec. Processed 1.44 million rows, 113.46 MB (10.22 million rows/s., 807.42 MB/s.)
```


[文章引用](https://www.zhihu.com/people/pingguosu)
