import 'package:flutter/material.dart';

class RankingUser {
  final String name;
  final String score;
  final Color avatarBackgroundColor;
  final Color? flagColor;
  final int? rank;

  RankingUser({
    required this.name,
    required this.score,
    this.avatarBackgroundColor = Colors.lightBlue,
    this.flagColor,
    this.rank,
  });
}