# Rancher

## Rancher Desktop for linux
[releases](https://github.com/rancher-sandbox/rancher-desktop/releases)
[示例代码库](https://docs.rancher.cn/docs/rancher2/k8s-in-rancher/pipelines/example-repos/_index/)
[linux install](https://docs.rancher.cn/docs/rancherdesktop/getting-started/installation/_index/)

---

- pass 设置
创建一个 GPG 密钥。pass 会使用它来保护密文。
```
GPG是自由软件基金会开发用于替代商业加密软件PGP的替代品，取名为GnuPG。

私钥生成 gpg --generate-key
如无图形界面需借助工具rng-tools解决(yum安装)，新开终端rngd -r /dev/urandom，(Ubuntu其命令为：rng -r /dev/urandom)

私钥查看 gpg --list-keys

```
[more](https://blog.csdn.net/weixin_36078354/article/details/116649866)

---
