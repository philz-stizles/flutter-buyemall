import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ListTileCard extends StatelessWidget {
  const ListTileCard({
    Key key,
    this.title,
    this.subTitle,
    this.trailing,
    this.leading,
  }) : super(key: key);

  final String leading;
  final String title;
  final String subTitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
              child: FittedBox(
            child: Text(
              leading,
              style: TextStyle(fontSize: 12),
            ),
          )),
          title: Text(title),
          subtitle: Text(subTitle),
          trailing: Text(trailing),
        ),
      ),
    );
  }
}

class DismissibleTileCard extends StatelessWidget {
  const DismissibleTileCard({
    Key key,
    this.title,
    this.subTitle,
    this.trailing,
    this.leading,
    this.id, this.onDismissed,
  }) : super(key: key);

  final String id;
  final String leading;
  final String title;
  final String subTitle;
  final String trailing;
  final Function onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          MdiIcons.trashCan,
          size: 30,
          color: Colors.white,
        ),
      ),
      onDismissed: onDismissed,
      child: ListTileCard(leading: leading, title: title, subTitle: subTitle, 
        trailing: trailing,)
    );
  }
}
