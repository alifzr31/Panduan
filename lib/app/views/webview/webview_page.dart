import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_filex/open_filex.dart';
import 'package:panduan/app/cubits/asset/asset_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_env.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:toastification/toastification.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({
    required this.fileName,
    required this.filePath,
    super.key,
  });

  final String fileName;
  final String filePath;

  static const String routeName = '/webview';

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  late WebViewController _webViewController;
  bool isCreated = false;

  void _initWebView() {
    final url = '${AppEnv.basePublicUrl}/assets/serve?path=${widget.filePath}';

    final uri = Uri.parse(
      widget.fileName.split('.').last == 'pdf'
          ? 'https://docs.google.com/gview?embedded=true&url=$url'
          : url,
    );

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (kDebugMode) print(progress);
          },
          onPageStarted: (String url) {
            if (kDebugMode) print(url);
          },
          onPageFinished: (String url) {
            if (kDebugMode) print(url);
            setState(() {
              isCreated = true;
            });
          },
          onHttpError: (HttpResponseError error) {
            if (kDebugMode) print(error);
          },
          onWebResourceError: (WebResourceError error) {
            if (kDebugMode) print(error);
          },
        ),
      )
      ..loadRequest(uri);
  }

  Future<void> _onOpenFile(String? savePath) async {
    try {
      await OpenFilex.open(savePath ?? '');
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  @override
  void initState() {
    _initWebView();
    super.initState();
  }

  @override
  void dispose() {
    _webViewController
      ..clearCache()
      ..clearLocalStorage();
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
          widget.fileName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actionsPadding: const EdgeInsets.only(right: 16),
        actions: [
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
                  if (context.mounted) {
                    context.read<AssetCubit>().resetDownloadAttachmentState();
                  }
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
                  fileName: widget.fileName,
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
        ],
      ),
      body: SafeArea(
        top: false,
        child: isCreated
            ? WebViewWidget(controller: _webViewController)
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Mohon tunggu sebentar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Sedang memuat konten...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const CupertinoActivityIndicator(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
