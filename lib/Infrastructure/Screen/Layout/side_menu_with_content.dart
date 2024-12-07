import 'package:flutter/material.dart';

class SideMenuWithContentLayout extends StatefulWidget {
  Widget menu;
  Widget content;

  SideMenuWithContentLayout(
      {super.key, required this.menu, required this.content});

  @override
  _SideMenuWithContentLayoutState createState() =>
      _SideMenuWithContentLayoutState();
}

class _SideMenuWithContentLayoutState extends State<SideMenuWithContentLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(width: 240, child: widget.menu),
          const SizedBox(width: 10),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: widget.content))
        ]));
  }
}
