# Tcl基本
Tcl只支持一种数据结构：字符串（string），所有的命令，命令的所有的参数，命令的结果，所有的变量都是字符串。请牢记这一点，所有的东西都是字符串；
##注释
Tcl同shell、perl一样，用`#`进行注释，并且tcl代码和注释最好分行写；除非代码用`;`作为结束，此时代码和注释方可写在一行，因为Tcl的命令是用换行符或分号来隔开的；
##变量定义和赋值
tcl将所有值当做字符，所以“set x 10”中的10是字符，而不被理解为真正的10。对比其他语言，perl是自动匹配，即编译器自动判断是数字还是字符，C语言是用户告诉编译器是int还是char。
###字符赋值
set x 10，或 set x $a
###数字赋值
使用 expr 命令，如：set y [expr 10+100]，则y的值就是110，注意：110仍然是个字符。
在赋值、数学计算中，都使用[]，而不是传统的()，如[ expr [ expr 1+2 ] *3 ]，所以最好不要用tcl进行数学计算，只用它处理字符和文件；
### 变量运算
set y [expr $x+100]，y的值仍然是110。
###显示变量
`puts 文件句柄  $x`或者`puts $x`(默认文件句柄为stdout)，或者直接`set $x`也是可以的。
###取消变量
	unset x y z 注销了 x y z 三个变量
###追加变量
	set x 10 
	append x abc
	此时x的值为10abc
