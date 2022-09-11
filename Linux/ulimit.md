# ulimit
```
一般可以通过ulimit命令或编辑/etc/security/limits.conf重新加载的方式使之生效
通过ulimit比较直接,但只在当前的session有效,limits.conf中可以根据用户和限制项使用户在下次登录中生效.
对于limits.conf的设定是通过pam_limits.so的加载生效的,比如/etc/pam.d/sshd,这样通过ssh登录时会加载limit.
又或者在/etc/pam.d/login加载生效.
```

- 对各种限制进行分析
```
core file size     (blocks, -c) 0
data seg size      (kbytes, -d) unlimited
scheduling priority       (-e) 20 a
file size        (blocks, -f) unlimited a
pending signals         (-i) 16382
max locked memory    (kbytes, -l) 64 a
max memory size     (kbytes, -m) unlimited a
open files           (-n) 1024 a
pipe size      (512 bytes, -p) 8
POSIX message queues   (bytes, -q) 819200
real-time priority       (-r) 0
stack size       (kbytes, -s) 8192
cpu time        (seconds, -t) unlimited
max user processes       (-u) unlimited
virtual memory     (kbytes, -v) unlimited
file locks           (-x) unlimited
```

- 一)限制进程产生的文件大小(file size)
```
先来说说ulimit的硬限制和软限制
硬限制用-H参数,软限制用-S参数.
ulimit -a看到的是软限制,通过ulimit -a -H可以看到硬限制.
如果ulimit不限定使用-H或-S,此时它会同时把两类限制都改掉的.
软限制可以限制用户/组对资源的使用,硬限制的作用是控制软限制.
超级用户和普通用户都可以扩大硬限制,但超级用户可以缩小硬限制,普通用户则不能缩小硬限制.
硬限制设定后,设定软限制时只能是小于或等于硬限制.
下面的测试应用于硬限制和软限制.

1)软限制不能超过硬限制
在超级用户下,同时修改硬/软限制,使当前会话只能建100KB的文件
ulimit -f 100

查看当前创建文件大小的硬限制为100KB
ulimit -H -f 
100

此时限制当前会话的软限制为1000KB,出现不能修改的报错
ulimit -S -f 1000
-bash: ulimit: file size: cannot modify limit: Invalid argument

2)硬限制不能小于软限制
在超级用户下,用户查看当前的软限制,此时为unlmiited
ulimit -S -f
unlimited

此时修改当前会话创建文件大小的硬限制为1000KB,出现不能修改的报错,说明硬限制不能小于软限制
ulimit -H -f 1000
-bash: ulimit: file size: cannot modify limit: Invalid argument

如果我们把创建文件大小的软限制改为900KB,此后就可以修改它的硬限制了
ulimit -S -f 900
ulimit -H -f 1000

3)普通用户只能缩小硬限制,超级用户可以扩大硬限制

用普通用户进入系统
su - test

查看创建文件大小的硬限制
ulimit -H -f
unlimited


此时可以缩小该硬限制
ulimit -H -f 1000

但不能扩大该硬限制
ulimit -H -f 10000

4)硬限制控制软限制,软限制来限制用户对资源的使用

用软限制限制创建文件的大小为1000KB
ulimit -S -f 1000

用硬限制限制创建文件的大小为2000KB
ulimit -H -f 2000

创建3MB大小的文件
dd if=/dev/zero of=/tmp/test bs=3M count=1
File size limit exceeded

查看/tmp/test的大小为1000KB,说明软限制对资源的控制是起决定性作用的.
ls -lh /tmp/test 
-rw-r--r-- 1 root root 1000K 2010-10-15 23:04 /tmp/test

file size单位是KB.
```
- 二)关于进程优先级的限制(scheduling priority)
```
这里的优先级指NICE值
这个值只对普通用户起作用,对超级用户不起作用,这个问题是由于CAP_SYS_NICE造成的.
例如调整普通用户可以使用的nice值为-10到20之间.
硬限制nice的限制为-15到20之间.
ulimit -H -e 35

软限制nice的限制为-10到20之间
ulimit -S -e 30

用nice命令,使执行ls的nice值为-10
nice -n -10 ls /tmp
ssh-BossiP2810 ssh-KITFTp2620 ssh-vIQDXV3333

用nice命令,使执行ls的nice值为-11,此时超过了ulimit对nice的软限制,出现了异常.
nice -n -11 ls /tmp 
nice: cannot set niceness: Permission denied
```
- 三)内存锁定值的限制(max locked memory)
```
这个值只对普通用户起作用,对超级用户不起作用,这个问题是由于CAP_IPC_LOCK造成的.
linux对内存是分页管理的,这意味着有不需要时,在物理内存的数据会被换到交换区或磁盘上.
有需要时会被交换到物理内存,而将数据锁定到物理内存可以避免数据的换入/换出.
采用锁定内存有两个理由:
1)由于程序设计上需要,比如oracle等软件,就需要将数据锁定到物理内存.
2)主要是安全上的需要,比如用户名和密码等等,被交换到swap或磁盘,有泄密的可能,所以一直将其锁定到物理内存.

锁定内存的动作由mlock()函数来完成
mlock的原型如下:
int mlock(const void *addr,size_t len);

测试程序如下:
\#include <stdio.h>
\#include <sys/mman.h>

int main(int argc, char* argv[])
{
    int array[2048];

​    if (mlock((const void *)array, sizeof(array)) == -1) {
​        perror("mlock: ");
​        return -1;
​    }

​    printf("success to lock stack mem at: %p, len=%zd\n",
​            array, sizeof(array));


    if (munlock((const void *)array, sizeof(array)) == -1) {
        perror("munlock: ");
        return -1;
    }

​    printf("success to unlock stack mem at: %p, len=%zd\n",
​            array, sizeof(array));

​    return 0;
}

gcc mlock_test.c -o mlock_test

上面这个程序,锁定2KB的数据到物理内存中,我们调整ulimit的max locked memory.
ulimit -H -l 4
ulimit -S -l 1
./mlock_test 
mlock: : Cannot allocate memory

我们放大max locked memory的限制到4KB,可以执行上面的程序了.
ulimit -S -l 4
./mlock_test
success to lock stack mem at: 0x7fff1f039500, len=2048
success to unlock stack mem at: 0x7fff1f039500, len=2048

注意:如果调整到3KB也不能执行上面的程序,原因是除了这段代码外,我们还会用其它动态链接库.
```

