ConvertFrom-StringData -StringData @'
	OSVersion                 = Select a known version number
	DownloadAll               = Download all
	LXPsFilter                = Filter
	LXPsDownloadTips          = Select a known version number, or manually enter the corresponding version number to filter, only numbers are allowed, and cannot contain: spaces before and after, \\ / : * ? & @ ! "" < > |
	ISO9660TipsErrorSpace     = Cannot contain: leading and trailing spaces
	ISO9660TipsErrorAZ        = Cannot contain: Letters A-Z
	ISO9660TipsErrorOther     = Cannot contain: \\ / : * ? & @ ! "" < > |
	ISOLengthError            = The length cannot be greater than {0} characters
	ISOShortError             = The length cannot be less than {0} characters
	NoSetLabel                = Please enter the version number manually
	LXPsRename                = Automatically rename by rules
	LXPsRenameTips            = Example: LanguageExperiencePack.{*}.Neutral.appx
	LicenseCreate             = Create License.xml certificate
	LicenseCreateTips         = Search by region tag, no License.xml certificate file, release license.xml from LanguageExperiencePack.{*}.Neutral.appx.

	SaveTo                    = Save to:
	SelectFolder              = Select directory
	SelectFolderTips          = After setting up a new directory, the "Sync source location is the same as download to location" option will be turned off.
	SaveToSync                = The sync source location is the same as the download to location
	SaveToSyncTips            = After setting a new filter version number, synchronize the new changes to the same location as the save directory. Please turn off this function after customizing.
	OpenFolder                = Open Directory
	Paste                     = Copy path
	AdvAppsDetailed           = Generate report
	AdvAppsDetailedTips       = Search by region tag, get more details after discovering available local language experience packs, generate a report file: *.CSV.
	AddSources                = Add source: \
	AddQueue                  = Add queue: \
	YesWork                   = There are tasks in the queue
	NoWork                    = No task
	ProcessSources            = Processing source
	AvailableLanguages        = Available languages
	Not_Select                = No available languages are selected
	MatchDownloadNoNewitem    = Not matched
	MatchNoDownloadItem       = Match undownloaded items

	# 通知
	LXPsAddDelTipsView        = There are new tips, check it out now
	LXPsAddDelTips            = Do not remind again
	LXPsGetSNTips             = 说明:\n\n第一步：添加本地语言体验包（LXPs），该步骤必须对应微软官方发行的对应包，前往此处并下载：\n       将语言包添加到 Windows 10 多会话映像\n       https://docs.microsoft.com/en-us/azure/virtual-desktop/language-packs\n\n       向 Windows 11 企业版映像添加语言\n       https://docs.microsoft.com/en-us/azure/virtual-desktop/windows-11-language-packs\n\n第二步：解压或挂载 *_InboxApps.iso，根据架构选择目录；\n\n第三步：如果微软官方尚未发行最新本地语言体验包（LXPs），跳过此步骤；如果有：请参照微软官方发布的公告：\n       1、对应本地语言体验包（LXPs）；\n       2、对应累积更新。 \n\n已预安装的应用程序 ( UWP ) 是单语言，需要重新安装才会获得多语言。 \n\n1、封装时请使用初始版本制作，已知初始版本：\n    Windows 11 系列\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 系列\n    Windows 10 21H2, 2109, Build 19044.1288\n    Windows 10 21H1, 2104, Build 19043.928\n    Windows 10 20H2, 2009, Build 19042.264\n    Windows 10 20H1, 2004, Build 19041.264\n    Windows 10 19H1, 1909, Build 18363.418\n\n    重要：\n      a. 每版本更新时，请重新制作镜像，例如从 21H1 跨越到 21H2 时，请勿在旧镜像基础上更新，应避免出现其它兼容性问题；再次提醒您，请使用初始版本制作。\n      b. 该条例已经在某些 OEM 厂商，通过各种形式向封装师明确传达了该法令，不允许直接从迭代版本里直接升级。\n      关键词：迭代、跨版本、累积更新。\n\n2、安装语言包后，必须添加累积更新，因为未添加累积更新之前，组件不会有任何变化，至直安装累积更新后才会发生新的变化，例如组件状态：已过时、待删除；\n\n3、使用已带累积更新的版本，到了最后还是得再次添加累积更新，已经重复操作了；\n\n4、所以在制作时建议您使用不带累积更新的版本制作，再最后一步添加累积更新。 \n\n选择目录后搜索条件：LanguageExperiencePack.*.Neutral.appx
'@