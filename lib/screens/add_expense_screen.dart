import 'package:flutter/material.dart';
import 'package:transport_expense_tracker/models/expense.dart';
import 'package:transport_expense_tracker/providers/all_expense.dart';

class AddExpenseScreen extends StatefulWidget {
  static String routeName = '/add-expense';

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  var form = GlobalKey<FormState>();
  String? purpose;
  String? mode;
  double? cost;
  DateTime? travelDate;

  void saveForm(AllExpenses expensesList) { bool isValid = form.currentState!.validate();
  if (isValid){
    if(travelDate==null) travelDate = DateTime.now();
    form.currentState!.save();
    print(purpose);
    print(mode);
    print(cost!.toStringAsFixed(2));
    MyExpenses.insert(0, Expense(purpose: purpose!,mode: mode!,cost:
    cost!, travelDate: travelDate!));
    //Hide the kb
    FocusScope.of(context).unfocus();

    //Reset the form
    form.currentState!.reset();
    travelDate = null;

    //Show a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Travel expense added successfully!'),));
    expensesList.addExpense(purpose, mode, cost, travelDate);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Center(
        child: Text('This is a sample Text widget'),
      ),
    );
    }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