- 四)进程打开文件的限制(open files)
```
这个值针对所有用户,表示可以在进程中打开的文件数.

例如我们将open files的值改为3
ulimit -n 3

此时打开/etc/passwd文件时失败了.
cat /etc/passwd
-bash: start_pipeline: pgrp pipe: Too many open files
-bash: /bin/cat: Too many open files
```
- 五)信号可以被挂起的最大数(pending signals)
```
这个值针对所有用户,表示可以被挂起/阻塞的最大信号数量

我们用以下的程序进行测试,源程序如下:

\#include <stdio.h>
\#include <string.h>
\#include <stdlib.h>
\#include <signal.h>
\#include <unistd.h>

volatile int done = 0;

void handler (int sig)
{
 const char *str = "handled...\n";
 write (1, str, strlen(str));
 done = 1;
}

void child(void)
{
 int i;
 for (i = 0; i < 3; i++){
  kill(getppid(), SIGRTMIN);
  printf("child - BANG!\n");
 }
 exit (0);
}

int main (int argc, char *argv[])
{
 signal (SIGRTMIN, handler);
 sigset_t newset, oldset;
 
 sigfillset(&newset);
 sigprocmask(SIG_BLOCK, &newset, &oldset);
 
 pid_t pid = fork();
 if (pid == 0)
 child();
 
 printf("parent sleeping \n");
 
 int r = sleep(3);
 
 printf("woke up! r=%d\n", r);
 
 sigprocmask(SIG_SETMASK, &oldset, NULL);
 
 while (!done){
 };
 
 printf("exiting\n");
 exit(0);
}

编译源程序:
gcc test.c -o test

执行程序test,这时子程序发送了三次SIGRTMIN信号,父程序在过3秒后,接收并处理该信号.
./test 
parent sleeping 
child - BANG!
child - BANG!
child - BANG!
woke up! r=0
handled...
handled...
handled...
exiting

注意:这里有采用的是发送实时信号(SIGRTMIN),如:kill(getppid(), SIGRTMIN);
如果不是实时信号,则只能接收一次.

如果我们将pending signals值改为2,这里将只能保证挂起两个信号,第三个信号将被忽略.如下:
ulimit -i 2
./test 
parent sleeping 
child - BANG!
child - BANG!
child - BANG!
woke up! r=0
handled...
handled...
exiting
```
- 六)可以创建使用POSIX消息队列的最大值,单位为bytes.(POSIX message queues)
```
我们用下面的程序对POSIX消息队列的限制进行测试,如下:

\#include <stdio.h>
\#include <string.h>
\#include <stdlib.h>
\#include <unistd.h>
\#include <mqueue.h>
\#include <sys/stat.h>
\#include <sys/wait.h>

struct message{
 char mtext[128];
};

int send_msg(int qid, int pri, const char text[])
{
 int r = mq_send(qid, text, strlen(text) + 1,pri);
 if (r == -1){
 perror("mq_send");
 }
 return r;
}

void producer(mqd_t qid)
{
 send_msg(qid, 1, "This is my first message.");
 send_msg(qid, 1, "This is my second message.");

 send_msg(qid, 3, "No more messages.");
}

void consumer(mqd_t qid)
{
 struct mq_attr mattr;
 do{
 u_int pri;
 struct message msg;
 ssize_t len;

 len = mq_receive(qid, (char *)&msg, sizeof(msg), &pri);
 if (len == -1){
  perror("mq_receive");
  break;
 }
 printf("got pri %d '%s' len=%d\n", pri, msg.mtext, len);

 int r = mq_getattr(qid, &mattr);
 if (r == -1){
  perror("mq_getattr");
  break;
 }
 }while(mattr.mq_curmsgs);
}

int
main (int argc, char *argv[])
{
 struct mq_attr mattr = {
 .mq_maxmsg = 10,
 .mq_msgsize = sizeof(struct message)
 };

 mqd_t mqid = mq_open("/myq",
  O_CREAT|O_RDWR,
  S_IREAD|S_IWRITE,
  &mattr);
 if (mqid == (mqd_t) -1){
 perror("mq_open");
 exit (1);
 }

 pid_t pid = fork();
 if (pid == 0){
 producer(mqid);
 mq_close(mqid);
 exit(0);
 }
 else
 {
 int status;
 wait(&status);
 consumer(mqid);
 mq_close(mqid);
 }
 mq_unlink("/myq");
 return 0;
}


编译:
gcc test.c -o test

限制POSIX消息队列的最大值为1000个字节
ulimit -q 1000

这里我们执行test程序
./test 
mq_open: Cannot allocate memory

程序报告无法分配内存.

用strace来跟踪test的运行过程,在下面一条语句时报错.
mq_open("myq", O_RDWR|O_CREAT, 0600, {mq_maxmsg=10, mq_msgsize=128}) = -1 ENOMEM (Cannot allocate memory)

{mq_maxmsg=10, mq_msgsize=128}即128*10=1280个字节,说明已经超过了1000个字节的POSIX消息队列限制.

我们将POSIX消息队列的最大值调整为1360时,程序可以运行.
ulimit -q 1360
./test
got pri 3 'No more messages.' len=18
got pri 1 'This is my first message.' len=26
got pri 1 'This is my second message.' len=27
```
- 七)程序占用CPU的时间,单位是秒(cpu time)
```
我们用下面的代码对程序占用CPU时间的限制进行测试

源程序如下：
\# include <stdio.h>
\# include <math.h>

int main (void)

{
 double pi=M_PI;
 double pisqrt;
 long i;

 while(1){
  pisqrt=sqrt(pi);
 }
 return 0;
}

编译:
gcc test.c -o test -lm

运行程序test,程序会一直循环下去,只有通过CTRL+C中断.
./test
^C

用ulimit将程序占用CPU的时间改为2秒,再运行程序.
ulimit -t 2
./test 
Killed

程序最后被kill掉了.
```
- 八)限制程序实时优先级的范围,只针对普通用户.(real-time priority)
```
我们用下面的代码对程序实时优先级的范围进行测试

源程序如下:
\# include <stdio.h>
int main (void)

{
 int i;
 for (i=0;i<6;i++)
 {
  printf ("%d\n",i);
  sleep(1);
 }
 return 0;
}

编译:
gcc test.c -o test

切换到普通用户进行测试
su - ckhitler

用实时优先级20运行test程序
chrt -f 20 ./test
chrt: failed to set pid 0's policy: Operation not permitted

我们用root将ulimit的实时优先级调整为20.再进行测试.
su - root
ulimit -r 20

切换到普通用户,用实时优先级20运行程序,可以运行这个程序了.
su - ckhitler
chrt -r 20 ./test 
0
1
2
3
4
5

以实时优先级50运行程序,还是报错,说明ulimit的限制起了作用.
chrt -r 50 ./test
chrt: failed to set pid 0's policy: Operation not permitted
```

