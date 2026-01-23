QUICK DOWNLOAD GUIDE
-

Open "Terminal" or "PowerShell ISE" as an administrator, paste the following command line into the "Terminal" dialog box, and press Enter to start running;

<br>

Open "Terminal" or "PowerShell ISE" as an administrator, set PowerShell execution policy: Bypass, PS command line:
```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force
```

<br>

a) Prioritize downloading from Github node
```
curl https://github.com/ilikeyi/LXPs/raw/main/get.ps1 -o get.ps1; .\get.ps1;
wget https://github.com/ilikeyi/LXPs/raw/main/get.ps1 -O get.ps1; .\get.ps1;
iwr https://github.com/ilikeyi/LXPs/raw/main/get.ps1 -out get.ps1; .\get.ps1;
Invoke-WebRequest https://github.com/ilikeyi/LXPs/raw/main/get.ps1 -OutFile get.ps1; .\get.ps1;
```

<br>

b) Prioritize downloading from Yi node
```
curl https://fengyi.tel/lxps -o get.ps1; .\get.ps1;
wget https://fengyi.tel/lxps -O get.ps1; .\get.ps1;
iwr https://fengyi.tel/lxps -out get.ps1; .\get.ps1;
Invoke-WebRequest https://fengyi.tel/lxps -OutFile get.ps1; .\get.ps1;
```

<p>After running the installation script, users can customize the installation interface: specify the download link, specify the installation location, go to: main program, create upgrade package, etc.</p>
<p>You can choose any one: interactive experience installation and custom installation to meet different installation requirements. Multiple different commands are provided during downloading: Curl, Wget, iwr, Invoke-WebRequest. When copying the download link, just copy any one.</p>

<br>

Learn
 * [How to customize the installation script interactive experience](https://github.com/ilikeyi/LXPs/blob/main/_Learn/Get/Get.pdf)

<br>

Available languages
-
 * [简体中文 - 中国](https://github.com/ilikeyi/LXPs/blob/main/_Learn/Readme/README.zh-CN.md)

<br>

<details open>
    <summary>Screenshots</summary>

1. Menu
![Image.Sources](https://github.com/ilikeyi/LXPs/raw/refs/heads/main/_Learn/Screenshots/1.Menu.webp)
</details>

<br>

Windows Local Language Experience Packs (LXPs) Downloader

<h4><pre>Main functions: </pre></h4>
<ul>1. Support online upgrade, please understand "how to customize the creation of upgrade package";</ul>
<ul>2. Support hot refresh, hot loading, modify the code, press R on the main interface to complete;</ul>
<ul>3. Customizable selection of local language experience packs (LXPs) to be downloaded;</ul>

<ul>4. How to custom create an upgrade package
   <dl>
      <dd>4.1. If you continue to use the current version, please skip the modification, for example, the current version number: 1.0.0.0, create a new version number: 2.0.0.0, Open Modules\LXPs.psd1, and modify ModuleVersion to: 2.0.0.0</dd>
      <dd>4.2. Modify the Modules\1.0.0.0 directory to 2.0.0.0; Note: 1.0.0.0 Please change it according to the version number.</dd>
      <dd>4.3. Re-specify the upgrade server and modify the URL connection: 
         <dl>
            <dd>Open it: Modules\LXPs.psd1, Change: </dd>
            <dd>4.3.1  To modify the minimum required version number: MinimumVersion, If the glide upgrade is supported starting at 1.0.0.0, if the script requires a minimum of 2.0.0.0, change to 2.0.0.0;</dd>
            <dd>4.3.2  To reassign the update server: UpdateServer</dd>
         </dl>
      </dd>

<br>
      <dd>4.4. running: .\_Create.Upgrade.Package.ps1</dd>
   </dl>
</ul>

<br>
<ul>5. When downloading:
   <dl>
      <dd>a. Downloadable in full;</dd>
      <dd>b. When downloading, you can filter by version number, and when the download is complete, you can automatically: Rename by rule, Create a License .xml Certificate;</dd>
   </dl>
</ul>
<ul>6. Generate report, generate content: file name, language, language description, minimum version number, highest test version, etc.</ul>
<br>


## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/LXPs](https://github.com/ilikeyi/LXPs)
