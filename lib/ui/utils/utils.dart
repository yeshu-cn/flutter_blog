import 'package:flutter/material.dart';

void navigateTo(BuildContext context, Widget page) {
  Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, _) {
        return FadeTransition(
          opacity: animation,
          child: page,
        );
      },
      transitionDuration: const Duration(milliseconds: 500)));
}