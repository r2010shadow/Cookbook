# Vim for mac   
* update brew   
```
run under Ruby 2.3
rm -r -f /usr/local/share/doc/homebrew 
brew update
## install vim
brew install vim
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
more http://codingpy.com/article/vim-and-python-match-in-heaven/
```

* Set
```
set filetype=python
au BufNewFile,BufRead *.py,*.pyw setf python
set helplang=cn "中文帮助文档(前提是下了中文包)
syntax enable
syntax on " 自动语法高亮
set number"显示行号
colorscheme desert" 设定配色方案
set guifont=Consolas:h12:cANSI"英文字体
set guifontwide=SimSun-ExtB:h12:cGB2312
set tabstop=4"表示Tab代表4个空格的宽度
set expandtab"表示Tab自动转换成空格
set autoindent"表示换行后自动缩进
set autoread " 当文件在外部被修改时，自动重新读取
set history=400"vim记住的历史操作的数量，默认的是20
set nocompatible"使用vim自己的键盘模式,而不是兼容vi的模式
set confirm"处理未保存或者只读文件时,给出提示
set smartindent"智能对齐
set shiftwidth=4
```

* Set vimrc
```
cd ~
touch .vimrc
vim .vimrc

"去掉vi的一致性"
set nocompatible
"显示行号"
set number
" 隐藏滚动条"    
set guioptions-=r 
set guioptions-=L
set guioptions-=b
"隐藏顶部标签栏"
set showtabline=0
"设置字体"
set guifont=Monaco:h13         
syntax on   "开启语法高亮"
let g:solarized_termcolors=256  "solarized主题设置在终端下的设置"
set background=dark     "设置背景色"
colorscheme solarized
set nowrap  "设置不折行"
set fileformat=unix "设置以unix的格式保存文件"
set cindent     "设置C样式的缩进格式"
set tabstop=4   "设置table长度"
set shiftwidth=4        "同上"
set showmatch   "显示匹配的括号"
set scrolloff=5     "距离顶部和底部5行"
set laststatus=2    "命令行为两行"
set fenc=utf-8      "文件编码"
set backspace=2
set mouse=a     "启用鼠标"
set selection=exclusive
set selectmode=mouse,key
set matchtime=5
set ignorecase      "忽略大小写"
set incsearch
set hlsearch        "高亮搜索项"
set noexpandtab     "不允许扩展table"
set whichwrap+=<,>,h,l
set autoread
set cursorline      "突出显示当前行"
set cursorcolumn        "突出显示当前列"
```
