
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

  late final Workshop _original;
  late DanceCategory? _category;
  late bool _isOnline;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final editing = widget.arguments.workshop != null;
    _original = widget.arguments.workshop ?? Workshop.empty();

    _title = TextEditingController(text: _original.title);
    _place = TextEditingController(text: _original.place);
    _limit = TextEditingController(
      text: _original.limit.toString(),
    );
    _description = TextEditingController(
      text: _original.description ?? '',
    );

    _date = TextEditingController();
    _time = TextEditingController();

    if (editing) {
      _category = _original.category;
      _selectedDate = _original.when;
      _selectedTime = TimeOfDay.fromDateTime(_original.when);

      _date.text =
      '${_original.when.day}.${_original.when.month}.${_original.when.year}';

      _time.text =
      '${_original.when.hour.toString().padLeft(2, '0')}:${_original.when.minute.toString().padLeft(2, '0')}';
    } else {
      _category = null;
    }

    _isOnline = _original.isOnline;

    _placeFocus = FocusNode();
    _limitFocus = FocusNode();
  }

  bool get _dirty {
    final editing = widget.arguments.workshop != null;

    String initialDate = '';
    String initialTime = '';

    if (editing) {
      initialDate =
      '${_original.when.day}.${_original.when.month}.${_original.when.year}';

      initialTime =
      '${_original.when.hour.toString().padLeft(2, '0')}:${_original.when.minute.toString().padLeft(2, '0')}';
    }

    DanceCategory? initialCategory;

    if (editing) {
      initialCategory = _original.category;
    }

    return _title.text != _original.title ||
        _place.text != _original.place ||
        _limit.text != _original.limit.toString() ||
        _description.text != (_original.description ?? '') ||
        _category != initialCategory ||
        _isOnline != _original.isOnline ||
        _date.text != initialDate ||
        _time.text != initialTime;
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

  Future<void> _confirmExit() async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Discard changes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Keep editing'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );

    if (discard == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final date = _selectedDate;
    final time = _selectedTime;

    if (date == null || time == null) {
      return;
    }

    final selectedWhen = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _saving = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) {
      return;
    }

    final result = _original.copyWith(
      title: _title.text.trim(),
      category: _category,
      when: selectedWhen,
      limit: int.parse(_limit.text.trim()),
      isOnline: _isOnline,
      place: _place.text.trim(),
      description: _description.text.trim().isEmpty
          ? null
          : _description.text.trim(),
      clearDescription: _description.text.trim().isEmpty,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.arguments.workshop != null;

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        await _confirmExit();
      },
      child: Scaffold(
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
                  onChanged: (value) {
                    setState(() {});
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
                  onChanged: (value) {
                    setState(() {});
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
                  onChanged: (value) {
                    setState(() {});
                  },
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: const InputDecoration(
                    labelText: 'Limit',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final number = int.tryParse(value ?? '');

                    if (number == null ||
                        number < 1 ||
                        number > 500) {
                      return 'Enter a number from 1 to 500';
                    }

                    if (editing && number < _original.count) {
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
                    final date = _selectedDate;

                    if (date == null) {
                      return 'Choose date';
                    }

                    final time = _selectedTime;

                    if (!editing && time != null) {
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
                    final time = _selectedTime;

                    if (time == null) {
                      return 'Choose time';
                    }

                    final date = _selectedDate;

                    if (!editing && date != null) {
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

                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _description,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    setState(() {});
                  },
                  onFieldSubmitted: (_) {
                    _save();
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
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const CircularProgressIndicator()
                      : const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
