ConvertFrom-StringData -StringData @'
	OSVersion                 = 選擇已知版本號
	DownloadAll               = 下載全部
	LXPsFilter                = 篩選
	LXPsDownloadTips          = 選擇已知版本號，或手動輸入對應的版本號來篩選，只允許數字，不能包含：前後空格、\\ / : * ? & @ ! "" < > |
	ISO9660TipsErrorSpace     = 不能包含：前後空格
	ISO9660TipsErrorAZ        = 不能包含：字母 A-Z
	ISO9660TipsErrorOther     = 不能包含：\\ / : * ? & @ ! "" < > |
	ISOLengthError            = 長度不能大於 {0} 字符
	ISOShortError             = 長度不能小於 {0} 字符
	NoSetLabel                = 請手動輸入版本號
	LXPsRename                = 自動按規則重命名
	LXPsRenameTips            = 範例：LanguageExperiencePack.{*}.Neutral.appx
	LicenseCreate             = 創建 License.xml 證書
	LicenseCreateTips         = 按語言標記檢查目錄下是否有 License.xml 證書文件，如果沒有，從 LanguageExperiencePack.{*}.Neutral.appx 裡釋放 license.xml 到當前目錄下。

	SaveTo                    = 儲存到：
	SelectFolder              = 選擇目錄
	SelectFolderTips          = 設置新的目錄後，將關閉“同步來源位置與下載到位置一致”選項。
	SaveToSync                = 同步來源位置與下載到位置一致
	SaveToSyncTips            = 設置新的篩選版本號後，將新的變化同步到保存目錄位置一致，自定義後請關閉該項功能。
	OpenFolder                = 打開目錄
	Paste                     = 複製路徑
	AdvAppsDetailed           = 生成報告
	AdvAppsDetailedTips       = 按區域標記搜索，發現可用的本地語言體驗包後獲取更多詳細信息，生成一份報告文件：*.CSV。
	AddSources                = 添加來源：
	AddQueue                  = 添加隊列：
	YesWork                   = 隊列中有任務
	NoWork                    = 無任務
	ProcessSources            = 處理來源
	AvailableLanguages        = 可用語言
	Not_Select                = 未選擇可用語言
	MatchDownloadNoNewitem    = 未匹配到
	MatchNoDownloadItem       = 匹配未下載項

	# 通知
	LXPsAddDelTipsView        = 有新的提示，現在查看
	LXPsAddDelTips            = 不再提示
	LXPsGetSNTips             = 說明:\n\n第一步：添加本地語言體驗包（LXPs），該步驟必須對應微軟官方發行的對應包，前往此處並下載：\n       將語言包添加到 Windows 10 多會話映像\n       https://docs.microsoft.com/en-us/azure/virtual-desktop/language-packs\n\n       向 Windows 11 企业版映像添加语言\n       https://docs.microsoft.com/en-us/azure/virtual-desktop/windows-11-language-packs\n\n第二步：解压或挂载 *_InboxApps.iso，根据架构选择目录；\n\n第三步：如果微软官方尚未发行最新本地语言体验包（LXPs），跳过此步骤；如果有：请参照微软官方发布的公告：\n       1、对应本地语言体验包（LXPs）；\n       2、对应累积更新。 \n\n已预安装的应用程序 ( UWP ) 是单语言，需要重新安装才会获得多语言。 \n\n1、封装时请使用初始版本制作，已知初始版本：\n    Windows 11 系列\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 系列\n    Windows 10 21H2, 2109, Build 19044.1288\n    Windows 10 21H1, 2104, Build 19043.928\n    Windows 10 20H2, 2009, Build 19042.264\n    Windows 10 20H1, 2004, Build 19041.264\n    Windows 10 19H1, 1909, Build 18363.418\n\n    重要：\n      a. 每版本更新时，请重新制作镜像，例如从 21H1 跨越到 21H2 时，请勿在旧镜像基础上更新，应避免出现其它兼容性问题；再次提醒您，请使用初始版本制作。\n      b. 该条例已经在某些 OEM 厂商，通过各种形式向封装师明确传达了该法令，不允许直接从迭代版本里直接升级。\n      关键词：迭代、跨版本、累积更新。\n\n2、安装语言包后，必须添加累积更新，因为未添加累积更新之前，组件不会有任何变化，至直安装累积更新后才会发生新的变化，例如组件状态：已过时、待删除；\n\n3、使用已带累积更新的版本，到了最后还是得再次添加累积更新，已经重复操作了；\n\n4、所以在制作时建议您使用不带累积更新的版本制作，再最后一步添加累积更新。 \n\n选择目录后搜索条件：LanguageExperiencePack.*.Neutral.appx
'@