快速下载指南
-

以管理员身份打开“Terminal”或“PowerShell ISE”，将以下命令行粘贴到“Terminal”对话框，按回车键（Enter）后开始运行；

<br>

以管理员身份打开“Terminal”或“PowerShell ISE”，设置 PowerShell 执行策略：绕过，PS 命令行：
```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
```

<br>

a) 优先从 Github 节点下载
```
curl https://github.com/ilikeyi/LXPs/raw/main/get.ps1 -o get.ps1; .\get.ps1;
wget https://github.com/ilikeyi/LXPs/raw/main/get.ps1 -O get.ps1; .\get.ps1;
iwr https://github.com/ilikeyi/LXPs/raw/main/get.ps1 -out get.ps1; .\get.ps1;
Invoke-WebRequest https://github.com/ilikeyi/LXPs/raw/main/get.ps1 -OutFile get.ps1; .\get.ps1;
```

<br>

b) 优先从 Yi 节点下载
```
curl https://fengyi.tel/lxps -o get.ps1; .\get.ps1;
wget https://fengyi.tel/lxps -O get.ps1; .\get.ps1;
iwr https://fengyi.tel/lxps -out get.ps1; .\get.ps1;
Invoke-WebRequest https://fengyi.tel/lxps -OutFile get.ps1; .\get.ps1;
```

<p>运行安装脚本后，用户可自定义安装界面：指定下载连接、指定安装到、可前往：主程序、创建升级包等。</p>
<p>你可以选择任意一种：交互式体验安装和自定义安装，以适用不同的安装需求，下载时提供了多条不同的命令：Curl、Wget、iwr、Invoke-WebRequest，复制下载连接时，任意复制一条即可。</p>

<br>

学习
 * [如何自定义安装脚本交互式体验](https://github.com/ilikeyi/LXPs/blob/main/_Learn/Get/Get.zh-CN.pdf)

<br>

Available languages
-
 * [United States - English](https://github.com/ilikeyi/LXPs)

<br>
Windows 本地语言体验包（LXPs）下载器

<br>
<h4><pre>主要功能：</pre></h4>
<ul>1. 支持在线升级，请了解“如何自定义创建升级包”；</ul>
<ul>2. 支持热刷新，热加载，修改代码后，在主界面按 R 即可完成；</ul>
<ul>3. 可自定义选择待下载的本地语言体验包（LXPs）；</ul>

<ul>4. 如何自定义创建升级包
   <dl>
      <dd>4.1. 继续使用当前版本请跳过修改，例如当前版本号：1.0.0.0，创建为新的版本号：2.0.0.0，打开 Modules\LXPs.psd1，修改“ModuleVersion”为：2.0.0.0</dd>
      <dd>4.2. 将 Modules\1.0.0.0 目录修改为 2.0.0.0，注意：1.0.0.0 请根据每版本号进行更改。</dd>
      <dd>4.3. 重新指定升级服务器，修改 URL 连接：
         <dl>
            <dd>打开：Modules\LXPs.psd1，更改：</dd>
            <dd>4.3.1  修改最低要求版本号：MinimumVersion，如果支持滑行升级可从 1.0.0.0 开始，如果脚本最低要求 2.0.0.0 开始，请更改为 2.0.0.0；</dd>
            <dd>4.3.2  重新指定更新服务器：UpdateServer。</dd>
         </dl>
      </dd>

<br>
      <dd>4.4. 运行：.\_Create.Upgrade.Package.ps1</dd>
   </dl>
</ul>

<br>
<ul>5. 下载时：
   <dl>
      <dd>a. 可下载全部；</dd>
      <dd>b. 下载时可按版本号筛选，下载完成后可自动：按规则重命名、创建 License.xml 证书；</dd>
   </dl>
</ul>
<ul>6. 生成报告，生成内容：文件名、语言、语言描述、最低版本号、最高测试版本等。</ul>
<br>


## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/LXPs](https://github.com/ilikeyi/LXPs)
