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
        ChangeNotifierProvider<AllExpenses>(create: (ctx)=> AllExpenses(),)
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
  var form = GlobalKey<FormState>();

  String? purpose;

  String? mode;

  double? cost;

  DateTime? travelDate;

  List <Expense> myExpenses = [];

  void removeItem(i){
    showDialog<Null>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(onPressed: (){
                setState(() {
                  myExpenses.removeAt(i);
                });
                Navigator.of(context).pop();
              }, child: Text('Yes')),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('No')),
            ],
          );
        });
  }

  void saveForm () {

    }
  }

  void presentDatePicker(BuildContext context){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days:14)),
      lastDate: DateTime.now(),
    ).then((value){
      if(value==null) return;
        setState(() {
          travelDate = value;
        });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Transport Expenses Tracker'),
        actions: [
          IconButton(onPressed: saveForm, icon: Icon(Icons.save))
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
              validator: (value){
                if(value==null) {
                  return "Please provide a mode of transport.";
                } else {
                  return null;
                }
              },
              onChanged: (value) {mode = value as String;},
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(label: Text('Cost')),
              validator: (value){
                if(value==null) {
                  return "Please provide a travel cost.";

                }
                else if (double.tryParse(value) == null) {
                  return "Please provide a valid travel cost.";
                } else {
                  return null;
                }
              },
              onSaved: (value) {cost = double.parse(value!); },
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
              onSaved: (value) {purpose = value;},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(travelDate == null? 'No Date Chosen': "Picked Date: " +
                DateFormat('dd/MM/yyyy').format(travelDate!)),
                TextButton(
                    child: Text('Choose Date', style: TextStyle(fontWeight:
                    FontWeight.bold)),
                    onPressed: () {presentDatePicker(context);} ),
              ],
            ),


      ],
          )
        )

      ),
      drawer: AppDrawer(),
    );
  }
}
