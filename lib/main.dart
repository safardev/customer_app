import 'package:customer_app/blocs/auth/auth_bloc.dart';
import 'package:customer_app/view/add_customer_page.dart';
import 'package:customer_app/view/customer_list.dart';
import 'package:customer_app/view/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/add_customer/customer_bloc.dart';
import 'models/customer_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CustomerAdapter());
  await Hive.openBox<Customer>('customers');
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MaterialApp(
    title: 'Flutter Test',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: MultiBlocProvider(providers: [
      BlocProvider(
        create: (BuildContext context) => AuthBloc(),
      ),
      BlocProvider(
        create: (BuildContext context) => CustomerBloc(),
      ),
    ], child: isLoggedIn ? CustomerList() : SignIn()),
    routes: {
      '/signin': (context) => const SignIn(),
      '/customerlist': (context) => const CustomerList(),
      '/addcustomer': (context) => const AddCustomerPage(),
    },
  ));
}
