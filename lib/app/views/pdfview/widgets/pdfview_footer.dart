import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/app_colors.dart';

class PdfViewFooter extends StatelessWidget {
  const PdfViewFooter({
    required this.currentPage,
    required this.totalPages,
    required this.onPreviousPage,
    required this.onNextPage,
    super.key,
  });

  final int currentPage;
  final int totalPages;
  final void Function()? onPreviousPage;
  final void Function()? onNextPage;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(52),
              blurRadius: 1,
              offset: const Offset(0, -1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Halaman ${currentPage + 1} dari $totalPages',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CupertinoButton(
                padding: const EdgeInsets.all(2),
                minimumSize: Size.zero,
                onPressed: currentPage > 0 ? onPreviousPage : null,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: currentPage > 0
                        ? AppColors.softPinkColor
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      MingCute.left_line,
                      size: 22,
                      color: currentPage > 0
                          ? AppColors.pinkColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              CupertinoButton(
                padding: const EdgeInsets.all(2),
                minimumSize: Size.zero,
                onPressed: currentPage < totalPages - 1 ? onNextPage : null,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: currentPage < totalPages - 1
                        ? AppColors.softPinkColor
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      MingCute.right_line,
                      size: 22,
                      color: currentPage < totalPages - 1
                          ? AppColors.pinkColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
