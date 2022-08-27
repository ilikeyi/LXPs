<#
	.Windows system version, version number
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

	Function LXPs_Refresh_Sources_To_Event
	{
		$RandomGuid = [guid]::NewGuid()

		if ($UI_Main_Download.Checked) {
			$UI_Main_Sync_Some_Location.Enabled = $False
			$UI_Main_Sync_Some_Location_Tips.Enabled = $False
			$UI_Main_Select_Folder.Enabled = $False
			$UI_Main_Select_Folder_Tips.Enabled = $False
			$UI_Main_Save_To.Text = "$($GetCurrentDisk)Download\Default"
		} else {
			$UI_Main_Sync_Some_Location.Enabled = $True
			$UI_Main_Sync_Some_Location_Tips.Enabled = $True
			if ($UI_Main_Sync_Some_Location.Checked) {
				if ([string]::IsNullOrEmpty($UI_Main_Download_Match_Version_Select.Text)) {
					$UI_Main_Save_To.Text = "$($GetCurrentDisk)Download\$($RandomGuid)"
				} else {
					$UI_Main_Save_To.Text = "$($GetCurrentDisk)Download\$($UI_Main_Download_Match_Version_Select.Text)"
				}
			} else {
				<#
					.Determine if the last selected directory has been saved
					.判断是否有已保存上次选择的目录
				#>
				if ([string]::IsNullOrEmpty($Script:InitalSaveToPath)) {
					$UI_Main_Save_To.Text = "$($GetCurrentDisk)Download\$($RandomGuid)"
				} else {
					$UI_Main_Save_To.Text = $Script:InitalSaveToPath
				}
			}
		}

		if ([string]::IsNullOrEmpty($UI_Main_Save_To.Text)) {
			$UI_Main_Save_To_License.Enabled = $False
			$UI_Main_Save_To_License_Tips.Enabled = $False
			$UI_Main_Save_To_Open_Folder.Enabled = $False
			$UI_Main_Save_To_Paste.Enabled = $False
			$UI_Main_Match_No_Select_Item.Enabled = $False
		} else {
			if (Test-Path $UI_Main_Save_To.Text -PathType Container) {
				$UI_Main_Save_To_License.Enabled = $True
				$UI_Main_Save_To_License_Tips.Enabled = $True
				$UI_Main_Save_To_Open_Folder.Enabled = $True
				$UI_Main_Save_To_Paste.Enabled = $True
				$UI_Main_Match_No_Select_Item.Enabled = $True
			} else {
				$UI_Main_Save_To_License.Enabled = $False
				$UI_Main_Save_To_License_Tips.Enabled = $False
				$UI_Main_Save_To_Open_Folder.Enabled = $False
				$UI_Main_Save_To_Paste.Enabled = $False
				$UI_Main_Match_No_Select_Item.Enabled = $False
			}
		}
	}

	<#
		.Event: Displays the rule details
		.事件：显示规则详细
	#>
	$UI_Main_Languages_Detailed_View_Click = {
		$UI_Main_Languages_Detailed_View_Mask.Visible = $True
	}

	<#
		.Event: Hide show rule details
		.事件：隐藏显示规则详细
	#>
	$UI_Main_Languages_Detailed_View_Mask_Canel_Click = {
		$UI_Main_Languages_Detailed_View_Mask.Visible = $False
	}

	<#
		.Event: Select a known version
		.事件：选择已知版本
	#>
	$GUILangChangeSelectVersionClick = {
		$UI_Main_Download_Match_Version.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Checked) {
					$UI_Main_Download_Match_Version_Select.Text = $_.Tag
				}
			}
		}
	}

	<#
		.Event: Download all
		.事件：显示更改已知版本
	#>
	$UI_Main_Download_Match_Version_OK_Click = {
		<#
			.Verify that the custom ISO is saved to the directory name by default
			.验证自定义 ISO 默认保存到目录名
		#>
		<#
			.Judgment: 1. Null value
			.判断：1. 空值
		#>
		if ([string]::IsNullOrEmpty($UI_Main_Download_Match_Version_Select.Text)) {
			$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError -f $($lang.NoSetLabel))"
			return
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断：2. 前缀不能带空格
		#>
		if ($UI_Main_Download_Match_Version_Select.Text -match '^\s') {
			$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError -f $($lang.ISO9660TipsErrorSpace))"
			return
		}

		<#
			.Judgment: 3. Suffix cannot contain spaces
			.判断：3. 后缀不能带空格
		#>
		if ($UI_Main_Download_Match_Version_Select.Text -match '\s$') {
			$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError -f $($lang.ISO9660TipsErrorSpace))"
			return
		}

		<#
			.Judgment: 4. The suffix cannot contain multiple spaces
			.判断：4. 后缀不能带多空格
		#>
		if ($UI_Main_Download_Match_Version_Select.Text -match '\s{2,}$') {
			$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError -f $($lang.ISO9660TipsErrorSpace))"
			return
		}

		<#
			.Judgment: 5. There can be no two spaces in between
			.判断：5. 中间不能含有二个空格
		#>
		if ($UI_Main_Download_Match_Version_Select.Text -match '\s{1,}') {
			$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError -f $($lang.ISO9660TipsErrorSpace))"
			return
		}

		<#
			.Judgment: 6. Cannot contain: A-Z
			.判断：6. 不能包含：字母 A-Z
		#>
		if ($UI_Main_Download_Match_Version_Select.Text -match '[A-Za-z]+') {
			$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError -f $($lang.ISO9660TipsErrorAZ))"
			return
		}

		<#
			.Judgment: 7. Cannot contain: \\ /: *? "" <> |
			.判断：7, 不能包含：\\ / : * ? "" < > |
		#>
		if ($UI_Main_Download_Match_Version_Select.Text -match '[~#$@!%&*{}<>?/|+".]') {
			$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError -f $($lang.ISO9660TipsErrorOther))"
			return
		}

		<#
			.Judgment: 8. Can't be less than 5 characters
			.判断：8. 不能小于 5 字符
		#>
		if ($UI_Main_Download_Match_Version_Select.Text.length -lt 5) {
			$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError -f $($lang.ISOShortError -f "5"))"
			return
		}

		<#
			.Judgment: 9. No more than 16 characters
			.判断：9. 不能大于 16 字符
		#>
		if ($UI_Main_Download_Match_Version_Select.Text.length -gt 16) {
			$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError -f $($lang.ISOLengthError -f "16"))"
			return
		}

		$UI_Main_Download_Match_Version_Menu.Visible = 0

		<#
			.Verify that the custom ISO is saved to the directory name by default, ends, and saves the new path
			.验证自定义 ISO 默认保存到目录名，结束并保存新路径
		#>
		Save_Dynamic -regkey "LXPs" -name "LXPsSelect" -value $UI_Main_Download_Match_Version_Select.Text -String
		$UI_Main_Download_Match_Filter_Results.Text = $UI_Main_Download_Match_Version_Select.Text

		LXPs_Refresh_Sources_To_Event
	}
	$UI_Main_Download_Match_Version_Canel_Click = {
		$UI_Main_Download_Match_Version.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) { $_.Checked = $false }
		}
		$UI_Main_Download_Match_Version_Menu.Visible = 0
	}
	$UI_Main_Download_Match_Filter_Setting_Click = {
		$UI_Main_Download_Match_Version.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) { $_.Checked = $false }
		}
		$UI_Main_Download_Match_Version_Error.Text = ""
		$UI_Main_Download_Match_Version_Menu.Visible = 1
	}

	<#
		.Event: Download all
		.事件：下载全部
	#>
	$UI_Main_Download_Click = {
		if ($UI_Main_Download.Checked) {
			Save_Dynamic -regkey "LXPs" -name "IsDownloadAll" -value "True" -String
			$UI_Main_Download_Menu.Enabled = $False
			$UI_Main_Download_Match_Version.Enabled = $False
			$UI_Main_Sync_Some_Location.Enabled = $False
			$UI_Main_Sync_Some_Location_Tips.Enabled = $False
		} else {
			Save_Dynamic -regkey "LXPs" -name "IsDownloadAll" -value "False" -String
			$UI_Main_Download_Menu.Enabled = $True
			$UI_Main_Download_Match_Version.Enabled = $True
			$UI_Main_Sync_Some_Location.Enabled = $True
			$UI_Main_Sync_Some_Location_Tips.Enabled = $True
		}

		LXPs_Refresh_Sources_To_Event
	}

	<#
		.Event: Matched undownloaded
		.事件：匹配未下载项
	#>
	$UI_Main_Match_No_Select_Item_Click = {
		$InitalReportSources = $UI_Main_Save_To.Text
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
			$UI_Main_Available_Languages_Select.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($($QueueLXPsMatchNoItemSelect) -contains $_.Tag) {
						$_.Checked = $True
					} else {
						$_.Checked = $False
					}
				}
			}
		} else {
			$UI_Main_Error.Text = $lang.MatchDownloadNoNewitem
		}
	}

	<#
		.Event: Generate a License .xml
		.事件：生成 License.xml
	#>
	$UI_Main_Save_To_License_Click = {
		$UI_Main.Hide()
		LXPs_Download_Licence_Process -Path $UI_Main_Save_To.Text
		$UI_Main.Close()
	}

	<#
		.Event: Generate a report
		.事件：生成报告
	#>
	$UI_Main_Mask_Report_OK_Click = {
		$MarkVerifyWrite = $False
		$InitalReportSources = $UI_Main_Mask_Report_Sources_Path.Text
		if (-not [string]::IsNullOrEmpty($InitalReportSources)) {
			if (Test-Path -Path "$($InitalReportSources)" -PathType Container) {
				$MarkVerifyWrite = $True
			}
		}

		if ($MarkVerifyWrite) {
			$UI_Main.Hide()
			LXPs_Download_Report_Process -Path $UI_Main_Mask_Report_Sources_Path.Text -SaveTo $UI_Main_Mask_Report_Save_To.Text
			$UI_Main.Close()
		} else {
			$UI_Main_Mask_Report_Error.Text = $($lang.Inoperable)
		}
	}
	
	Function LXPs_Refresh_Sources_To_Status
	{
		$UI_Main_Mask_Report_Error.Text = ""
		$RandomGuid = [guid]::NewGuid()
		$InitalReportSources = $UI_Main_Mask_Report_Sources_Path.Text
		$DesktopOldpath = [Environment]::GetFolderPath("Desktop")

		if (Test-Path -Path "$($InitalReportSources)" -PathType Container) {
			if (Test_Available_Disk -Path $InitalReportSources) {
				$UI_Main_Mask_Report_Sources_Open_Folder.Enabled = $True
				$UI_Main_Mask_Report_Sources_Paste.Enabled = $True
				$UI_Main_Mask_Report_Save_To.Text = "$($InitalReportSources)\Report.$($RandomGuid).csv"
			} else {
				$UI_Main_Mask_Report_Sources_Open_Folder.Enabled = $False
				$UI_Main_Mask_Report_Sources_Paste.Enabled = $False
				$UI_Main_Mask_Report_Save_To.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
			}
		} else {
			$UI_Main_Mask_Report_Sources_Open_Folder.Enabled = $False
			$UI_Main_Mask_Report_Sources_Paste.Enabled = $False
			$UI_Main_Mask_Report_Save_To.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
		}
	}
	
	$UI_Main_Report_Click = {
		$UI_Main_Mask_Report_Error.Text = ""
		$InitalReportSources = $UI_Main_Save_To.Text

		$RandomGuid = [guid]::NewGuid()
		$UI_Main_Mask_Report_Error.Text = ""

		<#
			.Determine whether the save to is empty, if not, randomly generate a new save path
			.判断保存到是否为空，如果不为空则随机生成新的保存路径
		#>
		if ([string]::IsNullOrEmpty($InitalReportSources)) {
			$UI_Main_Mask_Report_Save_To.Text = "$($InitalReportSources)\Report.$($RandomGuid).csv"
		} else {
			$UI_Main_Mask_Report_Sources_Path.Text = $InitalReportSources
		}

		LXPs_Refresh_Sources_To_Status
		$UI_Main_Mask_Report.visible = $True
	}
	$UI_Main_Mask_Report_Canel_Click = {
		$UI_Main_Mask_Report.visible = $False
	}

	$UI_Main_Mask_Report_Select_Folder_Click = {
		$RandomGuid = [guid]::NewGuid()

		$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{ 
			FileName = "Report.$($RandomGuid).csv"
			Filter   = "Export CSV Files (*.CSV;)|*.csv;"
		}

		if ($FileBrowser.ShowDialog() -eq "OK") {
			$UI_Main_Mask_Report_Save_To.Text = $FileBrowser.FileName
		} else {
			$UI_Main_Mask_Report_Error.Text = $($lang.UserCancel)
		}
	}

	<#
		.Event: Copy path
		.事件：复制路径
	#>
	$UI_Main_Mask_Report_Paste_Click = {
		if (-not [string]::IsNullOrEmpty($UI_Main_Mask_Report_Save_To.Text)) {
			Set-Clipboard -Value $UI_Main_Mask_Report_Save_To.Text
		}
	}

	$UI_Main_Mask_Report_Sources_Select_Folder_Click = {
		$RandomGuid = [guid]::NewGuid()
		$DesktopOldpath = [Environment]::GetFolderPath("Desktop")
		$UI_Main_Mask_Report_Error.Text = ""

		$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
			RootFolder = "MyComputer"
		}

		if ($FolderBrowser.ShowDialog() -eq "OK") {
			$InitalReportSources = (Join_MainFolder -Path $FolderBrowser.SelectedPath)
			$UI_Main_Mask_Report_Sources_Path.Text = $InitalReportSources
			
			if (Test-Path -Path "$($InitalReportSources)" -PathType Container) {
				if (Test_Available_Disk -Path $InitalReportSources) {
					$UI_Main_Mask_Report_Save_To.Text = "$($InitalReportSources)Report.$($RandomGuid).csv"
				} else {
					$UI_Main_Mask_Report_Save_To.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
				}

				LXPs_Refresh_Sources_To_Status
			} else {
				$UI_Main_Mask_Report_Save_To.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
			}
		} else {
			$UI_Main_Mask_Report_Error.Text = "$($lang.UserCancel)"
		}
	}
	<#
		.Event: Opens the directory, Report
		.事件：打开目录，报告
	#>
	$UI_Main_Mask_Report_Sources_Open_Folder_Click = {
		if (-not [string]::IsNullOrEmpty($UI_Main_Mask_Report_Sources_Path.Text)) {
			if (Test-Path $UI_Main_Mask_Report_Sources_Path.Text -PathType Container) {
				Start-Process $UI_Main_Mask_Report_Sources_Path.Text
			}
		}
	}
	<#
		.Event: Copy path, Report
		.事件：复制路径，报告
	#>
	$UI_Main_Mask_Report_Sources_Paste_Click = {
		if (-not [string]::IsNullOrEmpty($UI_Main_Mask_Report_Sources_Path.Text)) {
			Set-Clipboard -Value $UI_Main_Mask_Report_Sources_Path.Text
		}
	}
	<#
		.Event: The synchronization source location matches the download to location, Report
		.事件：同步来源位置与下载到位置一致，报告
	#>
	$UI_Main_Mask_Report_Sources_Sync_Click = {
		$RandomGuid = [guid]::NewGuid()
		$DesktopOldpath = [Environment]::GetFolderPath("Desktop")
		$UI_Main_Mask_Report_Error.Text = ""
		$InitalReportSources = (Join_MainFolder -Path $UI_Main_Save_To.Text)

		if (-not [string]::IsNullOrEmpty($InitalReportSources)) {
			$UI_Main_Mask_Report_Sources_Path.Text = $InitalReportSources

			if (Test-Path -Path "$($InitalReportSources)" -PathType Container) {
				if (Test_Available_Disk -Path $InitalReportSources) {
					$UI_Main_Mask_Report_Save_To.Text = "$($InitalReportSources)Report.$($RandomGuid).csv"
				} else {
					$UI_Main_Mask_Report_Save_To.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
				}
			} else {
				$UI_Main_Mask_Report_Save_To.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
			}
		}

		LXPs_Refresh_Sources_To_Status
	}

	<#
		.Event: Save directory location synchronized with filtered version number
		.事件：保存目录位置与筛选版本号同步
	#>
	$UI_Main_Sync_Some_Location_Click = {
		if ($UI_Main_Sync_Some_Location.Checked) {
			Save_Dynamic -regkey "LXPs" -name "IsSyncSaveTo" -value "True" -String
		} else {
			Save_Dynamic -regkey "LXPs" -name "IsSyncSaveTo" -value "False" -String
		}

		LXPs_Refresh_Sources_To_Event
	}

	<#
		.Event: The custom selection is saved to the directory
		.事件：自定义选择保存到目录
	#>
	$UI_Main_Select_Folder_Click = {
		$UI_Main_Error.Text = ""

		$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
			RootFolder   = "MyComputer"
		}

		if ($FolderBrowser.ShowDialog() -eq "OK") {
			$InitalReportSources = (Join_MainFolder -Path $FolderBrowser.SelectedPath)
			$UI_Main_Mask_Report_Sources_Path.Text = $InitalReportSources
			
			if (Test-Path -Path "$($InitalReportSources)" -PathType Container) {
				if (Test_Available_Disk -Path $InitalReportSources) {
					$UI_Main_Save_To.Text = $InitalReportSources
					$Script:InitalSaveToPath = $InitalReportSources

					<#
						.After the replacement is successful, turn off the Sync Check Box that matches the download location from location
						.更换成功后，关闭同步来源位置与下载位置一致，复选框
					#>
					$UI_Main_Sync_Some_Location.Checked = $False
				} else {
					$UI_Main_Error.Text = "$($lang.Inoperable)"
				}
			} else {
				$UI_Main_Error.Text = "$($lang.Inoperable)"
			}
		} else {
			$UI_Main_Error.Text = "$($lang.UserCancel)"
		}

		LXPs_Refresh_Sources_To_Event
	}

	<#
		.Event: Opens the directory
		.事件：打开目录
	#>
	$UI_Main_Save_To_Open_Folder_Click = {
		if (-not [string]::IsNullOrEmpty($UI_Main_Save_To.Text)) {
			if (Test-Path $UI_Main_Save_To.Text -PathType Container) {
				Start-Process $UI_Main_Save_To.Text
			}
		}
	}

	<#
		.Event: Copy path
		.事件：复制路径
	#>
	$UI_Main_Save_To_Paste_Click = {
		if (-not [string]::IsNullOrEmpty($UI_Main_Save_To.Text)) {
			Set-Clipboard -Value $UI_Main_Save_To.Text
		}
	}

	$UI_Main_Tips_Mask_DoNot_Click = {
		if ($UI_Main_Tips_Mask_DoNot.Checked) {
			Save_Dynamic -regkey "LXPs" -name "LXPsTipsWarning" -value "True" -String
		} else {
			Save_Dynamic -regkey "LXPs" -name "LXPsTipsWarning" -value "False" -String
		}
	}
	$UI_Main_Tips_Mask_View_Click = { $UI_Main_Tips_Mask.Visible = 1 }
	$UI_Main_Tips_Mask_Canel_Click = { $UI_Main_Tips_Mask.Visible = 0 }

	<#
		.Event: canceled
		.事件：取消
	#>
	$UI_Main_Canel_Click = {
		Write-Host "   $($lang.UserCancel)" -ForegroundColor Red
		$Script:Queue_Language_Download_Select = @()
		$UI_Main.Close()
	}

	<#
		.Event: Ok
		.事件：确认
	#>
	$UI_Main_OK_Click = {
		$Script:Queue_Language_Download_Select = @()

		$UI_Main_Available_Languages_Select.Controls | ForEach-Object {
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
			$UI_Main_Error.Text = "$($lang.SelectFromError -f $($lang.Not_Select))"
			return
		}

		if ([string]::IsNullOrEmpty($UI_Main_Download_Match_Filter_Results.Text)) {
			$UI_Main_Error.Text = "$($lang.SelectFromError -f $($langr.OSVersion))"
			return
		}

		$UI_Main.Hide()
		$Script:Version = $UI_Main_Download_Match_Filter_Results.Text
		$Script:IsDownload = $False
		$Script:IsRename = $False
		$Script:IsLicence = $False

		if ($UI_Main_Download.Checked) {
			$Script:IsDownload = $True
		} else {
			if ($UI_Main_Download_Rename.Checked) {
				$Script:IsRename = $True
			}

			if ($UI_Main_Download_Licence.Checked) {
				$Script:IsLicence = $True
			}
		}

		LXPs_Download_Process
		$UI_Main.Close()
	}
	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = $lang.LXPs
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
	}

	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 665
		Width          = 530
		Location       = "10,10"
		Padding        = "10,0,0,0"
		BorderStyle    = 0
		autoScroll     = $True
	}

	<#
		.可用语言
	#>
	$UI_Main_Available_Languages_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 340
		Text           = $lang.AvailableLanguages
	}
	$UI_Main_Available_Languages_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 225
		Width          = 495
		Padding        = "18,0,0,0"
		margin         = "0,0,0,20"
		autoSizeMode   = 0
		autoScroll     = $True
	}
	$UI_Main_Languages_Detailed_View = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 28
		Width          = 495
		Padding        = "16,0,0,0"
		Text           = $lang.Detailed
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Languages_Detailed_View_Click
	}

	<#
		.Mask: Displays rule details
		.蒙板：显示规则详细信息
	#>
	$UI_Main_Languages_Detailed_View_Mask = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 923
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = 0
	}
	$UI_Main_Languages_Detailed_View_Mask_Results = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 580
		Width          = 880
		BorderStyle    = 0
		Location       = "15,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	<#
		.Event, hide show rule details
		.事件，隐藏显示规则详细
	#>
	$UI_Main_Languages_Detailed_View_Mask_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		add_Click      = $UI_Main_Languages_Detailed_View_Mask_Canel_Click
		Text           = $lang.Cancel
	}

	<#
		.Group: Select a known version number
		.组：选择已知版本号
	#>
	$UI_Main_Download_Match_Version_Menu = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 923
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = 0
	}
	$UI_Main_Download_Match_Version_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 240
		Location       = "15,10"
		Text           = $lang.OSVersion
	}
	$UI_Main_Download_Match_Version = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 640
		Width          = 340
		Padding        = "8,0,8,0"
		Location       = "15,35"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
	}

	$UI_Main_Download_Match_Version_Select_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 25
		Width          = 400
		Location       = "405,15"
		Text           = $lang.LXPsFilter
	}
	$UI_Main_Download_Match_Version_Select = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 22
		Width          = 385
		Location       = "426,45"
		Text           = ""
	}
	$UI_Main_Download_Match_Version_Select_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 150
		Width          = 385
		Location       = "425,80"
		Text           = $lang.LXPsDownloadTips
	}

	$UI_Main_Download_Match_Version_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "405,565"
		Height         = 22
		Width          = 445
		Text           = ""
	}
	$UI_Main_Download_Match_Version_OK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		add_Click      = $UI_Main_Download_Match_Version_OK_Click
		Text           = $lang.OK
	}
	$UI_Main_Download_Match_Version_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		add_Click      = $UI_Main_Download_Match_Version_Canel_Click
		Text           = $lang.Cancel
	}

	<#
		.Download all
		.下载全部
	#>
	$UI_Main_Download = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 25
		Width          = 385
		margin         = "0,25,0,0"
		Text           = $lang.DownloadAll
		Checked        = $True
		add_Click      = $UI_Main_Download_Click
	}

	$UI_Main_Download_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Padding        = "16,0,0,0"
		margin         = "0,0,0,30"
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
	}
	$UI_Main_Download_Match_Filter = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 395
		Text           = $lang.LXPsFilter
	}
	$UI_Main_Download_Match_Filter_Results = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 395
		Padding        = "16,0,0,0"
		Text           = ""
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Download_Match_Filter_Setting_Click
	}
	$UI_Main_Download_Match_Filter_Setting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 395
		Padding        = "16,0,0,0"
		Text           = $lang.OSVersion
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Download_Match_Filter_Setting_Click
	}
	$UI_Main_Download_Match_Filter_Setting_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "16,0,15,5"
		Text           = $lang.LXPsDownloadTips
	}

	$UI_Main_Download_Rename = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 25
		Width          = 385
		margin         = "22,20,0,0"
		Text           = $lang.LXPsRename
		Checked        = $True
		add_Click      = $UI_Main_Download_Click
	}
	$UI_Main_Download_Rename_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "36,0,15,0"
		Text           = $lang.LXPsRenameTips
	}

	$UI_Main_Download_Licence = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 25
		Width          = 385
		margin         = "22,20,0,0"
		Text           = $lang.LicenseCreate
		Checked        = $True
		add_Click      = $UI_Main_Download_Click
	}
	$UI_Main_Download_Licence_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "36,0,15,0"
		Text           = $lang.LicenseCreateTips
	}

	<#
		.Save to
		.保存到
	#>
	$UI_Main_Save_To_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 25
		Width          = 455
		Text           = $lang.SaveTo
	}
	$UI_Main_Save_To = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 22
		Width          = 435
		margin         = "24,5,0,15"
		ReadOnly       = $True
		Text           = ""
	}
	$UI_Main_Select_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Select_Folder_Click
	}
	$UI_Main_Select_Folder_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "36,0,15,0"
		margin         = "0,0,0,15"
		Text           = $lang.SelectFolderTips
	}

	$UI_Main_Sync_Some_Location = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 25
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.SaveToSync
		add_Click      = $UI_Main_Sync_Some_Location_Click
	}
	$UI_Main_Sync_Some_Location_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "36,0,15,0"
		margin         = "0,0,0,15"
		Text           = $lang.SaveToSyncTips
	}

	<#
		.License
		.证书
	#>
	$UI_Main_Save_To_License = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.LicenseCreate
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Save_To_License_Click
	}
	$UI_Main_Save_To_License_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "36,0,15,0"
		margin         = "0,0,0,15"
		Text           = $lang.LicenseCreateTips
	}

	$UI_Main_Save_To_Open_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Save_To_Open_Folder_Click
	}
	$UI_Main_Save_To_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Save_To_Paste_Click
	}

	<#
		.Matches undownloaded items
		.匹配未下载项
	#>
	$UI_Main_Match_No_Select_Item = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.MatchNoDownloadItem
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Match_No_Select_Item_Click
	}

	<#
		.Displays the Change Locale mask
		.显示更改区域设置蒙层
	#>
	$UI_Main_Mask_Report = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 1025
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = 0
	}
	$UI_Main_Mask_Report_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 665
		Width          = 530
		Padding        = "8,0,8,0"
		Location       = "15,10"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
	}
	$UI_Main_Mask_Report_Sources_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 480
		Text           = $lang.AdvAppsDetailed
	}
	$UI_Main_Mask_Report_Sources_Name_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "16,0,0,0"
		margin         = "0,0,0,20"
		Text           = $lang.AdvAppsDetailedTips
	}

	$UI_Main_Mask_Report_Sources_Path_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 480
		Text           = $lang.ProcessSources
	}
	$UI_Main_Mask_Report_Sources_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 22
		Width          = 450
		margin         = "18,5,0,15"
		Text           = ""
		ReadOnly       = $True
	}
	$UI_Main_Mask_Report_Sources_Select_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Mask_Report_Sources_Select_Folder_Click
	}
	$UI_Main_Mask_Report_Sources_Open_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Mask_Report_Sources_Open_Folder_Click
	}
	$UI_Main_Mask_Report_Sources_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Mask_Report_Sources_Paste_Click
	}
	$UI_Main_Mask_Report_Sources_Sync = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.SaveToSync
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Mask_Report_Sources_Sync_Click
	}

	<#
		.The report is saved to
		.报告保存到
	#>
	$UI_Main_Mask_Report_Save_To_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 480
		margin         = "0,30,0,0"
		Text           = $lang.SaveTo
	}
	$UI_Main_Mask_Report_Save_To = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 22
		Width          = 450
		margin         = "20,5,0,15"
		Text           = ""
		ReadOnly       = $True
	}
	$UI_Main_Mask_Report_Select_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Mask_Report_Select_Folder_Click
	}
	$UI_Main_Mask_Report_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Mask_Report_Paste_Click
	}
	$UI_Main_Mask_Report_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "620,565"
		Height         = 22
		Width          = 280
		Text           = ""
	}
	$UI_Main_Mask_Report_OK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		add_Click      = $UI_Main_Mask_Report_OK_Click
		Text           = $lang.OK
	}
	$UI_Main_Mask_Report_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		add_Click      = $UI_Main_Mask_Report_Canel_Click
		Text           = $lang.Cancel
	}

	<#
		.Displays a hint mask
		.显示提示蒙层
	#>
	$UI_Main_Tips_Mask = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 898
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = 0
	}
	$UI_Main_Tips_Mask_Results = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 580
		Width          = 830
		BorderStyle    = 0
		Location       = "15,15"
		Text           = $lang.LXPsGetSNTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_Tips_Mask_DoNot = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "20,635"
		Height         = 25
		Width          = 440
		Text           = $lang.LXPsAddDelTips
		add_Click      = $UI_Main_Tips_Mask_DoNot_Click
	}
	$UI_Main_Tips_Mask_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		add_Click      = $UI_Main_Tips_Mask_Canel_Click
		Text           = $lang.Cancel
	}

	$UI_Main_Report    = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,10"
		Height         = 36
		Width          = 280
		add_Click      = $UI_Main_Report_Click
		Text           = $lang.AdvAppsDetailed
	}
	$UI_Main_Tips_Mask_View = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 22
		Width          = 280
		Text           = $lang.LXPsAddDelTipsView
		Location       = "620,520"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Tips_Mask_View_Click
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "620,568"
		Height         = 22
		Width          = 280
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		add_Click      = $UI_Main_OK_Click
		Text           = $lang.StartVerify
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		add_Click      = $UI_Main_Canel_Click
		Text           = $lang.Cancel
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Languages_Detailed_View_Mask,
		$UI_Main_Tips_Mask,
		$UI_Main_Mask_Report,
		$UI_Main_Download_Match_Version_Menu,
		$UI_Main_Menu,
		$UI_Main_Report,
		$UI_Main_Tips_Mask_View,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	<#
		.Mask: Displays language details
		.蒙板：显示语言详细信息
	#>
	$UI_Main_Languages_Detailed_View_Mask.controls.AddRange((
		$UI_Main_Languages_Detailed_View_Mask_Results,
		$UI_Main_Languages_Detailed_View_Mask_Canel
	))

	<#
		.You have new tips
		.你有新的提示
	#>
	$UI_Main_Tips_Mask.controls.AddRange((
		$UI_Main_Tips_Mask_Results,
		$UI_Main_Tips_Mask_DoNot,
		$UI_Main_Tips_Mask_Canel
	))

	<#
		.Mask, report
		.蒙板，报告
	#>
	$UI_Main_Mask_Report.controls.AddRange((
		$UI_Main_Mask_Report_Menu,
		$UI_Main_Mask_Report_Error,
		$UI_Main_Mask_Report_OK,
		$UI_Main_Mask_Report_Canel
	))
	$UI_Main_Mask_Report_Menu.controls.AddRange((
		$UI_Main_Mask_Report_Sources_Name,
		$UI_Main_Mask_Report_Sources_Name_Tips,
		$UI_Main_Mask_Report_Sources_Path_Name,
		$UI_Main_Mask_Report_Sources_Path,
		$UI_Main_Mask_Report_Sources_Select_Folder,
		$UI_Main_Mask_Report_Sources_Open_Folder,
		$UI_Main_Mask_Report_Sources_Paste,
		$UI_Main_Mask_Report_Sources_Sync,
		$UI_Main_Mask_Report_Save_To_Name,
		$UI_Main_Mask_Report_Save_To,
		$UI_Main_Mask_Report_Select_Folder,
		$UI_Main_Mask_Report_Paste
	))
	$UI_Main_Menu.controls.AddRange((
		<#
			.Available languages
			.可用语言
		#>
		$UI_Main_Available_Languages_Name,
		$UI_Main_Available_Languages_Select,
		$UI_Main_Languages_Detailed_View,

		<#
			.Select Download All
			.选择全部下载
		#>
		$UI_Main_Download,
		$UI_Main_Download_Menu,

		<#
			.Save to
			.保存到
		#>
		$UI_Main_Save_To_Name,
		$UI_Main_Save_To,

		<#
			.Open the catalog
			.打开目录
		#>
		$UI_Main_Save_To_Open_Folder,

		<#
			.Paste
			.粘贴
		#>
		$UI_Main_Save_To_Paste,

		<#
			.Select a directory
			.选择目录
		#>
		$UI_Main_Select_Folder,
		$UI_Main_Select_Folder_Tips,

		<#
			.The synchronization directory is the same as the version number
			.同步目录与版本号相同
		#>
		$UI_Main_Sync_Some_Location,
		$UI_Main_Sync_Some_Location_Tips,

		<#
			.Create a License .xml
			.创建 License.xml
		#>
		$UI_Main_Save_To_License,
		$UI_Main_Save_To_License_Tips,
		$UI_Main_Match_No_Select_Item
	))
	$UI_Main_Download_Menu.controls.AddRange((
		$UI_Main_Download_Match_Filter,
		$UI_Main_Download_Match_Filter_Results,
		$UI_Main_Download_Match_Filter_Setting,
		$UI_Main_Download_Match_Filter_Setting_Tips,
		$UI_Main_Download_Rename,
		$UI_Main_Download_Rename_Tips,
		$UI_Main_Download_Licence,
		$UI_Main_Download_Licence_Tips
	))
	$UI_Main_Download_Match_Version_Menu.controls.AddRange((
		$UI_Main_Download_Match_Version_Name,
		$UI_Main_Download_Match_Version,
		$UI_Main_Download_Match_Version_Select_Name,
		$UI_Main_Download_Match_Version_Select,
		$UI_Main_Download_Match_Version_Select_Tips,
		$UI_Main_Download_Match_Version_Error,
		$UI_Main_Download_Match_Version_OK,
		$UI_Main_Download_Match_Version_Canel
	))

	<#
		.Gets the list of languages and initializes the selection
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
				Text    = "$($Global:AvailableLanguages[$i][2].PadRight(45))$($Global:AvailableLanguages[$i][4])"
				Tag     = $($Global:AvailableLanguages[$i][2])
			}

			if ($SelectLXPsLanguageRemove -eq $Global:AvailableLanguages[$i][2]) {
				$CheckBox.Checked = $True
			} else {
				$CheckBox.Checked = $False
			}

			$UI_Main_Available_Languages_Select.controls.AddRange($CheckBox)
		}

		$UI_Main_Languages_Detailed_View_Mask_Results.Text += "    $($Global:AvailableLanguages[$i][4])`n    https://www.microsoft.com/store/productId/$($Global:AvailableLanguages[$i][6])`n`n"
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "LXPsSelect" -ErrorAction SilentlyContinue) {
		$GetLXPsSelect = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "LXPsSelect" -ErrorAction SilentlyContinue
		$UI_Main_Download_Match_Filter_Results.Text = $GetLXPsSelect
		$UI_Main_Download_Match_Version_Select.Text = $GetLXPsSelect
	} else {
		$UI_Main_Download_Match_Filter_Results.Text = $lang.MatchDownloadNoNewitem
	}

	for ($i=0; $i -lt $Global:OSCodename.Count; $i++) {
		$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
			Height    = 40
			Width     = 310
			Text      = "$($Global:OSCodename[$i][0])`n$($Global:OSCodename[$i][1])"
			Tag       = $($Global:OSCodename[$i][1])
			add_Click = $GUILangChangeSelectVersionClick
		}

		$UI_Main_Download_Match_Version.controls.AddRange($CheckBox)
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "IsSyncSaveTo" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "IsSyncSaveTo" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Sync_Some_Location.Checked = $True
			}
			"False" {
				$UI_Main_Sync_Some_Location.Checked = $False
			}
		}
	} else {
		$UI_Main_Sync_Some_Location.Checked = $True
	}

	$GetCurrentDisk = Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\" -ErrorAction SilentlyContinue
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "IsDownloadAll" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "IsDownloadAll" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Download.Checked = $True
				$UI_Main_Download_Match_Version.Enabled = $False
				$UI_Main_Download_Menu.Enabled = $False
				$UI_Main_Sync_Some_Location.Enabled = $False
				$UI_Main_Sync_Some_Location_Tips.Enabled = $False
			}
			"False" {
				$UI_Main_Download.Checked = $False
				$UI_Main_Download_Match_Version.Enabled = $True
				$UI_Main_Download_Menu.Enabled = $True
				$UI_Main_Sync_Some_Location.Enabled = $True
				$UI_Main_Sync_Some_Location_Tips.Enabled = $True
			}
		}
	} else {
		$UI_Main_Download.Checked = $True
		$UI_Main_Download_Match_Version.Enabled = $False
		$UI_Main_Download_Menu.Enabled = $False
		$UI_Main_Sync_Some_Location.Enabled = $False
		$UI_Main_Sync_Some_Location_Tips.Enabled = $False
	}

	LXPs_Refresh_Sources_To_Event

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "LXPsTipsWarning" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\LXPs" -Name "LXPsTipsWarning" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Tips_Mask.Visible = 0
				$UI_Main_Tips_Mask_DoNot.Checked = $True
			}
			"False" {
				$UI_Main_Tips_Mask.Visible = 1
				$UI_Main_Tips_Mask_DoNot.Checked = $False
			}
		}
	} else {
		$UI_Main_Tips_Mask.Visible = 1
		$UI_Main_Tips_Mask_DoNot.Checked = $False
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$GUIImageSelectFunctionSelClick = {
		$UI_Main_Available_Languages_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) { $_.Checked = $true }
		}
	}
	$GUIImageSelectFunctionAllClearClick = {
		$UI_Main_Available_Languages_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) { $_.Checked = $false }
		}
	}
	$GUIImageSelectFunctionSelectMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIImageSelectFunctionSelectMenu.Items.Add($lang.AllSel).add_Click($GUIImageSelectFunctionSelClick)
	$GUIImageSelectFunctionSelectMenu.Items.Add($lang.AllClear).add_Click($GUIImageSelectFunctionAllClearClick)
	$UI_Main_Available_Languages_Select.ContextMenuStrip = $GUIImageSelectFunctionSelectMenu

	switch ($Global:IsLang) {
		"zh-CN" {
			$UI_Main.Font = New-Object System.Drawing.Font("Microsoft YaHei", 9, [System.Drawing.FontStyle]::Regular)
		}
		Default {
			$UI_Main.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
		}
	}

	$UI_Main.FormBorderStyle = 'Fixed3D'
	$UI_Main.ShowDialog() | Out-Null
}

