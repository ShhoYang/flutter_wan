import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final double radius;
  final Color bgColor;
  final Color highlightColor;
  final Color splashColor;

  final Widget child;
  final String text;
  final TextStyle style;
  final VoidCallback onPressed;

  RoundButton(
      {Key key,
      this.width,
      this.height = 50,
      this.margin,
      this.radius,
      this.bgColor,
      this.highlightColor,
      this.splashColor,
      this.child,
      this.text,
      this.style,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _color = bgColor ?? Theme.of(context).primaryColor;
    BorderRadius _borderRadius = BorderRadius.circular(radius ?? (height / 2));
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: new Material(
        borderRadius: _borderRadius,
        color: _color,
        child: new InkWell(
          borderRadius: _borderRadius,
          onTap: () => onPressed(),
          child: child ??
              new Center(
                child: new Text(
                  text,
                  style:
                      style ?? new TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
        ),
      ),
    );
  }
}
