import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_filex/open_filex.dart';
import 'package:panduan/app/cubits/asset/asset_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/views/pdfview/components/pdfview_loading.dart';
import 'package:panduan/app/views/pdfview/widgets/pdfview_footer.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:toastification/toastification.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({
    required this.filePath,
    required this.fileName,
    super.key,
  });

  final String filePath;
  final String fileName;

  static const String routeName = '/pdfview';

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  bool _isLoading = true;
  bool _isPdfReady = false;
  String? _localPath;
  int _totalPages = 0;
  int _currentPage = 0;

  Future<void> _onOpenFile(String? savePath) async {
    try {
      await OpenFilex.open(savePath ?? '');
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<AssetCubit>().downloadAttachment(
      path: widget.filePath,
      fileName: '${widget.fileName}.pdf',
    );
  }

  @override
  void dispose() {
    _pdfViewController = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetCubit, AssetState>(
      listenWhen: (previous, current) =>
          previous.downloadStatus != current.downloadStatus,
      listener: (context, state) {
        if (state.downloadStatus == DownloadStatus.loading) {
          context.loaderOverlay.show();
        }

        if (state.downloadStatus == DownloadStatus.success) {
          context.loaderOverlay.hide();
          _isLoading = false;
          _localPath = state.savePath;
          setState(() {});
          context.read<AssetCubit>().resetDownloadAttachmentState();
        }

        if (state.downloadStatus == DownloadStatus.error) {
          context.loaderOverlay.hide();
          showCustomToast(
            context,
            title: 'Gagal Mengunduh File',
            description: state.downloadError,
            type: ToastificationType.error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(
            widget.fileName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
          actions: [
            if (_isPdfReady) ...{
              BlocListener<AssetCubit, AssetState>(
                listenWhen: (previous, current) =>
                    previous.downloadStatus != current.downloadStatus,
                listener: (context, state) {
                  if (state.downloadStatus == DownloadStatus.loading) {
                    context.loaderOverlay.show();
                  }

                  if (state.downloadStatus == DownloadStatus.success) {
                    context.loaderOverlay.hide();
                    showCustomToast(
                      context,
                      type: ToastificationType.success,
                      title: 'Unduh File Berhasil',
                      description: 'File disimpan ke ${state.savePath}',
                    );
                    _onOpenFile(state.savePath).then((_) {
                      if (!context.mounted) return;

                      context.read<AssetCubit>().resetDownloadAttachmentState();
                    });
                  }

                  if (state.downloadStatus == DownloadStatus.error) {
                    context.loaderOverlay.hide();
                    showCustomToast(
                      context,
                      type: ToastificationType.error,
                      title: 'Unduh File Gagal',
                      description: state.downloadError,
                    );
                  }
                },
                child: CupertinoButton(
                  alignment: Alignment.center,
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    context.read<AssetCubit>().downloadAttachment(
                      path: widget.filePath,
                      fileName: '${widget.fileName}.pdf',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.softBlueColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      MingCute.download_fill,
                      size: 18,
                      color: AppColors.blueColor,
                    ),
                  ),
                ),
              ),
            },
          ],
        ),
        body: _isLoading
            ? const PdfViewLoading()
            : Stack(
                children: [
                  PDFView(
                    filePath: _localPath,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: true,
                    pageSnap: true,
                    defaultPage: _currentPage,
                    fitPolicy: FitPolicy.BOTH,
                    onRender: (pages) {
                      setState(() {
                        _totalPages = pages ?? 0;
                        _isPdfReady = true;
                      });
                    },
                    onError: (error) {
                      showCustomToast(
                        context,
                        title: 'Gagal Mengunduh File',
                        description: error.toString(),
                        type: ToastificationType.error,
                      );
                    },
                    onPageError: (page, error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Halaman $page tidak dapat dimuat: $error',
                          ),
                        ),
                      );
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      if (!_pdfViewController.isCompleted) {
                        _pdfViewController.complete(pdfViewController);
                      }
                    },
                    onPageChanged: (int? page, int? total) {
                      if (page != null) {
                        setState(() {
                          _currentPage = page;
                        });
                      }
                    },
                  ),
                  if (_isPdfReady) ...{
                    PdfViewFooter(
                      currentPage: _currentPage,
                      totalPages: _totalPages,
                      onPreviousPage: () async {
                        final controller = await _pdfViewController.future;
                        await controller.setPage(_currentPage - 1);
                      },
                      onNextPage: () async {
                        final controller = await _pdfViewController.future;
                        await controller.setPage(_currentPage + 1);
                      },
                    ),
                  },
                  if (!_isPdfReady) ...{const PdfViewLoading()},
                ],
              ),
      ),
    );
  }
}
