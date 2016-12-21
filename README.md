# BingBgZz 每日桌面Bing壁纸

**每日开机运行后会下载当日bing壁纸并设置为桌面壁纸，用完即关**


```AutoHotkey
global DPI:="1920x1080"					;~;支持1024x768|1366x768|1920x1080|1920x1200|等
global bgDay=0							;~;获取必应今天壁纸,1为昨天,以此类推可下载历史壁纸
global bgNum=1							;~;获取bgDay至前几天壁纸数量,最大为8
global bgFlag=2							;~;壁纸文件名称形式,0为日期YYYYMMDD,1为英文名称_分辨率,2为英文名称_日期
global bgDir:="D:\Users\Pictures\bing"	;~;壁纸图片下载保存路径
```

用户可自定义配置以上几项，不想看到xml可以设置下载到缓存目录：`SetWorkingDir,%A_Temp%`

---

是的，顺带做了下载历史壁纸的隐藏功能：

设置“bgNum = 8”即获取前8天,再设置“bgDay = 8”为前8天的再前8天壁纸
把”;~ F2::“改“F2::”再按<kbd>F2</kbd>键

联系：hui0.0713@gmail.com 讨论QQ群：3222783、271105729、493194474
