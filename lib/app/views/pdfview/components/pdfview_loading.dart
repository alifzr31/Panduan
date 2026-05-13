import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PdfViewLoading extends StatelessWidget {
  const PdfViewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mohon tunggu sebentar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              'Sedang memuat file...',
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
    );
  }
}
