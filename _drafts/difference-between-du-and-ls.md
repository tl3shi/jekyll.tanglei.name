---
title: difference-between-du-and-ls
layout: post
categories: 
  - 经验技巧
tags: 
  - 经验技巧
  - Linux
---


### 由一次磁盘告警引发的血案

准确点说，不是收到的自动告警短信或者邮件告诉我某机器上的磁盘满了，而是某同学人肉告诉我为啥该机器写不了新文件了, 说明我司告警服务还不太稳定 :) 

第一次出现该问题时，先删了 `/tmp/` 目录, 空闲出了部分空间, 然后看了下主要的几个用户目录，发现某服务A的日志文件(contentutil.log)占用了好几个大G, 询问了相关开发人员该日志作用等是否可以直接删除还是说需要压缩备份到某地然后再删. 结论是可以直接删除, 于是 `rm contentutil.log` 之后就天真地认为万事大吉了...(不懂为啥当初没 df 再看看)

然而, 大约xx天后, 发现该机器磁盘又满了, 惊呼奇怪咋这么快又满了. 最终发现是上次 `rm contentutil.log` 后, 占用好几个大G的contentutil.log 一直被服务A的进程打开了, rm后空间并没有释放。 `rm` 其实是删除了该文件名到文件真正保存的磁盘位置的链接, 此时该文件句柄还被服务A打开, 因此对应的数据块并没有被回收, 其实可以理解为 GC 里面的引用计数, `rm` 只是减少了引用计数, 并没有真正的进行释放内存, 当引用计数为0的时候, OS内核才会释放空间, 供其他进程使用。所以当A进程停止(文件句柄的引用计数会变为0)或者重启后，占用的存储空间才被释放(从某种程度上讲说明该服务一直很稳定, 可以连续跑很久不出故障~ 微笑脸)。 
(tip: 如果不知道具体进程或文件名的话：`lsof | grep deleted`，这样会查找所有被删除的但是文件句柄没有释放的文件和相应的进程，然后再kill掉进程或者重启进程即可)
后来, 白老板告知可以用修改文件内容的方式在不用重启的情况下释放空间。

### du vs ls

前两天又出现了该问题了, 该服务A的日志文件(contentutil.log)占用了约7.6G(请原谅我们没有对该服务的日志做logrotate)。这一次学聪明了, 直接用`echo 'hello' > contentutil.log` 然后 `df` 看了下确实释放空间了, 心想着这次可以 Happy 了, 突然手贱执行了下 `ls` 和 `du`, 有了以下结果: 

```
[root@xxx shangtongdai-content-util]# ls -lah contentutil.log
-rw-r--r--. 1 root root 7.6G Nov  7 19:36 contentutil.log
[root@xxx shangtongdai-content-util]# du -h contentutil.log
2.3M    contentutil.log
```

百思不得其解, `ls` 和 `du` 这里的结果肯定代表不同的含义, 具体原因不详, 在朋友圈求助了下, 有了一些眉目. 大概与文件空洞和稀疏文件(holes in 'sparse' files)相关. 

`ls` 的结果中是 apparent sizes, 我的理解是文件长度, 好比 file 这个数据结构中的文件长度这个字段, `du` 的结果 disk usage, 真正占用存储空间的大小, 且默认度量单位是 block.  (apparent sizes 和 disk usage 说法摘自 `man du` 中的 `--apparent-size` 部分)

```
// Mac OS 10.11.6 (15G1004)
➜  _drafts git:(source) ✗ echo -n a >1B.log
➜  _drafts git:(source) ✗ ls -las 1B.log
8 -rw-r--r--  1 tanglei  staff  1 11  9 00:06 1B.log
➜  _drafts git:(source) ✗ du 1B.log
8	1B.log
➜  _drafts git:(source) ✗ du -h 1B.log
4.0K	1B.log
➜  _drafts git:(source) ✗
```

上面示例中, 文件 1B.log 内容就含一个字母 a, 文件长度为1个字节, 前面的 8 为占用的存储空间 8 个 block, (ls -s 的结果跟 du 的结果等价, 都是现实占用的空间), 为什么直接就占用8个 block 呢, 可以这样理解, block 为磁盘存储的基本的单位, 方便磁盘寻址等. 默认情况下, Mac中1个block中是 512-byte, 因此 `du -h` 结果是 `8 * 512 = 4096 = 4.0K` (ref `man du`: If the environment variable BLOCKSIZE is set, and the -k option is not specified, the block counts will be displayed in units of that size block.  If BLOCKSIZE is not set, and the -k option is not specified, the block counts will be displayed in 512-byte blocks.)

