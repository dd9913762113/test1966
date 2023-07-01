import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../platform_dector/platform_dector.dart';
import 'edit_markdown_page.dart';


class HomeListPage extends StatefulWidget {
  const HomeListPage({super.key});

  @override
  HomeListPageState createState() => HomeListPageState();
}

class HomeListPageState extends State<HomeListPage> {

  final bool isMobile = PlatformDetector.isMobile || PlatformDetector.isWebMobile;
  var list = [];
  final CounterStorage storage = CounterStorage();


  @override
  void initState() {
    super.initState();
    storage.readCounter().then((value) {
      setState(() {
        if(value.length > 1) {
          list = jsonDecode(value);
        } else {
          list = [];
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile ? AppBar(
        title: const Text( 'Markdown'),
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: const Icon(Icons.menu_book),
            tooltip: 'Navigation',
            onPressed: () => {
              debugPrint('Navigation button is pressed.'),
              pushToEdit(_markdownData, 9999),
            }
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add_circle_rounded),
              tooltip: '创建',
              onPressed: () => {
                pushToEdit("create123md",9999),
              }
          ),
        ],
      ) : null,

      body: listBuild(context),
    );
  }

  Widget listBuild(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(15),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          if (list.length > 0 ) {
            String strPush = list[index];
            return Container(
              height: 50,
              child: ListTile(
                title: Text(strPush),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  pushToEdit(strPush, index);
                },
                onLongPress: () {
                  debugPrint("onLongPress 长按删除 @todo");
                  myAlert(context,index);
                },
              ),
            );
          }else{
            return Container();
          }


        }
    );
  }

  void myAlert (BuildContext context, int index) {
    // BuildContext context = Get.Context;

    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: '你确定删除这条内容吗？',
      confirmBtnText: '是',
      cancelBtnText: '否',
      confirmBtnColor: Colors.green,
      onCancelBtnTap: () async {},
      onConfirmBtnTap: () async {
        setState(() {
          list.removeAt(index);
          storage.writeCounter(jsonEncode(list));
          Navigator.pop(context);

        });
      }
    );
  }


  void pushToEdit (String string,int index) {
    // print("string = $string");
    Navigator.push(context, MaterialPageRoute(
        builder: (context) =>const EditMarkdownPage(),
        settings: RouteSettings(arguments: string),
    )).then((value) => {
      // print("返回的value = $index $value "),

      setState(() {
          if(value.toString().isNotEmpty) {
            if (index < value.toString().length) {
              list[index] = value;
            }else{
              list.add(value);
            }

            storage.writeCounter(jsonEncode(list));
          }
      })
    });

  }



}




class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return contents;

    } catch (e) {

      return "";
    }
  }

  Future<File> writeCounter(String counter) async {
    final file = await _localFile;

    return file.writeAsString('$counter');
  }
}



const String _markdownData = """
# 欢迎使用 Markdown 编辑器（内容修改无效）
Markdown 让你轻松包含格式化的文本、图像，甚至格式化

## Titles

Setext-style

```
This is an H1
=============

This is an H2
-------------
```

Atx-style

```
# This is an H1

## This is an H2

###### This is an H6
```

Select the valid headers:

- [x] `# hello`
- [ ] `#hello`

---

### 1. 制作待办事宜 `Todo` 列表

- [x] 🎉 通常 `Markdown` 解析器自带的基本功能；
- [x] 🍀 支持**流程图**、**甘特图**、**时序图**、**任务列表**；
- [x] 🏁 支持粘贴 HTML 自动转换为 Markdown；
- [x] 💃🏻 支持插入原生 Emoji、设置常用表情列表；
- [x] 🚑 支持编辑内容保存**本地存储**，防止意外丢失；
- [x] 📝 支持**实时预览**，主窗口大小拖拽，字符计数；
- [x] 🛠 支持常用快捷键(**Tab**)，及代码块添加复制
- [x] ✨ 支持**导出**携带样式的 PDF、PNG、JPEG 等；
- [x] ✨ 升级 Vditor，新增对 `echarts` 图表的支持；
- [x] 👏 支持检查并格式化 Markdown 语法，使其专业；
- [x] 🦑 支持五线谱、及[部分站点、视频、音频解析](https://github.com/b3log/vditor/issues/117?utm_source=hacpai.com#issuecomment-526986052)；
- [x] 🌟 增加对**所见即所得**编辑模式的支持(`⌘-⇧-M`)；

---

## Links

[Google's Homepage][Google]

```
[inline-style](https://www.google.com)

[reference-style][Google]
```

## Images

![Flutter logo](/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png)

## Tables

|Syntax                                 |Result                               |
|---------------------------------------|-------------------------------------|
|`*italic 1*`                           |*italic 1*                           |
|`_italic 2_`                           | _italic 2_                          |
|`**bold 1**`                           |**bold 1**                           |
|`__bold 2__`                           |__bold 2__                           |
|`This is a ~~strikethrough~~`          |This is a ~~strikethrough~~          |
|`***italic bold 1***`                  |***italic bold 1***                  |
|`___italic bold 2___`                  |___italic bold 2___                  |
|`***~~italic bold strikethrough 1~~***`|***~~italic bold strikethrough 1~~***|
|`~~***italic bold strikethrough 2***~~`|~~***italic bold strikethrough 2***~~|

## Styling
Style text as _italic_, __bold__, ~~strikethrough~~, or `inline code`.

- Use bulleted lists
- To better clarify
- Your points

## Code blocks
Formatted Dart code looks really pretty too:

```
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Markdown(data: markdownData),
    ),
  ));
}
```

## Center Title

###### ※ ※ ※

_* How to implement it see main.dart#L129 in example._

## Custom Syntax

NaOH + Al_2O_3 = NaAlO_2 + H_2O

C_4H_10 = C_2H_6 + C_2H_4

## Markdown widget

This is an example of how to create your own Markdown widget:

    Markdown(data: 'Hello _world_!');

Enjoy!

[Google]: https://www.google.com/


---

## 3. 高亮一段代码[^code]

```js
// 给页面里所有的 DOM 元素添加一个 1px 的描边（outline）;
// [].forEach.call( ("*"),function(a){
//   a.style.outline="1px solid #"+(~~(Math.random()*(1<<24))).toString(16);
// })

```

##  绘制表格

| 作品名称        | 在线地址   |  上线日期  |
| :--------  | :-----  | :----:  |
| 倾城之链 | [https://nicelinks.site](https://nicelinks.site/??utm_source=markdown.lovejade.cn) |2012-09-20|
| 晚晴幽草轩 | [https://jeffjade.com](https://jeffjade.com/??utm_source=markdown.lovejade.cn) |2022-09-20|
| 静轩之别苑 | [http://quickapp.lovejade.cn](http://quickapp.lovejade.cn/??utm_source=markdown.lovejade.cn) |2022-01-12| 
    
    
## Line Breaks

This is an example of how to create line breaks (tab or two whitespaces):

line 1


line 2



line 3
""";
