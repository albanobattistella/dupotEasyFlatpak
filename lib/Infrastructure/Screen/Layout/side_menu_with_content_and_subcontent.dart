import 'package:flutter/material.dart';

class SideMenuWithContentAndSubContentLayout extends StatefulWidget {
  Widget menu;
  Widget content;
  Widget subContent;

  SideMenuWithContentAndSubContentLayout({
    super.key,
    required this.menu,
    required this.content,
    required this.subContent,
  });

  @override
  _SideMenuWithContentAndSubContentLayoutState createState() =>
      _SideMenuWithContentAndSubContentLayoutState();
}

class _SideMenuWithContentAndSubContentLayoutState
    extends State<SideMenuWithContentAndSubContentLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(width: 240, child: widget.menu),
          const SizedBox(width: 10),
          Container(width: 500, child: widget.content),
          Expanded(child: widget.subContent)
        ]));
  }
}
