# 7Linecodes
## [站点服务不可用的报警 --- 七层SLB的CPU占用率达到了100%](https://github.com/r2010shadow/Cookbook/blob/master/ACase/7Linecodes.MD)

* 运维角度
```
热线会议 --- 告知相关环节进而评估风险
```
- -
```
惯例与绿色通道 --- 预演故障情况下的绿色通道
```
```
排除法 --- 缩小故障范围
```
1. 


* 起源
```
local _gcd
_gcd = function (a,b)
    if b == 0 then
        return a
    end
    
    return _gcd (b, a % b)
end
```

* Lua具有这么几个特点
```
    这是一种动态类型语言，常用习惯里变量不需要定义类型，直接给变量赋值就行。
    Lua在对一个数字字符串进行算术操作时，会尝试将这个数字字符串转成一个数字。
    在Lua语言中，数学运算n%0的结果是nan(Not A Number)。
```




[7行代码崩溃3小时，竟因“一个诡计多端的0”](https://www.qbitai.com/2022/07/36300.html)



