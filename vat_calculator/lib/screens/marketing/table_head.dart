import 'package:flutter/material.dart';
import 'table_cell.dart';

class TableHead extends StatelessWidget {
  final ScrollController scrollController;

  TableHead({
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cellWidth,
      child: Row(
        children: [
          MultiplicationTableCell(
            color: Colors.yellow.withOpacity(0.3),
            value: 1,
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(20 - 1, (index) {
                return MultiplicationTableCell(
                  color: Colors.white.withOpacity(0.3),
                  value: index + 2,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
