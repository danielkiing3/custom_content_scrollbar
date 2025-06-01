import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../control_input_enum.dart';
import 'text_based_selector.dart';
import 'stick_indicator.dart';

import 'dart:math' as math;

class VerticalStadiumPicker extends StatefulWidget {
  const VerticalStadiumPicker({
    super.key,
    required this.currentSectionIndex,
    required this.contentHeader,
    required this.contentKeys,
    required this.activeControlNotifier,
    required this.debouncer,
  });

  final ValueNotifier<int> currentSectionIndex;

  final List<String> contentHeader;
  final ValueNotifier<ScrollInput> activeControlNotifier;
  final VoidCallback debouncer;
  final List<GlobalKey> contentKeys;

  @override
  State<VerticalStadiumPicker> createState() => _VerticalStadiumPickerState();
}

class _VerticalStadiumPickerState extends State<VerticalStadiumPicker> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Check if content is expaned or not
  bool _isExpanded = false;

  // Normal collapsed state width
  static const double collapsedWidth = 60.0;

  // Normal expanded state width
  static const double expandedWidth = 300.0;

  // Max unbounded width for the container
  static const double maxOverExpand = 340.0;

  static const double height = 300.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
  }

  void _toggle() {
    // Dynamically changing the target width based on [_isExpanded] state
    final double targetWidth = _isExpanded ? collapsedWidth : expandedWidth;

    final SpringSimulation bounceSimulation = SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1,
        stiffness: 220,
        // Why? I noticee reducing the spring oscillation when closing seems more natural, play around with it yourself
        ratio: _isExpanded ? 0.6 : 0.5,
      ),
      _controller.value,
      targetWidth,
      1000.0,
    );

    _controller.animateWith(bounceSimulation);
    _isExpanded = !_isExpanded;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          // Why? I decided to clamp because of two reason
          // 1. You expose the content behind the stadium picker if left on unclamped. Breaks the ui fidelity I was going for as the width can under shoot
          // 2. It causes overflow error since the width of the [stick selector] is set to [collaspedWidth]
          final double width = _controller.value.clamp(collapsedWidth, maxOverExpand);

          return Container(
            width: width,
            height: height,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(36)),
            child: Align(
              alignment: Alignment.centerRight,
              child: OverflowBox(
                alignment: Alignment.centerRight,
                maxWidth: math.max(collapsedWidth, expandedWidth),
                child: Row(
                  children: <Widget>[
                    // -- Text based selctor
                    Expanded(
                      child: TextBasedSelector(
                        currentSectionIndex: widget.currentSectionIndex,
                        contentHeader: widget.contentHeader,
                        activeControlNotifier: widget.activeControlNotifier,
                        debouncer: widget.debouncer,
                        contentKeys: widget.contentKeys,
                        contentHeight: height,
                      ),
                    ),

                    //TODO: Just for fun, build this with custom render objects
                    // -- Stick Indicator, find a better name 😂
                    SizedBox(
                      width: collapsedWidth,
                      child: StickIndicator(
                        itemCount: widget.contentHeader.length,
                        currentSectionIndex: widget.currentSectionIndex,
                        isVerticalPickerExpanded: ValueNotifier<bool>(_isExpanded),
                        contentHeight: height,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
