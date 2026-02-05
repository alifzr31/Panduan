import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/cubits/spm/spm_cubit.dart';
import 'package:panduan/app/views/create_spm/createspm_page.dart';
import 'package:panduan/app/views/spm_field/components/spmfield_card.dart';
import 'package:panduan/app/views/spm_field/components/spmfield_cardloading.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';

class SpmFieldPage extends StatefulWidget {
  const SpmFieldPage({super.key});

  static const String routeName = '/spmField';

  @override
  State<SpmFieldPage> createState() => _SpmFieldPageState();
}

class _SpmFieldPageState extends State<SpmFieldPage> {
  @override
  void initState() {
    context.read<SpmCubit>().fetchSpmFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Pilih Bidang Pelayanan',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () {
          return context.read<SpmCubit>().refreshSpmFields();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: Material(
                elevation: 1,
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(MingCute.building_5_line, size: 20),
                                SizedBox(width: 2),
                                Text(
                                  'Bidang Pelayanan Posyandu',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Pilih bidang pelayanan posyandu yang sesuai dengan kebutuhan anda',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<SpmCubit, SpmState>(
                        builder: (context, state) {
                          switch (state.spmFieldStatus) {
                            case SpmFieldStatus.error:
                              return SizedBox(
                                height: 400,
                                child: BaseHandleState(
                                  handleType: HandleType.error,
                                  errorMessage: state.spmFieldError ?? '',
                                  onRefetch: () {
                                    context.read<SpmCubit>().refetchSpmFields();
                                  },
                                ),
                              );
                            case SpmFieldStatus.success:
                              return state.spmFields.isEmpty
                                  ? SizedBox(
                                      height: 400,
                                      child: BaseHandleState(
                                        handleType: HandleType.empty,
                                        errorMessage: 'Bidang Pelayanan Kosong',
                                        onRefetch: () {
                                          context
                                              .read<SpmCubit>()
                                              .refetchSpmFields();
                                        },
                                      ),
                                    )
                                  : ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: state.spmFields.length,
                                      itemBuilder: (context, index) {
                                        final spmField = state.spmFields[index];

                                        return SpmFieldCard(
                                          name: spmField.name ?? '',
                                          description:
                                              spmField.description ??
                                              'Pilih bidang pelayanan ini',
                                          index: index,
                                          dataLength: state.spmFields.length,
                                          onTap: () async {
                                            final result =
                                                await Navigator.pushNamed(
                                                  context,
                                                  CreateSpmPage.routeName,
                                                  arguments: {
                                                    'spmFieldUuid':
                                                        spmField.uuid,
                                                    'spmFieldName':
                                                        spmField.name,
                                                  },
                                                );

                                            if (!context.mounted) return;

                                            if (result != null) {
                                              Navigator.pop(context, result);
                                            }
                                          },
                                        );
                                      },
                                    );
                            default:
                              return const SpmFieldCardLoading();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
