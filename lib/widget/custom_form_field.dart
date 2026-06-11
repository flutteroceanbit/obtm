import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/constant.dart';
import '../gen/assets.gen.dart';

class CustomFormField extends StatefulWidget {
  CustomFormField(
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
      this.onFieldSubmitted,
      this.validatorFunction,
      this.inputFormatters,
      this.height,
      this.isPasswordField = false,
      this.isEnable = true,
      this.isDialog = false,
      this.maxLength,
      this.cursorColor = Constant.cBlack,
      this.maxLine = 1,
      this.autoFocus = false})
      : super(key: key);
  String? hintText;
  TextInputType? type;
  TextEditingController? controller;
  Function()? onTap;
  bool isSuffix = false;
  FocusNode? focus;
  final InputDecoration? decoration;
  String? Function(String?)? validatorFunction;
  final String? validator;
  Function(String)? onChanged;
  Function(String)? onFieldSubmitted;
  List<TextInputFormatter>? inputFormatters;
  double? height;
  TextStyle? labelStyle;
  final bool isPasswordField;
  bool? isEnable;
  bool? isDialog;
  int? maxLength;
  int maxLine = 1;
  Color cursorColor;
  bool autoFocus;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool isPassVisible = false;

  InputDecoration inputDecoration = InputDecoration(
    counterText: '',
    filled: true,
    // fillColor: Colors.white,
    contentPadding: const EdgeInsets.fromLTRB(
      10,
      10,
      10,
      10,
    ),
    // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(5)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(5)),
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(5)),
    disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(5)),
    // suffixIconConstraints: const BoxConstraints(
    //   maxHeight: 40,
    //   maxWidth: 40,
    // ),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          textSelectionTheme:
              const TextSelectionThemeData(selectionColor: Color(0xFFFFB300))),
      child: TextFormField(
        //textAlign: TextAlign.start,
        maxLines: widget.maxLine,
        maxLength: widget.maxLength,
        controller: widget.controller,
        autofocus: widget.autoFocus,
        obscureText: widget.isPasswordField && !isPassVisible,
        focusNode: widget.focus,
        keyboardType: widget.type,
        inputFormatters: widget.inputFormatters,
        onTap: widget.onTap,
        enabled: widget.isEnable,
        onChanged: widget.onChanged,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Constant.cBlack),
        decoration: inputDecoration.copyWith(
          //contentPadding:  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.015,horizontal: MediaQuery.of(context).size.width*0.010),
          suffixIcon: widget.isPasswordField
              ? SizedBox(
                  // margin:  EdgeInsets.only(right: 20.w),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPassVisible = !isPassVisible;
                        });
                      },
                      child: isPassVisible
                          ? Assets.images.hidePassword
                              .image() /*Icon(Icons.visibility, color: Colors.black.withOpacity(0.8),)*/
                          : Assets.images.showPassword
                              .image() //Icon(Icons.visibility_off, color: Colors.black.withOpacity(0.8))),
                      ))
              : null,
          labelText: widget.hintText ?? '',
          hintText: widget.hintText ?? '',
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black.withOpacity(0.4),
                // color: Constant.cBlackText.withOpacity(0.4),
                fontWeight: FontWeight.bold,
              ),
          labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: ((widget.focus != null && widget.focus!.hasFocus) ||
                        widget.controller?.text != "")
                    ? Colors.black.withOpacity(0.4)
                    : Colors.black,
                // color: Constant.cBlackText.withOpacity(0.4),
                //fontWeight: FontWeight.bold,
              ),
        ),
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validatorFunction != null
            ? widget.validatorFunction!
            : (value) {
                if (value!.isEmpty) {
                  return widget.validator;
                }
                return null;
              },
        cursorColor: widget.cursorColor,
      ),
    );
  }
}
