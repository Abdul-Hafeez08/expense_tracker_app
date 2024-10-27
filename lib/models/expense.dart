import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category {
  food,
  travel,
  education,
  shopping,
  health,
  home,
  // ignore: constant_identifier_names
  Bills_Utilities,
  other,
}

const categoryIcons = {
  Category.food: FontAwesomeIcons.utensils,
  Category.travel: FontAwesomeIcons.car,
  Category.education: FontAwesomeIcons.book,
  Category.shopping: FontAwesomeIcons.bagShopping,
  Category.health: FontAwesomeIcons.hospital,
  Category.home: FontAwesomeIcons.house,
  Category.Bills_Utilities: FontAwesomeIcons.moneyBillWave,
  Category.other: FontAwesomeIcons.list
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  toJson() {}

  static fromJson(decode) {}
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount; // sum = sum + expense.amount
    }

    return sum;
  }
}
