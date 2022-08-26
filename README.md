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

The main function:
```
1. Support online upgrade;
2. Modify the script and press R to hot refresh;
3. Implement deployment rules according to the description file;
4. Get the installed language pack and add it automatically;
5. During the adding process, the S and SN versions are automatically judged and added according to the rules;
6. All conditions of "Language Overview" have been followed and met
   https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/languages-overview
```
.\LXPs.ps1 -Force

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
  a、继续使用当前版本请跳过修改，例如当前版本号：1.0.0.0，创建为新的版本号：2.0.0.0，
     打开 \LXPs\Modules\LXPs.psd1，修改“ModuleVersion”为：2.0.0.0

  b、将 Modules\1.0.0.0 目录修改为 2.0.0.0；
     注意：1.0.0.0 请根据每版本号进行更改。

  c、重新指定升级服务器，修改 URL 连接：
     打开：Modules\1.0.0.0\Functions\Base\Update\LXPs.Update.psm1，更改：
     c.1  修改最低要求版本号：$Global:ChkLocalver，如果支持滑行升级可从 1.0.0.0 开始，如果脚本最低要求 2.0.0.0 开始，请更改为 2.0.0.0；
     c.2  重新指定更新服务器：$PreServerList。

</details>


## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/LXPs](https://github.com/ilikeyi/LXPs)
