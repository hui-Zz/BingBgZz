/*
╔═══════════════════════════════
║【BingBgZz】每日桌面Bing壁纸
║ 联系：hui0.0713@gmail.com
║ 讨论QQ群：3222783、271105729、493194474
║ by Zz @2016.11.06
╚═══════════════════════════════
*/
#NoEnv					;~;不检查空变量为环境变量
SetBatchLines,-1		;~;脚本全速执行(默认10ms)
SetWorkingDir,%A_ScriptDir%	;~;脚本当前工作目录
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【初始化全局变量】
global DPI:="1920x1080"			;~;支持1024x768|1366x768|1920x1080|1920x1200|等
global bgDay=0					;~;获取必应今天壁纸,1为昨天,累加下载历史壁纸
global bgNum=1					;~;获取bgDay至前几天壁纸数量,最大为8
global bgFlag=2				;~;壁纸文件名称形式,0为日期YYYYMMDD,1为英文名称_分辨率,2为英文名称_日期
global bgDir:="D:\Users\Pictures\bing"	;~;壁纸图片下载保存路径
;~;必应壁纸XML地址
global bing:="http://cn.bing.com"
global bgImg:=bing "/HPImageArchive.aspx?idx=" bgDay "&n=" bgNum
global bgXML					;~;XML配置内容
global bgImgUrl					;~;壁纸下载地址
global bgPath					;~;壁纸保存路径
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
XML_Download()
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~ F1::
	FileRead, bgXML, %A_ScriptDir%\bingImg.xml
	RegExMatch(bgXML, "<enddate>(.*?)</enddate>", bgDate)
	RegExMatch(bgXML, "<url>(.*?)</url>", bgUrl)
	BG_GetImgUrlPath(bgUrl1,bgDate1)
	BG_Download()
	BG_Wallpapers()
return
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;~;【批量下载历史壁纸,搭配bgDay和bgNum使用】
;~ F2::
	FileRead, bgXML, %A_ScriptDir%\bingImg.xml
	pos = 1
	While, pos := RegExMatch(bgXML, "<enddate>(.*?)</enddate>", bgDate, pos + 1)
	{
		RegExMatch(bgXML, "<url>(.*?)</url>", bgUrl, pos)
		BG_GetImgUrlPath(bgUrl1,bgDate1)
		BG_Download()
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
