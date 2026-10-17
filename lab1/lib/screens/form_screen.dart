
import 'package:flutter/material.dart';

import '../models/workshop.dart';
import '../routes.dart';

class WorkshopFormScreen extends StatefulWidget {
  const WorkshopFormScreen({
    super.key,
    required this.arguments,
  });

  final FormArguments arguments;

  @override
  State<WorkshopFormScreen> createState() {
    return _WorkshopFormScreenState();
  }
}

class _WorkshopFormScreenState extends State<WorkshopFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _title;
  late final TextEditingController _place;
  late final TextEditingController _limit;
  late final TextEditingController _description;
  late final TextEditingController _date;
  late final TextEditingController _time;

  late final FocusNode _placeFocus;
  late final FocusNode _limitFocus;

  late DanceCategory? _category;
  late bool _isOnline;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();

    final workshop = widget.arguments.workshop ?? Workshop.empty();
    final editing = widget.arguments.workshop != null;

    _title = TextEditingController(text: workshop.title);
    _place = TextEditingController(text: workshop.place);
    _limit = TextEditingController(text: workshop.limit.toString());
    _description = TextEditingController(
      text: workshop.description ?? '',
    );

    _date = TextEditingController();
    _time = TextEditingController();

    if (editing) {
      _category = workshop.category;
      _selectedDate = workshop.when;
      _selectedTime = TimeOfDay.fromDateTime(workshop.when);

      _date.text =
      '${workshop.when.day}.${workshop.when.month}.${workshop.when.year}';

      _time.text =
      '${workshop.when.hour.toString().padLeft(2, '0')}:${workshop.when.minute.toString().padLeft(2, '0')}';
    } else {
      _category = null;
    }

    _isOnline = workshop.isOnline;

    _placeFocus = FocusNode();
    _limitFocus = FocusNode();
  }

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _limit.dispose();
    _description.dispose();
    _date.dispose();
    _time.dispose();

    _placeFocus.dispose();
    _limitFocus.dispose();

    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
      _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = date;
      _date.text = '${date.day}.${date.month}.${date.year}';
    });
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime:
      _selectedTime ?? const TimeOfDay(hour: 15, minute: 0),
    );

    if (time == null || !mounted) {
      return;
    }

    setState(() {
      _selectedTime = time;
      _time.text =
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    });
  }

  void _validateForm() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Validation passed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.arguments.workshop != null;
    final workshop = widget.arguments.workshop;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing ? 'Edit workshop' : 'New workshop',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _title,
                maxLength: 60,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  _placeFocus.requestFocus();
                },
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return 'At least 3 characters';
                  }

                  if (value.trim().length > 60) {
                    return 'At most 60 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DanceCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final category in DanceCategory.values)
                    DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Choose a category';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Online workshop'),
                value: _isOnline,
                onChanged: (value) {
                  setState(() {
                    _isOnline = value;
                  });
                },
              ),
              TextFormField(
                controller: _place,
                focusNode: _placeFocus,
                textInputAction: TextInputAction.next,
                keyboardType: _isOnline
                    ? TextInputType.url
                    : TextInputType.text,
                onFieldSubmitted: (_) {
                  _limitFocus.requestFocus();
                },
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  labelText: _isOnline ? 'Meeting link' : 'Place',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }

                  if (_isOnline && !value.contains('://')) {
                    return 'Link must contain ://';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _limit,
                focusNode: _limitFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Limit',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final number = int.tryParse(value ?? '');

                  if (number == null || number < 1 || number > 500) {
                    return 'Enter a number from 1 to 500';
                  }

                  if (workshop != null && number < workshop.count) {
                    return 'Below current participant count';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _date,
                readOnly: true,
                onTap: _pickDate,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Choose date';
                  }

                  if (!editing &&
                      _selectedDate != null &&
                      _selectedTime != null) {
                    final date = _selectedDate;
                    final time = _selectedTime;

                    if (date != null && time != null) {
                      final selected = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );

                      if (!selected.isAfter(DateTime.now())) {
                        return 'Must be in the future';
                      }
                    }
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _time,
                readOnly: true,
                onTap: _pickTime,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Time',
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_selectedTime == null) {
                    return 'Choose time';
                  }

                  if (!editing && _selectedDate != null) {
                    final date = _selectedDate;
                    final time = _selectedTime;

                    if (date != null && time != null) {
                      final selected = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );

                      if (!selected.isAfter(DateTime.now())) {
                        return 'Must be in the future';
                      }
                    }
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _validateForm();
                },
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _validateForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
