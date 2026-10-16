import 'package:flutter/material.dart';

import 'models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() {
    return _AddBookScreenState();
  }
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _pagesController = TextEditingController();
  final _yearController = TextEditingController();

  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        pages: int.parse(_pagesController.text.trim()),
        year: int.tryParse(_yearController.text.trim()),
      );

      Navigator.of(context).pop(book);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _pagesController.dispose();
    _yearController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value == null || value.trim().length < 2) {
                    return 'At least 2 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Author is required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _pagesController,
                decoration: const InputDecoration(
                  labelText: 'Pages',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  final number = int.tryParse(value ?? '');

                  if (number == null || number <= 0) {
                    return 'A whole number above 0';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Year (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }

                  final year = int.tryParse(value.trim());

                  if (year == null ||
                      year < 1450 ||
                      year > DateTime.now().year) {
                    return 'Enter a valid year';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              FilledButton(onPressed: _saveBook, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
