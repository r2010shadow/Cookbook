# Docker
```
Docker是Docker公司开源的一个基于轻量级虚拟化技术的容器引擎项目,整个项目基于Go语言开发，并遵从Apache 2.0协议。
Docker可以在容器内部快速自动化部署应用，并可以通过内核虚拟化技术（namespaces及cgroups等）来提供容器的资源隔离与安全保障等。

```

# Docker架构
```
Docker Client、Docker Daemon、Docker Registry、Graph、Driver、libcontainer以及Docker container。
```

# Docker 文件系统
`每层镜像包含：镜像文件以及镜像json元数据信息`

<img src="https://github.com/r2010shadow/Cookbook/blob/master/docker/img/Docker_fs.png" width=400>

* 可读写层(Read－Write Layer)
* Docker容器的初始层(Init Layer)


---
## 如此Docker
* copy
```
COPY from=storage.bigfish.com/fish/static-ffmpeg:v1 /ffmpeg /usr/local/bin/
从一个镜像中(storage.bigfish.com/fish/static-ffmpeg:v1)打包出的产物中，复制一个压缩包到另外一层镜像中
```

---
## 常用配置
- 加速
```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://l10nt4hq.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

---
## registry
```
docker pull registry:2
docker run -d -p 5000:5000 registry:2
curl -i http://localhost:5000/v2/

- push image to local registry
docker tag busybox localhost:5000/busy
docker push localhost:5000/busy

- show list
curl http://localhost:5000/v2/_catalog
curl http://localhost:5000/v2/busy/manifests/latest
```
