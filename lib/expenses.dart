import 'package:expense_tracker/components/expenses/new_expense.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

import 'components/chart/chart.dart';
import 'components/expenses/expense_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      date: DateTime.now(),
      title: 'Flutter Course',
      amount: 499.0,
      category: Category.work,
      id: '3',
    ),
    Expense(
      date: DateTime.now(),
      title: 'Groceries',
      amount: 800.0,
      category: Category.food,
      id: '3',
    ),
    Expense(
      date: DateTime.now(),
      title: 'Cinema',
      amount: 1499.0,
      category: Category.leisure,
      id: '1',
    ),
    Expense(
      date: DateTime.now(),
      title: 'tea',
      amount: 1499.0,
      category: Category.leisure,
      id: '2',
    ),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void onAddExpense(Expense expense) {
    _addExpense(expense);
  }

  void onRemoveExpense(Expense expense) {
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.add(expense);
            });
          },
        ),
      ),
    );
  }

  void onEditExpense(Expense oldExpense, Expense newExpense) {
    final index = _registeredExpenses.indexOf(oldExpense);
    setState(() {
      _registeredExpenses[index] = newExpense;
    });
  }

  void _showModal() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAdd: onAddExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(onPressed: _showModal, icon: Icon(Icons.add)),
        ],
      ),
      body: SafeArea(
        child: width < height
            ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(
                    child: _registeredExpenses.isEmpty
                        ? const Center(
                            child: Text('No expenses added. Try adding some!'),
                          )
                        : ExpenseList(
                            expenses: _registeredExpenses,
                            onRemove: onRemoveExpense,
                            onEdit: onEditExpense,
                          ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(
                    child: _registeredExpenses.isEmpty
                        ? const Center(
                            child: Text('No expenses added. Try adding some!'),
                          )
                        : ExpenseList(
                            expenses: _registeredExpenses,
                            onRemove: onRemoveExpense,
                            onEdit: onEditExpense,
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}

//
//
// import 'package:expense_tracker_app/components/chart/chart.dart';
// import 'package:expense_tracker_app/components/expenses/expense_list.dart';
// import 'package:expense_tracker_app/components/expenses/new_expense.dart';
// import 'package:expense_tracker_app/models/expense.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
//
// class Expenses extends StatefulWidget {
//   const Expenses({Key? key});
//
//   @override
//   State<Expenses> createState() => _ExpensesState();
// }
//
// class _ExpensesState extends State<Expenses> {
//   late Box<Expense> _expenseBox;
//
//   @override
//   void initState() {
//     super.initState();
//     _openExpenseBox();
//   }
//
//   Future<void> _openExpenseBox() async {
//     _expenseBox = await Hive.openBox<Expense>('expenses');
//   }
//
//   void _addExpense(Expense expense) {
//     _expenseBox.add(expense);
//     setState(() {});
//   }
//
//   void onAddExpense(Expense expense) {
//     _addExpense(expense);
//   }
//
//   void onRemoveExpense(Expense expense) {
//     _expenseBox.delete(expense.id);
//     setState(() {});
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Expense deleted'),
//         duration: const Duration(seconds: 3),
//         action: SnackBarAction(
//           label: 'Undo',
//           onPressed: () {
//             _expenseBox.add(expense);
//             setState(() {});
//           },
//         ),
//       ),
//     );
//   }
//
//   void _showModal() {
//     showModalBottomSheet(
//       useSafeArea: true,
//       isScrollControlled: true,
//       context: context,
//       builder: (ctx) => NewExpense(onAdd: onAddExpense),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Expense Tracker'),
//         actions: [
//           IconButton(
//             onPressed: _showModal,
//             icon: const Icon(Icons.add),
//           )
//         ],
//       ),
//       body: FutureBuilder(
//         future: _expenseBox.isOpen ? Future.value(true) : _openExpenseBox(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return const Center(child: Text('Error occurred'));
//           }
//           return _buildExpenseList();
//         },
//       ),
//     );
//   }
//
//   Widget _buildExpenseList() {
//     return ValueListenableBuilder<Box<Expense>>(
//       valueListenable: _expenseBox.listenable(),
//       builder: (context, box, _) {
//         final expenses = box.values.toList();
//         return expenses.isEmpty
//             ? const Center(
//                 child: Text('No expenses added. Try adding some!'),
//               )
//             : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Chart(expenses: expenses),
//                     ExpenseList(
//                       expenses: expenses,
//                       onRemove: onRemoveExpense,
//                     ),
//                   ],
//                 ),
//               );
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _expenseBox.close();
//     super.dispose();
//   }
// }
