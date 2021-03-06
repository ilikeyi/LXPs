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
The deployment LXPs is divided into multiple parts
-
You can intervene in the deployment process by adding more deployment tags, activate the first deployment:
.\LXPs.ps1 -Force


* Shared deployment tags

| Path             | Deployment tag        | Description |
|------------------|-----------------------|---|
| \Deploy\Allow    | IsMarkSync            | Allows full disk search and synchronization of deployment tags |

When enabling full disk search and synchronization of deployment tags, you can store deployment tags on any other disk, allowing or disallowing deployment, for example:
   1. The priority judgment deployment is marked as:
      D:\Yi\Deploy\Not Allowed\AutoUpdate

   2. Continue to judge: D:\Yi\Deploy\Allow\AutoUpdate

   3. Continue to judge the Deploy directory under the directory where the deployment LXPs script is stored.

When full disk search and synchronization of deployment tags are not allowed, only the Deploy directory under the directory where the deployment LXPs scripts are stored is recognized.

Download template: LXPs.Deploy.Rule.ISO


* Part 1: Prerequisite deployment

| Assignable path               | Deployment tag        | Description |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | AutoUpdate            | Allow automatic updates |
| \Deploy\{allow, Not Allowed}  | UseUTF8               | Beta: Use Unicode UTF-8 to provide global language support |
| \Deploy\{allow, Not Allowed}  | PrerequisitesReboot   | Restart the computer<br>Restarting the computer after completing the prerequisite deployment can solve the problem that needs to be restarted to take effect. |
| \Deploy\Regional              | Zone marker           | Change system locale |


* Part 2: Complete the first deployment

| Assignable path               | Deployment tag        | Description |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | PopupLXPs           | Allow the main interface of the deployment LXPs to pop up for the first time |
| \Deploy\{allow, Not Allowed}  | FirstPreExperience    | Allow the first pre-experience, as planned |
| \Deploy\{allow, Not Allowed}  | ResetExecutionPolicy  | Recovery PowerShell execution strategy: restricted |
| \Deploy\{allow, Not Allowed}  | ClearSolutions        | Delete the entire solution |
| \Deploy\{allow, Not Allowed}  | ClearLXPs           | Delete the deployment LXPs, keep the others |
| \Deploy\{allow, Not Allowed}  | FirstExperienceReboot | Restart the computer<br>After the deployment is complete, there are no important events. It is recommended that you cancel. |
</details>
 
<details>
  <summary>简体中文 - 中国</summary>
  <h1>全自动添加 Windows 系统已安装的语言</h1>

主要功能：
```
1、支持在线升级；
2、修改脚本按 R 可热刷新；
3、根据描述文件来实现部署规则；
4、获取已安装的语言包，自动添加；
5、添加过程中，自动判断 S、SN 版，按规则添加；
6、已遵循并满足“语言概述”的所有条件
   https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/languages-overview
```

部署引擎分为多部分
-
可通过添加更多的部署标记来进行干预部署过程，激活首次部署：
.\LXPs.ps1 -Force


* 共享部署标记

| 路径             | 部署标记               | 描述 |
|------------------|-----------------------|---|
| \Deploy\Allow    | IsMarkSync            | 允许全盘搜索并同步部署标记 |

允许全盘搜索并同步部署标记时，你可以在其它任意磁盘存放部署标记，可允许部署和不允许部署，例如：
   1、优先判断部署标记为：
      D:\Yi\Deploy\Not Allowed\AutoUpdate

   2、继续判断：D:\Yi\Deploy\Allow\AutoUpdate

   3、继续判断部署引擎脚本存放目录下的 Deploy 目录。

不允许全盘搜索并同步部署标记时，仅识别部署引擎脚本存放目录下的 Deploy 目录。

下载模板：LXPs.Deploy.Rule.ISO


* 第一部分：先决部署

| 可分配路径                     | 部署标记               | 描述 |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | AutoUpdate            | 允许自动更新 |
| \Deploy\{allow, Not Allowed}  | UseUTF8               | Beta 版：使用 Unicode UTF-8 提供全球语言支持 |
| \Deploy\{allow, Not Allowed}  | PrerequisitesReboot   | 重新启动计算机<br>完成先决部署后重新启动计算机，可解决需重启才生效的问题。 |
| \Deploy\Regional              | 区域标记               | 更改系统区域设置 |


* 第二部分：完成首次部署

| 可分配路径                     | 部署标记               | 描述 |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | PopupLXPs           | 允许首次弹出部署引擎主界面 |
| \Deploy\{allow, Not Allowed}  | FirstPreExperience    | 允许首次预体验，按计划 |
| \Deploy\{allow, Not Allowed}  | ResetExecutionPolicy  | 恢复 PowerShell 执行策略：受限 |
| \Deploy\{allow, Not Allowed}  | ClearSolutions        | 删除整个解决方案 |
| \Deploy\{allow, Not Allowed}  | ClearLXPs           | 删除部署引擎，保留其它 |
| \Deploy\{allow, Not Allowed}  | FirstExperienceReboot | 重新启动计算机<br>部署完成后没有重要的事件，建议您取消。 |
</details>


## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/LXPs](https://github.com/ilikeyi/LXPs)
