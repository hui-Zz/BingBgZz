/*
╔═════════════════════════════════
║【BingBgZz】每日桌面Bing壁纸 v1.2
║ 联系：hui0.0713@gmail.com
║ 讨论QQ群：3222783、271105729、493194474
║ by Zz @2016.12.23
║ 最新版本：github.com/hui-Zz/BingBgZz
╚═════════════════════════════════
*/
#NoEnv					;~;不检查空变量为环境变量
FileEncoding,UTF-8		;~;下载的XML以中文编码加载
SetBatchLines,-1		;~;脚本全速执行(默认10ms)
SetWorkingDir,%A_ScriptDir%	;~;脚本当前工作目录
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【初始化全局变量】
global bgDay=0			;~;下载必应今天壁纸,1为昨天,以此类推可下载历史壁纸
global bgNum=8			;~;下载bgDay至前1天壁纸数量,最大为前8天
global bgMax=8			;~;下载后最多只保留前8天的壁纸,设置0为不限制数量(注:bgFlag不能为1)
global bgFlag=2			;~;壁纸文件名称形式,0为日期YYYYMMDD,1为英文名称_分辨率,2为英文名称_日期
global bgDir:="D:\Users\Pictures\bing"	;~;壁纸图片下载保存路径
;~;默认自动根据分辨率获取
;~;可固定为"1024x768"|"1366x768"|"1920x1080"|"1920x1200"(带上双引号)
global DPI:=BG_GetDPI()	
;~;必应壁纸XML地址
global bing:="http://cn.bing.com"
global bgImg:=bing "/HPImageArchive.aspx?idx=" bgDay "&n=" bgNum
global bgXML			;~;XML配置内容
global bgImgUrl			;~;壁纸下载地址
global bgPath			;~;壁纸保存路径
IfNotExist, %bgDir%
	FileCreateDir, %bgDir%
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
XML_Download()
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~ F1::
	FileRead, bgXML, %A_ScriptDir%\bingImg.xml
	RegExMatch(bgXML, "<copyright>(.*?)</copyright>", bgCR)
	ToolTip,%bgCR1%,A_ScreenWidth,A_ScreenHeight
	RegExMatch(bgXML, "<url>(.*?)</url>", bgUrl)
	RegExMatch(bgXML, "<enddate>(.*?)</enddate>", bgDate)
	BG_GetImgUrlPath(bgUrl1,bgDate1)
	BG_Download()
	BG_DownFail()
	BG_Wallpapers()
	BG_DeleteBefore()
return
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【批量下载历史壁纸,搭配bgDay和bgNum使用】
;~ F2::
	FileRead, bgXML, %A_ScriptDir%\bingImg.xml
	pos = 1
	While, pos := RegExMatch(bgXML, "<enddate>(.*?)</enddate>", bgDate, pos + 1)
	{
		DPI:=BG_GetDPI()
		RegExMatch(bgXML, "<url>(.*?)</url>", bgUrl, pos)
		BG_GetImgUrlPath(bgUrl1,bgDate1)
		BG_Download()
		BG_DownFail()
		bgPaths .= bgPath . "`n"
	}
	MsgBox,下载完成`n%bgPaths%
return
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【获取壁纸下载地址和保存路径】
BG_GetImgUrlPath(bgUrl1,bgDate1){
	RegExMatch(bgUrl1, "[^/]+$", bgName)
	if(bgFlag=1){
		bgName:=RegExReplace(bgName, "i)[^_]+\.jpg$", DPI ".jpg")
	}else if(bgFlag=2){
		bgName:=RegExReplace(bgName, "i)[^_]+\.jpg$", bgDate1 ".jpg")
	}else{
		bgName:=bgDate1 . ".jpg"
	}
	bgImgUrl=%bing%%bgUrl1%
	bgImgUrl:=RegExReplace(bgImgUrl, "i)[^_]+\.jpg$", DPI ".jpg")
	bgPath=%bgDir%\%bgName%
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【下载必应壁纸XML配置信息】
XML_Download(){
	URLDownloadToFile,%bgImg%,%A_ScriptDir%\bingImg.xml
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【下载必应壁纸图片】
BG_Download(){
	URLDownloadToFile, %bgImgUrl%, %bgPath%
}
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【必应壁纸设置为桌面壁纸】
BG_Wallpapers(){
	DllCall("SystemParametersInfo", UInt, 0x14, UInt,0, Str,"" bgPath "", UInt, 2)
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
	if(bgFlag!=1 && bgMax>0){
		FileCopy, %bgDir%, %bgDir%
		if(bgMax<ErrorLevel){
			tMax := 1
			tPath := bgPath
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
			FileDelete, %tPath%
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
