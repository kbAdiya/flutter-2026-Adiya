import 'package:flutter/material.dart';

import 'api/fake_api.dart';
import 'widgets/loading_view.dart';
import 'widgets/error_view.dart';
import 'widgets/empty_view.dart';
import 'widgets/student_list.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({
    super.key,
    required this.api,
  });

  final FakeApi api;

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student>? _students;
  Object? _error;
  bool _saving = false;

  Future<void> _load() async {
    setState(() {
      _students = null;
      _error = null;
    });

    try {
      final list = await widget.api.fetchStudents();

      if (!mounted) return;

      setState(() {
        _students = list;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _save() async {
    if (_students == null || _saving) return;

    final count = _students!.length;

    setState(() {
      _saving = true;
    });

    try {
      await widget.api.save(count);

      if (!mounted) return;

      Navigator.pop(context);
    } on StateError catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );

      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_error != null) {
      content = ErrorView(onRetry: _load);
    } else if (_students == null) {
      content = const LoadingView();
    } else if (_students!.isEmpty) {
      content = const EmptyView();
    } else {
      content = StudentList(students: _students!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: content,
      floatingActionButton: _students == null || _students!.isEmpty
          ? null
          : FloatingActionButton(
        onPressed: _saving ? null : _save,
        child: _saving
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : const Icon(Icons.save),
      ),
    );
  }
}