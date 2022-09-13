- 对文件和目录进行简单的比较处理，

- - 如果需要复杂的文件比较需要使用difflib库来处理。



**filecmp.cmp(f1, f2, shallow=True)**



- 比较文件f1和文件f2

- - 当两个文件相同时返回True

  - - 否则返回False

- 只判断os.stat()函数返回内容是否相同

- - 如果相同就返回True

  - - 否则再比较文件内容是否相同
    - 使用shallow参数可以快速地比较文件是否有修改过



例子：

\#[Python](http://lib.csdn.net/base/11) 3.4

import filecmp

 

r = filecmp.cmp('F:\\temp\\py\\bisect2.py', 'F:\\temp\\py\\bisect2.py')

print(r)

r = filecmp.cmp('F:\\temp\\py\\bisect2.py', 'F:\\temp\\py\\cal_1.py')

print(r)

结果输出如下：

True

False

 

**filecmp.cmpfiles(dir1, dir2, common, shallow=True)**



- 比较两个目录里相同文件列表的文件

- - 参数dir1是目录1
  - 参数dir2是目录2
  - 参数common是比较的文件列表
  - 参数shallow是跟上面的函数是一样意义

- 本函数运行之后返回三个文件名列表：

- - 相同列表
  - 不相同列表
  - 错误列表





例子：

\#python 3.4

import filecmp

 

dir1 = 'F:\\temp\\py\\dir1'

dir2 = 'F:\\temp\\py\\dir2'

r = filecmp.cmpfiles(dir1, dir2,['difflib1.py', 'difflib5.py', 'test1.txt'])

print(r)

结果输出如下：

(['difflib1.py'], ['difflib5.py'], ['test1.txt'])





 x=filecmp.dircmp('/root/py','/root/py-2')

 x.report()

diff /root/py /root/py-2

Identical files : ['di.py', 'dns-1.py', 'dns-s.py', 'dns.py', 'dns.pyc', 'get.py']

 

**filecmp.clear_cache()**



- 清除文件比较缓冲区

- 当比较的文件不断地快速修改时

- - 就可以使用这个函数来更新文件的信息



 

**class filecmp.dircmp(a, b, ignore=None, hide=None)**



- 构造一个新的目录比较对象

- - 比较目录a和b

  - 参数ignore是忽略列表

  - - 是指那些文件不需要进行比较的

  - 参数hide是隐藏的文件列表

  - - 默认是[os.curdir, os.pardir]





这个类主要提供下面的方法：



- report()

- - 打印a和b之间的比较结果到系统sys.stdout输出。

 

- report_partial_closure()

- - 打印目录a和b，以及公共的子目录的比较结果到系统sys.stdout输出。

 

- report_full_closure()

- - 递归所有目标，包括子目录，把结果比较输出。

 

- left

- - 内部表示目录a。

 

- right

- - 内部表示目录b。

 

- left_list

- - 内部表示目录a经过隐藏和忽略过滤的文件和子目录列表。

 

- right_list

- - 内部表示目录b经过隐藏和忽略过滤的文件和子目录列表。

 

- common

- - 目录a和b都有的公共文件和子目录。

 

- left_only

- - 仅在目录a出现的文件和子目录。

 

- right_only

- - 仅在目录b出现的文件和子目录。

 

- common_dirs

- - 在目录a和目录b都出现的子目录。

 

- common_files

- - 在目录a和目录b都出现的文件。

 

- common_funny

- - 比较目录a和b不同的目录或文件，通过os.stat()比较。

 

- same_files

- - 比较目录a和b相同的目录或文件。

 

- diff_files

- - 比较目录a和b不同的目录或文件，通过文件内容比较。

 

- funny_files

- - 不进行比较的文件。

 

- subdirs

- - 子目录字典。

 

- filecmp.DEFAULT_IGNORES

- - 需要忽略的文件列表。



 

例子：

from filecmp import dircmp

def print_diff_files(dcmp):

   for name in dcmp.diff_files:

​     print("diff_file %s found in %s and %s" % (name, dcmp.left,

​        dcmp.right))

   for sub_dcmp in dcmp.subdirs.values():

​     print_diff_files(sub_dcmp)

 

dcmp = dircmp('dir1', 'dir2')

print_diff_files(dcmp)

在这个例子里，主要比较目录dir1和dir2，为此创建了dircmp对象dcmp，然后调用函数print_diff_files()，在这个函数里主要打印输出不同的文件，并递归到子目录里打印子目录里不同的文件输出。

demo：

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/acf77684-c332-4767-b2cb-952831046ddc/index_files/0.42262697783494274.png)

```
 1 #python filecmp
 2 #比较文件/文件夹
 3 
 4 from filecmp import *
 5 
 6 def print_diff_files(dcmp):
 7     print(dcmp.diff_files)
 8     for name in dcmp.diff_files:
 9         print("diff_file %s found in %s and %s" % (name, dcmp.left, dcmp.right))
10     for sub_dcmp in dcmp.subdirs.values():
11         print_diff_files(sub_dcmp)
12 
13 def main():
14     dirA = 'c:\\Download\\'
15     dirB = 'c:\\MyDrivers\\'
16     dcmp = dircmp(dirA, dirB)
17     print_diff_files(dcmp)
18 
19 if __name__ == '__main__':
20     main()
```

**dircmp(f1,f2)**

\>>> filecmp.dircmp('/root/py','/root/py-2').report()

diff /root/py /root/py-2

Only in /root/py : ['diff.py', 'dns-1.py']

Identical files : ['di.py', 'dns-s.py', 'dns.py', 'dns.pyc', 'get.py']
