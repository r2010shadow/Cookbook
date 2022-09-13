# AWS CLI 

在 Linux、Windows 和 macOS 上的主要分发方式是 pip，这是一个用于 Python 的程序包管理器，提供方便的方式来安装、升级和删除 Python 程序包及其相关组件。
```
当前 AWS CLI 版本

经常更新 AWS CLI 以支持新服务和命令。要了解您是否拥有最新版本，请查看GitHub 上的版本页面。

如果您已经有 pip 和支持的 Python 版本，则可以使用以下命令安装 AWS CLI：

$ pip install --upgrade --user awscli

--upgrade 选项通知 pip 升级已安装的任何必要组件。--user 选项通知 pip 将程序安装到用户目录的子目录中，以避免修改您的操作系统所使用的库。

如果您在尝试随 pip 一起安装 AWS CLI 时遇到问题，可以在虚拟环境中安装 AWS CLI 来隔离工具及其依赖项；或者使用与平时使用的 Python 不同的版本。
```

- 独立安装程序
```
对于 Linux, macOS, or Unix 上的离线或自动安装，请尝试捆绑安装程序。捆绑安装程序包括 AWS CLI 和其依赖项，以及为您执行安装的 Shell 脚本。

在 Windows 上，您也可以使用 MSI 安装程序。这两种方法都简化了初始安装，并对新版本 AWS CLI 发布后升级更加困难的情况做出权衡。

在安装 AWS CLI 后，将可执行文件路径添加到您的 PATH 变量中：

Linux – ~/.local/bin

macOS – ~/Library/Python/3.4/bin

修改您的 PATH 变量 (Linux, macOS, or Unix)

    在您的用户文件夹中查找 Shell 的配置文件脚本。如果您不能确定所使用的 Shell，请运行 echo $SHELL。

    $ ls -a ~
    .  ..  .bash_logout  .bash_profile  .bashrc  Desktop  Documents  Downloads

        Bash – .bash_profile、.profile 或 .bash_login。
        Zsh – .zshrc
        Tcsh – .tcshrc、.cshrc 或 .login。
    向配置文件脚本添加导出命令。

    export PATH=~/.local/bin:$PATH

    在本示例中，此命令将路径 ~/.local/bin 添加到当前 PATH 变量中。
    将配置文件加载到当前会话。

    $ source ~/.bash_profile

Windows – %USERPROFILE%\AppData\Roaming\Python\Scripts

Python 3.5+，Windows – %USERPROFILE%\AppData\Roaming\Python\Python版本号\Scripts

修改您的 PATH 变量 (Windows)

    按 Windows 键并键入环境变量。
    选择 Edit environment variables for your account。
    选择 PATH，然后选择 Edit。
    向 Variable value 字段添加路径，中间用分号隔开。例如：C:\existing\path;C:\new\path
    选择 OK 两次以应用新设置。
    关闭任何运行的命令提示符并重新打开。

通过运行 aws --version 来验证 AWS CLI 是否已正确安装。

$ aws --version
aws-cli/1.11.44 Python/3.4.3 Linux/4.4.0-59-generic botocore/1.5.7

定期更新 AWS CLI，以便添加对新服务和命令的支持。要更新到最新版本的 AWS CLI，请再次运行安装命令。

$ pip install --upgrade --user awscli

如果需要卸载 AWS CLI，请使用 pip uninstall。

$ pip uninstall awscli

如果您没有 Python 和 pip，则使用适合您的操作系统的过程：

小节目录

    在 Linux 上安装 Python、pip 和 AWS Command Line Interface
    在 Microsoft Windows 上安装 AWS Command Line Interface
    在 macOS 上安装 AWS Command Line Interface
    在虚拟环境中安装 AWS Command Line Interface
    使用捆绑安装程序安装 AWS CLI (Linux, macOS, or Unix)
```




