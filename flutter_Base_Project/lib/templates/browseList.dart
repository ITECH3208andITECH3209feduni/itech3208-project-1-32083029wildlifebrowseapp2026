import 'package:flutter/material.dart';
import 'dart:math';

class BrowseList extends StatefulWidget {
  const BrowseList({super.key, required this.browses});
  
  final List<String> browses;

  @override
  State<BrowseList> createState() => _BrowseList();
 }

class _BrowseList extends State<BrowseList> {
  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < widget.browses.length; i++)
                Text('${widget.browses[i]}'),
            ],
          );
  }
}

class BrowseQuantityList extends StatefulWidget {
  const BrowseQuantityList({
    super.key, 
    required this.browses, 
    required this.quantities, 
    this.fontColor = Colors.black
  });
  
  final List<String> browses;
  final List<int> quantities;
  final Color fontColor;

  @override
  State<BrowseQuantityList> createState() => _BrowseQuantityList();
 }

class _BrowseQuantityList extends State<BrowseQuantityList> {
  @override
  Widget build(BuildContext context) {
    // Bool that checks if browse list is Greater Than two
    bool isBrowseGTTwo = widget.browses.length > 2 ? true : false;

    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gets the smallest of either the browses or 2 to ensure only a max of two browse are listed on the requestTile
            // Quantities and Browses length should always be the same but this is to handle in case it doesn't
            for (int i = 0; i < min(min(widget.browses.length, widget.quantities.length), 2); i++)
              Text(
                '${widget.quantities[i]}x ',
                style: TextStyle(
                  color: widget.fontColor,
                )
              )
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gets the smallest of either the browses or 2 to ensure only a max of two browse are listed on the requestTile
            // Quantities and Browses length should always be the same but this is to handle in case it doesn't
            for (int i = 0; i < min(min(widget.browses.length, widget.quantities.length), 2); i++)
              Text(
                // Checks if there's more than 2 browse listed adding an elipse to the second one to indicate there's more  on the requestTile
                (isBrowseGTTwo && i == 1)
                ? '${widget.browses[i]}...'
                : '${widget.browses[i]}',
                style: TextStyle(
                  color: widget.fontColor,
                )
              ),
          ],
        ),
      ]
    );
  }
}