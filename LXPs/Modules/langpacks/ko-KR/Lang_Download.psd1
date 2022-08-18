ConvertFrom-StringData -StringData @'
	OSVersion                 = 알려진 버전 번호 선택
	DownloadAll               = 모두 다운로드
	LXPsFilter                = 필터
	LXPsDownloadTips          = 알려진 버전 번호를 선택하거나 필터링할 해당 버전 번호를 수동으로 입력하십시오. 숫자만 허용되며 다음을 포함할 수 없습니다. 앞뒤 공백,\\ / : * ? & @ ! "" < > |
	ISO9660TipsErrorSpace     = 포함할 수 없음: 선행 및 후행 공백
	ISO9660TipsErrorAZ        = 포함할 수 없음: 문자 A-Z
	ISO9660TipsErrorOther     = 다음을 포함할 수 없음: \\ / : * ? & @ ! "" < > |
	ISOLengthError            = 길이는 {0} 자를 초과할 수 없습니다
	ISOShortError             = 길이는 {0} 자보다 작을 수 없습니다
	NoSetLabel                = 버전 번호를 수동으로 입력하십시오
	LXPsRename                = 규칙에 따라 자동으로 이름 바꾸기
	LXPsRenameTips            = 예: LanguageExperiencePack.{*}.Neutral.appx
	LicenseCreate             = License.xml 인증서 생성
	LicenseCreateTips         = 언어 태그에 따라 디렉터리에 License.xml 인증서 파일이 있는지 확인하고 없으면 LanguageExperiencePack.{*}.Neutral.appx 에서 현재 디렉터리로 license.xml 을 릴리스합니다.

	SaveTo                    = 저장 위치: \
	SelectFolder              = 디렉토리 선택
	SelectFolderTips          = 새 디렉토리를 설정한 후 "동기화 소스 위치는 다운로드 위치와 동일합니다" 옵션이 꺼집니다.
	SaveToSync                = 동기화 소스 위치는 다운로드 위치와 동일합니다
	SaveToSyncTips            = 새 필터 버전 번호를 설정한 후 새 변경 사항을 저장 디렉토리와 동일한 위치에 동기화하십시오.사용자 정의 후 이 기능을 끄십시오.
	OpenFolder                = 디렉토리 열기
	Paste                     = 복사 경로
	AdvAppsDetailed           = 보고서 생성
	AdvAppsDetailedTips       = 지역 태그로 검색하고 사용 가능한 현지 언어 경험 팩을 찾은 후 자세한 내용을 확인하고 보고서 파일 *.CSV 를 생성합니다.
	AddSources                = 소스 추가: \
	AddQueue                  = 대기열 추가: \
	YesWork                   = 대기열에 작업이 있습니다
	NoWork                    = 묻지 않는다
	ProcessSources            = 처리 소스
	AvailableLanguages        = 사용 가능한 언어입니다
	Not_Select                = 사용 가능한 언어가 선택되지 않았습니다
	MatchDownloadNoNewitem    = 일치하지 않음
	MatchNoDownloadItem       = 다운로드하지 않은 항목 일치

	# 通知
	LXPsAddDelTipsView        = 지금 볼 수있는 새로운 팁이 있습니다
	LXPsAddDelTips            = 더 이상 메시지가 표시되지 않습니다
	LXPsGetSNTips             = 说明:\n\n第一步：添加本地语言体验包（LXPs），该步骤必须对应微软官方发行的对应包，前往此处并下载：\n       将语言包添加到 Windows 10 多会话映像\n       https://docs.microsoft.com/en-us/azure/virtual-desktop/language-packs\n\n       向 Windows 11 企业版映像添加语言\n       https://docs.microsoft.com/en-us/azure/virtual-desktop/windows-11-language-packs\n\n第二步：解压或挂载 *_InboxApps.iso，根据架构选择目录；\n\n第三步：如果微软官方尚未发行最新本地语言体验包（LXPs），跳过此步骤；如果有：请参照微软官方发布的公告：\n       1、对应本地语言体验包（LXPs）；\n       2、对应累积更新。 \n\n已预安装的应用程序 ( UWP ) 是单语言，需要重新安装才会获得多语言。 \n\n1、封装时请使用初始版本制作，已知初始版本：\n    Windows 11 系列\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 系列\n    Windows 10 21H2, 2109, Build 19044.1288\n    Windows 10 21H1, 2104, Build 19043.928\n    Windows 10 20H2, 2009, Build 19042.264\n    Windows 10 20H1, 2004, Build 19041.264\n    Windows 10 19H1, 1909, Build 18363.418\n\n    重要：\n      a. 每版本更新时，请重新制作镜像，例如从 21H1 跨越到 21H2 时，请勿在旧镜像基础上更新，应避免出现其它兼容性问题；再次提醒您，请使用初始版本制作。\n      b. 该条例已经在某些 OEM 厂商，通过各种形式向封装师明确传达了该法令，不允许直接从迭代版本里直接升级。\n      关键词：迭代、跨版本、累积更新。\n\n2、安装语言包后，必须添加累积更新，因为未添加累积更新之前，组件不会有任何变化，至直安装累积更新后才会发生新的变化，例如组件状态：已过时、待删除；\n\n3、使用已带累积更新的版本，到了最后还是得再次添加累积更新，已经重复操作了；\n\n4、所以在制作时建议您使用不带累积更新的版本制作，再最后一步添加累积更新。 \n\n选择目录后搜索条件：LanguageExperiencePack.*.Neutral.appx
'@