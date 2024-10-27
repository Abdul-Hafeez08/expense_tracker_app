import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker2/models/expense.dart';

class ExpenseItem extends StatefulWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  State<ExpenseItem> createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> {
  String? _savedCurrency;

  @override
  void initState() {
    super.initState();
    _loadSavedCurrency();
  }

  // Load the saved currency from SharedPreferences
  Future<void> _loadSavedCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedCurrency = prefs.getString('currency');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '$_savedCurrency ${widget.expense.amount.toStringAsFixed(2)}', // You may want to use the saved currency here, instead of 'Rs'
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[widget.expense.category]),
                    const SizedBox(width: 8),
                    Text(widget.expense.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
