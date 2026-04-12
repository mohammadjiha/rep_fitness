import 'package:flutter/cupertino.dart' show BuildContext, Widget, StatelessWidget, Color, Row, EdgeInsets, MediaQuery, BorderRadius, BoxDecoration, MainAxisAlignment, FontWeight, TextStyle, Text, SizedBox, Icon, Container, GestureDetector;
import 'package:flutter/material.dart';

class StartWorkoutButton extends StatelessWidget {
  const StartWorkoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFC8FF00),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'START WORKOUT',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFF1A1A1A),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}