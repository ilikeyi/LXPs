ConvertFrom-StringData -StringData @'
	OSVersion                 = 既知のバージョン番号を選択してください
	DownloadAll               = すべてダウンロード
	LXPsFilter                = フィルター
	LXPsDownloadTips          = 既知のバージョン番号を選択するか、対応するバージョン番号を手動で入力してフィルタリングします。番号のみが許可され、次のスペースを含めることはできません：前後のスペース、\\ / : * ? & @ ! "" < > |
	ISO9660TipsErrorSpace     = 含めることはできません：先頭と末尾のスペース
	ISO9660TipsErrorAZ        = 含めることはできません：文字A〜Z
	ISO9660TipsErrorOther     = 含めることはできません：\\ / : * ? & @ ! "" < > |
	ISOLengthError            = 長さは {0} 文字を超えることはできません
	ISOShortError             = 長さは {0} 文字以上にする必要があります
	NoSetLabel                = バージョン番号を手動で入力してください
	LXPsRename                = ルールによって自動的に名前を変更します
	LXPsRenameTips            = 例：LanguageExperiencePack.{*}.Neutral.appx
	LicenseCreate             = License.xml 証明書を作成する
	LicenseCreateTips         = 言語タグに従ってディレクトリに License.xml 証明書ファイルがあるかどうかを確認します。ない場合は、LanguageExperiencePack.{*}.Neutral.appx から現在のディレクトリに license.xml を解放します。

	SaveTo                    = に保存：
	SelectFolder              = ディレクトリを選択
	SelectFolderTips          = 新しいディレクトリを設定すると、[ソースの場所を場所にダウンロードするのと同じです]オプションがオフになります。
	SaveToSync                = 同期ソースの場所は、ダウンロード先の場所と同じです
	SaveToSyncTips            = 新しいフィルタのバージョン番号を設定した後、新しい変更を保存ディレクトリと同じ場所に同期します。カスタマイズした後は、この機能をオフにしてください。
	OpenFolder                = 開けるコンテンツ
	Paste                     = コピーパス
	AdvAppsDetailed           = レポートを生成する
	AdvAppsDetailedTips       = 地域タグで検索し、利用可能なローカル言語エクスペリエンスパックを見つけて詳細を取得し、レポートファイル *.CSV を生成します。
	AddSources                = ソースを追加：
	AddQueue                  = キューを追加：
	YesWork                   = キューにタスクがあります
	NoWork                    = 聞かない
	ProcessSources            = 処理元
	AvailableLanguages        = 使用可能な言語
	Not_Select                = 使用可能な言語が選択されていません
	MatchDownloadNoNewitem    = 一致しません
	MatchNoDownloadItem       = ダウンロードされていないアイテムを一致させる

	# 通知
	LXPsAddDelTipsView        = 新しいヒントは、今すぐチェックされます
	LXPsAddDelTips            = プロンプトは表示されなくなります
	LXPsGetSNTips             = 说明:\n\n第一步：添加本地语言体验包（LXPs），该步骤必须对应微软官方发行的对应包，前往此处并下载：\n       将语言包添加到 Windows 10 多会话映像\n       https://docs.microsoft.com/en-us/azure/virtual-desktop/language-packs\n\n       向 Windows 11 企业版映像添加语言\n       https://docs.microsoft.com/en-us/azure/virtual-desktop/windows-11-language-packs\n\n第二步：解压或挂载 *_InboxApps.iso，根据架构选择目录；\n\n第三步：如果微软官方尚未发行最新本地语言体验包（LXPs），跳过此步骤；如果有：请参照微软官方发布的公告：\n       1、对应本地语言体验包（LXPs）；\n       2、对应累积更新。 \n\n已预安装的应用程序 ( UWP ) 是单语言，需要重新安装才会获得多语言。 \n\n1、封装时请使用初始版本制作，已知初始版本：\n    Windows 11 系列\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 系列\n    Windows 10 21H2, 2109, Build 19044.1288\n    Windows 10 21H1, 2104, Build 19043.928\n    Windows 10 20H2, 2009, Build 19042.264\n    Windows 10 20H1, 2004, Build 19041.264\n    Windows 10 19H1, 1909, Build 18363.418\n\n    重要：\n      a. 每版本更新时，请重新制作镜像，例如从 21H1 跨越到 21H2 时，请勿在旧镜像基础上更新，应避免出现其它兼容性问题；再次提醒您，请使用初始版本制作。\n      b. 该条例已经在某些 OEM 厂商，通过各种形式向封装师明确传达了该法令，不允许直接从迭代版本里直接升级。\n      关键词：迭代、跨版本、累积更新。\n\n2、安装语言包后，必须添加累积更新，因为未添加累积更新之前，组件不会有任何变化，至直安装累积更新后才会发生新的变化，例如组件状态：已过时、待删除；\n\n3、使用已带累积更新的版本，到了最后还是得再次添加累积更新，已经重复操作了；\n\n4、所以在制作时建议您使用不带累积更新的版本制作，再最后一步添加累积更新。 \n\n选择目录后搜索条件：LanguageExperiencePack.*.Neutral.appx
'@