Function LXPs_Download_Report_Process
{
	param
	(
		$Path,
		$SaveTo
	)

	if (Test-Path -Path "$($Path)\LocalExperiencePack" -PathType Container) {
		$FolderDirect = (Join_MainFolder -Path "$($Path)\LocalExperiencePack")
	} else {
		$FolderDirect = (Join_MainFolder -Path $Path)
	}

	write-host "`n   $($lang.AdvAppsDetailed)"
	$QueueSelectLXPsReport = @()
	$RandomGuid = [guid]::NewGuid()
	$ISOTestFolderMain = "$($env:userprofile)\AppData\Local\Temp\$($RandomGuid)"
	Check_Folder -chkpath $ISOTestFolderMain

	for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
		$TempNewFileFolderPath = "$($ISOTestFolderMain)\$($Global:AvailableLanguages[$i][2])"
		$TempNewFileFullPath = "$($FolderDirect)$($Global:AvailableLanguages[$i][2])\LanguageExperiencePack.$($Global:AvailableLanguages[$i][2]).Neutral.appx"

		if (Test-Path -Path $TempNewFileFullPath -PathType Leaf) {
			Check_Folder -chkpath $TempNewFileFolderPath

			Add-Type -AssemblyName System.IO.Compression.FileSystem
			$zipFile = [IO.Compression.ZipFile]::OpenRead($TempNewFileFullPath)
			$zipFile.Entries | where { $_.Name -like 'AppxManifest.xml' } | foreach {
				[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$($TempNewFileFolderPath)\$($_.Name)", $true)
			}
			$zipFile.Dispose()

			if (Test-Path -Path "$($TempNewFileFolderPath)\AppxManifest.xml" -PathType Leaf) {
				[xml]$xml = Get-Content -Path "$($TempNewFileFolderPath)\AppxManifest.xml"

				$QueueSelectLXPsReport += [PSCustomObject]@{
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
			$QueueSelectLXPsReport += [PSCustomObject]@{
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

	$QueueSelectLXPsReport | Export-CSV -NoTypeInformation -Path "$($SaveTo)" -Encoding UTF8

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

	write-host "`n   $($lang.LicenseCreate)"
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
		Write-Host "   $($lang.YesWork)" -ForegroundColor Green

		Write-host "`n   $($lang.ProcessSources)`n   ---------------------------------------------------"
		write-host "   $($Path)"

		Write-Host "`n   $($lang.AddSources)`n   ---------------------------------------------------"
		foreach ($item in $QueueLXPsLicenceSelect) {
			Write-Host "   $($item.Language)".PadRight(28) -NoNewline
			write-host " $($item.FileName)"
		}

		Write-Host "`n   $($lang.AddQueue)`n   ---------------------------------------------------"
		foreach ($item in $QueueLXPsLicenceSelect) {
			$TempNewFileFullPath = "$($item.OrgPath)\$($item.FileName)"

			if (Test-Path -Path $TempNewFileFullPath -PathType Leaf) {
				write-host "   $($item.Language)".PadRight(28) -NoNewline
				Remove-Item -Path "$($item.OrgPath)\License.xml" -ErrorAction SilentlyContinue

				Add-Type -AssemblyName System.IO.Compression.FileSystem
				$zipFile = [IO.Compression.ZipFile]::OpenRead($TempNewFileFullPath)
				$zipFile.Entries | where { $_.Name -like 'License.xml' } | foreach {
					[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$($item.OrgPath)\$($_.Name)", $true)
				}
				$zipFile.Dispose()

				if (Test-Path -Path "$($item.OrgPath)\License.xml" -PathType Leaf) {
					Write-Host "   $($lang.Done)" -ForegroundColor Green
				} else {
					Write-Host "   $($lang.Failed)" -ForegroundColor Red
				}
			}
		}
	} else {
		Write-Host "   $($lang.NoWork)" -ForegroundColor Red
	}
}

Function LXPs_Download_Process
{
	if ($Script:Queue_Language_Download_Select.Count -gt 0) {
		Write-Host "   $($lang.YesWork)" -ForegroundColor Green

		Write-Host "`n   $($lang.AddSources)`n   ---------------------------------------------------"
		foreach ($item in $Script:Queue_Language_Download_Select) {
			write-host "   $($item)"
		}

		Write-host "`n   $($lang.ProcessSources)`n   ---------------------------------------------------"
		for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
			if (($Script:Queue_Language_Download_Select) -Contains $($Global:AvailableLanguages[$i][2])) {
				$NewFolder = "$($PSScriptRoot)\..\..\..\..\Download\$($Script:Version)\LocalExperiencePack\$($Global:AvailableLanguages[$i][2])"
				Check_Folder -chkpath $NewFolder
				$NewFolder = Convert-Path -Path $NewFolder -ErrorAction SilentlyContinue

				write-host "   $($Global:AvailableLanguages[$i][2].PadRight(45))$($Global:AvailableLanguages[$i][4])"
				write-host "   $($lang.SaveTo)"
				Write-host "   $($NewFolder)"
				if ($Script:IsDownload) {
					LXPs_URL_Download_Process -NewLang $Global:AvailableLanguages[$i][2] -StoreURL $Global:AvailableLanguages[$i][6] -SaveTo $NewFolder
				} else {
					$NewFilename = "LanguageExperiencePack.$($Global:AvailableLanguages[$i][2]).Neutral.appx"
					write-host "   $($NewFilename)" -ForegroundColor Green

					if (Test-Path -Path "$($NewFolder)\$($NewFilename)" -PathType Leaf) {
						write-host "   $($lang.AlreadyExists)`n" -ForegroundColor Green
					} else {
						LXPs_URL_Download_Process -NewLang $Global:AvailableLanguages[$i][2] -StoreURL $Global:AvailableLanguages[$i][6] -SaveTo $NewFolder
					}
				}
			}
		}
	} else {
		Write-Host "   $($lang.NoWork)" -ForegroundColor Red
	}
}

function LXPs_URL_Download_Process
{
	param
	(
		$NewLang,
		$StoreURL,
		$SaveTo
	)

	$NewStoreURL = "https://www.microsoft.com/store/productId/$($StoreURL)"

	write-host "   $($lang.UpdateDownloadAddress)$($NewStoreURL)"


	try {
		$wchttp = [System.Net.WebClient]::new()
		$URI = "https://store.rg-adguard.net/api/GetFiles"
		$myParameters = "type=url&url=$($NewStoreURL)"
		#&ring=Retail&lang=sv-SE"

		$wchttp.Headers[[System.Net.HttpRequestHeader]::ContentType]="application/x-www-form-urlencoded"
		$HtmlResult = $wchttp.UploadString($URI, $myParameters)
		$Start = $HtmlResult.IndexOf("<p>The links were successfully received from the Microsoft Store server.</p>")
		#write-host $start
	} catch {
		write-host "   $($lang.DownloadFailed)" -ForegroundColor Red
		return
	}

	if ($Start -eq -1) {
		write-host "   $($lang.Get_Link_Failed)"
		return
	}
	$TableEnd=($HtmlResult.LastIndexOf("</table>")+8)

	$SemiCleaned=$HtmlResult.Substring($start,$TableEnd-$start)

	#https://stackoverflow.com/questions/46307976/unable-to-use-ihtmldocument2
	$newHtml = New-Object -ComObject "HTMLFile"
	try {
		# This works in PowerShell with Office installed
		$newHtml.IHTMLDocument2_write($SemiCleaned)
	} catch {
		# This works when Office is not installed    
		$src = [System.Text.Encoding]::Unicode.GetBytes($SemiCleaned)
		$newHtml.write($src)
	}

	$ToDownload = $newHtml.getElementsByTagName("a") | Select-Object textContent, href

	$LastFrontSlash = $NewStoreURL.LastIndexOf("/")
	$ProductID = $NewStoreURL.Substring($LastFrontSlash+1,$NewStoreURL.Length-$LastFrontSlash-1)

	# OldRegEx   Failed when the %tmp% started with a lowercase char
	#if ([regex]::IsMatch("$SaveTo\$ProductID","([,!@?#$%^&*()\[\]]+|\\\.\.|\\\\\.|\.\.\\\|\.\\\|\.\.\/|\.\/|\/\.\.|\/\.|;|(?<![A-Z]):)|^\w+:(\w|.*:)"))

	if ([regex]::IsMatch("$SaveTo","([,!@?#$%^&*()\[\]]+|\\\.\.|\\\\\.|\.\.\\\|\.\\\|\.\.\/|\.\/|\/\.\.|\/\.|;|(?<![A-Za-z]):)|^\w+:(\w|.*:)")) {
		write-host "Invalid characters in path"$SaveTo""
		return
	}

	Foreach ($Download in $ToDownload)
	{
		if ($Script:IsDownload) {
			Write-host "   $($lang.DownloadNow)"
			Write-host "   $($Download.textContent)" -ForegroundColor Green

			if (Test-Path -Path "$($SaveTo)\$($Download.textContent)" -PathType Leaf) {
				write-host "   $($lang.AlreadyExists)`n" -ForegroundColor Green
			} else {
				$wchttp.DownloadFile($Download.href, "$($SaveTo)\$($Download.textContent)")

				if (Test-Path -Path "$($SaveTo)\$($Download.textContent)" -PathType Leaf) {
					write-host "   $($lang.Done)`n" -ForegroundColor Green
				} else {
					write-host "   $($lang.DownloadFailed)`n" -ForegroundColor Red
				}
			}
		} else {
			if ($Download.textContent -like "*$($Script:Version)*.appx") {
				Write-host "   $($lang.DownloadNow)`n   $($Download.textContent)"
				try {
					$wchttp.DownloadFile($Download.href, "$($SaveTo)\$($Download.textContent)")
				} catch {
					write-host "   $($lang.DownloadFailed)" -ForegroundColor Red
					return
				}

				if (Test-Path -Path "$($SaveTo)\$($Download.textContent)" -PathType Leaf) {
					Write-Host "   $($lang.Done)" -ForegroundColor Green

					<#
						.Renaming
						.改名
					#>
					write-host "`n   $($lang.LXPsRename)"
					if ($Script:IsRename) {
						write-host "   $($lang.UpdateAvailable)" -ForegroundColor Green
						write-host "   LanguageExperiencePack.$($NewLang).Neutral.appx"

						Rename-Item -Path "$($SaveTo)\$($Download.textContent)" -NewName "$($SaveTo)\LanguageExperiencePack.$($NewLang).Neutral.appx" -ErrorAction SilentlyContinue

						if (Test-Path -Path "$($SaveTo)\LanguageExperiencePack.$($NewLang).Neutral.appx" -PathType Leaf) {
							Write-Host "   $($lang.Done)" -ForegroundColor Green
						} else {
							Write-Host "   $($lang.Failed)" -ForegroundColor Red
						}
					} else {
						write-host "   $($lang.UpdateUnavailable)" -ForegroundColor Red
					}

					<#
						.License
						.证书
					#>
					write-host "`n   $($lang.LicenseCreate)"
					if ($Script:IsLicence) {
						$TempNewFileFullPath = "$($SaveTo)\LanguageExperiencePack.$($NewLang).Neutral.appx"

						write-host "   $($lang.UpdateAvailable)" -ForegroundColor Green
						Remove-Item "$($SaveTo)\License.xml" -ErrorAction SilentlyContinue

						if (Test-Path -Path $TempNewFileFullPath -PathType Leaf) {
							write-host "   $($TempNewFileFullPath)" -ForegroundColor Green

							try {
								Add-Type -AssemblyName System.IO.Compression.FileSystem
								$zipFile = [IO.Compression.ZipFile]::OpenRead($TempNewFileFullPath)
								$zipFile.Entries | where { $_.Name -like 'License.xml' } | foreach {
									[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$($SaveTo)\$($_.Name)", $true)
								}
								$zipFile.Dispose()

								if (Test-Path -Path "$($SaveTo)\License.xml" -PathType Leaf) {
									Write-Host "   $($lang.Done)" -ForegroundColor Green
								} else {
									Write-Host "   $($lang.Failed)" -ForegroundColor Red
								}
							} catch {
								Write-Host "   $($lang.Failed)" -ForegroundColor Red
							}
						} else {
							Write-Host "   $($lang.Failed)" -ForegroundColor Red
						}
					} else {
						write-host "   $($lang.UpdateUnavailable)" -ForegroundColor Green
					}
				} else {
					write-host "   $($lang.DownloadFailed)" -ForegroundColor Red
				}
			}
		}
	}
}