* 虚拟机网卡类型
```
Vlance：AMD 79C970 PCnet32- LANCE网卡的仿真版本，是版本较旧的10Mbps 网卡，附带大多数 32 位客户机操作系统（Windows Vista 和更高版本除外）中可用的驱动程序。配置了此网络适配器的虚拟机可以立即使用其网络。

VMXNET：VMXNET 虚拟网络适配器没有对应的物理设备。在虚拟机中，已对 VMXNET 进行了性能优化。由于操作系统供应商没有为此卡提供内置的驱动程序，虚拟机必须安装 VMware Tools才能获得可用的VMXNET 网络适配器的驱动程序。

Flexible：在虚拟机启动时，Flexible网络适配器可将其自身标识为 Vlance 适配器，并且可以自行进行初始化，并作为 Vlance 或 VMXNET 适配器运行，具体取决于哪个驱动程序对其进行了初始化。安装 VMware Tools 后，VMXNET 驱动程序会将 Vlance 适配器更改为更高性能的 VMXNET 适配器。

E1000：Intel 82545EM 千兆位以太网网卡的仿真版本，Linux 2.4.19 版和更高版本、Windows XP Professional x64 版和更高版本以及 Windows Server 2003（32 位）和更高版本包含 E1000 驱动程序。
       注意：在 ESXi/ESX 4.1 之前，E1000 不支持巨帧。

E1000e：仿真虚拟硬件中更高版本的 Intel 千兆位网卡（编号 82574）型号，称为“e1000e”vNIC。e1000e仅可用于 vSphere5 中虚拟硬件版本8或更高版本的虚拟机。这是 Windows 8和更高版本 (Windows) 客户机操作系统的默认虚拟网络适配器。对于 Linux 客户机，无法从 UI 使用 e1000e（e1000、灵活型 vmxnet、增强型 vmxnet 和 vmxnet3 可用于 Linux）。

VMXNET 2（增强型）：VMXNET 2适配器基于VMXNET适配器，提供现代网络上常用的一些高性能功能，如巨帧和硬件卸载。此虚拟网络适配器只能在 ESX/ESXi 3.5 及更高版本的主机上针对部分客户机操作系统可用。由于操作系统供应商没有为此网卡提供内置驱动程序，因此，您必须安装 VMware Tools，才能获得适用于可用 VMXNET 2 网络适配器的驱动程序。
```
