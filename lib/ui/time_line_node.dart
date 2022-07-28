import 'package:flutter/material.dart';

class TimeLineNode extends StatefulWidget {
  final Widget child;
  final double height;
  final bool firstNode;
  final double indicatorSize;
  final double timeLineWidth;
  final double firstNodeIndicatorOffset;

  const TimeLineNode({
    Key? key,
    required this.child,
    this.height = 46,
    this.firstNode = false,
    this.indicatorSize = 9,
    this.timeLineWidth = 2,
    this.firstNodeIndicatorOffset = 2,
  }) : super(key: key);

  @override
  State<TimeLineNode> createState() => _TimeLineNodeState();
}

class _TimeLineNodeState extends State<TimeLineNode> {
  @override
  Widget build(BuildContext context) {
    var lineLeftPadding =
        (widget.indicatorSize + widget.firstNodeIndicatorOffset) / 2 -
            widget.timeLineWidth / 2;
    return Stack(
      children: [
        Padding(
          padding: widget.firstNode
              ? EdgeInsets.only(left: lineLeftPadding, top: widget.height / 2)
              : EdgeInsets.only(
                  left: lineLeftPadding,
                ),
          child: Container(
            width: widget.timeLineWidth,
            height: widget.height,
            decoration: BoxDecoration(color: Colors.grey[300]),
          ),
        ),
        SizedBox(
          height: widget.height,
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: widget.firstNode
                      ? 0
                      : widget.firstNodeIndicatorOffset / 2,
                ),
                Container(
                  width: widget.firstNode
                      ? widget.indicatorSize + widget.firstNodeIndicatorOffset
                      : widget.indicatorSize,
                  height: widget.firstNode
                      ? widget.indicatorSize + widget.firstNodeIndicatorOffset
                      : widget.indicatorSize,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey),
                ),
                const SizedBox(
                  width: 8,
                ),
                widget.child,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
