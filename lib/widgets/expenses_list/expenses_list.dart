import 'package:flutter/material.dart';

import 'package:expense_tracker2/widgets/expenses_list/expense_item.dart';
import 'package:expense_tracker2/models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
          child: const Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Delete Item",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                SizedBox(width: 50),
                Text(
                  "Delete Item",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ],
            ),
          ),
        ),
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(
          expenses[index],
        ),
      ),
    );
  }
}
