

import 'package:flutter/cupertino.dart';

class TestMain extends StatefulWidget {
  const TestMain({Key? key}) : super(key: key);

  @override
  State<TestMain> createState() => _TestMainState();
}

class _TestMainState extends State<TestMain> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
