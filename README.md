# 【BingBgZz】每日桌面Bing壁纸 v2.0

**每日开机运行后会下载当日bing壁纸并设置为桌面壁纸，用完即关**

**2.0升级！！可使用exe可执行程序，配置分离直接在ini文件中配置**

> 把bgNum变大就会自动下载历史壁纸，设置当天的为桌面壁纸

> PS：第二次运行就会随机更换历史壁纸了😎

```ini
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
```


**你的支持是我最大的动力！：**

<img src="https://raw.githubusercontent.com/hui-Zz/BingBgZz/master/支持BingBgZz微信.png" alt="支持BingBgZz微信" width="300" height="336">

<img src="https://raw.githubusercontent.com/hui-Zz/BingBgZz/master/支持BingBgZz支付宝.jpg" alt="支持BingBgZz支付宝" width="300" height="300">

