﻿/*
;╔═════════════════════════════════
;║【BingBgZz】每日桌面Bing壁纸 v2.1 @2019.03.11
;║ 地址：https://github.com/hui-Zz/BingBgZz
;║ by hui-Zz 建议：hui0.0713@gmail.com
;║ 讨论QQ群：[246308937]、3222783、493194474
;╚═════════════════════════════════
*/
#NoEnv                          ;~;不检查空变量为环境变量
FileEncoding,UTF-8              ;~;下载的XML以中文编码加载
SetBatchLines,-1                ;~;脚本全速执行(默认10ms)
SetTitleMatchMode,RegEx         ;~;窗口标题正则匹配
SetWorkingDir,%A_ScriptDir%     ;~;脚本当前工作目录
global BingBgZz:="BingBgZz"    ;~;名称
global iniFile:=A_ScriptDir "\" BingBgZz ".ini"
IfNotExist,%iniFile%
{
	TrayTip,,BingBgZz初始化中...,2,1
	gosub,First_Run
	Run,%iniFile%
}
global autoRun:=0
global bgDay:=0
global bgNum:=1
global bgMax:=30
global bgFlag:=2
global bgDir:="bing"
global DPI:=0
global bing:="http://cn.bing.com"
global style:=0
global time:=2000
global xpWin7:=0
IniRead, autoRun,%iniFile%, var_config, autoRun, 0
IniRead, bgDay,%iniFile%, var_config, bgDay, 0
IniRead, bgNum,%iniFile%, var_config, bgNum, 1
IniRead, bgMax,%iniFile%, var_config, bgMax, 30
IniRead, bgFlag,%iniFile%, var_config, bgFlag, 2
IniRead, bgDir,%iniFile%, var_config, bgDir, bing
IniRead, DPI,%iniFile%, var_config, DPI, 0
IniRead, bing,%iniFile%, var_config, bing, http://cn.bing.com
IniRead, style,%iniFile%, var_config, style, 0
IniRead, time,%iniFile%, var_config, time, 2000
IniRead, xpWin7,%iniFile%, var_config, xpWin7, 0
;~;判断并修改随系统自动启动
RegRead, autoRunFlag, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, BingBgZz
autoRunFlag:=autoRunFlag ? 1 : 0
if(!autoRunFlag && autoRun=1){
	RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, BingBgZz, %A_ScriptFullPath%
}else if(autoRunFlag){
	RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, BingBgZz
}
;~;判断壁纸图片保存路径
if(RegExMatch(bgDir,"S)^(\\\\|.:\\)")){
	IfNotExist, %bgDir%
		FileCreateDir, %bgDir%
}else{
	bgDir:=A_ScriptDir "\" bgDir
	IfNotExist, %bgDir%
		FileCreateDir, %bgDir%
}
;~;判断分辨率获取
if(!DPI)
	DPI:=BG_GetDPI()
