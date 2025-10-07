import 'package:equatable/equatable.dart';

class SpmAttachment extends Equatable {
  final String? key;
  final String? label;

  const SpmAttachment({this.key, this.label});

  @override
  List<Object?> get props => [key, label];
}
