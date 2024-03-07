Available languages
-
 * United States - English
 * [简体中文 - 中国](https://github.com/ilikeyi/LXPs/blob/main/README.zh-CN.md)

<br>
Windows Local Language Experience Packs (LXPs) Downloader

<br>
<h4><pre>Main functions: </pre></h4>
<ul>1. Support online upgrade, please understand "how to customize the creation of upgrade package";</ul>
<ul>2. Support hot refresh, hot loading, modify the code, press R on the main interface to complete;</ul>
<ul>3. Customizable selection of local language experience packs (LXPs) to be downloaded;</ul>

<ul>4. How to custom create an upgrade package
   <dl>
      <dd>4.1. If you continue to use the current version, please skip the modification, for example, the current version number: 1.0.0.0, create a new version number: 2.0.0.0, Open LXPs\Modules\LXPs.psd1, and modify ModuleVersion to: 2.0.0.0</dd>
      <dd>4.2. Modify the Modules\1.0.0.0 directory to 2.0.0.0; Note: 1.0.0.0 Please change it according to the version number.</dd>
      <dd>4.3. Re-specify the upgrade server and modify the URL connection: 
         <dl>
            <dd>Open it: Modules\1.0.0.0\Functions\Base\Update\LXPs.Update.psm1, Change: </dd>
            <dd>c.1  To modify the minimum required version number: $Global:ChkLocalver, If the glide upgrade is supported starting at 1.0.0.0, if the script requires a minimum of 2.0.0.0, change to 2.0.0.0;</dd>
            <dd>c.2  To reassign the update server: $PreServerList</dd>
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
