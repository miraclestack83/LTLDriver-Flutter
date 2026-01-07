import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final int max;
  final bool scrollAble;
  const ExpandableText(
      {Key? key,
      required this.text,
      required this.textStyle,
      this.max = 200,
      this.scrollAble = true})
      : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf = "";
  late String secondHalf = "";
  int get max => widget.max;
  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > max) {
      firstHalf = widget.text.substring(0, max);
      secondHalf = widget.text.substring(max, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  void didUpdateWidget(covariant ExpandableText oldWidget) {
    if (widget.text.length > max) {
      firstHalf = widget.text.substring(0, max);
      secondHalf = widget.text.substring(max, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (secondHalf.isEmpty) {
      return Text(
        firstHalf,
        style: widget.textStyle,
        textAlign: TextAlign.left,
      );
    } else {
      if (!flag) {
        return SizedBox(
          height: widget.scrollAble ? 90 : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.scrollAble
                  ? Flexible(
                      child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Text(
                          flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                          style: widget.textStyle,
                        ),
                      ),
                    ))
                  : Text(
                      flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                      style: widget.textStyle,
                      textAlign: TextAlign.left,
                    ),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      flag ? "More" : "Show less",
                      style: widget.textStyle!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    flag = !flag;
                  });
                },
              ),
            ],
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              flag ? (firstHalf + "...") : (firstHalf + secondHalf),
              style: widget.textStyle,
              textAlign: TextAlign.left,
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    flag ? "More" : "Show less",
                    style:
                        widget.textStyle!.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  flag = !flag;
                });
              },
            ),
          ],
        );
      }
    }
  }
}
