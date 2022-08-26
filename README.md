Available languages
-
 * United States - English
 * 日本 - 日本語
 * 대한민국 - 한국어
 * Россия - Русский
 * 简体中文 - 中国
 * 繁體中文 - 中國


<details>
  <summary>United States - English</summary>
  <h1>Local Experience Packs (LXPs)</h1>

Main functions:
```
1. Support online upgrade, please understand "how to customize the creation of upgrade package";
2. Support hot refresh, hot loading, modify the code, press R on the main interface to complete;
3. Customizable selection of local language experience packs (LXPs) to be downloaded;
4. When downloading:
   a. Downloadable in full;
   b. When downloading, you can filter by version number, and when the download is complete, you can automatically:
      Rename by rule,
      Create a License .xml Certificate;
5. Generate report, generate content: file name, language, language description, minimum version number, highest test version, etc.
```

* How to custom create an upgrade package
```
  a. If you continue to use the current version, please skip the modification, for example, the current version number: 1.0.0.0, create a new version number: 2.0.0.0,
     Open LXPs\Modules\LXPs.psd1, and modify ModuleVersion to: 2.0.0.0

  b. Modify the Modules\1.0.0.0 directory to 2.0.0.0;
     Note: 1.0.0.0 Please change it according to the version number.

  c. Re-specify the upgrade server and modify the URL connection:
     Open it: Modules\1.0.0.0\Functions\Base\Update\LXPs.Update.psm1, Change: 
     c.1  To modify the minimum required version number: $Global:ChkLocalver, If the glide upgrade is supported starting at 1.0.0.0, if the script requires a minimum of 2.0.0.0, change to 2.0.0.0;
     c.2  To reassign the update server: $PreServerList。
```
</details>
 
<details>
  <summary>简体中文 - 中国</summary>
  <h1>本地语言体验包（LXPs）</h1>

主要功能：
```
1、支持在线升级，请了解“如何自定义创建升级包”；
2、支持热刷新，热加载，修改代码后，在主界面按 R 即可完成；
3、可自定义选择待下载的本地语言体验包（LXPs）；
4、下载时：
   a. 可下载全部；
   b. 下载时可按版本号筛选，下载完成后可自动：
      按规则重命名、
      创建 License.xml 证书；
5、生成报告，生成内容：文件名、语言、语言描述、最低版本号、最高测试版本等。
```

* 如何自定义创建升级包
```
  a、继续使用当前版本请跳过修改，例如当前版本号：1.0.0.0，创建为新的版本号：2.0.0.0，
     打开 \LXPs\Modules\LXPs.psd1，修改“ModuleVersion”为：2.0.0.0

  b、将 Modules\1.0.0.0 目录修改为 2.0.0.0；
     注意：1.0.0.0 请根据每版本号进行更改。

  c、重新指定升级服务器，修改 URL 连接：
     打开：Modules\1.0.0.0\Functions\Base\Update\LXPs.Update.psm1，更改：
     c.1  修改最低要求版本号：$Global:ChkLocalver，如果支持滑行升级可从 1.0.0.0 开始，如果脚本最低要求 2.0.0.0 开始，请更改为 2.0.0.0；
     c.2  重新指定更新服务器：$PreServerList。
```
</details>


## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/LXPs](https://github.com/ilikeyi/LXPs)
