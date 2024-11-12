import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          children: [
            SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  "应用信息",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "使用教程",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              "step1. 把你想听的课程放在手机的一个文件夹下\n"
              "step2. 在设置中选择文件夹\n"
              "step3. 尽情使用吧！",
              textAlign: TextAlign.center,
            ),
            Text(
              "P.S. 如果以后添加了文件，请在设置中重构索引\n"
              "我们会自动把文件夹视为课程名，文件名视为该课标题\n"
              "Small Tip. 左上角标点一下可以续播哦",
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            SizedBox(
              height: 20,
            ),
            // ============================================
            Divider(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "感谢你使用courser!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              "这是一个由blakeJia完全自主开发的程序\n"
              "初衷是苦于没有播放器可以续播每一个播放列表\n"
              "or 有这个功能的都想尽办法收费",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            // ================================================
            Divider(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "应用信息",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              "courser完全单机，无网络连接权限，并且完全永久免费\n"
              "根据文件夹和文件名对音频文件处理,归类,播放",
              textAlign: TextAlign.center,
            ),
            Text(
                "就算是别人乱改过的metadata\n"
                "遇到这款软件也一点办法都没有呢",
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).hintColor)),
            SizedBox(
              height: 20,
            ),
            // =================================================
            Divider(),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "开发信息",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              "如果你喜欢这个应用，别忘了在后台反馈\n"
              "如果你对编程感兴趣，也可以++我哦",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}
