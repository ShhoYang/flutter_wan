import 'package:flutter/material.dart';
import 'package:flutter_wan/res/colors.dart';
import 'package:flutter_wan/res/style.dart';

class LoginItem extends StatefulWidget {
  final IconData prefixIcon;
  final bool hasSuffixIcon;
  final String hintText;
  final TextEditingController controller;

  LoginItem(
      {Key key,
      this.prefixIcon,
      this.hasSuffixIcon,
      this.hintText,
      this.controller})
      : super(key: key);

  @override
  _LoginItemState createState() => _LoginItemState();
}

class _LoginItemState extends State<LoginItem> {
  bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.hasSuffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new IconButton(
            iconSize: 28, icon: new Icon(widget.prefixIcon), onPressed: () {}),
        Gaps.hGap30,
        new Expanded(
          child: new TextField(
            obscureText: _obscureText,
            controller: widget.controller,
            style: new TextStyle(color: Colours.gray_66, fontSize: 14),
            decoration: new InputDecoration(
              hintText: widget.hintText,
              hintStyle: new TextStyle(color: Colours.gray_99, fontSize: 14),
              suffixIcon: widget.hasSuffixIcon
                  ? new IconButton(
                      icon: new Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colours.gray_66,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      })
                  : null,
              focusedBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colours.green_de),
              ),
              enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colours.green_de),
              ),
            ),
          ),
        )
      ],
    );
  }
}
