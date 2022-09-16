**---什么是序列化（picking）？**

　我们把变量从内存中变成可存储或传输的过程称之为序列化。

　序列化之后，就可以把序列化后的内容写入磁盘，或者通过网络传输到别的机器上。

　反过来，把变量内容从序列化的对象重新读到内存里称之为反序列化，即unpickling。

　举例：大家应该都玩过魔兽争霸，应该知道该游戏有一个存档的功能，我每次不想玩得时候就可以存档，然后再玩得时候我们根本不需要重新开始玩，只需要读档就可以了。我们现在学习的事面向对象的思想，那么在我们眼中不管是我们的游戏角色还是游戏中的怪物、装备等等都可以看成是 一个个的对象，进行简单的分析。

角色对象（包含等级、性别、经验值、HP、MP等等属性） 
武器对象（包含武器的类型、武器的伤害、武器附加的能力值等等属性） 
怪物对象（包含等级、经验值、攻击、怪物类型等等） 
于是玩游戏过程变的非常有意思了，创建游戏角色就好像是创建了一个角色对象，拿到武器就好像创建了一个武器对象，遇到的怪物、NPC等等都是对象了。 
然后再用学  过的知识进行分析，我们发现对象的数据都是保存在内存中的，应该都知道内存的数据在断电以后是会消失的，但是我们的游戏经过存档以后，就算你关机了几天，  再进入游戏的时候，读取你的存档发现你在游戏中的一切都还在呢，奇怪了，明明内存中的数据已经没有了啊，这是为什么呢？于是再仔细考虑，电脑中有硬盘这个  东西在断电以后保存的数据是不会丢的（要是由于断电导致的硬盘损坏了，没有数据了，哈哈，不在此考虑中）。那么应该很容易的想到这些数据是被保存在硬盘中 了。没错！这就是对象的持久化，也就是我们今天要讲的对象的序列化。那么反序列化就很好理解了就是将存放在硬盘中的信息再读取出来形成对象。

 

**---如何序列化？**

　　在python中提供了两个模块可进行序列化。分别是pickle和json。

**pickle**

　　pickle是python中独有的序列化模块，所谓独有，就是指不能和其他编程语言的序列化进行交互,因为pickle将数据对象转化为bytes

 

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.49795081866640145.png)

```
>>> import pickle
>>> d=[1,2,3,4]
>>> pickle.dumps(d)
b'\x80\x03]q\x00(K\x01K\x02K\x03K\x04e.'
>>> type(pickle.dumps(d))
<class 'bytes'>     #类型为bytes
```

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.5557278589663883.png)

 

　　pickle模块提供了四个功能：dumps、dump、loads、load。

　　dumps和dump都是进行序列化，而loads和load则是反序列化。

 

![img](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.8112767298426933.png)

```
>>> import pickle
>>> d=[1,2,3,4]
>>> pickle.dumps(d)
b'\x80\x03]q\x00(K\x01K\x02K\x03K\x04e.'
```

　　dumps将所传入的变量的值序列化为一个bytes，然后，就可以将这个bytes写入磁盘或者进行传输。

　　而dump则更加一步到位，在dump中可以传入两个参数，一个为需要序列化的变量，另一个为需要写入的文件。

![img](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.68316270541579.png)

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.41717175757121616.png)

```
f=open('file_test','wb')
>>> d=[1,2,3,4]
>>> pickle.dump(d,f)
>>> f.close()
>>> f=opem('file_test','rb')
 f=open('file_test','rb')
>>> f.read()
b'\x80\x03]q\x00(K\x01K\x02K\x03K\x04e.'
```

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.8524266571496015.png)

　　loads当我们要把对象从磁盘读到内存时，可以先把内容读到一个bytes，然后用loads方法反序列化出对象，也可以直接用load方法直接反序列化一个文件。

![img](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.7956048802563007.png)

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.9156399005939801.png)

```
>>> d=[1,2,3,4]
>>> r=pickle.dumps(d)
>>> print(r)
b'\x80\x03]q\x00(K\x01K\x02K\x03K\x04e.'
>>> pickle.loads(r)
[1, 2, 3, 4]
```

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.9692881995820832.png)

![img](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.9963909268371498.png)

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.28285030245698506.png)

```
>>> d=[1,2,3,4]
>>> f=open('file_test','wb')
>>> pickle.dump(d,f)
>>> f.close()
>>> f=open('file_test','rb')
>>> r=pickle.load(f)
>>> f.close()
>>> print(r)
[1, 2, 3, 4]
```

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.4419169031551009.png)

**json**

　　如果我们要在不同的编程语言之间传递对象，就必须把对象序列化为标准格式，比如XML，但更好的方法是序列化为JSON，因为JSON表示出来就是一个字符串，可以被所有语言读取，也可以方便地存储到磁盘或者通过网络传输。JSON不仅是标准格式，并且比XML更快，而且可以直接在Web页面中读取，非常方便。

　　如果想要详细了解JSON的话，推荐一篇博文：http://www.cnblogs.com/mcgrady/archive/2013/06/08/3127781.html

　　json中的方法和pickle中差不多，也是dumps，dump，loads，load。使用上也没有什么区别,区别在于，json中的序列化后格式为字符。

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.46225672795689765.png)

```
>>> import json
>>> d=[1,2,3,4]
>>> json.dumps(d)
'[1, 2, 3, 4]'
>>> type(json.dumps(d))
<class 'str'>           #类型为str
```

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.67398005546662.png)

因为python中一切事物皆对象，所有对象都是基于类创建的，所以，‘类’在python中占据了相当大的比重。我们能否将类的实例进行序列化呢？

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.73954819794592.png)

```
>>> class student(object):
...     def __init__(self,name,age,course):
...         self.name=name
...         self.age=age
...         self.course=course
...         
>>> a=student('linghuchong',24,'xixingdafa')
>>> import json
>>> json.dumps(a)
TypeError: <student object at 0x035B8230> is not JSON serializable
```

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.5914350681816987.png)

 晕，竟然不能！现在几乎都是面向对象编程，类这么重要，竟然不能序列化，怎么搞？

不要着急，前面的代码之所以无法把student类实例序列化为JSON，是因为默认情况下，dumps方法不知道如何将student实例变为一个JSON的'{}'对象。

我们需要’告诉‘json模块如何转换。

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.7309669300654265.png)

```
>>> def st_to_dict(a):
...     return {'name':a.name,'age':a.age,'course':a.course}
...     
>>> print(json.dumps(a,default=st_to_dict))          #default参数就是告知json如何进行序列化
{"course": "xixingdafa", "name": "linghuchong", "age": 24}
    
```

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/ba9cd57d-5825-48b3-b6a8-30909f42e6f3/index_files/0.6940313749565412.png)

当然，如果我们每定义一个类，还得再定义一下这个类的实例转换为字典的函数实在是太麻烦了！！我们有一个一劳永逸的办法。

```
print(json.dumps(a, default=lambda obj: obj.__dict__))
```

其中的__dict__不需我们在类中定义,因为通常class的实例都有一个__dict__属性，它就是一个字典，用来存储实例变量。

```
>>> print(a.__dict__)
{'course': 'xixingdafa', 'age': 24, 'name': 'linghuchong'}
```

 

no

来源： http://www.cnblogs.com/MnCu8261/p/5539254.html