- 常用AWS命令行汇总(awscli)
```
时间 2014-11-03 11:13:44  I'm on the cloud
原文  http://imbusy.me/?p=328
主题 网络安全

创建一个Key，查看内容并生成pem文件。

aws ec2 create-key-pair --key-name MyCypayTestCalifornia --query 'KeyMaterial' --output text > MyTestCalifornia.pem

aws ec2 create - key - pair -- key - name MyCypayTestCalifornia -- query 'KeyMaterial' -- output text > MyTestCalifornia . pem

创建一个VPC安全组

aws ec2 create-security-group --group-name MyCATest --description MyCATest --vpc-id vpc-efxxxx8a

aws ec2 create - security - group -- group - name MyCATest -- description MyCATest -- vpc - id vpc - efxxxx8a

列举当前安全组名称和ID

aws ec2 describe-security-groups  --query SecurityGroups[*].[GroupName,GroupId,VpcId]

aws ec2 describe - security - groups    -- query SecurityGroups [ * ] . [ GroupName , GroupId , VpcId ]

添加安全组规则

aws ec2 authorize-security-group-ingress --group-id sg-d1xxxxb4 --protocol tcp --port 22 --cidr 202.x.x.120/29  --protocol tcp --port 8080-8082 --cidr 10.10.0.0/16  --protocol tcp --port 80 --cidr 0.0.0.0/0


aws ec2 authorize - security - group - ingress -- group - id sg - d1xxxxb4 -- protocol tcp -- port 22 -- cidr 202.x.x.120 / 29    -- protocol tcp -- port 8080 - 8082 -- cidr 10.10.0.0 / 16    -- protocol tcp -- port 80 -- cidr 0.0.0.0 / 0

查看当前安全组规则

aws ec2 describe-security-groups --group-ids  sg-d1xxxxb4

aws ec2 describe - security - groups -- group - ids   sg - d1xxxxb4

创建实例

aws ec2 run-instances --image-id ami-7axxxx3f --count 1 --instance-type t1.micro --key-name MyTestCalifornia --security-group-ids sg-dxxxxbb4 --placement AvailabilityZone=us-west-1c --subnet-id subnet-5exxxx3b --block-device-mappings "[{\"DeviceName\": \"/dev/sdf\",\"Ebs\":{\"VolumeSize\":100}}]"  --user-data  "/sbin/mkfs.ext4 /dev/xvdf  && /bin/mount /dev/xvdf /home"

aws ec2 run - instances -- image - id ami - 7axxxx3f -- count 1 -- instance - type t1 . micro -- key -name MyTestCalifornia -- security - group - ids sg - dxxxxbb4 -- placement AvailabilityZone = us - west - 1c -- subnet - id subnet - 5exxxx3b -- block - device - mappings "[{\"DeviceName\": \"/dev/sdf\",\"Ebs\":{\"VolumeSize\":100}}]"    -- user - data    "/sbin/mkfs.ext4 /dev/xvdf  && /bin/mount /dev/xvdf /home"

给实例打标签

aws ec2 create-tags --resources i-3xxxxb6d --tags Key=Name,Value=APITest  Key=PROJECT,Value=cypay

aws ec2 create - tags -- resources i - 3xxxxb6d -- tags Key = Name , Value = APITest   Key = PROJECT , Value = cypay

创建个EIP

aws ec2 allocate-address --domain vpc
{
   "PublicIp": "54.x.x.12",
   "Domain": "vpc",
   "AllocationId": "eipalloc-axxxxxcd"
}

aws ec2 allocate - address -- domain vpc

{

"PublicIp" : "54.x.x.12" ,

"Domain" : "vpc" ,

"AllocationId" : "eipalloc-axxxxxcd"

}

将VPC中的EIP与VPC中的实例关联

aws ec2 associate-address --instance-id i-3xxxxx6d --allocation-id eipalloc-afxxxx8cd

aws ec2 associate - address -- instance - id i - 3xxxxx6d -- allocation - id eipalloc - afxxxx8cd

此时可以ssh链接自己的实例

ssh -i MyTestCalifornia.pem  ec2-user@54.x.x.12


ssh - i MyTestCalifornia . pem   ec2 - user @ 54.x.x.12

列举出当前实例的相关信息

aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, Placement.AvailabilityZone, State.Name,  InstanceType, PublicIpAddress, PrivateIpAddress, Tags[0].Value, Tags[1].Value]' --output text

aws ec2 describe - instances -- query 'Reservations[*].Instances[*].[InstanceId, Placement.AvailabilityZone, State.Name,  InstanceType, PublicIpAddress, PrivateIpAddress, Tags[0].Value, Tags[1].Value]' -- output text

来源： http://www.tuicool.com/articles/qYFFvyV


您还可以根据标签筛选资源列表。以下示例演示了如何通过 describe-instances 命令使用标签来筛选实例。

示例 1：描述具有指定标签键的实例

以下命令描述了具有 Stack 标签 (无论标签的值如何) 的实例。

aws ec2 describe-instances --filters Name=tag-key,Values=Stack

示例 2：描述具有指定标签的实例

以下命令描述了具有标签 Stack=production 的实例。

aws ec2 describe-instances --filters Name=tag:Stack,Values=production

示例 3：描述具有指定标签值的实例

以下命令描述了具有值为 production 的标签（无论标签键如何) 的实例。

aws ec2 describe-instances --filters Name=tag-value,Values=production

```






