import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker2/widgets/new_expense.dart';
import 'package:expense_tracker2/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker2/models/expense.dart';
import 'package:expense_tracker2/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];
  String? _selectedCurrency;
  @override
  void initState() {
    super.initState();
    _loadExpensesFromLocalStorage();
    //for Currency
    _loadCurrency();
  }

//load from saved currency
  Future<void> _loadCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = prefs.getString('currency');
    });
    if (_selectedCurrency == null) {
      _showCurrencyDialog();
    }
  }

  //save in local storage
  Future<void> _saveCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
    setState(() {
      _selectedCurrency = currency;
    });
  }

  // Show dialog to select currency
  void _showCurrencyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Currency'),
          content: DropdownButton<String>(
            value: _selectedCurrency,
            onChanged: (String? newValue) {
              if (newValue != null) {
                _saveCurrency(newValue);
                Navigator.of(context).pop();
              }
            },
            items: <String>['USD', 'EUR', 'PKR', 'INR']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  double calculateTotalExpenses() {
    double sum = 0;

    for (final expense in _registeredExpenses) {
      sum += expense.amount;
    }

    return sum;
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) async {
    setState(() {
      _registeredExpenses.add(expense);
    });
    _saveExpensesToLocalStorage();
  }

  Future<void> _removeExpense(Expense expense) async {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: const Text('Expense Deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
    _saveExpensesToLocalStorage();
  }

  Future<void> _saveExpensesToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> expensesStringList =
          _registeredExpenses.map((expense) {
        return "${expense.title},${expense.amount},${expense.date},${expense.category.index}";
      }).toList();
      await prefs.setStringList('expenses', expensesStringList);
    } catch (e) {
      // print("Error saving expenses: $e");
    }
  }

  Future<void> _loadExpensesFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? expensesStringList = prefs.getStringList('expenses');

      if (expensesStringList != null) {
        final List<Expense> loadedExpenses =
            expensesStringList.map((expenseString) {
          final parts = expenseString.split(',');
          return Expense(
            title: parts[0],
            amount: double.parse(parts[1]),
            date: DateTime.parse(parts[2]),
            category: Category.values[int.parse(parts[3])],
          );
        }).toList();

        setState(() {
          _registeredExpenses.clear();
          _registeredExpenses.addAll(loadedExpenses);
        });
      }
    } catch (e) {
      // print("Error loading expenses: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    //final hight = MediaQuery.of(context).size.height;

    Widget mainContent = const Center(
      child: Text('No expenses found!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Text(
                  "Total Expense = $_selectedCurrency ${calculateTotalExpenses().toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 165, 125, 2),
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
