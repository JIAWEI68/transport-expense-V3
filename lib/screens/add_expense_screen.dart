import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/models/expense.dart';
import 'package:transport_expense_tracker/providers/all_expense.dart';

class AddExpenseScreen extends StatefulWidget {
  static String routeName = '/add-expense';

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();}



class _AddExpenseScreenState extends State<AddExpenseScreen> {

  var form = GlobalKey<FormState>();
  String? purpose;
  String? mode;
  double? cost;
  DateTime? travelDate;

  void saveForm(AllExpenses expenseList) {
    expenseList.addExpense(purpose, mode, cost, travelDate);
    bool isValid = form.currentState!.validate();
  }

  void presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 14)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        travelDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AllExpenses expenseList = Provider.of<AllExpenses>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        actions: [
          IconButton(onPressed: () {
            saveForm(expenseList);
          }, icon:
          Icon(Icons.save))
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Form(
              key: form,
              child: Column(children: [
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    label: Text('Mode of Transport'),
                  ),
                  items: [
                    DropdownMenuItem(child: Text('Bus'), value: 'bus'),
                    DropdownMenuItem(child: Text('Grab'), value: 'grab'),
                    DropdownMenuItem(child: Text('MRT'), value: 'mrt'),
                    DropdownMenuItem(child: Text('Taxi'), value: 'taxi'),
                  ],
                  validator: (value) {
                    if (value == null) {
                      return "Please provide a mode of transport.";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    mode = value as String;
                  },

                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(label: Text('Cost')),
                  validator: (value) {
                    if (value == null) {
                      return "Please provide a travel cost.";
                    }
                    else if (double.tryParse(value) == null) {
                      return "Please provide a valid travel cost.";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    cost = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(label: Text('Purpose')),
                  validator: (value) {
                    if (value == null)
                      return 'Please provide a purpose.';
                    else if (value.length < 5)
                      return 'Please enter a description that is at least 5 characters.';
                    else
                      return null;
                  },
                  onSaved: (value) {
                    purpose = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(travelDate == null
                        ? 'No Date Chosen'
                        : "Picked Date: " +
                        DateFormat('dd/MM/yyyy').format(travelDate!)),
                    TextButton(
                        child: Text('Choose Date', style: TextStyle(fontWeight:
                        FontWeight.bold)),
                        onPressed: () {
                          presentDatePicker(context);
                        }),
                  ],
                ),


              ],
              )
          )
      ),
    );
  }
}





