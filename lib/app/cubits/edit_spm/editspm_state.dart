part of 'editspm_cubit.dart';

enum ServiceCategoryStatus { initial, loading, success, error }

enum FormStatus { initial, loading, success, error }

class EditSpmState extends Equatable {
  final ServiceCategoryStatus serviceCategoryStatus;
  final List<ServiceCategory> serviceCategories;
  final String? serviceCategoryError;
  final FormStatus formStatus;
  final Response? formResponse;
  final String? formError;

  const EditSpmState({
    this.serviceCategoryStatus = ServiceCategoryStatus.initial,
    this.serviceCategories = const [],
    this.serviceCategoryError,
    this.formStatus = FormStatus.initial,
    this.formResponse,
    this.formError,
  });

  EditSpmState copyWith({
    ServiceCategoryStatus? serviceCategoryStatus,
    List<ServiceCategory>? serviceCategories,
    String? serviceCategoryError,
    FormStatus? formStatus,
    Response? formResponse,
    String? formError,
  }) {
    return EditSpmState(
      serviceCategoryStatus:
          serviceCategoryStatus ?? this.serviceCategoryStatus,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      serviceCategoryError: serviceCategoryError,
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
    formStatus,
    formResponse,
    formError,
  ];
}
