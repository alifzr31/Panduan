import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/cubits/hp_registration/hp_registration_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/string_extension.dart';
import 'package:panduan/app/views/hp_registration/components/hpregistration_loading.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';

class HpRegistrationPage extends StatefulWidget {
  const HpRegistrationPage({
    required this.healthPostId,
    required this.healthPostCode,
    super.key,
  });

  static const String routeName = '/hpRegistration';

  final int healthPostId;
  final String healthPostCode;

  @override
  State<HpRegistrationPage> createState() => _HpRegistrationPageState();
}

class _HpRegistrationPageState extends State<HpRegistrationPage> {
  @override
  void initState() {
    context.read<HpRegistrationCubit>().fetchHpRegistration(
      healthPostId: widget.healthPostId,
    );
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
          'Detail Posyandu Binaan',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<HpRegistrationCubit, HpRegistrationState>(
        builder: (context, state) {
          switch (state.registrationStatus) {
            case RegistrationStatus.error:
              return BaseHandleState(
                handleType: HandleType.error,
                errorMessage: state.registrationError ?? '',
                onRefetch: () {
                  context.read<HpRegistrationCubit>().refetchHpRegistration(
                    healthPostId: widget.healthPostId,
                  );
                },
              );
            case RegistrationStatus.success:
              return state.hpRegistration == null
                  ? BaseHandleState(
                      handleType: HandleType.empty,
                      errorMessage: 'Data registrasi posyandu belum diinput',
                      onRefetch: () {
                        context
                            .read<HpRegistrationCubit>()
                            .refetchHpRegistration(
                              healthPostId: widget.healthPostId,
                            );
                      },
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      physics: const ClampingScrollPhysics(),
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Material(
                            elevation: 1,
                            color: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Data Posyandu',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Divider(
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  Text(
                                    'Nama Posyandu:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    state.hpRegistration?.name?.capitalize() ??
                                        '-',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Kode Posyandu:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    widget.healthPostCode,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Tanggal Registrasi:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    state.hpRegistration?.date == null
                                        ? '-'
                                        : AppHelpers.dmyDateFormat(
                                            state.hpRegistration?.date ??
                                                DateTime(0000),
                                          ),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'No. Surat Registrasi:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    state.hpRegistration?.noReg ?? '-',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SafeArea(
                          top: false,
                          child: SizedBox(
                            width: double.infinity,
                            child: Material(
                              elevation: 1,
                              color: Colors.white,
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Kelengkapan Dokumen Pembentukan Posyandu',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Divider(
                                        height: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    ...List.generate(
                                      state
                                              .hpRegistration
                                              ?.components
                                              ?.length ??
                                          0,
                                      (index) {
                                        final component = state
                                            .hpRegistration
                                            ?.components?[index];

                                        return Container(
                                          margin: EdgeInsets.only(
                                            bottom:
                                                index ==
                                                    (state
                                                                .hpRegistration
                                                                ?.components
                                                                ?.length ??
                                                            0) -
                                                        1
                                                ? 0
                                                : 8,
                                          ),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${index + 1}. ${component?.name}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              ...List.generate(
                                                component
                                                        ?.componentItems
                                                        ?.length ??
                                                    0,
                                                (idx) {
                                                  return Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                          10,
                                                        ),
                                                    margin: EdgeInsets.only(
                                                      bottom:
                                                          idx ==
                                                              (component
                                                                          ?.componentItems
                                                                          ?.length ??
                                                                      0) -
                                                                  1
                                                          ? 0
                                                          : 4,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                component
                                                                        ?.componentItems?[idx]
                                                                        .title ??
                                                                    '',
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                              ),
                                                              if (component
                                                                      ?.componentItems?[idx]
                                                                      .filePath !=
                                                                  null) ...{
                                                                const SizedBox(
                                                                  height: 2,
                                                                ),
                                                                BaseTextButton(
                                                                  text:
                                                                      'Lihat File',
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                              },
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Ink(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                6,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                component
                                                                        ?.componentItems?[idx]
                                                                        .response ??
                                                                    false
                                                                ? AppColors
                                                                      .softGreenColor
                                                                : AppColors
                                                                      .softRedColor,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                            component
                                                                        ?.componentItems?[idx]
                                                                        .response ??
                                                                    false
                                                                ? MingCute
                                                                      .check_circle_fill
                                                                : MingCute
                                                                      .close_circle_fill,
                                                            size: 18,
                                                            color:
                                                                component
                                                                        ?.componentItems?[idx]
                                                                        .response ??
                                                                    false
                                                                ? AppColors
                                                                      .greenColor
                                                                : AppColors
                                                                      .redColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //     vertical: 10,
                                    //   ),
                                    //   child: Divider(
                                    //     height: 1,
                                    //     color: Colors.grey.shade300,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width: double.infinity,
                                    //   child: BaseButtonIcon(
                                    //     bgColor: Colors.red.shade600,
                                    //     fgColor: Colors.white,
                                    //     icon: MingCute.pdf_line,
                                    //     label: 'Download PDF',
                                    //     onPressed: () {
                                    //       Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (context) {
                                    //             return const TesPage();
                                    //           },
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            default:
              return hpRegistrationLoading();
          }
        },
      ),
    );
  }
}
