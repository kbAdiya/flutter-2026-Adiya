import 'package:flutter/material.dart';

import 'summary_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const SignUpScreen(),
    );
  }
}

const groups = ['IT-2301', 'IT-2302', 'IT-2303', 'IT-2304', 'IT-2305'];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthController = TextEditingController();

  final _emailFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  int passwordLength = 0;

  String? _group;
  DateTime? _birth;
  bool _agreed = false;
  bool _done = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();

      setState(() {
        _done = true;
      });
    }
  }

  Future<void> _selectBirthDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _birth = picked;

      String day = picked.day.toString().padLeft(2, '0');
      String month = picked.month.toString().padLeft(2, '0');
      String year = picked.year.toString();

      _birthController.text = '$day.$month.$year';
    });
  }

  void _startOver() {
    setState(() {
      _name.clear();
      _email.clear();
      _password.clear();
      _confirm.clear();
      _birthController.clear();

      _group = null;
      _birth = null;
      _agreed = false;
      _done = false;
      passwordLength = 0;
    });
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _email,
      _password,
      _confirm,
      _birthController,
    ]) {
      controller.dispose();
    }

    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: _done ? _buildSummary() : _buildForm(),
    );
  }

  Widget _buildSummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Account created!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          SummaryCard(
            name: _name.text,
            email: _email.text,
            group: _group ?? '',
            birthDate: _birthController.text,
          ),

          const SizedBox(height: 20),

          TextButton(onPressed: _startOver, child: const Text('Start over')),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            // NAME
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                _emailFocus.requestFocus();
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if ((value ?? '').trim().length < 2) {
                  return 'Name is too short';
                }
                return null;
              },
            ),

            // EMAIL
            TextFormField(
              controller: _email,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'name@kbtu.kz',
              ),
              validator: (value) {
                String email = (value ?? '').trim();

                if (!email.contains('@') ||
                    !email.split('@').last.contains('.')) {
                  return 'Email looks wrong';
                }
                return null;
              },
            ),

            // PASSWORD
            TextFormField(
              controller: _password,
              obscureText: true,
              textInputAction: TextInputAction.next,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: const InputDecoration(
                labelText: 'Password',
                helperText: 'At least 8 characters',
              ),
              onChanged: (value) {
                setState(() {
                  passwordLength = value.length;
                });
              },
              validator: (value) {
                if ((value ?? '').length < 8) {
                  return 'Password is too short';
                }
                return null;
              },
            ),

            Text('$passwordLength of 8'),

            // CONFIRM PASSWORD
            TextFormField(
              controller: _confirm,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                if (_agreed) {
                  _submitForm();
                }
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: const InputDecoration(labelText: 'Confirm password'),
              validator: (value) {
                if (value != _password.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // GROUP
            DropdownButtonFormField<String>(
              initialValue: _group,
              decoration: const InputDecoration(labelText: 'Group'),
              items: [
                for (final group in groups)
                  DropdownMenuItem(value: group, child: Text(group)),
              ],
              onChanged: (value) {
                setState(() {
                  _group = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Choose a group';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // DATE OF BIRTH
            TextFormField(
              controller: _birthController,
              readOnly: true,
              onTap: _selectBirthDate,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: const InputDecoration(
                labelText: 'Date of birth',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (_birth == null) {
                  return 'Choose your birth date';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // CHECKBOX
            CheckboxListTile(
              title: const Text('I agree to the rules'),
              value: _agreed,
              onChanged: (value) {
                setState(() {
                  _agreed = value ?? false;
                });
              },
            ),

            const SizedBox(height: 24),

            // SIGN UP
            FilledButton(
              onPressed: _agreed ? _submitForm : null,
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
