import 'package:equatable/equatable.dart';

class ServiceType extends Equatable {
  final String? nameIndonesian;
  final String? nameEnglish;

  const ServiceType({this.nameIndonesian, this.nameEnglish});

  @override
  List<Object?> get props => [nameIndonesian, nameEnglish];
}
