import 'package:flutter/material.dart';

class TimeLineNode extends StatefulWidget {
  final Widget child;

  const TimeLineNode({Key? key, required this.child}) : super(key: key);

  @override
  State<TimeLineNode> createState() => _TimeLineNodeState();
}

class _TimeLineNodeState extends State<TimeLineNode> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              child: const Center(
                child: VerticalDivider(thickness: 3,),
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(width: 8,),
        widget.child,
      ],
    );
  }
}
