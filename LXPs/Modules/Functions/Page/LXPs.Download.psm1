<#
	.Windows 系统版本、版本号
#>
$Global:OSCodename = @(
	("Windows Server Preview Build",     "20344"),
	("Windows Server 2022",              "20348"),
	("Windows 11 23H2 Insider Build",    "23000"),
	("Windows 11 22H2",                  "22621"),
	("Windows 11 21h2",                  "22000"),
	("Windows 10 Insider Preview Build", "19645"),
	("Windows 10 20H1 or later",         "19041"),
	("Windows 10 1903 or 1909",          "18362"),
	("Windows 10 1809",                  "17763"),
	("Windows 10 1803",                  "17134")
)

<#
	.Change the global default language user interface of the image package
	.更改映像包全局默认语言用户界面
#>
Function LXPs_Download
{
	Write-Host "`n  "$($lang.LXPs)""

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Refresh_Download_Sources_To
	{
		$RandomGuid = [guid]::NewGuid()

		if ($GUILangChangeDownloadAll.Checked) {
			$GUIISOSaveToSelectPanel.Enabled = $False
			$GUIISOSaveCustomizePath.Text = "$($GetCurrentDisk)Download\Default"
		} else {
			$GUIISOSaveToSelectPanel.Enabled = $True
			if ($GUIISOSaveToSync.Checked) {
				if ([string]::IsNullOrEmpty($GUILangChangeNumberShow.Text)) {
					$GUIISOSaveCustomizePath.Text = "$($GetCurrentDisk)Download\$($RandomGuid)"
				} else {
					$GUIISOSaveCustomizePath.Text = "$($GetCurrentDisk)Download\$($GUILangChangeNumberShow.Text)"
				}
			} else {
				<#
					.判断是否有已保存上次选择的目录
				#>
				if ([string]::IsNullOrEmpty($Script:InitalSaveToPath)) {
					$GUIISOSaveCustomizePath.Text = "$($GetCurrentDisk)Download\$($RandomGuid)"
				} else {
					$GUIISOSaveCustomizePath.Text = $Script:InitalSaveToPath
				}
			}
		}

		if ([string]::IsNullOrEmpty($GUIISOSaveCustomizePath.Text)) {
			$GUIISOSaveToPanel.Enabled = $False
		} else {
			if (Test-Path $GUIISOSaveCustomizePath.Text -PathType Container) {
				$GUIISOSaveToPanel.Enabled = $True
			} else {
				$GUIISOSaveToPanel.Enabled = $False
			}
		}
	}

	<#
		.事件：选择已知版本
	#>
	$GUILangChangeSelectVersionClick = {
		$GUILangChangeSelectVersion.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Checked) {
					$GUILangChangeNumberShow.Text = $_.Tag
				}
			}
		}
	}

	<#
		.Event: Download all
		.事件：显示更改已知版本
	#>
	$GUILangChangeSelectOKClick = {
		<#
			.验证自定义 ISO 默认保存到目录名
		#>
		<#
			.Judgment: 1. Null value
			.判断：1. 空值
		#>
		if ([string]::IsNullOrEmpty($GUILangChangeNumberShow.Text)) {
			$GUILangChangeSelectErrorMsg.Text = "$($Upgrade_Package.SelectFromError -f $($Lang_Download.NoSetLabel))"
			return
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断：2. 前缀不能带空格
		#>
		if ($GUILangChangeNumberShow.Text -match '^\s') {
			$GUILangChangeSelectErrorMsg.Text = "$($Upgrade_Package.SelectFromError -f $($Lang_Download.ISO9660TipsErrorSpace))"
			return
		}

		<#
			.Judgment: 3. Suffix cannot contain spaces
			.判断：3. 后缀不能带空格
		#>
		if ($GUILangChangeNumberShow.Text -match '\s$') {
			$GUILangChangeSelectErrorMsg.Text = "$($Upgrade_Package.SelectFromError -f $($Lang_Download.ISO9660TipsErrorSpace))"
			return
		}

		<#
			.Judgment: 4. The suffix cannot contain multiple spaces
			.判断：4. 后缀不能带多空格
		#>
		if ($GUILangChangeNumberShow.Text -match '\s{2,}$') {
			$GUILangChangeSelectErrorMsg.Text = "$($Upgrade_Package.SelectFromError -f $($Lang_Download.ISO9660TipsErrorSpace))"
			return
		}

		<#
			.Judgment: 5. There can be no two spaces in between
			.判断：5. 中间不能含有二个空格
		#>
		if ($GUILangChangeNumberShow.Text -match '\s{1,}') {
			$GUILangChangeSelectErrorMsg.Text = "$($Upgrade_Package.SelectFromError -f $($Lang_Download.ISO9660TipsErrorSpace))"
			return
		}

		<#
			.Judgment: 6. Cannot contain: A-Z
			.判断：6. 不能包含：字母 A-Z
		#>
		if ($GUILangChangeNumberShow.Text -match '[A-Za-z]+') {
			$GUILangChangeSelectErrorMsg.Text = "$($Upgrade_Package.SelectFromError -f $($Lang_Download.ISO9660TipsErrorAZ))"
			return
		}

		<#
			.Judgment: 7. Cannot contain: \\ /: *? "" <> |
			.判断：7, 不能包含：\\ / : * ? "" < > |
		#>
		if ($GUILangChangeNumberShow.Text -match '[~#$@!%&*{}<>?/|+".]') {
			$GUILangChangeSelectErrorMsg.Text = "$($Upgrade_Package.SelectFromError -f $($Lang_Download.ISO9660TipsErrorOther))"
			return
		}

		<#
			.Judgment: 8. Can't be less than 5 characters
			.判断：8. 不能小于 5 字符
		#>
		if ($GUILangChangeNumberShow.Text.length -lt 5) {
			$GUILangChangeSelectErrorMsg.Text = "$($Upgrade_Package.SelectFromError -f $($Lang_Download.ISOShortError -f "5"))"
			return
		}

		<#
			.Judgment: 9. No more than 16 characters
			.判断：9. 不能大于 16 字符
		#>
		if ($GUILangChangeNumberShow.Text.length -gt 16) {
			$GUILangChangeSelectErrorMsg.Text = "$($Upgrade_Package.SelectFromError -f $($Lang_Download.ISOLengthError -f "16"))"
			return
		}
		$GUILangChangeNumberGroupCL.Visible = 0

		<#
			.验证自定义 ISO 默认保存到目录名，结束并保存新路径
		#>
		Save_Dynamic -regkey "LXPs" -name "LXPsSelect" -value $GUILangChangeNumberShow.Text -String
		$GUILangChangeDownloadMatchSetting.Text = $GUILangChangeNumberShow.Text

		Refresh_Download_Sources_To
	}
	$GUIImageSourceGroupCLCanelClick = {
		$GUILangChangeSelectVersion.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) { $_.Checked = $false }
		}
		$GUILangChangeNumberGroupCL.Visible = 0
	}
	$GUILangChangeNewClick = {
		$GUILangChangeSelectVersion.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) { $_.Checked = $false }
		}
		$GUILangChangeSelectErrorMsg.Text = ""
		$GUILangChangeNumberGroupCL.Visible = 1
	}

	<#
		.Event: Download all
		.事件：下载全部
	#>
	$GUILangChangeDownloadAllClick = {
		if ($GUILangChangeDownloadAll.Checked) {
			Save_Dynamic -regkey "LXPs" -name "IsDownloadAll" -value "True" -String
			$GUILangChangeDownloadPanel.Enabled = $False
			$GUILangChangeSelectVersion.Enabled = $False
			$GUIISOSaveToSelectPanel.Enabled = $False
		} else {
			Save_Dynamic -regkey "LXPs" -name "IsDownloadAll" -value "False" -String
			$GUILangChangeDownloadPanel.Enabled = $True
			$GUILangChangeSelectVersion.Enabled = $True
			$GUIISOSaveToSelectPanel.Enabled = $True
		}

		Refresh_Download_Sources_To
	}

	<#
		事件：匹配未下载项
	#>
	$GUILangMatchNoDownloadItemClick = {
		$InitalReportSources = $GUIISOSaveCustomizePath.Text
		$QueueLXPsMatchNoItemSelect = @()

		if (Test-Path -Path "$($InitalReportSources)\LocalExperiencePack" -PathType Container) {
			$FolderDirect = (Join_MainFolder -Path "$($InitalReportSources)\LocalExperiencePack")
		} else {
			$FolderDirect = (Join_MainFolder -Path $InitalReportSources)
		}

		if (Test-Path -Path "$($FolderDirect)" -PathType Container) {
			for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
				$TempNewFileFullPath = "$($FolderDirect)$($Global:AvailableLanguages[$i][2])\LanguageExperiencePack.$($Global:AvailableLanguages[$i][2]).Neutral.appx"

				if (-not (Test-Path -Path $TempNewFileFullPath -PathType Leaf)) {
					$QueueLXPsMatchNoItemSelect += "$($Global:AvailableLanguages[$i][2])"
				}
			}
		}

		if ($QueueLXPsMatchNoItemSelect.count -gt 0) {
			$GUILangChangeShowGroupCLVersion.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($($QueueLXPsMatchNoItemSelect) -contains $_.Tag) {
						$_.Checked = $True
					} else {
						$_.Checked = $False
					}
				}
			}
		} else {
			$UI_Main_Error.Text = $Lang_Download.MatchDownloadNoNewitem
		}
	}

	<#
		.事件：生成 License.xml
	#>
	$GUIISOAdvAppsLicenseClick = {
		$GUILangChange.Hide()
		LXPs_Download_Licence_Process -Path $GUIISOSaveCustomizePath.Text
		$GUILangChange.Close()
	}

	<#
		.事件：生成报告
	#>
	$GUILangReportOKClick = {
		$MarkVerifyWrite = $False
		$InitalReportSources = $GUILangReportShowSourcesPath.Text
		if (-not [string]::IsNullOrEmpty($InitalReportSources)) {
			if (Test-Path -Path "$($InitalReportSources)" -PathType Container) {
				$MarkVerifyWrite = $True
			}
		}

		if ($MarkVerifyWrite) {
			$GUILangChange.Hide()
			LXPs_Download_Report_Process -Path $GUILangReportShowSourcesPath.Text -SaveTo $GUILangChangeReportSaveToPath.Text
			$GUILangChange.Close()
		} else {
			$GUILangReportErrorMsg.Text = $($lang.Inoperable)
		}
	}
	
	$GUILangReportCreateClick = {
		$RandomGuid = [guid]::NewGuid()
		$DesktopOldpath = [Environment]::GetFolderPath("Desktop")
		$InitalReportSources = $GUIISOSaveCustomizePath.Text
		$GUILangReportErrorMsg.Text = ""
		<#
			.判断保存到是否为空，如果不为空则随机生成新的保存路径
		#>
		if ([string]::IsNullOrEmpty($InitalReportSources)) {
			$GUILangChangeReportSaveToPath.Text = "$($InitalReportSources)\Report.$($RandomGuid).csv"
		} else {
			$GUILangReportShowSourcesPath.Text = $InitalReportSources

			if (Test-Path -Path "$($InitalReportSources)" -PathType Container) {
				if (Test_Available_Disk -Path $InitalReportSources) {
					$GUILangChangeReportSaveToPath.Text = "$($InitalReportSources)\Report.$($RandomGuid).csv"
				} else {
					$GUILangChangeReportSaveToPath.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
				}
			} else {
				$GUILangChangeReportSaveToPath.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
			}
		}

		$GUILangReportPanel.visible = $True
	}
	$GUILangReportCanelClick = {
		$GUILangReportPanel.visible = $False
	}

	$GUILangChangeReportSaveToSelectFolderClick = {
		$RandomGuid = [guid]::NewGuid()

		$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{ 
			FileName = "Report.$($RandomGuid).csv"
			Filter   = "Export CSV Files (*.CSV;)|*.csv;"
		}

		if ($FileBrowser.ShowDialog() -eq "OK") {
			$GUILangChangeReportSaveToPath.Text = $FileBrowser.FileName
		} else {
			$GUILangReportErrorMsg.Text = $($lang.UserCancel)
		}
	}

	<#
		.事件：复制路径
	#>
	$GUILangChangeReportSaveToPathPasteClick = {
		if (-not [string]::IsNullOrEmpty($GUILangChangeReportSaveToPath.Text)) {
			Set-Clipboard -Value $GUILangChangeReportSaveToPath.Text
		}
	}

	$GUILangReportShowSourcesSelectFolderClick = {
		$RandomGuid = [guid]::NewGuid()
		$DesktopOldpath = [Environment]::GetFolderPath("Desktop")
		$GUILangReportErrorMsg.Text = ""

		$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
			RootFolder = "MyComputer"
		}

		if ($FolderBrowser.ShowDialog() -eq "OK") {
			$InitalReportSources = (Join_MainFolder -Path $FolderBrowser.SelectedPath)
			$GUILangReportShowSourcesPath.Text = $InitalReportSources
			
			if (Test-Path -Path "$($InitalReportSources)" -PathType Container) {
				if (Test_Available_Disk -Path $InitalReportSources) {
					$GUILangChangeReportSaveToPath.Text = "$($InitalReportSources)Report.$($RandomGuid).csv"
				} else {
					$GUILangChangeReportSaveToPath.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
				}
			} else {
				$GUILangChangeReportSaveToPath.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
			}
		} else {
			$GUILangReportErrorMsg.Text = "$($lang.UserCancel)"
		}
	}
	<#
		.事件：打开目录
	#>
	$GUILangReportShowSourcesOpenClick = {
		if (-not [string]::IsNullOrEmpty($GUILangReportShowSourcesPath.Text)) {
			if (Test-Path $GUILangReportShowSourcesPath.Text -PathType Container) {
				Start-Process $GUILangReportShowSourcesPath.Text
			}
		}
	}
	<#
		.事件：复制路径
	#>
	$GUILangReportShowSourcesPasteClick = {
		if (-not [string]::IsNullOrEmpty($GUILangReportShowSourcesPath.Text)) {
			Set-Clipboard -Value $GUILangReportShowSourcesPath.Text
		}
	}
	<#
		.事件：同步来源位置与下载到位置一致
	#>#>
	$GUILangReportShowSourcesSyncClick = {
		$RandomGuid = [guid]::NewGuid()
		$DesktopOldpath = [Environment]::GetFolderPath("Desktop")
		$GUILangReportErrorMsg.Text = ""
		$InitalReportSources = (Join_MainFolder -Path $GUIISOSaveCustomizePath.Text)

		if (-not [string]::IsNullOrEmpty($InitalReportSources)) {
			$GUILangReportShowSourcesPath.Text = $InitalReportSources

			if (Test-Path -Path "$($InitalReportSources)" -PathType Container) {
				if (Test_Available_Disk -Path $InitalReportSources) {
					$GUILangChangeReportSaveToPath.Text = "$($InitalReportSources)Report.$($RandomGuid).csv"
				} else {
					$GUILangChangeReportSaveToPath.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
				}
			} else {
				$GUILangChangeReportSaveToPath.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
			}
		}
	}

	<#
		.事件：保存目录位置与筛选版本号同步
	#>
	$GUIISOSaveToSyncClick = {
		if ($GUIISOSaveToSync.Checked) {
			Save_Dynamic -regkey "LXPs" -name "IsSyncSaveTo" -value "True" -String
		} else {
			Save_Dynamic -regkey "LXPs" -name "IsSyncSaveTo" -value "False" -String
		}

		Refresh_Download_Sources_To
	}

	<#
		.事件：自定义选择保存到目录
	#>
	$GUIISOSaveCustomizeSelectFolderClick = {
		$UI_Main_Error.Text = ""

		$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
			RootFolder   = "MyComputer"
		}

		if ($FolderBrowser.ShowDialog() -eq "OK") {
			$InitalReportSources = (Join_MainFolder -Path $FolderBrowser.SelectedPath)
			$GUILangReportShowSourcesPath.Text = $InitalReportSources
			
			if (Test-Path -Path "$($InitalReportSources)" -PathType Container) {
				if (Test_Available_Disk -Path $InitalReportSources) {
					$GUIISOSaveCustomizePath.Text = $InitalReportSources
					$Script:InitalSaveToPath = $InitalReportSources

					<#
						.更换成功后，关闭同步来源位置与下载位置一致，复选框
					#>
					$GUIISOSaveToSync.Checked = $False
				} else {
					$UI_Main_Error.Text = "$($lang.Inoperable)"
				}
			} else {
				$UI_Main_Error.Text = "$($lang.Inoperable)"
			}
		} else {
			$UI_Main_Error.Text = "$($lang.UserCancel)"
		}
	}

	<#
		.事件：打开目录
	#>
	$GUIISOSaveCustomizeOpenFolderClick = {
		if (-not [string]::IsNullOrEmpty($GUIISOSaveCustomizePath.Text)) {
			if (Test-Path $GUIISOSaveCustomizePath.Text -PathType Container) {
				Start-Process $GUIISOSaveCustomizePath.Text
			}
		}
	}

	<#
		.事件：复制路径
	#>
	$GUIISOSaveCustomizePasteClick = {
		if (-not [string]::IsNullOrEmpty($GUIISOSaveCustomizePath.Text)) {
			Set-Clipboard -Value $GUIISOSaveCustomizePath.Text
		}
	}

	$GUILangChangeTipsDoNotClick = {
		if ($GUILangChangeTipsDoNot.Checked) {
			Save_Dynamic -regkey "LXPs" -name "LXPsTipsWarning" -value "True" -String
		} else {
			Save_Dynamic -regkey "LXPs" -name "LXPsTipsWarning" -value "False" -String
		}
	}
	$GUILangChangeTipsViewClick = { $GUILangChangeTips.Visible = 1 }
	$GUILangChangeTipsCanelClick = { $GUILangChangeTips.Visible = 0 }

	<#
		.Event: canceled
		.事件：取消
	#>
	$UI_Main_Canel_Click = {
		Write-Host "   $($lang.UserCancel)" -ForegroundColor Red
		$Script:Queue_Language_Download_Select = @()
		$GUILangChange.Close()
	}

	<#
		.Event: Ok
		.事件：确认
	#>
	$UI_Main_OK_Click = {
		$Script:Queue_Language_Download_Select = @()

		$GUILangChangeShowGroupCLVersion.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Script:Queue_Language_Download_Select += $_.Tag
					}
				}
			}
		}

		if ($Script:Queue_Language_Download_Select.count -gt 0) {
			Save_Dynamic -regkey "LXPs" -name "Select_Download_Language" -value $Script:Queue_Language_Download_Select -Multi
		} else {
			$UI_Main_Error.Text = "$($Upgrade_Package.SelectFromError -f $($Lang_Download.Not_Select))"
			return
		}

		if ([string]::IsNullOrEmpty($GUILangChangeDownloadMatchSetting.Text)) {
			$UI_Main_Error.Text = "$($Upgrade_Package.SelectFromError -f $($Lang_Downloadr.OSVersion))"
			return
		}

		$GUILangChange.Hide()
		$Script:Version = $GUILangChangeDownloadMatchSetting.Text
		$Script:IsDownload = $False
		$Script:IsRename = $False
		$Script:IsLicence = $False

		if ($GUILangChangeDownloadAll.Checked) {
			$Script:IsDownload = $True
		} else {
			if ($GUILangChangeRuleRename.Checked) {
				$Script:IsRename = $True
			}

			if ($GUILangChangeLicence.Checked) {
				$Script:IsLicence = $True
			}
		}

		LXPs_Download_Process
		$GUILangChange.Close()
	}
	$GUILangChange     = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 878
		Text           = $lang.LXPs
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
	}

	$GUILangChangeSelect = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 665
		Width          = 500
		Location       = "10,10"
		BorderStyle    = 0
		autoScroll     = $True
	}

	<#
		.可用语言
	#>
	$GUILangSelectAdvTips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 340
		Text           = $Lang_Download.AvailableLanguages
	}
	$GUILangChangeShowGroupCLVersion = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 200
		Width          = 475
		Padding        = "18,0,0,0"
		margin         = "0,0,0,25"
		autoSizeMode   = 0
		autoScroll     = $True
	}

	<#
		.组：选择已知版本号
	#>
	$GUILangChangeNumberGroupCL = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 923
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = 0
	}
	$GUILangChangeSelectVersionTitle = New-Object system.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 240
		Location       = "15,10"
		Text           = $Lang_Download.OSVersion
	}
	$GUILangChangeSelectVersion = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 640
		Width          = 340
		Padding        = "8,0,8,0"
		Location       = "15,35"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
	}

	$GUILangChangeNumberGroupCLShowTitle = New-Object system.Windows.Forms.Label -Property @{
		Height         = 25
		Width          = 400
		Location       = "405,15"
		Text           = $Lang_Download.LXPsFilter
	}
	$GUILangChangeNumberShow = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 22
		Width          = 385
		Location       = "426,45"
		Text           = ""
	}
	$GUILangChangeNumberShowTips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 150
		Width          = 385
		Location       = "425,80"
		Text           = $Lang_Download.LXPsDownloadTips
	}

	$GUILangChangeSelectErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		Location       = "405,565"
		Height         = 22
		Width          = 445
		Text           = ""
	}
	$GUILangChangeSelectOK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,595"
		Height         = 36
		Width          = 280
		add_Click      = $GUILangChangeSelectOKClick
		Text           = $lang.OK
	}
	$GUIImageSourceGroupCLCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,635"
		Height         = 36
		Width          = 280
		add_Click      = $GUIImageSourceGroupCLCanelClick
		Text           = $lang.Cancel
	}

	<#
		.下载全部
	#>
	$GUILangChangeDownloadAll = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 25
		Width          = 385
		Text           = $Lang_Download.DownloadAll
		Checked        = $True
		add_Click      = $GUILangChangeDownloadAllClick
	}

	$GUILangChangeDownloadPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Padding        = "16,0,0,0"
		margin         = "0,0,0,30"
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
	}
	$GUILangChangeDownloadMatch = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 395
		Text           = $Lang_Download.LXPsFilter
	}
	$GUILangChangeDownloadMatchSetting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 395
		Padding        = "16,0,0,0"
		Text           = ""
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUILangChangeNewClick
	}
	$GUILangChangeNew = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 395
		Padding        = "16,0,0,0"
		Text           = $Lang_Download.OSVersion
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUILangChangeNewClick
	}
	$GUILangChangeDownloadMatchTips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "16,0,15,5"
		Text           = $Lang_Download.LXPsDownloadTips
	}

	$GUILangChangeRuleRename = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 25
		Width          = 385
		margin         = "0,20,0,0"
		Text           = $Lang_Download.LXPsRename
		Checked        = $True
		add_Click      = $GUILangChangeDownloadAllClick
	}
	$GUILangChangeRuleRenameTips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "14,0,15,0"
		Text           = $Lang_Download.LXPsRenameTips
	}

	$GUILangChangeLicence = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 25
		Width          = 385
		margin         = "0,20,0,0"
		Text           = $Lang_Download.LicenseCreate
		Checked        = $True
		add_Click      = $GUILangChangeDownloadAllClick
	}
	$GUILangChangeLicenceTips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "14,0,15,0"
		Text           = $Lang_Download.LicenseCreateTips
	}

	<#
		.保存到
	#>
	$GUIISOSaveTo      = New-Object system.Windows.Forms.Label -Property @{
		Height         = 25
		Width          = 455
		Text           = $Lang_Download.SaveTo
	}
	$GUIISOSaveCustomizePath = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 22
		Width          = 435
		margin         = "24,5,0,15"
		ReadOnly       = $True
		Text           = ""
	}
	$GUIISOSaveCustomizeSelectFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $Lang_Download.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUIISOSaveCustomizeSelectFolderClick
	}
	$GUIISOSaveCustomizeSelectFolderTips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "36,0,15,0"
		margin         = "0,0,0,15"
		Text           = $Lang_Download.SelectFolderTips
	}

	$GUIISOSaveToSelectPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		Padding        = "16,0,0,0"
	}
	$GUIISOSaveToSync  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 25
		Width          = 455
		Text           = $Lang_Download.SaveToSync
		add_Click      = $GUIISOSaveToSyncClick
	}
	$GUIISOSaveToSyncTips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "18,0,15,0"
		margin         = "0,0,0,25"
		Text           = $Lang_Download.SaveToSyncTips
	}

	$GUIISOSaveToPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		Padding        = "16,0,0,0"
		margin         = "0,0,0,15"
	}
	<#
		.证书
	#>
	$GUIISOAdvAppsLicense = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		Text           = $Lang_Download.LicenseCreate
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUIISOAdvAppsLicenseClick
	}
	$GUIISOAdvAppsLicenseTips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "18,0,15,0"
		margin         = "0,0,0,25"
		Text           = $Lang_Download.LicenseCreateTips
	}
	$GUIISOSaveCustomizeOpenFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		Text           = $Lang_Download.OpenFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUIISOSaveCustomizeOpenFolderClick
	}
	$GUIISOSaveCustomizePaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		Text           = $Lang_Download.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUIISOSaveCustomizePasteClick
	}

	<#
		.匹配未下载项
	#>
	$GUILangMatchNoDownloadItem = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		Text           = $Lang_Download.MatchNoDownloadItem
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUILangMatchNoDownloadItemClick
	}

	<#
		.显示更改区域设置蒙层
	#>
	$GUILangReportPanel = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 1025
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = 0
	}
	$GUILangReportShow = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 665
		Width          = 450
		Padding        = "8,0,8,0"
		Location       = "15,10"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
	}
	$GUILangReportShowTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 300
		Text           = $Lang_Download.AdvAppsDetailed
	}
	$GUILangReportShowTitleTips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "16,0,0,0"
		margin         = "0,0,0,20"
		Text           = $Lang_Download.AdvAppsDetailedTips
	}

	$GUILangReportShowSelectSources = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 400
		Text           = $Lang_Download.ProcessSources
	}
	$GUILangReportShowSourcesPath = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 22
		Width          = 370
		margin         = "18,5,0,10"
		Text           = ""
		ReadOnly       = $True
	}
	$GUILangReportShowSourcesSelectFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 425
		Padding        = "16,0,0,0"
		Text           = $Lang_Download.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUILangReportShowSourcesSelectFolderClick
	}
	$GUILangReportShowSourcesOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 425
		Padding        = "16,0,0,0"
		Text           = $Lang_Download.OpenFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUILangReportShowSourcesOpenClick
	}
	$GUILangReportShowSourcesPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 425
		Padding        = "16,0,0,0"
		Text           = $Lang_Download.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUILangReportShowSourcesPasteClick
	}
	$GUILangReportShowSourcesSync = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 425
		Padding        = "16,0,0,0"
		Text           = $Lang_Download.SaveToSync
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUILangReportShowSourcesSyncClick
	}

	<#
		.报告保存到
	#>
	$GUILangChangeReportSaveTo = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 400
		margin         = "0,30,0,0"
		Text           = $Lang_Download.SaveTo
	}
	$GUILangChangeReportSaveToPath = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 22
		Width          = 370
		margin         = "20,5,0,15"
		Text           = ""
		ReadOnly       = $True
	}
	$GUILangChangeReportSaveToSelectFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 425
		Padding        = "16,0,0,0"
		Text           = $Lang_Download.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUILangChangeReportSaveToSelectFolderClick
	}
	$GUILangChangeReportSaveToPathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 425
		Padding        = "16,0,0,0"
		Text           = $Lang_Download.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUILangChangeReportSaveToPathPasteClick
	}
	$GUILangReportErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		Location       = "570,565"
		Height         = 22
		Width          = 280
		Text           = ""
	}
	$GUILangReportOK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,595"
		Height         = 36
		Width          = 280
		add_Click      = $GUILangReportOKClick
		Text           = $lang.OK
	}
	$GUILangReportCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,635"
		Height         = 36
		Width          = 280
		add_Click      = $GUILangReportCanelClick
		Text           = $lang.Cancel
	}

	<#
		.显示提示蒙层
	#>
	$GUILangChangeTips   = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 898
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = 0
	}
	$GUILangChangeTipsMsg = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 580
		Width          = 845
		BorderStyle    = 0
		Location       = "15,15"
		Text           = $Lang_Download.LXPsGetSNTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$GUILangChangeTipsDoNot = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "20,635"
		Height         = 25
		Width          = 440
		Text           = $Lang_Download.LXPsAddDelTips
		add_Click      = $GUILangChangeTipsDoNotClick
	}
	$GUILangChangeTipsCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,635"
		Height         = 36
		Width          = 280
		add_Click      = $GUILangChangeTipsCanelClick
		Text           = $lang.Cancel
	}
	$GUILangChangeTipsView = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 22
		Width          = 280
		Text           = $Lang_Download.LXPsAddDelTipsView
		Location       = "570,520"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUILangChangeTipsViewClick
	}

	$GUILangReportCreate = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,10"
		Height         = 36
		Width          = 280
		add_Click      = $GUILangReportCreateClick
		Text           = $Lang_Download.AdvAppsDetailed
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "570,568"
		Height         = 22
		Width          = 280
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,595"
		Height         = 36
		Width          = 280
		add_Click      = $UI_Main_OK_Click
		Text           = $lang.StartVerify
	}
	$UI_Main_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,635"
		Height         = 36
		Width          = 280
		add_Click      = $UI_Main_Canel_Click
		Text           = $lang.Cancel
	}
	$GUILangChange.controls.AddRange((
		$GUILangChangeTips,
		$GUILangReportPanel,
		$GUILangChangeNumberGroupCL,
		$GUILangChangeSelect,
		$GUILangReportCreate,
		$GUILangChangeTipsView,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))
	$GUILangChangeTips.controls.AddRange((
		$GUILangChangeTipsMsg,
		$GUILangChangeTipsDoNot,
		$GUILangChangeTipsCanel
	))
	$GUILangReportPanel.controls.AddRange((
		$GUILangReportShow,
		$GUILangReportErrorMsg,
		$GUILangReportOK,
		$GUILangReportCanel
	))
	$GUILangReportShow.controls.AddRange((
		$GUILangReportShowTitle,
		$GUILangReportShowTitleTips,
		$GUILangReportShowSelectSources,
		$GUILangReportShowSourcesPath,
		$GUILangReportShowSourcesSelectFolder,


		$GUILangReportShowSourcesOpen,
		$GUILangReportShowSourcesPaste,
		$GUILangReportShowSourcesSync,
		$GUILangChangeReportSaveTo,
		$GUILangChangeReportSaveToPath,
		$GUILangChangeReportSaveToSelectFolder,
		$GUILangChangeReportSaveToPathPaste
	))
	$GUILangChangeSelect.controls.AddRange((
		$GUILangSelectAdvTips,
		$GUILangChangeShowGroupCLVersion,

		$GUILangChangeDownloadAll,
		$GUILangChangeDownloadPanel,

		$GUIISOSaveTo,
		$GUIISOSaveCustomizePath,
		$GUIISOSaveCustomizeSelectFolder,
		$GUIISOSaveCustomizeSelectFolderTips,
#		$GUIISOSaveCustomizeOpenFolder,
#		$GUIISOSaveCustomizePaste,

		$GUIISOSaveToSelectPanel,
		$GUIISOSaveToPanel
	))
	$GUIISOSaveToSelectPanel.controls.AddRange((
		$GUIISOSaveToSync,
		$GUIISOSaveToSyncTips
	))
	$GUIISOSaveToPanel.controls.AddRange((
		$GUIISOAdvAppsLicense,
		$GUIISOAdvAppsLicenseTips,
		$GUIISOSaveCustomizeOpenFolder,
		$GUIISOSaveCustomizePaste,
		$GUILangMatchNoDownloadItem
	))
	$GUILangChangeDownloadPanel.controls.AddRange((
		$GUILangChangeDownloadMatch,
		$GUILangChangeDownloadMatchSetting,
		$GUILangChangeNew,
		$GUILangChangeDownloadMatchTips,
		$GUILangChangeRuleRename,
		$GUILangChangeRuleRenameTips,
		$GUILangChangeLicence,
		$GUILangChangeLicenceTips
	))
	$GUILangChangeNumberGroupCL.controls.AddRange((
		$GUILangChangeSelectVersionTitle,
		$GUILangChangeSelectVersion,
		$GUILangChangeNumberGroupCLShowTitle,
		$GUILangChangeNumberShow,
		$GUILangChangeNumberShowTips,
		$GUILangChangeSelectErrorMsg,
		$GUILangChangeSelectOK,
		$GUIImageSourceGroupCLCanel
	))

	<#
		.获取语言列表并初始化选择
	#>
	if (-not (Get-ItemProperty -Path  "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name 'Select_Download_Language' -ErrorAction SilentlyContinue)) {
		Save_Dynamic -regkey "LXPs" -name "Select_Download_Language" -value "" -Multi
	}
	$GetSelectLXPsLanguageRemove = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "Select_Download_Language"

	$SelectLXPsLanguageRemove = @()
	foreach ($item in $GetSelectLXPsLanguageRemove) {
		$SelectLXPsLanguageRemove += $item
	}

	for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
		if ($Global:AvailableLanguages[$i][0] -eq "1") {
			$CheckBox   = New-Object System.Windows.Forms.CheckBox -Property @{
				Height  = 28
				Width   = 430
				Text    = "$($Global:AvailableLanguages[$i][2].PadRight(45)) $($Global:AvailableLanguages[$i][4])"
				Tag     = $($Global:AvailableLanguages[$i][2])
			}

			if ($SelectLXPsLanguageRemove -eq $Global:AvailableLanguages[$i][2]) {
				$CheckBox.Checked = $True
			} else {
				$CheckBox.Checked = $False
			}

			$GUILangChangeShowGroupCLVersion.controls.AddRange($CheckBox)
		}
	}


	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "LXPsSelect" -ErrorAction SilentlyContinue) {
		$GetLXPsSelect = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "LXPsSelect" -ErrorAction SilentlyContinue
		$GUILangChangeDownloadMatchSetting.Text = $GetLXPsSelect
		$GUILangChangeNumberShow.Text = $GetLXPsSelect
	} else {
		$GUILangChangeDownloadMatchSetting.Text = $Lang_Download.MatchDownloadNoNewitem
	}

	for ($i=0; $i -lt $Global:OSCodename.Count; $i++) {
		$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
			Height    = 40
			Width     = 310
			Text      = "$($Global:OSCodename[$i][0])`n$($Global:OSCodename[$i][1])"
			Tag       = $($Global:OSCodename[$i][1])
			add_Click = $GUILangChangeSelectVersionClick
		}

		$GUILangChangeSelectVersion.controls.AddRange($CheckBox)
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "IsSyncSaveTo" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "IsSyncSaveTo" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOSaveToSync.Checked = $True
			}
			"False" {
				$GUIISOSaveToSync.Checked = $False
			}
		}
	} else {
		$GUIISOSaveToSync.Checked = $True
	}

	$GetCurrentDisk = Convert-Path -Path "$($PSScriptRoot)\..\..\..\" -ErrorAction SilentlyContinue
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "IsDownloadAll" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "IsDownloadAll" -ErrorAction SilentlyContinue) {
			"True" {
				$GUILangChangeDownloadAll.Checked = $True
				$GUILangChangeSelectVersion.Enabled = $False
				$GUILangChangeDownloadPanel.Enabled = $False
				$GUIISOSaveToSelectPanel.Enabled = $False
			}
			"False" {
				$GUILangChangeDownloadAll.Checked = $False
				$GUILangChangeSelectVersion.Enabled = $True
				$GUILangChangeDownloadPanel.Enabled = $True
				$GUIISOSaveToSelectPanel.Enabled = $True
			}
		}
	} else {
		$GUILangChangeDownloadAll.Checked = $True
		$GUILangChangeSelectVersion.Enabled = $False
		$GUILangChangeDownloadPanel.Enabled = $False
		$GUIISOSaveToSelectPanel.Enabled = $False
	}

	Refresh_Download_Sources_To

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "LXPsTipsWarning" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "LXPsTipsWarning" -ErrorAction SilentlyContinue) {
			"True" {
				$GUILangChangeTips.Visible = 0
				$GUILangChangeTipsDoNot.Checked = $True
			}
			"False" {
				$GUILangChangeTips.Visible = 1
				$GUILangChangeTipsDoNot.Checked = $False
			}
		}
	} else {
		$GUILangChangeTips.Visible = 1
		$GUILangChangeTipsDoNot.Checked = $False
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$GUIImageSelectFunctionSelClick = {
		$GUILangChangeShowGroupCLVersion.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) { $_.Checked = $true }
		}
	}
	$GUIImageSelectFunctionAllClearClick = {
		$GUILangChangeShowGroupCLVersion.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) { $_.Checked = $false }
		}
	}
	$GUIImageSelectFunctionSelectMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIImageSelectFunctionSelectMenu.Items.Add($lang.AllSel).add_Click($GUIImageSelectFunctionSelClick)
	$GUIImageSelectFunctionSelectMenu.Items.Add($lang.AllClear).add_Click($GUIImageSelectFunctionAllClearClick)
	$GUILangChangeShowGroupCLVersion.ContextMenuStrip = $GUIImageSelectFunctionSelectMenu

	switch ($Global:IsLang) {
		"zh-CN" {
			$GUILangChange.Font = New-Object System.Drawing.Font("Microsoft YaHei", 9, [System.Drawing.FontStyle]::Regular)
		}
		Default {
			$GUILangChange.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
		}
	}

	$GUILangChange.FormBorderStyle = 'Fixed3D'
	$GUILangChange.ShowDialog() | Out-Null
}


