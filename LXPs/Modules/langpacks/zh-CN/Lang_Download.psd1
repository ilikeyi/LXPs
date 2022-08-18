ConvertFrom-StringData -StringData @'
	OSVersion                 = 选择已知版本号
	DownloadAll               = 下载全部
	LXPsFilter                = 筛选
	LXPsDownloadTips          = 选择已知版本号，或手动输入对应的版本号来进行筛选，数字长度不少于 5 位，不能包含：英文字母、前后空格、\\ / : * ? & @ ! "" < > | .
	ISO9660TipsErrorSpace     = 不能包含：前后空格
	ISO9660TipsErrorAZ        = 不能包含：字母 A-Z
	ISO9660TipsErrorOther     = 不能包含：\\ / : * ? & @ ! "" < > |
	ISOLengthError            = 长度不能大于 {0} 字符
	ISOShortError             = 长度不能小于 {0} 字符
	NoSetLabel                = 请手动输入版本号
	LXPsRename                = 自动按规则重命名
	LXPsRenameTips            = 示例：LanguageExperiencePack.{*}.Neutral.appx
	LicenseCreate             = 创建 License.xml 证书
	LicenseCreateTips         = 按区域标记搜索，没有 License.xml 证书文件，从 LanguageExperiencePack.{*}.Neutral.appx 里释放 license.xml。

	SaveTo                    = 保存到：
	SelectFolder              = 选择目录
	SelectFolderTips          = 设置新的目录后，将关闭“同步来源位置与下载到位置一致”选项。
	SaveToSync                = 同步来源位置与下载到位置一致
	SaveToSyncTips            = 设置新的筛选版本号后，将新的变化同步到保存目录位置一致，自定义后请关闭该项功能。
	OpenFolder                = 打开目录
	Paste                     = 复制路径
	AdvAppsDetailed           = 生成报告
	AdvAppsDetailedTips       = 按区域标记搜索，发现可用的本地语言体验包后获取更多详细信息，生成一份报告文件：*.CSV。
	AddSources                = 添加来源：
	AddQueue                  = 添加队列：
	YesWork                   = 队列中有任务
	NoWork                    = 无任务
	ProcessSources            = 处理来源
	AvailableLanguages        = 可用语言
	Not_Select                = 未选择可用语言
	MatchDownloadNoNewitem    = 未匹配到
	MatchNoDownloadItem       = 匹配未下载项

	# 通知
	LXPsAddDelTipsView        = 有新的提示，现在查看
	LXPsAddDelTips            = 不再提示
	LXPsGetSNTips             = 说明:\n\n第一步：添加本地语言体验包（LXPs），该步骤必须对应微软官方发行的对应包，前往此处并下载：\n       将语言包添加到 Windows 10 多会话映像\n       https://docs.microsoft.com/en-us/azure/virtual-desktop/language-packs\n\n       向 Windows 11 企业版映像添加语言\n       https://docs.microsoft.com/en-us/azure/virtual-desktop/windows-11-language-packs\n\n第二步：解压或挂载 *_InboxApps.iso，根据架构选择目录；\n\n第三步：如果微软官方尚未发行最新本地语言体验包（LXPs），跳过此步骤；如果有：请参照微软官方发布的公告：\n       1、对应本地语言体验包（LXPs）；\n       2、对应累积更新。 \n\n已预安装的应用程序 ( UWP ) 是单语言，需要重新安装才会获得多语言。 \n\n1、封装时请使用初始版本制作，已知初始版本：\n    Windows 11 系列\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 系列\n    Windows 10 21H2, 2109, Build 19044.1288\n    Windows 10 21H1, 2104, Build 19043.928\n    Windows 10 20H2, 2009, Build 19042.264\n    Windows 10 20H1, 2004, Build 19041.264\n    Windows 10 19H1, 1909, Build 18363.418\n\n    重要：\n      a. 每版本更新时，请重新制作镜像，例如从 21H1 跨越到 21H2 时，请勿在旧镜像基础上更新，应避免出现其它兼容性问题；再次提醒您，请使用初始版本制作。\n      b. 该条例已经在某些 OEM 厂商，通过各种形式向封装师明确传达了该法令，不允许直接从迭代版本里直接升级。\n      关键词：迭代、跨版本、累积更新。\n\n2、安装语言包后，必须添加累积更新，因为未添加累积更新之前，组件不会有任何变化，至直安装累积更新后才会发生新的变化，例如组件状态：已过时、待删除；\n\n3、使用已带累积更新的版本，到了最后还是得再次添加累积更新，已经重复操作了；\n\n4、所以在制作时建议您使用不带累积更新的版本制作，再最后一步添加累积更新。 \n\n选择目录后搜索条件：LanguageExperiencePack.*.Neutral.appx
'@