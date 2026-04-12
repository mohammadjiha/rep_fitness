import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutTopBar extends StatelessWidget {
  const WorkoutTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2209),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFFC8FF00),
                size: 16,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'CHEST DAY',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFC8FF00),
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2209),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF6B8C3A),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}