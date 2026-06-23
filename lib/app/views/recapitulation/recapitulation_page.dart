import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/recapitulation/recapitulation_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/recapitulation/components/recapitulation_card.dart';
import 'package:panduan/app/views/recapitulation/widgets/recapitulation_body.dart';
import 'package:panduan/app/views/recapitulation/widgets/recapitulation_header.dart';

class RecapitulationPage extends StatefulWidget {
  const RecapitulationPage({required this.recapitulationLevel, super.key});

  static const String routeName = '/recapitulation';

  final String recapitulationLevel;

  @override
  State<RecapitulationPage> createState() => _RecapitulationPageState();
}

class _RecapitulationPageState extends State<RecapitulationPage> {
  //   final _searchKeywordController = TextEditingController();
  //   String _searchKeyword = '';
  //   List<Equatable> _searchResults = [];

  List<DateTime> _selectedRangeDates = [
    DateTime(DateTime.now().year, 1, 1),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  ];
  final _rangeDateController = TextEditingController();

  //   void _onSearchRecapitulation(String? value) {
  //     if (value == null) {
  //       setState(() {
  //         _searchKeyword = '';
  //         _searchResults.clear();
  //         _searchKeywordController.clear();
  //       });
  //       return;
  //     }

  //     setState(() {
  //       _searchKeyword = value.trim().toLowerCase();
  //       if (_searchKeyword.isEmpty) {
  //         _searchResults.clear();
  //         _searchKeywordController.clear();
  //       } else {
  //         _searchResults = _recapitulations.where((e) {
  //           final name = widget.recapitulationLevel == 'district'
  //               ? (e as SpmDistrictCount).district ?? ''
  //               : widget.recapitulationLevel == 'subdistrict'
  //               ? (e as SpmSubDistrictCount).subDistrict ?? ''
  //               : (e as SpmHpCount).healthPost ?? '';

  //           return name.toLowerCase().contains(_searchKeyword);
  //         }).toList();
  //       }
  //     });
  //   }

  void _initRangeDate() async {
    final isFirstYear =
        _selectedRangeDates.first.day == _selectedRangeDates.last.day &&
        _selectedRangeDates.first.month == _selectedRangeDates.last.month &&
        _selectedRangeDates.first.year == _selectedRangeDates.last.year;

    if (isFirstYear) {
      _rangeDateController.text = AppHelpers.rangeDateFormat(
        _selectedRangeDates.first,
      );
    } else {
      _rangeDateController.text =
          '${AppHelpers.rangeDateFormat(_selectedRangeDates.first)} - ${AppHelpers.rangeDateFormat(_selectedRangeDates.last)}';
    }
  }

  Future<void> _initFetchByLevel() async {
    switch (widget.recapitulationLevel) {
      case 'district':
        context.read<RecapitulationCubit>().fetchSpmDistrictCount(
          startDate: _selectedRangeDates.first,
          endDate: _selectedRangeDates.last,
        );
        break;
      case 'subdistrict':
        context.read<RecapitulationCubit>().fetchSpmSubDistrictCount(
          startDate: _selectedRangeDates.first,
          endDate: _selectedRangeDates.last,
        );
        break;
      case 'healthpost':
        context.read<RecapitulationCubit>().fetchSpmHpCount(
          startDate: _selectedRangeDates.first,
          endDate: _selectedRangeDates.last,
        );
        break;
      default:
        break;
    }
  }

  String get _title {
    switch (widget.recapitulationLevel) {
      case 'district':
        return 'Rekapitulasi SPM Kecamatan';
      case 'subdistrict':
        return 'Rekapitulasi SPM Kelurahan';
      case 'healthpost':
        return 'Rekapitulasi SPM Posyandu';
      default:
        return 'Rekapitulasi SPM';
    }
  }

  @override
  void initState() {
    super.initState();
    _initRangeDate();
    _initFetchByLevel();
  }

