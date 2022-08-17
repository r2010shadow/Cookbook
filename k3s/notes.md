# k3s

## install/uninstall

| 先决条件     |                                                              |
| ------------ | ------------------------------------------------------------ |
| 主机名不重复 | 使用`--with-node-id`选项为每个节点添加一个随机后缀，或者为您添加到集群的每个节点设计一个独特的名称，用`--node-name`或`$K3S_NODE_NAME`传递。 |
| 硬件         | agentMin 1C512MB,建议使用ssd磁盘,serverMin 2C4G              |
| agent网络    | K3s server_6443,metrics server_10250, etcd_2379 和 2380 ,Flannel_51820,51821,8472 |
| server网络   | 考虑增加集群 CIDR 的子网大小，以免 Pod 的 IP 耗尽。你可以通过在启动时向 K3s 服务器传递`--cluster-cidr`选项来实现。 |
| 数据库       | 100节点2C8G，250节点4C16G                                    |
| 注意事项     | server 节点默认是可以调度的，规避需 server 节点上设置污点。  |



- Server

curl -sfL https://get.k3s.io | sh -  ` 国际`

curl -sfL https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh - `国内`

Token  /var/lib/rancher/k3s/server/node-token  `mynodetoken` 

uninstall /usr/local/bin/k3s-uninstall.sh 



- Client

curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -

curl -sfL https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -

hosts  echo "myserverIP myserver" >> /etc/hosts 

uninstall /usr/local/bin/k3s-agent-uninstall.sh



## 离线install

[k3s二进制文件](https://github.com/k3s-io/k3s/releases)

离线安装的过程主要分为以下两个步骤：

**步骤 1**：部署镜像，本文提供了两种部署方式，分别是**部署私有镜像仓库**和**手动部署镜像**。请在这两种方式中选择一种执行。

**步骤 2**：安装 K3s，本文提供了两种安装方式，分别是**单节点安装**和**高可用安装**。完成镜像部署后，请在这两种方式中选择一种执行。

**离线升级 K3s 版本**：完成离线安装 K3s 后，您还可以通过脚本升级 K3s 版本，或启用自动升级功能，以保持离线环境中的 K3s 版本与最新的 K3s 版本同步。

### 操作步骤[#](https://docs.rancher.cn/docs/k3s/installation/airgap/_index#操作步骤)

请按照以下步骤准备镜像目录和 K3s 二进制文件。

1. 从[K3s GitHub Release](https://github.com/rancher/k3s/releases)页面获取你所运行的 K3s 版本的镜像 tar 文件。

2. 将 tar 文件放在`images`目录下，例如：

   sudo mkdir -p /var/lib/rancher/k3s/agent/images/

   sudo cp ./k3s-airgap-images-$ARCH.tar /var/lib/rancher/k3s/agent/images/

   Copy

3. 将 k3s 二进制文件放在 `/usr/local/bin/k3s`路径下，并确保拥有可执行权限。

4. 安装k3s

```
SERVER 
	INSTALL_K3S_SKIP_DOWNLOAD=true ./install.sh
AGENT  
	INSTALL_K3S_SKIP_DOWNLOAD=true K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken ./install.sh
	
`高可用模式`
SERVER 
	curl -sfL https://get.k3s.io | sh -s - server \
  --datastore-endpoint='mysql://username:password@tcp(hostname:3306)/database-name'
 AGENT
	INSTALL_K3S_SKIP_DOWNLOAD=true INSTALL_K3S_EXEC='server' 
	K3S_DATASTORE_ENDPOINT='mysql://username:password@tcp(hostname:3306)/database-name' 
	./install.sh  
```



---

- 管理集群
  - 搭建---首先启动一个 server 节点，使用`cluster-init`标志来启用集群，并使用一个标记作为共享的密钥来加入其他服务器到集群中。使用共享密钥将第二台和第三台 server 加入集群。

curl -sfL https://get.k3s.io | K3S_TOKEN=SECRET sh -s - server --cluster-init

curl -sfL https://get.k3s.io | K3S_TOKEN=SECRET sh -s - server --server https://<ip or hostname of server1>:6443

---

- 管理私有仓库
  - 启动时，K3s 会检查`/etc/rancher/k3s/`中是否存在`registries.yaml`文件，并指示 containerd 使用文件中定义的镜像仓库。
  - 镜像仓库配置文件 mirrors+configs

```
mirrors:               # 定义专用镜像仓库的名称和 endpoint 的指令
  docker.io:
    endpoint:
      - "https://mycustomreg.com:5000"
configs:               # 定义了每个 mirror 的 TLS 和凭证配置，不使用TLS则忽略configs段落
  "mycustomreg:5000":  # 使用TLS每个节点都配置文件 /etc/rancher/k3s/registries.yaml
    auth:              # 使用TLS但无认证，可忽略auth段落
      username: xxxxxx # 这是私有镜像仓库的用户名
      password: xxxxxx # 这是私有镜像仓库的密码
    tls:
      cert_file: # 镜像仓库中使用的cert文件的路径。
      key_file:  # 镜像仓库中使用的key文件的路径。
      ca_file:   # 镜像仓库中使用的ca文件的路径。
```

---

- 禁用组件

```
1. 在/etc/rancher/k3s/config.yaml文件中添加以下选项：
disable-apiserver: true
disable-controller-manager: true
disable-scheduler: true
cluster-init: true

2. 然后用 curl 命令启动 K3s，不需要任何参数：
curl -fL https://get.k3s.io | sh -
```

- 使用.skip 文件禁用组件

```
对于/var/lib/rancher/k3s/server/manifests下的任何 yaml 文件（coredns、traefik、local-storeage 等），你可以添加一个.skip文件，这将导致 K3s 不应用相关的 yaml 文件。
```

---

- 仪表盘
