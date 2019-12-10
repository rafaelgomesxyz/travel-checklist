import 'package:flutter/material.dart';
import 'package:travel_checklist/models/ChecklistItem.dart';

class ChecklistItemCard extends StatelessWidget {
  final ChecklistItem item;

  ChecklistItemCard(this.item);

  @override
  build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: <Widget> [
            Container(
              child: Row(
                children: <Widget> [
                  Text(
                    this.item.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.all(10.0),
      ),
      onTap: () {
        // TODO: Toggle checklist box
      },
    );
  }
}