function MicrosoftToDo
{
	param
	(
		$lang,
		$StoreURL,
		$SaveTo
	)

	write-host "   $StoreURL"
	write-host "   $SaveTo"

	$wchttp=[System.Net.WebClient]::new()
	$URI = "https://store.rg-adguard.net/api/GetFiles"
	$myParameters = "type=url&url=$($StoreURL)"
	#&ring=Retail&lang=sv-SE"

	$wchttp.Headers[[System.Net.HttpRequestHeader]::ContentType]="application/x-www-form-urlencoded"
	$HtmlResult = $wchttp.UploadString($URI, $myParameters)

	$Start=$HtmlResult.IndexOf("<p>The links were successfully received from the Microsoft Store server.</p>")
	#write-host $start

	if ($Start -eq -1)
	{
		write-host "Could not get the links, please check the StoreURL."
		return
	}
	$TableEnd=($HtmlResult.LastIndexOf("</table>")+8)

	$SemiCleaned=$HtmlResult.Substring($start,$TableEnd-$start)

	#https://stackoverflow.com/questions/46307976/unable-to-use-ihtmldocument2
	$newHtml=New-Object -ComObject "HTMLFile"
	try {
		# This works in PowerShell with Office installed
		$newHtml.IHTMLDocument2_write($SemiCleaned)
	} catch {
		# This works when Office is not installed    
		$src = [System.Text.Encoding]::Unicode.GetBytes($SemiCleaned)
		$newHtml.write($src)
	}

	$ToDownload=$newHtml.getElementsByTagName("a") | Select-Object textContent, href

	$LastFrontSlash=$StoreURL.LastIndexOf("/")
	$ProductID=$StoreURL.Substring($LastFrontSlash+1,$StoreURL.Length-$LastFrontSlash-1)

	# OldRegEx   Failed when the %tmp% started with a lowercase char
	#if ([regex]::IsMatch("$SaveTo\$ProductID","([,!@?#$%^&*()\[\]]+|\\\.\.|\\\\\.|\.\.\\\|\.\\\|\.\.\/|\.\/|\/\.\.|\/\.|;|(?<![A-Z]):)|^\w+:(\w|.*:)"))

	if ([regex]::IsMatch("$SaveTo","([,!@?#$%^&*()\[\]]+|\\\.\.|\\\\\.|\.\.\\\|\.\\\|\.\.\/|\.\/|\/\.\.|\/\.|;|(?<![A-Za-z]):)|^\w+:(\w|.*:)")) {
		write-host "Invalid characters in path"$SaveTo""
		return
	}

	Foreach ($Download in $ToDownload)
	{
		if ($Script:IsDownload) {
			Write-host "   Downloading $($Download.textContent)"
			$wchttp.DownloadFile($Download.href, "$($SaveTo)\$($Download.textContent)")
		} else {
			if ($Download.textContent -like "*$($Script:Version)*.appx") {
				Write-host "   Downloading $($Download.textContent)"
				$wchttp.DownloadFile($Download.href, "$($SaveTo)\$($Download.textContent)")

				<#
					.改名
				#>
				write-host "   改名"
				if ($Script:IsRename) {
					write-host "   允许改名" -ForegroundColor Green
					Rename-Item -Path "$($SaveTo)\$($Download.textContent)" -NewName "$($SaveTo)\LanguageExperiencePack.$($lang).Neutral.appx" -ErrorAction SilentlyContinue

					if (Test-Path -Path "$($SaveTo)\LanguageExperiencePack.$($lang).Neutral.appx" -PathType Leaf) {
						write-host "   Done" -ForegroundColor Green
					} else {
						write-host "   Failure" -ForegroundColor Red
					}
				} else {
					write-host " 不改名" -ForegroundColor Red
				}

				<#
					.证书
				#>
				if ($Script:IsLicence) {
					write-host "   允许创建证书" -ForegroundColor Green

					if (Test-Path -Path "$($SaveTo)\License.xml" -PathType Leaf) {
						write-host "   Failure" -ForegroundColor Red
					} else {
						$zipFile = [IO.Compression.ZipFile]::OpenRead("$($SaveTo)\LanguageExperiencePack.$($lang).Neutral.appx")
						$zipFile.Entries | where { $_.Name -like 'License.xml' } | foreach { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$($SaveTo)\$($_.Name)", $true) }
						$zipFile.Dispose()

						write-host "   Done" -ForegroundColor Green
					}
				} else {
					write-host "   跳过创建证书" -ForegroundColor Red
				}
			}
		}
	}
}

Function LXPs_Download_Report_Process
{
	param
	(
		$Path,
		$SaveTo
	)

	Add-Type -AssemblyName System.IO.Compression.FileSystem;

	if (Test-Path -Path "$($Path)\LocalExperiencePack" -PathType Container) {
		$FolderDirect = (Join_MainFolder -Path "$($Path)\LocalExperiencePack")
	} else {
		$FolderDirect = (Join_MainFolder -Path $Path)
	}

	write-host "`n   $($Lang_Download.AdvAppsDetailed)"
	$QueueSelectLXPsReport = @()
	$RandomGuid = [guid]::NewGuid()
	$ISOTestFolderMain = "$($env:userprofile)\AppData\Local\Temp\$($RandomGuid)"
	Check_Folder -chkpath $ISOTestFolderMain

	for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
		$TempNewFileFolderPath = "$($ISOTestFolderMain)\$($Global:AvailableLanguages[$i][2])"
		$TempNewFileFullPath = "$($FolderDirect)$($Global:AvailableLanguages[$i][2])\LanguageExperiencePack.$($Global:AvailableLanguages[$i][2]).Neutral.appx"

		if (Test-Path -Path $TempNewFileFullPath -PathType Leaf) {
			Check_Folder -chkpath $TempNewFileFolderPath

			$zipFile = [IO.Compression.ZipFile]::OpenRead($TempNewFileFullPath)
			$zipFile.Entries | where { $_.Name -like 'AppxManifest.xml' } | foreach { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$($TempNewFileFolderPath)\$($_.Name)", $true) }
			$zipFile.Dispose()

			if (Test-Path -Path "$($TempNewFileFolderPath)\AppxManifest.xml" -PathType Leaf) {
				[xml]$xml = Get-Content -Path "$($TempNewFileFolderPath)\AppxManifest.xml"

				$QueueSelectLXPsReport += @{
					FileName           = "LanguageExperiencePack.$($Global:AvailableLanguages[$i][2]).Neutral.appx"
					MatchLanguage      = "$($Global:AvailableLanguages[$i][2])"
					LXPsDisplayName    = $Xml.Package.Properties.DisplayName
					LXPsLanguage       = $Xml.Package.Resources.Resource.Language
					LXPsVersion        = $Xml.Package.Identity.Version
					TargetDeviceFamily = $Xml.Package.Dependencies.TargetDeviceFamily.Name
					MinVersion         = $Xml.Package.Dependencies.TargetDeviceFamily.MinVersion
					MaxVersionTested   = $Xml.Package.Dependencies.TargetDeviceFamily.MaxVersionTested
				}
			}
		} else {
			$QueueSelectLXPsReport += @{
				FileName           = "LanguageExperiencePack.$($Global:AvailableLanguages[$i][2]).Neutral.appx"
				MatchLanguage      = "$($Global:AvailableLanguages[$i][2])"
				LXPsDisplayName    = ""
				LXPsLanguage       = ""
				LXPsVersion        = ""
				TargetDeviceFamily = ""
				MinVersion         = ""
				MaxVersionTested   = ""
			}
		}
	}

	$QueueSelectLXPsReport | Export-CSV –NoType -Path "$($SaveTo)" -Encoding utf8BOM
	Remove_Tree $ISOTestFolderMain
}

Function LXPs_Download_Licence_Process
{
	param
	(
		$Path
	)

	Add-Type -AssemblyName System.IO.Compression.FileSystem;

	if (Test-Path -Path "$($Path)\LocalExperiencePack" -PathType Container) {
		$FolderDirect = (Join_MainFolder -Path "$($Path)\LocalExperiencePack")
	} else {
		$FolderDirect = (Join_MainFolder -Path $Path)
	}

	write-host "`n   $($Lang_Download.LicenseCreate)"
	$QueueLXPsLicenceSelect = @()
	for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
		$TempNewFileFolderPath = "$($FolderDirect)$($Global:AvailableLanguages[$i][2])"
		$TempNewFileFullPath = "$($FolderDirect)$($Global:AvailableLanguages[$i][2])\LanguageExperiencePack.$($Global:AvailableLanguages[$i][2]).Neutral.appx"

		if (Test-Path -Path $TempNewFileFullPath -PathType Leaf) {
			$QueueLXPsLicenceSelect += @{
				Language = "$($Global:AvailableLanguages[$i][2])"
				FileName = "LanguageExperiencePack.$($Global:AvailableLanguages[$i][2]).Neutral.appx"
				OrgPath  = $TempNewFileFolderPath
			}
		}
	}

	if ($QueueLXPsLicenceSelect.count -gt 0) {
		Write-Host "   $($Lang_Download.YesWork)" -ForegroundColor Green

		Write-host "`n   $($Lang_Download.ProcessSources)`n   ---------------------------------------------------"
		write-host "   $($Path)"

		Write-Host "`n   $($Lang_Download.AddSources)`n   ---------------------------------------------------"
		foreach ($item in $QueueLXPsLicenceSelect) {
			Write-Host "   $($item.Language)".PadRight(28) -NoNewline
			write-host " $($item.FileName)"
		}

		Write-Host "`n   $($Lang_Download.AddQueue)`n   ---------------------------------------------------"
		foreach ($item in $QueueLXPsLicenceSelect) {
			$TempNewFileFullPath = "$($item.OrgPath)\$($item.FileName)"

			if (Test-Path -Path $TempNewFileFullPath -PathType Leaf) {
				write-host "   $($item.Language)".PadRight(28) -NoNewline
				Remove-Item -Path "$($item.OrgPath)\License.xml" -ErrorAction SilentlyContinue

				$zipFile = [IO.Compression.ZipFile]::OpenRead($TempNewFileFullPath)
				$zipFile.Entries | where { $_.Name -like 'License.xml' } | foreach {
					[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$($item.OrgPath)\$($_.Name)", $true)
				}
				$zipFile.Dispose()

				if (Test-Path -Path "$($item.OrgPath)\License.xml" -PathType Leaf) {
					write-host " YES"
				} else {
					write-host " NO"
				}
			}
		}
	} else {
		Write-Host "   $($Lang_Download.NoWork)" -ForegroundColor Red
	}
}

Function LXPs_Download_Process
{
	Write-Host "   $($Lang_Download.YesWork)" -ForegroundColor Green

	write-host "   待下载的语言"
	if ($Script:Queue_Language_Download_Select.Count -gt 0) {
		foreach ($item in $Script:Queue_Language_Download_Select) {
			write-host "   $($item)"
		}

		Write-hsot "`n    正在下载："
		for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
			if (($Script:Queue_Language_Download_Select) -Contains $($Global:AvailableLanguages[$i][2])) {
				$NewStoreURL = "https://www.microsoft.com/store/productId/$($Global:AvailableLanguages[$i][6])"
				$NewFolder   = "$($PSScriptRoot)\..\..\..\Download\$($Script:Version)\LocalExperiencePack\$($Global:AvailableLanguages[$i][2])"
				$NewFilename = "LanguageExperiencePack.$($Global:AvailableLanguages[$i][2]).Neutral.appx"

				Check_Folder -chkpath $NewFolder
				$NewFolder = Convert-Path -Path $NewFolder -ErrorAction SilentlyContinue

				write-host "   $($NewFolder)\$($NewFilename)" -ForegroundColor Green

				if (Test-Path -Path "$($NewFolder)\$($NewFilename)" -PathType Leaf) {
					write-host "   Local presence: $($NewFolder)\$($NewFilename)`n" -ForegroundColor Green
				} else {
					write-host "   Sources: $($NewStoreURL)"

					MicrosoftToDo -Lang $Global:AvailableLanguages[$i][2] -StoreURL $NewStoreURL -SaveTo $NewFolder
				}
			}
		}
	} else {
		Write-Host "   $($Lang_Download.NoWork)" -ForegroundColor Red
	}
}