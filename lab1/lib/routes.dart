
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
  });

  final Workshop workshop;
  final String profileName;
}

class FormArguments {
  const FormArguments({
    this.workshop,
  });

  final Workshop? workshop;
}
