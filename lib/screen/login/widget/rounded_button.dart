import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSelected;

  const RoundedButton({super.key,
    required this.icon,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: isSelected ? ColorPalette.lavenderWhite : ColorPalette.peachGold,
      ),
      child: ElevatedButton(onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ), backgroundColor: isSelected ? ColorPalette.peachGold : ColorPalette.lavenderWhite,
        ), child: Text('One way', style: TextStyle(fontSize: 13, color:
        isSelected ? Colors.white : Colors.deepPurpleAccent

        ),),

      ),
    );
  }
}