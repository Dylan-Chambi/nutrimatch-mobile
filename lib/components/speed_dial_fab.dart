import 'package:flutter/material.dart';
import 'dart:math' as math;

class SpeedDialFabWidget extends StatefulWidget {
  const SpeedDialFabWidget({
    super.key,
    this.secondaryBackgroundColor = Colors.white,
    this.secondaryForegroundColor = Colors.black,
    this.primaryBackgroundColor = Colors.white,
    this.primaryForegroundColor = Colors.black,
    this.primaryIconCollapse = Icons.expand_less,
    this.primaryIconExpand = Icons.expand_less,
    this.rotateAngle = math.pi,
    required this.secondaryIconsList,
    required this.secondaryIconsOnPress,
    this.secondaryIconsText,
    this.primaryElevation = 5.0,
    this.secondaryElevation = 10.0,
  });

  final Color secondaryBackgroundColor;
  final Color secondaryForegroundColor;
  final Color primaryBackgroundColor;
  final Color primaryForegroundColor;
  final double primaryElevation;
  final double secondaryElevation;
  final IconData primaryIconCollapse;
  final IconData primaryIconExpand;
  final double rotateAngle;
  final List<IconData> secondaryIconsList;
  final List<String>? secondaryIconsText;
  final List<Function> secondaryIconsOnPress;

  @override
  State createState() => SpeedDialFabWidgetState();
}

class SpeedDialFabWidgetState extends State<SpeedDialFabWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (widget.secondaryIconsList.length !=
        widget.secondaryIconsOnPress.length) {
      throw ("secondaryIconsList should have the same length of secondaryIconsOnPress");
    }
    if (widget.secondaryIconsText != null) {
      if (widget.secondaryIconsText!.length !=
          widget.secondaryIconsOnPress.length) {
        throw ("secondaryIconsText should have the same length of secondaryIconsOnPress");
      }
    }

    super.initState();
  }

  void forceExpandSecondaryFab() {
    _controller.forward();
  }

  void forceCollapseSecondaryFab() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.secondaryIconsList.length, (int index) {
        Widget secondaryFAB = Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(
                0.0,
                1.0 - index / widget.secondaryIconsList.length / 2.0,
                curve: Curves.easeOut,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton(
                  elevation: widget.secondaryElevation,
                  tooltip: widget.secondaryIconsText![index],
                  heroTag: null,
                  mini: true,
                  backgroundColor: widget.secondaryBackgroundColor,
                  onPressed: () {
                    (widget.secondaryIconsOnPress[index] as void Function())();
                    forceCollapseSecondaryFab();
                  },
                  child: Icon(
                    widget.secondaryIconsList[index],
                    color: widget.secondaryForegroundColor,
                  ),
                ),
                Positioned(
                  right: 51.0,
                  top: 10,
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(5),
                    borderOnForeground: true,
                    elevation: widget.secondaryElevation,
                    shadowColor: Colors.black,
                    color: widget.secondaryBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Text(
                        widget.secondaryIconsText?[index] ?? "",
                        style: TextStyle(
                          color: widget.secondaryForegroundColor,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        return secondaryFAB;
      }).toList()
        ..add(
          FloatingActionButton(
            elevation: widget.primaryElevation,
            clipBehavior: Clip.antiAlias,
            backgroundColor: widget.primaryBackgroundColor,
            heroTag: null,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  transform: Matrix4.rotationZ(
                    _controller.value * (widget.rotateAngle),
                  ),
                  alignment: FractionalOffset.center,
                  child: Icon(
                    _controller.isDismissed
                        ? widget.primaryIconExpand
                        : widget.primaryIconCollapse,
                    color: widget.primaryForegroundColor,
                  ),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }
}
