import 'package:flutter/material.dart';
import '../../controller/match_controller.dart';
import 'HexagonCard.dart';

class DraggableCard extends StatefulWidget {
  final HexagonCard card;
  final MapEntry<int, HexagonCard> entry; // Changed index to MapEntry<int, HexagonCard>
  final Function(int) onSwipe; // Modified onSwipe callback to accept index
  final MatchController recordsController; // Add your controller here

  const DraggableCard({
    Key? key,
    required this.card,
    required this.entry,
    required this.onSwipe,
    required this.recordsController, // Pass your controller here
  }) : super(key: key);

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  double _dragPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragPosition += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        if (widget.entry.key != widget.recordsController.cardDeck.length - 1) {
          if (_dragPosition > 100) {
            // Swiped right
            widget.onSwipe(widget.entry.key); // Pass index to onSwipe callback
          } else if (_dragPosition < -100) {
            // Swiped left
            widget.onSwipe(widget.entry.key); // Pass index to onSwipe callback
          }
        }
        setState(() {
          _dragPosition = 0.0;
        });
      },
      child: Transform.translate(
        offset: Offset(_dragPosition, 0.0),
        child: widget.card,
      ),
    );
  }
}