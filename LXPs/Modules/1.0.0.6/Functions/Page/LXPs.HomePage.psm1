<#
	.LOGO
#>
Function Logo
{
	param
	(
		$Title
	)

	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$((Get-Module -Name LXPs).Author)'s Solutions | $($Title)"
	Write-Host "`n   Author: $((Get-Module -Name LXPs).Author) ( $((Get-Module -Name LXPs).HelpInfoURI) )

   From: $((Get-Module -Name LXPs).Author)'s Solutions
   buildstring: $((Get-Module -Name LXPs).Version.ToString()).bs_release.2024.04.18`n"
}

<#
	.主界面
	.Main interface
#>
Function Mainpage
{
	Logo -Title $($lang.LXPs)
	Write-Host "   $($lang.Menu)`n   $('-' * 80)"

	write-host "      1   $($lang.ChkUpdate)
      2   $($lang.LXPs)" -ForegroundColor Green

   write-host  "`n      L   $($lang.SwitchLanguage)
      R   $($lang.RefreshModules)`n"

	switch (Read-Host "   $($lang.PleaseChoose)")
	{
		"1" {
			Update
			Modules_Refresh -Function "ToMainpage -wait 2"
		}
		"2" {
			LXPs_Download
			ToMainpage -wait 2
		}
		"l" {
			Language -Reset
			Mainpage
		}
		"r" {
			Modules_Refresh -Function "ToMainpage -wait 2"
		}
		"q" {
			Modules_Import
			Stop-Process $PID
			exit
		}
		default { Mainpage }
	}
}

<#
	.返回到主界面
	.Return to the main interface
#>
Function ToMainpage
{
	param
	(
		[int]$wait
	)

	Write-Host $($lang.ToMsg -f $wait) -ForegroundColor Red
	Start-Sleep -s $wait
	Mainpage
}