  @override
  void dispose() {
    _rangeDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          _title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocSelector<RecapitulationCubit, RecapitulationState, bool>(
        selector: (state) {
          switch (widget.recapitulationLevel) {
            case 'district':
              return state.spmDistrictCountStatus == Status.success &&
                  state.spmDistrictCounts.isNotEmpty;
            case 'subdistrict':
              return state.spmSubDistrictCountStatus == Status.success &&
                  state.spmSubDistrictCounts.isNotEmpty;
            case 'healthpost':
              return state.spmHpCountStatus == Status.success &&
                  state.spmHpCounts.isNotEmpty;
            default:
              return false;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              if (state) ...{
                RecapitulationHeader(
                  rangeDateController: _rangeDateController,
                  selectedRangeDates: _selectedRangeDates,
                  onSelectedRangeDate: (selectedRangeDates) {
                    _selectedRangeDates = selectedRangeDates;
                    _rangeDateController.text =
                        selectedRangeDates.first.isAtSameMomentAs(
                          selectedRangeDates.last,
                        )
                        ? AppHelpers.rangeDateFormat(_selectedRangeDates.first)
                        : '${AppHelpers.rangeDateFormat(_selectedRangeDates.first)} - ${AppHelpers.rangeDateFormat(_selectedRangeDates.last)}';

                    setState(() {});

                    switch (widget.recapitulationLevel) {
                      case 'district':
                        context
                            .read<RecapitulationCubit>()
                            .refetchSpmDistrictCount(
                              startDate: _selectedRangeDates.first,
                              endDate: _selectedRangeDates.last,
                            );
                        break;
                      case 'subdistrict':
                        context
                            .read<RecapitulationCubit>()
                            .refetchSpmSubDistrictCount(
                              startDate: _selectedRangeDates.first,
                              endDate: _selectedRangeDates.last,
                            );
                        break;
                      case 'healthpost':
                        context.read<RecapitulationCubit>().refetchSpmHpCount(
                          startDate: _selectedRangeDates.first,
                          endDate: _selectedRangeDates.last,
                        );
                        break;
                      default:
                        break;
                    }
                  },
                ),
              },
              Expanded(
                child: BlocBuilder<RecapitulationCubit, RecapitulationState>(
                  builder: (context, state) {
                    switch (widget.recapitulationLevel) {
                      case 'district':
                        return RecapitulationBody(
                          status: state.spmDistrictCountStatus,
                          errorMessage: state.spmDistrictCountError ?? '',
                          emptyMessage: 'Rekapitulasi SPM Kecamatan Kosong',
                          onRefetch: () {
                            context
                                .read<RecapitulationCubit>()
                                .refetchSpmDistrictCount(
                                  startDate: _selectedRangeDates.first,
                                  endDate: _selectedRangeDates.last,
                                );
                          },
                          items: state.spmDistrictCounts,
                          itemBuilder: (context, index, item) {
                            return RecapitulationCard(
                              label: 'Kecamatan',
                              title: item.district ?? '',
                              total: item.total ?? 0,
                              pendidikan: item.pendidikan ?? 0,
                              kesehatan: item.kesehatan ?? 0,
                              pekerjaanUmum: item.pekerjaanUmum ?? 0,
                              perumahanRakyat: item.perumahanRakyat ?? 0,
                              sosial: item.sosial ?? 0,
                              trantibumLinmas: item.trantibumLinmas ?? 0,
                              lainnya: item.lainnya ?? 0,
                              dataLength: state.spmDistrictCounts.length,
                              index: index,
                            );
                          },
                        );
                      case 'subdistrict':
                        return RecapitulationBody(
                          status: state.spmSubDistrictCountStatus,
                          errorMessage: state.spmSubDistrictCountError ?? '',
                          emptyMessage: 'Rekapitulasi SPM Kelurahan Kosong',
                          onRefetch: () {
                            context
                                .read<RecapitulationCubit>()
                                .refetchSpmSubDistrictCount(
                                  startDate: _selectedRangeDates.first,
                                  endDate: _selectedRangeDates.last,
                                );
                          },
                          items: state.spmSubDistrictCounts,
                          itemBuilder: (context, index, item) {
                            return RecapitulationCard(
                              label: 'Kelurahan',
                              title: item.subDistrict ?? '',
                              total: item.total ?? 0,
                              pendidikan: item.pendidikan ?? 0,
                              kesehatan: item.kesehatan ?? 0,
                              pekerjaanUmum: item.pekerjaanUmum ?? 0,
                              perumahanRakyat: item.perumahanRakyat ?? 0,
                              sosial: item.sosial ?? 0,
                              trantibumLinmas: item.trantibumLinmas ?? 0,
                              lainnya: item.lainnya ?? 0,
                              dataLength: state.spmSubDistrictCounts.length,
                              index: index,
                            );
                          },
                        );
                      case 'healthpost':
                        return RecapitulationBody(
                          status: state.spmHpCountStatus,
                          errorMessage: state.spmHpCountError ?? '',
                          emptyMessage: 'Rekapitulasi SPM Posyandu Kosong',
                          onRefetch: () {
                            context
                                .read<RecapitulationCubit>()
                                .refetchSpmHpCount(
                                  startDate: _selectedRangeDates.first,
                                  endDate: _selectedRangeDates.last,
                                );
                          },
                          items: state.spmHpCounts,
                          itemBuilder: (context, index, item) {
                            return RecapitulationCard(
                              label: 'Posyandu',
                              title: item.healthPost ?? '',
                              total: item.total ?? 0,
                              pendidikan: item.pendidikan ?? 0,
                              kesehatan: item.kesehatan ?? 0,
                              pekerjaanUmum: item.pekerjaanUmum ?? 0,
                              perumahanRakyat: item.perumahanRakyat ?? 0,
                              sosial: item.sosial ?? 0,
                              trantibumLinmas: item.trantibumLinmas ?? 0,
                              lainnya: item.lainnya ?? 0,
                              dataLength: state.spmHpCounts.length,
                              index: index,
                            );
                          },
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
