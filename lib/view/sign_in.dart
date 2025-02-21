import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/auth/auth.event.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> obsecurePassword = ValueNotifier<bool>(false);
  FocusNode f1 = FocusNode();
  bool autoValidate = false;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    f1.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title:
                const Text(style: TextStyle(color: Colors.white), 'Sign In')),
        body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) async {
          if (state is AuthSuccess) {
            final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', true);
                  await prefs.setString('email', _emailController.text.toString());
            Navigator.pushReplacementNamed(context, '/customerlist');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        }, builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Form(
                  key: _formKey,
                  autovalidateMode: autoValidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(f1);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}")
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        ValueListenableBuilder(
                            valueListenable: obsecurePassword,
                            builder: (context, value, child) {
                              return TextFormField(
                                controller: _passwordController,
                                focusNode: f1,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      obsecurePassword.value =
                                          !obsecurePassword.value;
                                    },
                                    child: obsecurePassword.value
                                        ? const Icon(
                                            Icons.visibility_off,
                                          )
                                        : const Icon(
                                            Icons.visibility,
                                          ),
                                  ),
                                ),
                                obscureText: !obsecurePassword.value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              );
                            }),
                        const SizedBox(height: 8.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: (){
                            context.read<AuthBloc>().add(
                              LoginEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Center(
                              child: Text(
                                  style: TextStyle(color: Colors.white),
                                  'Sign In')),
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child:
                                const Text("Don't have an account? Create one"),
                          ),
                        )
                      ]),
                )
              ],
            ),
          );
        }));
  }
}
