import 'package:flutter/material.dart';

class OnlyContentLayout extends StatefulWidget {
  Widget content;
  Function handleGoTo;

  OnlyContentLayout({
    super.key,
    required this.handleGoTo,
    required this.content,
  });

  @override
  _OnlyContentLayoutState createState() => _OnlyContentLayoutState();
}

class _OnlyContentLayoutState extends State<OnlyContentLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.content,
    );
  }
}
