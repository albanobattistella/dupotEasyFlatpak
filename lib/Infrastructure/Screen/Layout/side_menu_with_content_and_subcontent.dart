import 'package:flutter/material.dart';

class SideMenuWithContentAndSubContentLayout extends StatefulWidget {
  Widget menu;
  Widget content;
  Widget subContent;
  bool hasSubContent = false;

  SideMenuWithContentAndSubContentLayout(
      {super.key,
      required this.menu,
      required this.content,
      required this.subContent,
      required this.hasSubContent});

  @override
  _SideMenuWithContentAndSubContentLayoutState createState() =>
      _SideMenuWithContentAndSubContentLayoutState();
}

class _SideMenuWithContentAndSubContentLayoutState
    extends State<SideMenuWithContentAndSubContentLayout> {
  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Card(
            elevation: 4,
            color: Theme.of(context).cardColor,
            child: widget.content));

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                width: 240,
                child: Card(
                    semanticContainer: widget.hasSubContent ? true : false,
                    elevation: 4,
                    color: Theme.of(context).primaryColorLight,
                    child: widget.menu),
              )),
          widget.hasSubContent
              ? SizedBox(
                  width: 500,
                  child: content,
                )
              : Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: content)),
          if (widget.hasSubContent)
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                        elevation: 4,
                        color: Theme.of(context).secondaryHeaderColor,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: widget.subContent))))
        ]));
  }
}
