part of 'createspm_cubit.dart';

enum ServiceCategoryStatus { initial, loading, success, error }

enum ResidentStatus { initial, loading, success, error }

enum VerifyNikNameStatus { initial, loading, success, error }

enum FormStatus { initial, loading, success, error }

class CreateSpmState extends Equatable {
  final ServiceCategoryStatus serviceCategoryStatus;
  final List<ServiceCategory> serviceCategories;
  final String? serviceCategoryError;
  final ResidentStatus residentStatus;
  final Resident? resident;
  final String? residentError;
  final VerifyNikNameStatus verifyNikNameStatus;
  final Response? verifyNikNameResponse;
  final String? verifyNikNameError;
  final FormStatus formStatus;
  final Response? formResponse;
  final String? formError;

  const CreateSpmState({
    this.serviceCategoryStatus = ServiceCategoryStatus.initial,
    this.serviceCategories = const [],
    this.serviceCategoryError,
    this.residentStatus = ResidentStatus.initial,
    this.resident,
    this.residentError,
    this.verifyNikNameStatus = VerifyNikNameStatus.initial,
    this.verifyNikNameResponse,
    this.verifyNikNameError,
    this.formStatus = FormStatus.initial,
    this.formResponse,
    this.formError,
  });

  CreateSpmState copyWith({
    ServiceCategoryStatus? serviceCategoryStatus,
    List<ServiceCategory>? serviceCategories,
    String? serviceCategoryError,
    ResidentStatus? residentStatus,
    Resident? resident,
    String? residentError,
    VerifyNikNameStatus? verifyNikNameStatus,
    Response? verifyNikNameResponse,
    String? verifyNikNameError,
    FormStatus? formStatus,
    Response? formResponse,
    String? formError,
  }) {
    return CreateSpmState(
      serviceCategoryStatus:
          serviceCategoryStatus ?? this.serviceCategoryStatus,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      serviceCategoryError: serviceCategoryError,
      residentStatus: residentStatus ?? this.residentStatus,
      resident: resident,
      residentError: residentError,
      verifyNikNameStatus: verifyNikNameStatus ?? this.verifyNikNameStatus,
      verifyNikNameResponse: verifyNikNameResponse,
      verifyNikNameError: verifyNikNameError,
      formStatus: formStatus ?? this.formStatus,
      formResponse: formResponse,
      formError: formError,
    );
  }

  @override
  List<Object?> get props => [
    serviceCategoryStatus,
    serviceCategories,
    serviceCategoryError,
    residentStatus,
    resident,
    residentError,
    verifyNikNameStatus,
    verifyNikNameResponse,
    verifyNikNameError,
    formStatus,
    formResponse,
    formError,
  ];
}
