import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/models/expense.dart';
import 'package:transport_expense_tracker/providers/all_expense.dart';
import 'package:transport_expense_tracker/providers/all_expenses.dart';
import 'package:transport_expense_tracker/services/firestore_service.dart';

class EditExpenseScreen extends StatefulWidget {
  static String routeName = '/edit-expense';

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  var form = GlobalKey<FormState>();

  String? purpose;

  String? mode;

  double? cost;

  DateTime? travelDate;
  void saveForm(String id){
    bool isValid = form.currentState!.validate();
    if(isValid == null) {
      travelDate = DateTime.now();
    }

    form.currentState!.save();
    print(purpose);
    print(mode);
    print(cost!.toStringAsFixed(2));

    FirestoreService fsService = FirestoreService();
    fsService.editExpense(id,purpose, mode, cost,travelDate);

    //hides keyboard
    FocusScope.of(context).unfocus();

    //resets form
    form.currentState!.reset();
    travelDate = null;

    //shows a snackbar (popup)
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Travel expense added sucessfully!'),));
  }
  void presentDatePicker(BuildContext context){
    //creates date picker and sets default date
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 14)), //sets first possible date that is settable
      lastDate: DateTime.now(),
    ).then((value) { // sets last possible date
      if(value == null) return;

      setState(() {
        travelDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Expense selectedExpense = ModalRoute.of(context)?.settings.arguments as
    Expense;
    if (travelDate == null) travelDate = selectedExpense.travelDate;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
        actions: [
          IconButton( onPressed: (){ saveForm(selectedExpense.id);}, icon: const Icon(Icons.save))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: form,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: selectedExpense.mode,
                decoration: const InputDecoration(
                  label: const Text('Mode of Transport'),
                ),
                items: [
                  const DropdownMenuItem(child: Text('Bus'), value: 'bus'),
                  const DropdownMenuItem(child: Text('Grab'), value: 'grab'),
                  const DropdownMenuItem(child: const Text('MRT'), value: 'mrt'),
                  const DropdownMenuItem(child: const Text('Taxi'), value: 'taxi'),
                ],
                validator: (value){
                  if(value == null){
                    return "Please Provide a mode of Transport.";
                  } else{
                    return null;
                  }
                },
                onChanged: (value) { mode = value as String;},
                onSaved: (value) { mode = value as String; },
              ),
              TextFormField(
                initialValue: selectedExpense.cost.toStringAsFixed(2),
                decoration: const InputDecoration(label: const Text('Cost')),
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value == null){
                    return "Please Provide the travel cost";
                  } else if (double.tryParse(value) == null){
                    return "Please enter a valid travel cost.";
                  } else{
                    return null;
                  }
                },
                onSaved: (value) { cost = double.parse(value!) ;}, //changed from cost = double.parse(value!);
              ),
              TextFormField(
                initialValue: selectedExpense.purpose,
                decoration: const InputDecoration(label: Text('Purpose')),
                validator: (value){
                  if(value == null){
                    return "Please Provide a purpose";
                  } else if (value.length < 5){
                    return "Please enter a description that is minimally 5 characters.";
                  } else{
                    return null;
                  }
                },
                onSaved: (value) {purpose = value;},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(travelDate == null ? 'No Date Chosen' : "Picked date: " + DateFormat('dd/MM/yyyy').format(travelDate!)),
                  // if date = null, no date chosen. else picked date + date
                  TextButton(
                      child: const Text('Choose Date', style: TextStyle(fontWeight:
                      FontWeight.bold)),
                      onPressed: () {presentDatePicker(context);} )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}




