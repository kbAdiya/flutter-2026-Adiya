import 'package:flutter/material.dart';

import 'models/workshop.dart';

abstract final class Routes {
  static const shell = '/';
  static const detail = '/detail';
  static const form = '/form';
}

class DetailArguments {
  const DetailArguments({
    required this.workshop,
    required this.profileName,
    required this.onUpdate,
    required this.onDelete,
    required this.goToProfile,
  });

  final Workshop workshop;
  final String profileName;
  final ValueChanged<Workshop> onUpdate;
  final ValueChanged<Workshop> onDelete;
  final VoidCallback goToProfile;
}

class FormArguments {
  const FormArguments({this.workshop});

  final Workshop? workshop;
}
