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
          Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                width: 240,
                child: Card(
                  elevation: 4,
                  color: Theme.of(context).primaryColorLight,
                  child: widget.menu,
                ),
              )),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Card(
                      elevation: 4,
                      color: Theme.of(context).cardColor,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: widget.content))))
        ]));
  }
}
