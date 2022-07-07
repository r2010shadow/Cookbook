# Logstash cookbook
The Logstash event processing pipeline has three stages: inputs → filters → outputs.

## JDK
```
Java (JVM) version
Bundled JDK
Check your Java version
LS_JAVA_HOME
Using JDK 17
```

## Logstash in docker
```
docker pull docker.elastic.co/logstash/logstash:8.3.1
```

## logstash.yml
```
grep ^[[:alnum:]] logstash.yml
node.name: logstash-test-0404
path.data: /data/logstash
http.host: "10.10.9.109"
path.logs: /data/log/logstash

## kafka-logstash-es
cat logstash-es.conf
input {
    kafka {
      bootstrap_servers => "10.10.9.109:9092"
      topics=> ["elk"]
      consumer_threads => 5
      decorate_events => true
    }
}


output {
  elasticsearch {
    hosts => ["10.10.9.109:9200"]
    index => "elk-6.70-%{+YYYY.MM.dd}"
  }
}
```