##关键字符转义
\空格--------------------空格
\ [  ------------------------[ ([]只需要转义前一个[即可，后面]不需要转义)
\x48 ---------------------十六进制0x48对应的ASCII字符
\756 -------------------- 八进制0756对应的ASCII字符
##数组
Tcl中，数组只能和数组元素一起声明。数组中，数组元素的名字包含两部分：数组名和数组中元素的名字，例如：`set day(monday) 1`
###定义数组
`set x {1 2 3}`，等同于 `set x [list 1 2 3]`

此外，可以使用""或{}，如：`set x "1 2 3"，x = 1 2 3,`
`""`的用法： 编译器仍然编译`""`里面的内容，如：set x "$y"，则 x = y的值；`[express]`也会被编译。
`{}`的用法： 编译器不编译`{}`中的任何内容，如：`set y {\n}`，则 `y = \n`，{}其实是定义数组的方式；
###数组嵌套
`set x 1 2 3 {4 5}`  `set y {1 2 {3 4} 5}`
###合并数组
`set $z [concatlist $x $y]`
###从数组中取元素
`lindex $x 2`，从$x中取从0开始第2个元素
###数组长度
`llength $x`
###插入数组元素
`linsert $x 3 $y`，在原数组$x的3位置插入一个新数组$y，序号3位置可以使用end表示最后一个。
###替换数组元素
`lreplace $x 1 3 5 7`，将原数组$x的第1~3位置元素替换为5和7。
###截取数组
`lrange $x 1 3`，截取原数组$x的第1~3位置的一段。
###尾部追加数组元素
`lappend x 1 3 4`，在原数组x的后面加入元素1 3 4。注意：该命令与上面的数组命令不同。上面的数组命令只产生一个新的数组，原数组x不变，而本命令会改变原数组x本身。因此我们不写成`lappend $x 1 3 4`，而应该写成`lappend x 1 3 4`。
###在数组元素中查找
`lsearch $x 33`，在数组 $x 中查找33，找到后返回序号，未找到返回-1。搜索命令可以加控制选项：-exact（完全匹配，不支持通配符*等），-glob(支持通配符的查找)，-regexp（正则表达式）。如下：`lsearch -regexp $x .*3.+`。
###数组排序
`lsort 选项 $x`，如果不写选项，默认按ASC码顺序排列。其他选项有： 
-integer：整数排列，2不会拍到10后面
-real：按浮点数排列
-increasing：ASC码升序排列
-decreasing：ASC码降序排列
###将string拆成数组
`split "abc" {}`，将字符串abc拆成数组a b c，{}是拆分的依据，即把每个字符都拆开。也可以用其他依据，如：`split "a:b:c"` :，结果还是 a b c
###将数组变成string
`join {1 2 3}` ，结果是一个字符串1:2:3
##条件判断
tcl编译器是早期编译器，比较“弱智”，对“换行符”、“空格”等都敏感。“换行符”用来标识一行命令结束（类似C语言中的；），“空格”用来划分命令和参数。因此，在tcl复杂语言结构中，使用“换行”和“空格”一定要注意。
	if {条件1} { //注意“空格”和“换行”的位置。条件、结果都用{}，不用（）。
		结果1
	} elseif {条件2} {
		结果2
	} else {
		结果3
	}
	
	switch 选项 $x {
	b {结果1}
	c {结果2}
	default {结果3}
	}
switch的选项有：-exact(准确匹配)，-glob(整体匹配)，-regexp(regular expression正则表达式匹配)

##循环结构
tcl循环支持 break 和 continue .
	while {条件} {
		循环体
	}
	
	for {int} {test} {reinit} {
		循环体
	}
	
	foreach i $a {    //$a 是个数组
		循环体
	}

foreach 还可以多变量赋值，如下：
	foreach i {1 2 3} j {4 5 6} {
		循环体
	}

##动态命令
`set x "expr 3+2"`，`eval $x`，显示为5。
##自定义函数
在tcl中也可以写函数，供脚本调用。函数定义方法如下：
`proc 函数名 参数列表 {函数功能块}`，例如：`proc add {x y} {expr $x+$y}`，写完后，调用时写`add 1 3`，执行结果为4。支持return。
在函数外定义的变量，如果要在函数中使用，并继承原来的值，需要在“函数功能块”中用`global x`进行声明。
可以给函数的参数定义默认值：`proc add {{x 1} {y 2}} {expr $x+$y}`。
可以让函数携带非固定数量的参数，关键词是args，例如:`proc add {args} {......}`，args是作为列表使用的，而非单独一个元素。
##字符串操作
tcl数字处理是繁琐的，而对字符串操作是它的强项，因为tcl主要用于命令行中对文件名、目录名、路径等字符串进行操作。
###格式化字符串
在C语言和perl中，我们使用sprintf来格式化字符串，或输出到屏幕上，或输出到另一个字符串变量中。在tcl中，完成相同功能的命令叫format，例如：`format "%s is %d" $x $y`，使用时把C语言中的逗号改成空格，没有括号，就是tcl的表达方式。
###字符串匹配
使用perl语言的话，用模式匹配符 =~ 进行正则表达式匹配超容易，在tcl中稍麻烦一些，使用命令：regexp，格式为：
`regexp {pattern} string`
如果pattern匹配string，则返回1，否则返回0. 例如：`regexp {abc} baiabc001`，abc在baiabc001中出现，匹配成功，返回1。
匹配命令regexp也可以像perl一样从string中截取变量的值，赋给变量，例如：
`regexp {(.).+([0-1]+)} "baiguangyu001" x y z`，则x匹配整个baiguangyu001，y匹配第一个b，z匹配最后一个1。
打开选项-indices可以返回匹配的位置，如`regexp -indices {(.).+([0-1]+)}` "baiguangyu001" x y z，x的值是{0 12}，表示匹配整个字符串，y的值是{0 0}，表示从第一个字符开始，到第一个字符结束。z的值是{12 12}，从第12个字符开始，又从第12个字符结束。
###字符串替换
regexp是字符串匹配，相当于perl中的m//，而regsub是字符串替换，相当于perl中的s//。
格式为：`regsub option pattern string substr whole_str_aft`
用pattern在string中匹配，匹配上以后，用substr替代匹配部分，替换后的整个string存在whole_str_aft里。
在option处可以加选项，相当于perl中的m//igx之类的。具体选项有：-nocase：不区分大小写//i，-all就是//g.
###字符串比较
`string compare [-nocase] [-length 10] str1 str2`，
比较str1和str2，如果有length 10，就是只比较前10个字符。返回值：-1（小于），0（等于），1（大于）
`string equal [-nocase] [-length 10] str1 str2`，返回值：1（等于），0（不等于）。
###字符串长度
`string length str`，返回str的长度。
###字符串大小写互转
`string tolower str`，将str变小写。
`string toupper str`，将str变大写。

##文件访问

对于tcl来说，一个重点是字符串，另一个重点就是文件操作。
###打开文件
`set x [open $filename r]`，同perl中的：`open x,"<$filename"`;同C语言的：`x=fopen(filename,"r")`; r是读，w是写，a是追加，r+是读写。
###关闭文件
`close $x`
###逐行读取文件
关键命令gets,`while {gets $x line}`，把x句柄的每一行赋给line变量。类似perl中的：`while($line = <$x>)`，但perl更简单。
###写文件
`puts 文件句柄 内容`
###3种特殊的文件句柄
stdin，stdout，stderr。
##刷新缓冲区
有时候内容显示不出来，就用flush命令，“flush 句柄”。
###文件指针跳跃
“seek 句柄 偏移 坐标原点”，坐标原点只有3种：start,current,end
###获知文件指针
“tell 句柄”，“eof 句柄”说明文件是否已经读完

###目录文件管理
###查找文件或目录名
`glob name1 name2 ....`，用来查找当前工作目录中是否有name文件，name的格式不是模式匹配的，所以需要文件名的全称，也支持通配符，但不支持正则表达式。通配符有*，集合符有[ab](表示ab中的一个字符)，{a1,a2}类似[ab]但是个组集合。如果怕报错，写一个-nocomplain，即便没找到，也只返回空。例如：
`glob -nocomplain {abc,a123}/*hd.[co]`，可以匹配abc/1hd.c，a123/Ahd.o等。
###显示文件的访问时间
`file atime name`，atime就是access time（访问时间），返回一个很莫名其妙的时间。
###显示文件的修改时间
`file mtime name`，mtime就是manipulate time(操作时间).
###显示文件大小
`file size name`，单位是字节。
###显示文件类型
`file type name`，类型有：file,directory,characterspecial(字符设备),blockspecial（块设备）,fifo,link,socket.
###文件操作
	file copy [-force] source target
	file delete [-force] name
	file dirname name
	file executable name
	file exists name
	file extension name
	file isdirectory name
	file lstat name，lstat就是link state
	file mkdir dirname1 dirname2
	file rename [-force] source target，类似linux的mv命令，可以用于剪切和粘贴。

##tcl调用perl
tcl的功能有限，很多复杂处理还需要用perl实现较快，以下是tcl调用perl的方法：
`set x [exec perl abc.pl]`
其中abc.pl是被调用的perl脚本的文件名。
如果abc.pl的内容为：
`$a = 4; $b = 3; $c = $a+$b; print $c;`
则 x 被赋值为 7.

##命令行参数调用
Tcl中有两个默认变量，`$argc` 存储命令行参数的个数。`$argv`中包含了参数信息
Example:
	#!/usr/bin/tclsh
	set i 0
	while {$argc > $i} {
	set arg [lindex $argv $i]
	#lindex 返回argv 的第i个元素（0—based）
	puts "$arg"
	incr i 1
	} 

