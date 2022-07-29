import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/paginator_button.dart';

class NumberPaginator extends StatefulWidget {
  /// Total number of pages that should be shown.
  final int numberPages;

  /// Index of initially selected page.
  final int initialPage;

  /// This function is called when the user switches between pages. The received
  /// parameter indicates the selected index, starting from 0.
  final Function(int)? onPageChange;

  /// The height of the number paginator.
  final double height;

  /// The shape of the [PaginatorButton]s.
  final OutlinedBorder? buttonShape;

  /// The [PaginatorButton]'s foreground color (text/icon color) when selected.
  ///
  /// Defaults to [Colors.white].
  final Color? buttonSelectedForegroundColor;

  /// The [PaginatorButton]'s foreground color (text/icon color) when unselected.
  ///
  /// Defaults to `null`.
  final Color? buttonUnselectedForegroundColor;

  /// The [PaginatorButton]'s background color when selected.
  ///
  /// Defaults to the [Theme]'s accent color.
  final Color? buttonSelectedBackgroundColor;

  /// The [PaginatorButton]'s background color when unselected.
  ///
  /// Defaults to `null`.
  final Color? buttonUnselectedBackgroundColor;

  /// Creates an instance of [NumberPaginator].
  const NumberPaginator({
    Key? key,
    required this.numberPages,
    this.initialPage = 0,
    this.onPageChange,
    this.height = 48.0,
    this.buttonShape,
    this.buttonSelectedForegroundColor,
    this.buttonUnselectedForegroundColor,
    this.buttonSelectedBackgroundColor,
    this.buttonUnselectedBackgroundColor,
  }) : super(key: key);

  @override
  _NumberPaginatorState createState() => _NumberPaginatorState();
}

class _NumberPaginatorState extends State<NumberPaginator> {
  late int _currentPage;
  int _availableSpots = 0;

  @override
  void initState() {
    _currentPage = widget.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          if (_currentPage > 0)
            PaginatorButton(
              onPressed: _currentPage > 0 ? _prev : null,
              shape: widget.buttonShape,
              selectedForegroundColor: widget.buttonSelectedForegroundColor,
              unSelectedforegroundColor: widget.buttonUnselectedForegroundColor,
              selectedBackgroundColor: widget.buttonSelectedBackgroundColor,
              unSelectedBackgroundColor: widget.buttonUnselectedBackgroundColor,
              child: const Icon(Icons.chevron_left),
            ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _availableSpots = (constraints.maxWidth / _buttonWidth).floor();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ..._generateButtonList(),
                    if (_dotsShouldShow) _buildDots(),
                    _buildPageButton(widget.numberPages - 1),
                  ],
                );
              },
            ),
          ),
          if (_currentPage < widget.numberPages - 1)
            PaginatorButton(
              onPressed: _currentPage < widget.numberPages - 1 ? _next : null,
              shape: widget.buttonShape,
              selectedForegroundColor: widget.buttonSelectedForegroundColor,
              unSelectedforegroundColor: widget.buttonUnselectedForegroundColor,
              selectedBackgroundColor: widget.buttonSelectedBackgroundColor,
              unSelectedBackgroundColor: widget.buttonUnselectedBackgroundColor,
              child: const Icon(Icons.chevron_right),
            ),
        ],
      ),
    );
  }

  /// Buttons have an aspect ratio of 1:1. Therefore use paginator height as
  /// button width.
  double get _buttonWidth => widget.height;

  _prev() {
    setState(() {
      _currentPage--;
    });
    widget.onPageChange?.call(_currentPage);
  }

  _next() {
    setState(() {
      _currentPage++;
    });
    widget.onPageChange?.call(_currentPage);
  }

  _navigateToPage(int index) {
    setState(() {
      _currentPage = index;
    });
    widget.onPageChange?.call(index);
  }

  /// Checks if pages don't fit in available spots and dots have to be shown.
  bool get _dotsShouldShow =>
      _availableSpots < widget.numberPages && _currentPage < widget.numberPages - _availableSpots ~/ 2 - 1;

  /// Generates the variable button list which is on the left of the (optional)
  /// dots. The very last page is shown independently of this list.
  List<Widget> _generateButtonList() {
    // if dots shown: available minus one for last page + one for dots
    var shownPages = _dotsShouldShow ? _availableSpots - 2 : _availableSpots - 1;

    int minValue, maxValue;
    minValue = max(0, _currentPage - shownPages ~/ 2);
    maxValue = min(minValue + shownPages, widget.numberPages - 1);
    if (maxValue - minValue < shownPages) {
      minValue = (maxValue - shownPages).clamp(0, widget.numberPages - 1);
    }

    return List.generate(maxValue - minValue, (index) => _buildPageButton(minValue + index));
  }

  /// Builds a button for the given index.
  Widget _buildPageButton(int index) => PaginatorButton(
        onPressed: () => _navigateToPage(index),
        selected: _selected(index),
        shape: widget.buttonShape,
        selectedForegroundColor: widget.buttonSelectedForegroundColor,
        unSelectedforegroundColor: widget.buttonUnselectedForegroundColor,
        selectedBackgroundColor: widget.buttonSelectedBackgroundColor,
        unSelectedBackgroundColor: widget.buttonUnselectedBackgroundColor,
        child: Text((index + 1).toString()),
      );

  Widget _buildDots() => AspectRatio(
        aspectRatio: 1,
        child: Container(
          // padding: const EdgeInsets.all(4.0),
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.bottomCenter,
          decoration: ShapeDecoration(
            shape: widget.buttonShape ?? const CircleBorder(),
            color: widget.buttonUnselectedBackgroundColor,
          ),
          child: Icon(
            Icons.more_horiz,
            color: widget.buttonUnselectedForegroundColor ?? Theme.of(context).colorScheme.secondary,
            size: 20,
          ),
        ),
      );

  /// Checks if the given index is currently selected.
  bool _selected(index) => index == _currentPage;
}