所以通常情况下, `ls` 的结果应该比 `du`的结果更小才对(都指用默认的参数执行, 调整参数可使其表达含义相同), 然而上面跑服务 A 的机器上 contentutil.log 的对比结果是 `7.6G vs. 2.3M`, 无法理解了. 顺着 [man du](https://linux.die.net/man/1/du) 可以看到 *although the apparent size is usually smaller, it may be larger due to holes in ('sparse') files, internal fragmentation, indirect blocks, and the like* 即因contentutil.log是一个稀疏文件, 虽然其文件长度很大, 到7.6G了, 然而其中包含大量的`holes`并不占用实际空间.   

下面用一个具体的例子来复现以上遇到的问题. 注意以下例子为 Linux version 2.6.32 (Red Hat 4.4.7)中运行结果, 且在 Mac 中并不能复现.


```
// 从标准输入中读取 count=0 个block, 输出到 sparse-file 中, 一个 block 的大小为1k(bs=1k), 输出时先将写指针移动到 seek 位置的地方
[root@localhost ~]# dd of=sparse-file bs=1k seek=5120 count=0
0+0 records in
0+0 records out
0 bytes (0 B) copied, 1.6329e-05 s, 0.0 kB/s
// 所以此时的文件长度为: 5120*1k(1024) = 5242880
[root@localhost ~]# ls -l sparse-file
-rw-r--r--. 1 root root 5242880 Nov  8 11:32 sparse-file
[root@localhost ~]# ls -ls sparse-file
0 -rw-r--r--. 1 root root 5242880 Nov  8 11:32 sparse-file
// 而 sparse-file 占用的存储空间为 0 个 block
[root@localhost ~]# du sparse-file
0	sparse-file
[root@localhost ~]# du -h sparse-file
0	sparse-file
```

此时若用 vim 打开该文件, 用二进制形式查看 (tip `:%!xxd` 可以更改当前文件显示为2进制形式), 能看到里面的内容全是`0`. 或者直接用`od`命令查看2进制. 

```
// vim 二进制查看
0000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
....
//od -b sparse-file
0000000   000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000
*
24000000
```

其实本来 Sparse 文件是不占用存储空间的, 当在读取稀疏文件的时候, 文件系统根据文件的 metadata(就是前面说的文件这个数据结构)自动用`0`填充; 因此, 实际上文件不占用磁盘空间, 读取运行时又被自动填充了`0`. 前面这句 Wiki 上说的. Wiki还说, 现代的一些文件系统都支持 Sparse 文件, 包括 Unix 变种和 NTFS, Apple File System(APFS)不支持, 因此我在我的 Mac 上用 du 查看占用空间跟 ls 的结果一致. Wiki 最后还指出 Apple 在今年6月的 WWWC 上宣称支持 Sparse 文件. (貌似目前我的系统版本还不支持)

```
// In Mac
➜  ~ dd of=sparse-file bs=1k seek=5120 count=0
0+0 records in
0+0 records out
0 bytes transferred in 0.000024 secs (0 bytes/sec)
➜  ~ ls -ls sparse-file
10240 -rw-r--r--  1 tanglei  staff  5242880 11  9 09:44 sparse-file
➜  ~ du sparse-file
10240	sparse-file
```

以上是用 `dd` 等命令创建稀疏文件, 也有同学用 c 代码实现了相同的功能. 其实就是写文件的时候, 改变下当前文件写指针. 前面提到的问题也应该是类似.

```c
#include <stdio.h>
#include <fcntl.h>
#include <string.h>

int main() {
    int fd, result;
    char wbuf[] = "hello";

    if ((fd = open("./filetest.log", O_RDWR|O_CREAT|O_EXCL, S_IRUSR|S_IWUSR))
)  {
            perror("open");
            return -1;
    }
    if ((result = write(fd, wbuf, strlen(wbuf)+1)) < 0) {
            perror("write");
            return -1;
    }
    if ((result = lseek(fd, 1024*1024*10, SEEK_END)) < 0) {
            perror("lseek");
            return -1;
    }
    if ((result = write(fd, wbuf, strlen(wbuf)+1)) < 0) {
            perror("write");
            return -1;
    }

    close(fd);
    return 0;
}
```
gcc 编译后， 运行结果产生的 filetest.log 文件详情如下: 

```
[root@localhost ~]# ls -ls filetest.log
8 -rw-------. 1 root root 10485772 Nov  9 17:45 filetest.log
[root@localhost ~]# du  filetest.log
8	filetest.log
[root@localhost ~]# du -h filetest.log
8.0K	filetest.log
[root@localhost ~]# ls -lh filetest.log
-rw-------. 1 root root 11M Nov  9 17:45 filetest.log
[root@localhost ~]# od -c filetest.log
0000000   h   e   l   l   o  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000020  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
50000000  \0  \0  \0  \0  \0  \0   h   e   l   l   o  \0
50000014
```

文件长度应该是 "hello" 加上 "\n" 共6个字节`*2 = 12`, 再加上`1024*1024*10`个字节为ls产生的结果10485772个字节约11M, 而du的结果为8个block也为8k(这台机器上得block大小为1024). (`du --help`能得到: *Display values are in units of the first available SIZE from --block-size, and the DU_BLOCK_SIZE, BLOCK_SIZE and BLOCKSIZE environment variables.  Otherwise, units default to 1024 bytes (or 512 if POSIXLY_CORRECT is set).*

总结: 出现以上问题说明自己对一些基础掌握得尚不牢固, 比如 1). rm 某文件后, 文件占用的磁盘空间并不是立即释放, 而是其句柄没有被其他进程引用时才回收; 2). ls/du 命令结果的具体含义; 3). 稀疏文件. 这些知识点都在 <UNIX环境高级编程> 这本书中有讲 (之前走马观花看过不少, 咋对稀疏文件等一点印象都木有!) 

以上内容若有不清楚或不正确的地方, 还望大家指出, 感谢.

参考资料: 

- [删除守护进程的日志](http://blog.qiusuo.im/blog/2014/08/18/rm-daemon-log/)
- [wiki Sparse\_file	](https://en.wikipedia.org/wiki/Sparse_file)
- [man du](https://linux.die.net/man/1/du)
- [《UNIX环境高级编程》笔记--read函数，write函数，lseek函数](http://blog.csdn.net/todd911/article/details/11237627)
- [为什么用ls和du显示出来的文件大小有差别？](http://www.cnblogs.com/coldplayerest/archive/2012/02/19/2358098.html)
- UNIX环境高级编程 第2版, 第3章 文件 I/O, 第4章 文件和目录
