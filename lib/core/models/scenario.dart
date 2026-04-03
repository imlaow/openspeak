import 'package:flutter/material.dart';

/// Represents a learning scenario that the user can practice.
class Scenario {
  final String id;
  final String title;
  final String description;
  final String iconCodePoint; // Material icon code point
  final ScenarioDifficulty difficulty;
  final ScenarioCategory category;
  final String systemPrompt;

  const Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCodePoint,
    required this.difficulty,
    required this.category,
    required this.systemPrompt,
  });

  IconData get iconData {
    switch (id) {
      case 'daily_coffee_shop':
        return Icons.local_cafe;
      case 'daily_grocery':
        return Icons.shopping_cart;
      case 'daily_roommate':
        return Icons.people;
      case 'biz_interview':
        return Icons.business_center;
      case 'biz_meeting':
        return Icons.groups;
      case 'biz_email':
        return Icons.email;
      case 'travel_airport':
        return Icons.flight;
      case 'travel_hotel':
        return Icons.hotel;
      case 'travel_directions':
        return Icons.map;
      case 'academic_presentation':
        return Icons.school;
      case 'academic_study_group':
        return Icons.menu_book;
      case 'academic_office_hours':
        return Icons.history_edu;
      default:
        return Icons.chat_bubble_outline;
    }
  }
}

enum ScenarioDifficulty {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  final String label;
  const ScenarioDifficulty(this.label);
}

enum ScenarioCategory {
  dailyLife('Daily Life', '0xe88a'), // home icon
  business('Business', '0xef3d'), // business_center icon
  travel('Travel', '0xe539'), // flight icon
  academic('Academic', '0xe80c'); // school icon

  final String label;
  final String iconCode;
  const ScenarioCategory(this.label, this.iconCode);

  IconData get iconData {
    switch (this) {
      case ScenarioCategory.dailyLife:
        return Icons.home;
      case ScenarioCategory.business:
        return Icons.business_center;
      case ScenarioCategory.travel:
        return Icons.flight;
      case ScenarioCategory.academic:
        return Icons.school;
    }
  }
}
