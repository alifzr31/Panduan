import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:panduan/app/widgets/base_formfield.dart';

class BaseTypeaHeadField<T> extends StatelessWidget {
  const BaseTypeaHeadField({
    required this.itemBuilder,
    required this.onSelected,
    required this.suggestionsCallback,
    this.hint,
    this.controller,
    this.validator,
    this.emptyLabel,
    super.key,
  });

  final Widget Function(BuildContext context, T value) itemBuilder;
  final void Function(T value)? onSelected;
  final FutureOr<List<T>?> Function(String keyword) suggestionsCallback;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      controller: controller,
      builder: (context, controller, focusNode) {
        return BaseFormField(
          hint: hint,
          controller: controller,
          focusNode: focusNode,
          validator: validator,
        );
      },
      decorationBuilder: (context, child) {
        return Material(
          color: Colors.white,
          elevation: 2,
          borderRadius: BorderRadius.circular(6),
          clipBehavior: Clip.antiAlias,
          child: child,
        );
      },
      constraints: const BoxConstraints(maxHeight: 200),
      loadingBuilder: (context) {
        return const CircularProgressIndicator();
      },
      emptyBuilder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            emptyLabel ?? '',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        );
      },
      itemBuilder: itemBuilder,
      onSelected: onSelected,
      suggestionsCallback: suggestionsCallback,
    );
  }
}

class BaseTypeaHeadGroupField<T> extends StatelessWidget {
  const BaseTypeaHeadGroupField({
    required this.label,
    required this.itemBuilder,
    required this.onSelected,
    required this.suggestionsCallback,
    this.hint,
    this.mandatory = false,
    this.controller,
    this.validator,
    this.emptyLabel,
    super.key,
  });

  final String label;
  final Widget Function(BuildContext context, T value) itemBuilder;
  final void Function(T value)? onSelected;
  final FutureOr<List<T>?> Function(String keyword) suggestionsCallback;
  final String? hint;
  final bool mandatory;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (mandatory)
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade700,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        TypeAheadField<T>(
          controller: controller,
          builder: (context, controller, focusNode) {
            return BaseFormField(
              hint: hint,
              controller: controller,
              focusNode: focusNode,
              validator: validator,
            );
          },
          decorationBuilder: (context, child) {
            return Material(
              color: Colors.white,
              elevation: 2,
              borderRadius: BorderRadius.circular(6),
              clipBehavior: Clip.antiAlias,
              child: child,
            );
          },
          constraints: const BoxConstraints(maxHeight: 200),
          loadingBuilder: (context) {
            return const CircularProgressIndicator();
          },
          emptyBuilder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                emptyLabel ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
          itemBuilder: itemBuilder,
          onSelected: onSelected,
          suggestionsCallback: suggestionsCallback,
        ),
      ],
    );
  }
}