- 九)限制程序可以fork的进程数,只对普通用户有效(max user processes)
```
我们用下面的代码对程序的fork进程数的范围进行测试

源程序如下:
\#include <unistd.h>
\#include <stdio.h>
int main(void)
{
 pid_t pid;
 int count=0;
 while (count<3){
  pid=fork();
  count++;
  printf("count= %d\n",count);
 }
 return 0;
}

编译:
gcc test.c -o test
count= 1
count= 2
count= 3
count= 2
count= 3
count= 1
count= 3
count= 2
count= 3
count= 3
count= 3
count= 2
count= 3
count= 3

程序fork的进程数成倍的增加,这里是14个进程的输出.除自身外,其它13个进程都是test程序fork出来的.
我们将fork的限定到12,如下:
ulimit -u 12
再次执行test程序,这里只有12个进程的输出.
./test 
count= 1
count= 2
count= 3
count= 1
count= 2
count= 3
count= 2
count= 3
count= 3
count= 2
count= 3
count= 3
count= 3
```
- 十)限制core文件的大小(core file size)
```
我们用下面的代码对程序生成core的大小进行测试

源代码:
\#include <stdio.h>

static void sub(void);

int main(void)
{
   sub();
   return 0;
}

static void sub(void)
{
   int *p = NULL;
   printf("%d", *p);
}

编译:
gcc -g test.c -o test

运行程序test,出现段错误.
./test 
Segmentation fault (core dumped)

如果在当前目录下没有core文件,我们应该调整ulimit对core的大小进行限制,如果core文件大小在这里指定为0,将不会产生core文件.
这里设定core文件大小为10个blocks.注:一个blocks在这里为1024个字节.

ulimit -c 10
再次运行这个程序
./test 
Segmentation fault (core dumped)

查看core文件的大小
ls -lh core 
-rw------- 1 root root 12K 2011-03-08 13:54 core

我们设定10个blocks应该是10*1024也不是10KB,为什么它是12KB呢,因为它的递增是4KB.
如果调整到14个blocks，我们将最大产生16KB的core文件.
```
- 十一)限制进程使用数据段的大小(data seg size)
```
一般来说这个限制会影响程序调用brk(系统调用)和sbrk(库函数)
调用malloc时，如果发现vm不够了就会用brk去内核申请.

限制可以使用最大为1KB的数据段

ulimit -d 1 

用norff打开/etc/passwd文件
nroff /etc/passwd
Segmentation fault

可以用strace来跟踪程序的运行.
strace nroff /etc/passwd

打印出如下的结果,证明程序在分配内存时不够用时,调用brk申请新的内存,而由于ulimit的限制,导致申请失败.
munmap(0x7fc2abf00000, 104420)     = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8) = 0
open("/dev/tty", O_RDWR|O_NONBLOCK)   = 3
close(3)                = 0
brk(0)                 = 0xf5b000
brk(0xf5c000)              = 0xf5b000
brk(0xf5c000)              = 0xf5b000
brk(0xf5c000)              = 0xf5b000
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV +++
Segmentation fault


我们这里用一个测试程序对data segment的限制进行测试.
源程序如下:
\#include <stdio.h>
int main()
{

  int start,end;
  start = sbrk(0);
  (char *)malloc(32*1024);
  end = sbrk(0);
  printf("hello I used %d vmemory\n",end - start);
  return 0;
}

gcc test.c -o test
 ./test
hello I used 0 vmemory

通过ulimit将限制改为170KB
再次运行程序
./test
hello I used 167936 vmemory
```
- 十二)限制进程使用堆栈段的大小
```
我们用ulimit将堆栈段的大小调整为16,即16*1024.
ulimit -s 16

再运行命令:
ls -l /etc/
Segmentation fault (core dumped)

这时用strace跟踪命令的运行过程
strace ls -l /etc/

发现它调用getrlimit,这里的限制是16*1024,不够程序运行时用到的堆栈.
getrlimit(RLIMIT_STACK, {rlim_cur=16*1024, rlim_max=16*1024}) = 0

注:在2.6.32系统上ls -l /etc/并不会出现堆栈不够用的情况,这时可以用expect来触发这个问题.

如:
expect
Tcl_Init failed: out of stack space (infinite loop?)
```
- 十三)限制进程使用虚拟内存的大小
```
我们用ulimit将虚拟内存调整为8192KB
ulimit -v 8192

运行ls
ls
ls: error while loading shared libraries: libc.so.6: failed to map segment from shared object: Cannot allocate memory
ls在加载libc.so.6动态库的时候报了错,提示内存不足.

用strace跟踪ls的运行过程,看到下面的输出,说明在做mmap映射出内存时,出现内存不够用.
mmap(NULL, 3680296, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = -1 ENOMEM (Cannot allocate memory)
close(3)                = 0
writev(2, [{"ls", 2}, {": ", 2}, {"error while loading shared libra"..., 36}, {": ", 2}, {"libc.so.6", 9}, {": ", 2}, {"failed to map segment from  share"..., 40}, {": ", 2}, {"Cannot allocate memory", 22}, {"\n", 1}],  10ls: error while loading shared libraries: libc.so.6: failed to map  segment from shared object: Cannot allocate memory
```
- 十四)剩下的三种ulimit限制说明(file locks/max memory size/pipe size)
```
文件锁的限制只在2.4内核之前有用.
驻留内存的限制在很多系统里也没有作用.
管道的缓存不能改变,只能是8*512(bytes),也就是4096个字节.
```
