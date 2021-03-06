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
	$Host.UI.RawUI.WindowTitle = "$($Global:UniqueID)'s Solutions | $($Title)"
	Write-Host "`n   Author: $($Global:UniqueID) ( $($Global:AuthorURL) )

   From: $($Global:UniqueID)'s Solutions
   buildstring: $((Get-Module -Name LXPs).Version.ToString()).bs_release.220201-1208`n"
}

<#
	.主界面
	.Main interface
#>
Function Mainpage
{
	Logo -Title $($lang.LXPs)
	Write-Host "   $($lang.Menu)`n   ---------------------------------------------------"

	write-host "   1. $($lang.Update)
   2. $($lang.LXPs)" -ForegroundColor Green

   write-host  "`n   L. $($lang.SwitchLanguage)
   R. $($lang.RefreshModules)
   Q. $($lang.Exit)`n"

	$select = Read-Host "   $($lang.Choose)"
	switch ($select)
	{
		"1" {
			Update
			ToMainpage -wait 2
		}
		"2" {
			LXPs_Download
			LXPs_Download_Process
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
			$Global:Quit = $False
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

	if ($Global:QUIT) {
		Write-Host $($lang.ToQuit -f $wait) -ForegroundColor Red
		Start-Sleep -s $wait
		Modules_Import
		$Global:Quit = $False
		exit
	} else {
		Write-Host $($lang.ToMsg -f $wait) -ForegroundColor Red
		Start-Sleep -s $wait
		Mainpage
	}
}