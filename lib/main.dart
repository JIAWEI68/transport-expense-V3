import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/models/expense.dart';
import 'package:transport_expense_tracker/providers/all_expense.dart';
import 'package:transport_expense_tracker/screens/add_expense_screen.dart';
import 'package:transport_expense_tracker/screens/expense_list_screen.dart';
import 'package:transport_expense_tracker/widgets/app_drawer.dart';
import 'package:transport_expense_tracker/widgets/expenses_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AllExpenses>(
          create: (ctx)=> AllExpenses(),)
      ],
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MainScreen(), routes: {
        AddExpenseScreen.routeName : (_) { return AddExpenseScreen(); },
        ExpenseListScreen.routeName : (_) { return ExpenseListScreen(); },
      }
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  static String routeName = '/';
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    AllExpenses expenseList = Provider.of<AllExpenses>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Transport Expenses Tracker'),
      ),

      body: Column(
        children: [
          Image.asset('images/creditcard.png'),
          Text('Total spent: \$' +
          expenseList.getTotalSpend().toStringAsFixed(2), style:
          Theme.of(context).textTheme.titleLarge)
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}




