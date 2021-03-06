import 'package:flutter/cupertino.dart';
import 'package:transport_expense_tracker/models/expense.dart';

class AllExpenses with ChangeNotifier {
  List<Expense> myExpenses = [];
  List<Expense> getMyExpenses() {
    return myExpenses;
  }

  void removeExpense(i) {
    myExpenses.removeAt(i);
    notifyListeners();
  }

  double getTotalSpend() {
    double sum = 0;
    myExpenses.forEach((element) {
      sum += element.cost;
    });
    return sum;
  }
}