;~;必应壁纸XML地址
global bgImg:=bing "/HPImageArchive.aspx?idx=" bgDay "&n=" bgNum
global bgXML			;~;XML配置内容
global bgImgUrl		;~;壁纸下载地址
global bgPath			;~;壁纸保存路径
XML_Download()
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
batchFlag:=false
FileRead, bgXML, %A_Temp%\bingImg.xml
if bgNum is number
{
	if(bgNum>1){
		batchFlag:=true
	}
}
if(!batchFlag){
	;~;【读取XML,下载图片,设置桌面背景,如已下载则随机更换壁纸】
	RegExMatch(bgXML, "<url>(.*?)</url>", bgUrl)
	RegExMatch(bgXML, "<enddate>(.*?)</enddate>", bgDate)
	BG_GetImgUrlPath(bgUrl1,bgDate1)
	IfNotExist,%bgPath%
	{
		RegExMatch(bgXML, "<copyright>(.*?)</copyright>", bgCR)
		BG_DeleteBefore()
		BG_Download()
		BG_DownFail()
		BG_Wallpapers()
		BG_Content(bgCR1)
	}else{
		BG_Random()
	}
}else{
	;~;【批量下载历史壁纸,搭配bgDay和bgNum使用】
	bgCRList:=""
	pos = 1
	While, pos := RegExMatch(bgXML, "<enddate>(.*?)</enddate>", bgDate, pos + 1)
	{
		RegExMatch(bgXML, "<url>(.*?)</url>", bgUrl, pos)
		BG_GetImgUrlPath(bgUrl1,bgDate1)
		IfNotExist,%bgPath%
		{
			RegExMatch(bgXML, "<copyright>(.*?)</copyright>", bgCR, pos)
			ToolTip,%bgCR1%
			if(A_Index=1)
				BG_DeleteBefore()
			BG_Download()
			BG_DownFail()
			if(A_Index=1)
				BG_Wallpapers()
			bgCRList .= bgCR1 . "`n"
		}
	}
	if(bgCRList){
		BG_Content(bgCRList)
	}else{
		BG_Random()
	}
}
FileDelete,%A_Temp%\bingImg.xml
return
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【获取壁纸下载地址和保存路径】
BG_GetImgUrlPath(bgUrl1,bgDate1){
	bgName:=RegExReplace(bgUrl1, "i)\/th\?id=OHR\.(.*?ZH-CN.*?\.jpg).*?$", "$1")
	if(bgFlag=1){
		bgName:=RegExReplace(bgName, "i)[^_]+\.jpg$", DPI ".jpg")
	}else if(bgFlag=2){
		bgName:=RegExReplace(bgName, "i)[^_]+\.jpg$", bgDate1 ".jpg")
	}else if(bgFlag=3){
		bgName:=RegExReplace(bgName, "i)[^_]+\.jpg$", DPI "_" bgDate1 ".jpg")
	}else{
		bgName:=bgDate1 . ".jpg"
	}
	bgImgUrl:=bing . bgUrl1
	bgImgUrl:=RegExReplace(bgImgUrl, "i)_(\d+x\d+\.jpg)", "_" DPI ".jpg")
	bgPath:=bgDir "\" bgName
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【下载必应壁纸XML配置信息】
XML_Download(){
	URLDownloadToFile,%bgImg%,%A_Temp%\bingImg.xml
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【下载必应壁纸图片】
BG_Download(){
	URLDownloadToFile, %bgImgUrl%, %bgPath%
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【必应壁纸设置为桌面壁纸】
BG_Wallpapers(){
	if(!xpWin7){
		DllCall("SystemParametersInfo", UInt, 0x14, UInt,0, Str,"" bgPath "", UInt, 2)
	}else if(xpWin7=2){
		RegWrite,REG_SZ,HKEY_CURRENT_USER,Control Panel\Desktop,WallPaper,%bgPath%
		Sleep,1000
		sysBg:="rundll32.exe USER32.DLL,UpdatePerUserSystemParameters"
		Run,%sysBg%
	}else{
		Process,Close,rundll32.exe
		imageView:="rundll32.exe C:\Windows\System32\shimgvw.dll,ImageView_Fullscreen " . bgPath
		Run,%imageView%
		WinWaitActive, - Windows.*查看器$,,1
		Sleep,20
		SendInput, {AppsKey}
		Sleep,200
		SendInput,% A_OSVersion="WIN_XP" ? "b" : "k"
		Sleep,100
		WinHide, - Windows.*查看器$
		Sleep,8000
		Process,Close,rundll32.exe
	}
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【随机更换桌面壁纸】
BG_Random(){
	FileCopy, %bgDir%, %bgDir%
	Random, roll, 1, %ErrorLevel%
	Loop,%bgDir%\*.jpg
	{
		if(A_Index=roll){
			bgPath:=A_LoopFileLongPath
			BG_Wallpapers()
		}
	}
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【获取屏幕的分辨率】
BG_GetDPI(){
	SysGet, Mon, Monitor
	ratio := MonRight/MonBottom
	if (ratio = 16/9)
		return "1920x1080"
	else if (ratio = 16/10)
		return "1920x1200"
	else if (ratio = 4/3)
		return "1024x768"
	else if (MonRight = 1366 && MonBottom = 768)
		return "1366x768"
	else
		return "1920x1080"
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【壁纸数量超过设定删除最早一张】
BG_DeleteBefore(){
	if(bgMax>0){
		FileCopy, %bgDir%, %bgDir%
		if(bgMax<ErrorLevel){
			tMax := 1
			Loop,%bgDir%\*.jpg
			{
				t1 := A_Now
				t2 := A_LoopFileTimeCreated
				t1 -= %t2%, Days
				if(t1>tMax){
					tMax := t1
					tPath := A_LoopFileLongPath
				}
			}
			if(RegExMatch(tPath, "i).*?_.*?\.jpg$")){
				FileDelete, %tPath%
			}
		}
	}
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【下载壁纸失败后用其它分辨率替代】
BG_DownFail(){
	FileGetSize, bgSize, %bgPath%
	if (!FileExist(bgPath) || bgSize=0){
		DPI:="1920x1080"
		BG_GetImgUrlPath(bgUrl1,bgDate1)
		BG_Download()
	}
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【壁纸说明文字显示】
BG_Content(content){
	if(time=0){
		MsgBox, 0, 可按Ctrl+C来复制内容, %content%
	}else{
		if(style=2 || style=3)
			TrayTip,,%content%,3,1
		if(style=0 || style=1)
			ToolTip,%content%
		if(style=1 || style=3)
			Clipboard:=content
		Sleep,%time%
	}
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;[初次运行]
First_Run:
xpWin7:=(A_OSVersion="WIN_XP" || A_OSVersion="WIN_7") ? 1 : 0
FileAppend,
(
;╔═════════════════════════════════
;║【BingBgZz】每日桌面Bing壁纸 v2.0 @2018.03.29
;║ 地址：https://github.com/hui-Zz/BingBgZz
;║ by hui-Zz 建议：hui0.0713@gmail.com
;║ 讨论QQ群：[246308937]、3222783、493194474
;╚═════════════════════════════════
;~;【用户自定义变量】
[var_config]
;~;是否随系统自动启动,0不自动启动,1随系统自动启动（修改后保存，再运行BingBgZz就生效了）
autoRun=0
;~;0为下载必应今天壁纸,1为昨天,以此类推可下载历史壁纸
bgDay=0
;~;批量下载(默认1张),下载bgDay至前1天壁纸数量,最大为前8天
bgNum=1
;~;壁纸文件名称形式,0为日期YYYYMMDD,1为英文名称_分辨率,2为英文名称_日期,3为英文名称_分辨率_日期
bgFlag=2
;~;下载后最多只保留前30天的壁纸,设置0为不限制数量不删除旧图片
bgMax=30
;~;壁纸图片保存路径,默认在bing目录下,可设置路径如C:\Users\Pictures\bing
;~;（注意！如果bgMax不是0，必须保证bgDir目录中没有除壁纸外的jpg图片,防止丢失其他图片）
bgDir=bing
;~;默认0为自动根据分辨率获取,可固定为1024x768|1366x768|1920x1080|1920x1200
DPI=0
;~;必应壁纸XML获取地址,默认不用修改
bing=http://cn.bing.com
;~;当前必应壁纸说明显示方式,0为鼠标浮动文字,1为浮动文字并拷贝到剪贴板,2为弹出消息通知,3为弹出消息通知并拷贝到剪贴板
style=0
;~;当前必应壁纸说明显示停留时间(毫秒),0为弹窗显示手动关闭
time=3000
;~;【设置壁纸方式】Win10推荐：0；Win7推荐：0、1、2；XP推荐：1、2；(1为强制成功,2为命令行壁纸可能无变化)
xpWin7=%xpWin7%
),%iniFile%
return