import 'package:flutter/material.dart';

class BadgedIcon extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String value;
  final Function onPressed;

  const BadgedIcon({
    Key key,
    this.color,
    @required this.icon,
    @required this.value, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(icon: Icon(icon), onPressed: onPressed),
        Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color:
                      (color != null) ? color : Theme.of(context).accentColor),
              constraints: BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ))
      ],
    );
  }
}
