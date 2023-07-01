> 🚀 The Markdown 1.0

Language：[简体中文](https://github.com/asjqkkkk/markdown_widget/blob/master/README_ZH.md) | [English](https://github.com/asjqkkkk/markdown_widget/blob/master/README.md)

# 📖 Markdown


A simple and easy-to-use Markdown rendering component.

- Supports TOC (Table of Contents) function for quick location through Headings
- Supports code highlighting
- Supports all platforms

## 🚀Usage

Before starting

```
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class MarkdownPage extends StatelessWidget {
  final String data;

  MarkdownPage(this.data);

  @override
  Widget build(BuildContext context) => Scaffold(body: buildMarkdown());

  Widget buildMarkdown() => MarkdownWidget(data: data);
}
```
If you want to use your own Column or other list widget, you can use `MarkdownGenerator`

```
  Widget buildMarkdown() =>
      Column(children: MarkdownGenerator().buildWidgets(data));
```

## 🌠Night mode

`markdown_widget` supports night mode by default. Simply use a different `MarkdownConfig` to enable it.

```
  Widget buildMarkdown(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MarkdownWidget(
        data: data,
        config:
            isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig);
  }
```

Default mode | Night mode
---|---
<img src="https://user-images.githubusercontent.com/30992818/211159089-ec4acd11-ee02-46f2-af4f-f8c47eb28410.png" width=400> | <img src="https://user-images.githubusercontent.com/30992818/211159108-4c20de2d-fb1d-4bcb-b23f-3ceb91291661.png" width=400>


## 🔗Link

You can customize the style and click events of links, like this

```
  Widget buildMarkdown() => MarkdownWidget(
      data: data,
      config: MarkdownConfig(configs: [
        LinkConfig(
          style: TextStyle(
            color: Colors.red,
            decoration: TextDecoration.underline,
          ),
          onTap: (url) {
            ///TODO:on tap
          },
        )
      ]));
```

## 📜TOC (Table of Contents) feature

Using the TOC is very simple

```
  Widget buildTocWidget() => TocWidget(controller: tocController);

  Widget buildMarkdown() => MarkdownWidget(data: data, tocController: tocController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          children: <Widget>[
            Expanded(child: buildTocWidget()),
            Expanded(child: buildMarkdown(), flex: 3)
          ],
        ));
  }
```

## 🎈Highlighting  code

Highlighting code supports multiple themes.

```
import 'package:flutter_highlight/themes/a11y-light.dart';

  Widget buildMarkdown() => MarkdownWidget(
      data: data,
      config: MarkdownConfig(configs: [
        PreConfig(theme: a11yLightTheme, language: 'dart'),
      ]));
```

## 🌐HTML tags

The current package only implements the conversion of Markdown tags, so it does not support the conversion of HTML tags by default. 

## 🍑Custom tag implementation

By passing a `SpanNodeGeneratorWithTag` to `MarkdownGeneratorConfig`, you can add new tags and the corresponding `SpanNode`s for those tags. You can also use existing tags to override the corresponding `SpanNode`s.

You can also customize the parsing rules for Markdown strings using `InlineSyntax` and `BlockSyntax`, and generate new tags.

# 🧾Appendix

Here are the other libraries used in `markdown_widget`

Packages | Descriptions
---|---
[markdown](https://pub.flutter-io.cn/packages/markdown) | Parsing markdown data
[flutter_highlight](https://pub.flutter-io.cn/packages/flutter_highlight) | Code highlighting
[highlight](https://pub.flutter-io.cn/packages/highlight) | Code highlighting
[url_launcher](https://pub.flutter-io.cn/packages/url_launcher) | Opening links
[visibility_detector](https://pub.flutter-io.cn/packages/visibility_detector) | Listening for visibility of a widget;
[scroll_to_index](https://pub.flutter-io.cn/packages/scroll_to_index) | Enabling ListView to jump to an index.
