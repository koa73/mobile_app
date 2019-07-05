import 'package:flutter/material.dart';
import 'dart:math' as math;


// Widget for rotate form area

class RotatingCell extends StatefulWidget {
  RotatingCell(
      {Key key,
        @required this.frontWidget,
        @required this.backWidget,
        this.cellSize,
        this.padding,
        this.stateStream
        }
        );

  final Widget frontWidget;
  final Widget backWidget;
  final Size cellSize;
  final EdgeInsetsGeometry padding;
  final Stream stateStream;

  @override
  _RotatingCellState createState() => _RotatingCellState();
}

class _RotatingCellState extends State<RotatingCell> with SingleTickerProviderStateMixin {

  final ninetyDegrees = math.pi / 2;
  double _currentAnimationValue;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    widget.stateStream.listen(_rotate);
    _currentAnimationValue = 0;
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.addListener(() {
      setState(() {
        _currentAnimationValue = _animationController.value;
      });
    });
  }

  @override
  void dispose() {
    if (_animationController != null) _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final angleInRadians = _currentAnimationValue * math.pi;
    return GestureDetector(
      child: Padding(
        padding: widget.padding,
        child: Container(
          child: Stack(
            children: <Widget>[
              Transform(
                alignment: FractionalOffset(0.5, 0.5),
                transform: (Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                // For back widget, we want to go from the
                // rotated to normal.
                  ..rotateY(-(math.pi - angleInRadians))),
                child: Container(
                  // If <= 90 degrees, set no height or width
                  height: angleInRadians <= ninetyDegrees ? 0.0 : widget.cellSize.height,
                  width: angleInRadians <= ninetyDegrees ? 0.0 : widget.cellSize.width,
                  child: widget.backWidget,
                ),
              ),
              Transform(
                alignment: FractionalOffset(0.5, 0.5),
                transform: (Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angleInRadians)),
                child: Container(
                  // If >= 90 degrees, set no height or width
                  height: angleInRadians >= ninetyDegrees ? 0.0 : widget.cellSize.height,
                  width: angleInRadians >= ninetyDegrees ? 0.0 : widget.cellSize.width,
                  child: widget.frontWidget,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _rotate(state) {

    if (state.toString().contains('Back')){
      _animationController.forward();
    } else if (state.toString().contains('Front')){
      _animationController.reverse();
    }

  }
}