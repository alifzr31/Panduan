import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panduan/app/utils/app_colors.dart';

class BaseFormField extends StatelessWidget {
  const BaseFormField({
    super.key,
    this.hint,
    this.controller,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.helperText,
    this.helperTextColor,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.isDate = false,
    this.hintColor,
    this.borderColor,
    this.initialValue,
    this.inputFormatters,
  });

  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final String? helperText;
  final Color? helperTextColor;
  final void Function(String?)? onChanged;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool isDate;
  final Color? hintColor;
  final Color? borderColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      maxLength: maxLength,
      cursorColor: AppColors.amberColor,
      style: TextStyle(
        fontSize: 14,
        color: readOnly ? Colors.grey.shade500 : null,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14,
          color: hintColor ?? Colors.grey.shade500,
          fontWeight: FontWeight.w500,
        ),
        helperText: helperText,
        helperMaxLines: 2,
        errorMaxLines: 2,
        helperStyle: TextStyle(fontSize: 12, color: helperTextColor),
        errorStyle: TextStyle(fontSize: 12, color: Colors.red.shade600),
        counterText: '',
        isDense: true,
        contentPadding: const EdgeInsets.all(10),
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 10, right: 2),
                child: prefixIcon,
              ),
        prefixIconConstraints: const BoxConstraints(
          minHeight: 38,
          minWidth: 30,
        ),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 2, right: 10),
                child: suffixIcon,
              ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 38,
          minWidth: 30,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade600),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        filled: true,
        fillColor: AppColors.greyFormField,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly ? readOnly : isDate,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
    );
  }
}

class BaseFormGroupField extends StatelessWidget {
  const BaseFormGroupField({
    super.key,
    required this.label,
    this.mandatory = false,
    this.hint,
    this.controller,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.helperText,
    this.helperTextColor,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.isDate = false,
    this.initialValue,
    this.inputFormatters,
  });

  final String label;
  final bool mandatory;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final String? helperText;
  final Color? helperTextColor;
  final void Function(String?)? onChanged;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool isDate;
  final void Function()? onTap;

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
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          maxLines: maxLines,
          maxLength: maxLength,
          cursorColor: AppColors.amberColor,
          style: TextStyle(
            fontSize: 14,
            color: readOnly ? Colors.grey.shade500 : null,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
            helperText: helperText,
            helperMaxLines: 2,
            errorMaxLines: 2,
            counterText: '',
            helperStyle: TextStyle(fontSize: 12, color: helperTextColor),
            errorStyle: TextStyle(fontSize: 12, color: Colors.red.shade600),
            prefixIcon: prefixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 2),
                    child: prefixIcon,
                  ),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 38,
              minWidth: 30,
            ),
            suffixIcon: suffixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 2, right: 10),
                    child: suffixIcon,
                  ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: 38,
              minWidth: 30,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.all(10),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade600),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            filled: true,
            fillColor: AppColors.greyFormField,
          ),
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly ? readOnly : isDate,
          initialValue: initialValue,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }
}
