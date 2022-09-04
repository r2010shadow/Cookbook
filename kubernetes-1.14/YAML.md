# YAML
## Yet Another Markup Language
```
是“另一种标记语言”的外语缩写
但为了强调这种语言以数据做为中心
而不是以置标语言为重点
而用返璞词重新命名

它是一种直观的能够被电脑识别的数据序列化格式
是一个可读性高并且容易被人类阅读
容易和脚本语言交互
用来表达资料序列的编程语言

http://yaml.org/
YAML资源
```
## 规则一：缩进
```
YAML 使用一个固定的缩进风格表示数据层结构关系
需要每个缩进级别由两个空格组成
注意不要使用 tabs 键
例如 mysql.yaml 中 options 和 replication 这是2个层级，用2个空格来表示
如果同一层级，那就竖直对齐就好啦：
init_config:

instances:
  - server: localhost
    user: oneapm
    pass: YourPassword
    tags:
      - tag_key1:tag_value1
      - tag_key2:tag_value2
    options:
      replication: 0
      galera_cluster: 1
```      
## 规则二：短横杠
```
想要表示列表项
使用一个短横杠加一个空格
多个项使用同样的缩进级别作为同一列表的一部分：
- list_value_one
- list_value_two
- list_value_three    
列表可以可以作为一个键值对的 value，这个在 tags 里面很多：
db_user:
  - wang
  - zhang
  - li
```
## 规则三：冒号
```
字典的 keys 在 YAML 中的表现形式是一个以冒号结尾的字符串
values 的表现形式是冒号后面的同一行
用一个空格隔开：
my_key: my_value    
一个 value 可以通过缩进与 key 联接
注意也是缩紧2个空格
一个 key 的 value 不是单一的
而是一个列表的values
my_key:
  my_value1
  my_value2
其中字典也可以嵌套：
first_key:
  second_key: value_in_second
```
