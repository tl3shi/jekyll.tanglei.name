---
title: Mac 软件推荐(续)之程序猿篇
layout: post
categories: 
  - 经验技巧
tags: 
  - 经验技巧
  - Mac
---

在前面一篇文章["Mac 软件推荐续(!程序猿篇)"](http://www.tanglei.name/blog/app-in-mac-for-common.html) (文章取名装X失败, 悲伤脸)中, 我已经介绍了一些大众化的软件, 当然作为程序猿的你也应该参考参考. 
本篇文章将介绍一些可以提高程序猿工作效率的一些软件和工具及相关配置. 

## Mac built-in

首先介绍的就是我觉得应该熟悉 Mac 内置的一些软件及配置. 

### trackpad 配置

1. **启用 Tap**
启用 **Tap to click**, 在 `System Preferences -> Trackpad ` 中启用, 用 **tap** 替换 **click** 的操作, 明明轻轻 **tap** 就可以完成的, 为何还要用力点击才 OK. 现在偶尔用其他人电脑非得用力 click 就太纠结了.

同时, 还有 "右键"功能, **Secondary click**, 用两个手指 tap 弹出右键菜单. 
![mac trackpad 设置](/resources/app-in-mac/mac-os-trackpad.png)

2. **开启单词选词查询**
选中某个中英文单词后, 三指 tab 会弹出词典释义. 这个在[之前一篇文章](http://www.tanglei.name/blog/app-in-mac-preface.html)中有介绍. 

3. **Scroll 方向 **
这个道是自己习惯就好. 由于我刚开始从 Win 转向 Mac 的时候习惯用 Win 的那种方式, 于是就没有开启 *Scroll direction: natural*, 然后也一直沿用至今. 

4. **其他手势** 其他手势有必要熟悉一下, 比如知道在 Win 环境下用 `win+d` 可以显示桌面, 相应的功能在 Mac 下如何做. 

### 快捷键

作为程序猿, 肯定离不开各种快捷键. 对于 Mac 内置的一些快捷键, 我们还是很有必要知道的.  基本的复制/粘贴就不说了, 常用的还有

```
空格键: 预览
cmd + ,: 设置
cmd + -/=: 缩小/放大
ctrl + u: 删除到行首(与zsh冲突, zsh中是删除整行)
ctrl + k: 删除到行尾
ctrl + p/n: 上/下移动一行或者前/后一个命令
ctrl + b/f: 光标前/后移char
esc + b/f: 光标前/后移word(蛋疼不能连续work)
ctrl + a/e: 到行首/行尾
ctrl + h/d: 删前/后字符
ctrl + y: 粘贴
ctrl + w: 删除前一个单词
esc + d: 删后一个单词
ctrl + _: undo
ctrl + r: bck-i-search/reverse-i-search, 输入关键字搜索历史命令
```

上面的这些快捷键特别是在敲命令时还是很有用的(可能有得确实是在命令行中才生效), 特别是结合 zsh 自动补全等功能. 比较 DT 的是就是 `esc` 一起用的时候, 不能连续使用. 举个例子, terminal 中输入了 `git push origin source`, 光标在末尾, 这时按住`ctrl` 不放, 按一下 `w` 即向前删除一个单词. 而 `esc + d` 不能这样结合使用, `esc` 必须中途释放再按才能 work. 

啥? 你说上面快捷键 `ctrl + w` 等不太好按? 按键特别别扭? 
你需要做的就是将 `caps lock` 映射为 `ctrl`, `Keyboard -> Modifier Keys `修改, 目前我笔记本上的 `ctrl` 键无效. 不过, 一般情况下我用我的 HHKB, 这种映射方式正好符合 HHKB 的布局. (其实我是在买 HHKB 之前就修改的这个映射)

另外, 借助之前介绍的Karabiner, 可以将一些常用的方向键(上下左右)重新映射一下, 比如我目前是 `s + h/j/k/l` 来表示方向, 手不用太移动就能直接按方向(HHKB 本身按方向太麻烦, Mac 内置键盘有方向键还需要大幅度移动手), 用起来方便多了. 


Mac 内置的更多的快捷键列表可以参考 [Mac 官网](https://support.apple.com/zh-cn/HT201236)

其他还有一些常用的软件的快捷键, 可以用之前介绍的软件 cheetsheet, 长按 **cmd**, 可弹出当前 active 的软件的快捷键.

### 截图

这个从快捷键中单独列出来了, 就强调下这个功能. 

`cmd + shift + 3` 截取整个屏幕. 
`cmd + shift + 4` 部分窗口, 出现十字供选取, 若此时按空格键(这个技能得点赞), 会选取当前应用的窗口, 再 **tap** 即可完成截图. 

上面快捷键是截图后以文件形式保存在桌面(默认是桌面, 当然你也可以自己修改保存位置), 再上面快捷键基础上再同时按 `ctrl` 就会把图片保存在内存/剪贴板中, 直接去相应窗口粘贴即可.


## home brew

类似 centos 的 **yum**, ubuntu 的 **apt-get**, 能够方便管理安装软件包. 
Mac 上类似的应用还有**port**, 我刚开始试用过 port, 貌似 brew 上的源会多一些. 
brew-cask 是 brew 的一个加强版, 可以安装一些桌面应用, 例如 chrome 等等之类的. 

这里就不多介绍了, 详情可以到官网查看. 
[brew](http://brew.sh/)
[brew-cask](https://caskroom.github.io/)

## iTerm2 

[iTerm2官网](http://www.iterm2.com/features.html)有介绍功能. 以下是觉得可能常用的功能. 

1. **分屏功能**
	- `cmd + d` 竖着分屏, `cmd + shift + d` 横着分屏
	- `cmd + t` 新建一个 tab, `cmd + num` 切换到第 num 个 tab
	- 当前窗口含有分屏时, 通过 `cmd + [` 和 `cmd + ]` 来进行切换小的分屏

2. **热键** 设置一个热键, 比如我的是 `alt + 空格`, 弹出 iTerm2, 且以半透明的方式显示在当前 active 的窗口上面.
![iTerm2 hotkey](/resources/app-in-mac/iterm2-hotkey.png)

3. 搜索
	- `cmd + f`搜索输入关键字后, 匹配的会黄色高亮, 此时按 `tab` 或者 `shift + tab` 会自动向后/前以word 的方式选中高亮的, 并自动 copy 到剪切板
	- 在所有的 tab 中全局搜索, 搜索出候选项后, 再选着你想要进入的 tab. 
	
	![iTerm2 search](/resources/app-in-mac/iterm2-search-all.png)

4. 其他
	- 新版本的 iTerm2 还支持直接在控制台里 ls 图片文件(图片显示在控制台里).(如上图下半部分, 连 gif 都支持)
	- 自动识别控制台里的内容, 如含有链接或者本地文件路径可以用 `cmd` 加点击的方式直接打开链接或者文件(如下图上半部分). 这个功能很重要呢, 比如在编译过程中, 出现了 warning 或者 error, 一般会打印出具体文件路径, 此时直接从控制台就能打开文件进行 fix 了. 
![iTerm2 imgcat](/resources/app-in-mac/iterm2-imgcat.png)
	- 自动补全, iTerm2 本身是支持自动补全的, 不过建议直接结合后面的zsh使用.
	- 一些高级的功能目前可能处于测试版本, 你若用的稳定版是不支持的, 需要到官网下测试版. 还有更多的功能请到 iTerm2 官网探索吧. 

## zsh

这个墙裂推荐啊. 结合 [oh my zsh](http://ohmyz.sh/), 丰富的[插件资源](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins-Overview). 

语法高亮, 自动补全等特别好, 在此推荐的几个插件或功能

1. **git**: 当前目录若是在一个 git repo 下面的话, 会自动显示当前的分支信息等等. 然后可以自己搞一些 alias, 简写命令, 比如我常用的一些. 

```
alias gs='git status'
alias gb='git branch -va'
alias gco='git checkout'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gfom='git fetch origin master'
alias gfod='git fetch origin develop'
alias grod='git rebase origin/develop'
alias grom='git rebase origin/master'
```

2. **autojump**: 这个也炒鸡赞. 会自动记录你 `cd` 过的目录, 下次你直接 `j keyword` 就会自动 `cd` 到以 *keyword* 匹配的目录. 

3. **osx**: 举个最简单的例子, 比如你现在正在 finder 中浏览一个很深的目录, 现在突然想 cd 到这个目录去做一些命令操作. 如果你用xtrafinder 这样的软件的话道有这样的功能, 如果配上这个插件, 你直接输入 `cdf` (cd finder)就自动 `cd` 到 finder 打开的目录下. 

4. **zsh-autosuggestions**, 如下图所示, 我在 *app-in-mac* 这个目录下, 刚输入了 `git`, 此时光标还在 `p` 前面, zsh 就已经自动给我补全了 `git push origin source`, 此时我只要按 `ctrl + e` 跳转到行尾(所以熟悉上文中的快捷键很有必要啊), 回车即可执行命令了. 

![iTerm2 zsh plugins](/resources/app-in-mac/zsh-plugins.png) 

更多的, 还是请到官网查看. 

## sublime text

文本编辑器, 也有丰富的插件支持, 直接[官网](http://www.sublimetext.com/)看吧. 这个 App, 我用得也不是很多. 

这里分享一个小的功能, 怎么在命令行用 sublime 打开特定的文件. 其实就是添加一个软链即可. 

```bash
➜  app-in-mac git:(source) ✗ subl dungeon-game.cpp
➜  app-in-mac git:(source) ✗ which subl
/usr/local/bin/subl
➜  app-in-mac git:(source) ✗ ls -la /usr/local/bin/subl
lrwxr-xr-x  1 tanglei  admin  62  1 24  2016 /usr/local/bin/subl -> /Applications/Sublime Text.app/Contents/SharedSupport/bin/subl
➜  app-in-mac git:(source) ✗
```

## Vim 

介绍 Vim 的文章也很多了. 这里就不详细展开了. 分享下俩我用的部分插件. 


Vundle/pathogen
nerdtree
YouCompleteMe: [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)
conque_term
ag

## Dash 

其实介绍[前文](http://www.tanglei.name/blog/app-in-mac-preface.html) 介绍 Alfred 已经提到过, 这里再介绍一下. 程序猿应该必备啊. 内置各种语言, 各种环境的各种文档. 该 App 还提供各种 API 供其他工具交互使用. 例如 Vim(不是想象当中自动补全功能, 只是能够快捷地搜索 API), Sublime 等.  (p.s 要是有人写了一个 Vim 插件, 能够支持调用 dash 的 API 自动补全代码, 那应该会很受欢迎的)

![](/resources/app-in-mac/dash-main.png)


## 其他App

### chrome 

插件

- dont redirect
- f + 字母链接
- cVim/Vimium


### Charles

类 Windows 下 Fiddler 抓包应用. 

类似命令 tcpdump

### Postman

类似命令 curl 

ifttt

## 其他有用的命令行

- openssl sha1 
- md5
- base64
