[What are Kubernetes Pods Anyway?](https://www.ianlewis.org/en/what-are-kubernetes-pods-anyway)

`You know why containers in a pod are always scheduled together? It's cuz they're nested containers.`

```
While it wasn't 100% accurate (Containers aren't really a thing. We'll get to that in a bit) it did point out the fact that Pods are amazing things. It's worth taking a look at Pods and containers in general and learn what they actually are.

The Kubernetes documentation on Pods provides the best and most complete explanation of Pods but it's written in a very general sense and uses a lot of jargon. I do recommend you read it though as it's a better and more correct explanation than I could write. This post will hopefully be a more down-to-earth compliment.
```

## Containers aren't Containers

```
Many folks know this already but Linux "containers" don't really exist. There is no thing called a "container" in Linux. 
Containers as everyone knows them are normal processes that are executed 
using two features of the Linux kernel called namespaces and cgroups. 
```

- Namespaces
```
allow you to provide a "view" to the process that hides everything outside of those namespaces, 
thus giving it its own environment to run in. This makes it so processes can't see or interfere with other processes:

Namespaces include:
```
- - Hostname
- - Process IDs
- - File System
- - Network interfaces
- - Inter-Process Communication (IPC)

- that's not really true
While I said above that processes running in a namespace can't interfere with other processes that's not really true. 
A process can use all the resources on the physical machine it runs on, thus starving other processes for resources. In order to limit that, Linux has a feature called cgroups. Processes can be run in a cgroup much like a namespace but the cgroup limits the resources that the process can use. These resources include CPU, RAM, block I/O, network I/O etc. CPU is usually limited by milli-cores (a 1000th of a core), and memory is limited by bytes of RAM. The process itself can run as normal but it will only be able to use as much CPU as allowed by the cgroup and will get out-of-memory errors if it exceeds the memory limit set on the cgroup.

There are lots of resources on learning more about namespaces and cgroups that are only a Google search away so I urge you check them out. Here are a couple good ones:

What even is a container: namespaces and cgroups
Cgroups, namespaces, and beyond: what are containers made from?
The thing I wanted to point out here was that cgroups and each namespace type are separate features. Some subset of the namespaces listed above could be used or not used at all. You could use only cgroups or some other combination of the two (well, you're still using namespaces and cgroups just the root ones but whatever). Namespaces and cgroups also work on groups of processes. You have have multiple processes running with a single namespace. That way they can see and interact with each other. Or you could run them in a single cgroup. That way the processes together will be limited to a specific amount of CPU and RAM.

