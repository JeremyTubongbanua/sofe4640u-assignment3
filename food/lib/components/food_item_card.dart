import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food/models/food_item.dart';

class FoodItemCard extends StatefulWidget {
  final FoodItem item;
  final VoidCallback onTap;
  final bool isAffordable;

  const FoodItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.isAffordable = true,
  });

  @override
  _FoodItemCardState createState() => _FoodItemCardState();
}

class _FoodItemCardState extends State<FoodItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isAffordable) {
      _animationController
        ..reset()
        ..forward();
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: MouseRegion(
        onEnter: (event) {
          if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
            setState(() {
              _isHovered = true;
            });
          }
        },
        onExit: (event) {
          if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
            setState(() {
              _isHovered = false;
            });
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final scale = 1.0 + (_animationController.value * 0.2); // Pop effect
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Card(
            elevation: _isHovered ? 6 : 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: widget.isAffordable ? Colors.white : Colors.grey.shade300,
            child: Opacity(
              opacity: widget.isAffordable ? 1.0 : 0.5,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.item.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\$${widget.item.cost.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
