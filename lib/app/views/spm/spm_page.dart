import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/spm/spm_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/spm/widgets/spm_body.dart';
import 'package:panduan/app/views/spm/widgets/spm_header.dart';
import 'package:panduan/app/views/spm_field/spmfield_page.dart';

class SpmPage extends StatefulWidget {
  const SpmPage({this.status, super.key});

  static const String routeName = '/spm';

  final String? status;

  @override
  State<SpmPage> createState() => _SpmPageState();
}

class _SpmPageState extends State<SpmPage> {
  final _spmScrollController = ScrollController();

  final _searchSpmController = TextEditingController();
  String? _spmKeyword;
  Timer? _spmDebounce;
  final _years = List.generate(3, (index) {
    return DateTime.now().year - index;
  });
  int _selectedYear = DateTime.now().year;
  final _months = const [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  int? _selectedMonth = DateTime.now().month;

  void _onScrollSpm() {
    if (_spmScrollController.hasClients) {
      final currentScroll = _spmScrollController.position.pixels;
      final maxScroll = _spmScrollController.position.maxScrollExtent;

      if (currentScroll == maxScroll &&
          context.read<SpmCubit>().state.hasMoreSpm) {
        context.read<SpmCubit>().fetchSpm(
          year: _selectedYear,
          month: _selectedMonth,
          status: widget.status,
        );
      }
    }
  }

  void _onSearchSpm(String? keyword) {
    setState(() {
      _spmKeyword = keyword ?? '';
    });

    if (_spmDebounce?.isActive ?? false) _spmDebounce!.cancel();
    _spmDebounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SpmCubit>().refetchSpm(
        keyword: _spmKeyword,
        month: _selectedMonth,
        year: _selectedYear,
        status: widget.status,
      );
    });
  }

  @override
  void initState() {
    context
        .read<SpmCubit>()
        .fetchSpm(
          year: _selectedYear,
          month: _selectedMonth,
          status: widget.status,
        )
        .then((value) {
          _spmScrollController.addListener(_onScrollSpm);
        });
    super.initState();
  }

  @override
  void dispose() {
    _spmScrollController
      ..removeListener(_onScrollSpm)
      ..dispose();
    _searchSpmController.dispose();
    _spmDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Data SPM',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton:
          AppHelpers.hasPermission(
            context.read<AuthCubit>().state.userPermissions,
            permissionName: 'user-submission-create',
          )
          ? FloatingActionButton(
              elevation: 2,
              backgroundColor: AppColors.softBlueColor,
              foregroundColor: AppColors.blueColor,
              onPressed: () {
                Navigator.pushNamed(context, SpmFieldPage.routeName);
              },
              child: const Icon(MingCute.add_fill),
            )
          : null,
      body: Column(
        children: [
          SpmHeader(
            searchSpmController: _searchSpmController,
            onSearchSpm: _onSearchSpm,
            months: _months,
            selectedMonth: _selectedMonth,
            onSelectedMonth: (value) {
              setState(() {
                _selectedMonth = value as int;
              });

              context.read<SpmCubit>().refetchSpm(
                keyword: _spmKeyword,
                month: _selectedMonth,
                year: _selectedYear,
                status: widget.status,
              );
            },
            onRemoveMonth: () {
              setState(() {
                _selectedMonth = null;
              });

              context.read<SpmCubit>().refetchSpm(
                keyword: _spmKeyword,
                month: _selectedMonth,
                year: _selectedYear,
                status: widget.status,
              );
            },
            years: _years,
            selectedYear: _selectedYear,
            onSelectedYear: (value) {
              setState(() {
                _selectedYear = value as int;
              });

              context.read<SpmCubit>().refetchSpm(
                keyword: _spmKeyword,
                month: _selectedMonth,
                year: _selectedYear,
                status: widget.status,
              );
            },
          ),
          SpmBody(
            selectedYear: _selectedYear,
            selectedMonth: _selectedMonth,
            spmKeyword: _spmKeyword,
            spmStatus: widget.status,
            spmScrollController: _spmScrollController,
            onRefreshSpm: () {
              _searchSpmController.clear();
              setState(() {
                _spmKeyword = null;
                _selectedYear = DateTime.now().year;
                _selectedMonth = DateTime.now().month;
              });
              if (context.mounted) {
                context.read<SpmCubit>().refetchSpm(
                  year: _selectedYear,
                  month: _selectedMonth,
                  status: widget.status,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
