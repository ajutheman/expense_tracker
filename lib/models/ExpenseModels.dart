// import 'package:hive/hive.dart';
//
// import 'expense.dart';
//
// // part 'expense.g.dart';
//
// @HiveType(typeId: 0)
// class Expense extends HiveObject {
//   @HiveField(0)
//   late String title;
//
//   @HiveField(1)
//   late double amount;
//
//   @HiveField(2)
//   late DateTime date;
//
//   @HiveField(3)
//   late Category category;
//
//   Expense({
//     required this.title,
//     required this.amount,
//     required this.date,
//     required this.category,
//   });
//
//   // Getter for the expense key
//   int get expenseKey => key as int;
//
//   // Method to format the expense details as a string
//   String expenseDetailsAsString() {
//     return 'Title: $title, Amount: $amount, Date: $date, Category: $category';
//   }
// }

// expense.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
var formatter = DateFormat.yMd();

enum Category { work, food, leisure, travel }

const categoryIcon = {
  Category.food: Icons.lunch_dining,
  Category.leisure: Icons.movie,
  Category.travel: Icons.flight_takeoff,
  Category.work: Icons.work
};

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final Category category;

  Expense({
    required this.date,
    required this.title,
    required this.amount,
    required this.category,
  }) : id = uuid.v4();

  String get formattedDate {
    return formatter.format(date);
  }
}
