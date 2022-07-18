# 调度中心

[XXX-job](http://www.xuxueli.com/xxl-job)
`XXL-JOB是一个轻量级分布式任务调度平台，其核心设计目标是开发迅速、学习简单、轻量级、易扩展。`
```
Path: $CI/opt/xxl-job-admin/
-rw-r--r-- 1 root root      392 Nov 12 11:33 Dockerfile
-rw-r--r-- 1 root root 39002757 Nov 12 11:33 xxl-job-admin-2.3.0.jar

docker build -t xxl-job-admin .
docker run -p 8095:8095 -v /root/java/log:/data/applogs --name xxl-job-admin -d  xxl-job-admin

```
