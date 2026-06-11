import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constant/constant.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {Key? key,
      this.hintText,
      this.type,
      this.controller,
      this.onTap,
      this.isSuffix = false,
      this.focus,
      this.decoration,
      this.validator,
      this.onChanged,
      this.validatorFunction,
      this.inputFormatters,
      this.height = Constant.customTextFieldHeight,
      this.isPasswordField = false,
      this.isEnable = true,
      this.isDialog = false,
      this.maxLength,
      this.cursorColor = Constant.cGrayDark,
      this.maxLines = 1,
      this.contentPadding,
      this.suffixIcon,
      this.width,
      this.isCopy,
      this.textColor})
      : super(key: key);
  String? hintText;
  TextInputType? type;
  TextEditingController? controller;
  Function()? onTap;
  bool isSuffix = false;
  bool? isCopy = true;
  FocusNode? focus;
  final InputDecoration? decoration;
  String? Function(String?)? validatorFunction;
  final String? validator;
  Function(String)? onChanged;
  List<TextInputFormatter>? inputFormatters;

  //double height;
  TextStyle? labelStyle;
  final bool isPasswordField;
  bool? isEnable;
  bool? isDialog;
  int? maxLength;
  Color cursorColor;
  int maxLines;
  double height;
  Widget? suffixIcon;
  double? width;
  Color? textColor;
  EdgeInsetsGeometry? contentPadding =
      const EdgeInsets.symmetric(horizontal: Constant.paddingHalf);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();

  InputDecoration inputDecoration = InputDecoration(
    counterText: '',
    // filled: true,
    // fillColor: Constant.cWhite,
    // isDense: true,
    // contentPadding:  const EdgeInsets.symmetric(horizontal: Constant.paddingHalf,vertical: Constant.paddingHalf),
    /*fromLTRB(
      Constant.paddingHalf,
      Constant.paddingHalf,
      Constant.paddingHalf,
      Constant.paddingHalf,
    ),*/
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Constant.cBlack),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Constant.cBlack),
      borderRadius: BorderRadius.circular(10),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Constant.cBlack),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Constant.cBlack),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Constant.cBlack),
      borderRadius: BorderRadius.circular(10),
    ),
    /*suffixIconConstraints: BoxConstraints(
      maxHeight: Constant.textFieldIconSize,
      maxWidth: Constant.textFieldIconSize,
    ),*/
  );
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPassVisible = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        maxLength: widget.maxLength,
        controller: widget.controller,
        maxLines: widget.maxLines,
        autofocus: false,
        readOnly: !widget.isEnable!,
        obscureText: widget.isPasswordField && !isPassVisible,
        focusNode: widget.focus,
        keyboardType: widget.type,
        inputFormatters: widget.inputFormatters,
        onTap: widget.onTap,
        // enabled: widget.isEnable,
        onChanged: widget.onChanged,
        cursorColor: widget.cursorColor,
        style: Constant.textStyleSize13(context)?.copyWith(
          color: widget.textColor ?? Constant.cGrayDark,
        ) /*.copyWith(fontWeight: FontWeight.bold)*/,
        enableInteractiveSelection: widget.isCopy,
        decoration: widget.inputDecoration.copyWith(
            hintText: widget.hintText,
            hintStyle: Constant.textStyleSize13(context)?.copyWith(
              color: Constant.cGrayDark,
            ),
            contentPadding: widget.contentPadding,
            suffixIcon: widget.suffixIcon ?? const SizedBox.shrink(),
            suffixIconConstraints: widget.suffixIcon != null
                ? const BoxConstraints(
                    minHeight: 48, minWidth: 50, maxWidth: 100, maxHeight: 50)
                : const BoxConstraints(
                    minWidth: 0, maxHeight: 0, maxWidth: 0, minHeight: 0)),
        validator: widget.validatorFunction ??
            (value) {
              if (value!.isEmpty) {
                return widget.validator;
              }
              return null;
            },
      ),
    );
  }
}
