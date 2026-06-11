import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/my_loader.dart';

class Constant {
  static MyLoader myLoader = MyLoader();
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        // primarySwatch: Colors.deepPurple,
        // primaryColor: primaryColor ,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: colorSurface,
          onPrimary: colorOnSecondary,
          secondary: cBlack,
          onSecondary: colorOnSecondary,
          error: colorError,
          onError: colorOnError,
          surface: colorSurface,
          onSurface: colorSurface,
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: colorSelectedIndicator,
        ),

        cardColor: Colors.white,
        // canvasColor: colorSurface,

        /*appBarTheme: appBarTheme(context, Colors.black).copyWith(
      color: Colors.white,
    ),*/
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: cWhite,
          onPrimary: colorOnSecondary,
          secondary: colorPrimary,
          onSecondary: cWhite,
          error: colorError,
          onError: colorOnError,
          surface: colorDarkSurface,
          onSurface: cWhite,
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
        // fontFamily: 'Roboto_Regular.ttf',
        // textTheme: GoogleFonts.poppinsTextTheme(),
        cardColor: Colors.black,
        canvasColor: colorDarkSurface,
        // buttonColor: lightBluishColor,
        // accentColor: Colors.white,
        /* appBarTheme: appBarTheme(context, Colors.white).copyWith(
      color: Colors.black,
    ),*/
      );

  /*static AppBarTheme appBarTheme(BuildContext context, Color titleColor) {
    return AppBarTheme(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(MyTheme.topBarBottomBarCornerRadius),
            bottomRight: Radius.circular(MyTheme.topBarBottomBarCornerRadius)),
      ),
      elevation: MyTheme.topBarBottomBarElevation,
      iconTheme: IconThemeData(color: titleColor),
      titleTextStyle: context.textTheme.headline6!.copyWith(
        color: titleColor,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }*/
  ///preferences constant
  static SharedPreferences? pref;

  ///common toast widget
  void show_toast(String msg, BuildContext context) {
    showToast(msg,
        context: context,
        position: const StyledToastPosition(
            align: Alignment.bottomCenter, offset: 20),
        animation: StyledToastAnimation.scale,
        backgroundColor: cBlack.withOpacity(0.8),
        textStyle: const TextStyle(color: cWhite));
  }

  Widget ShowMessage(String msg, BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        AnimatedContainer(
          curve: Curves.easeIn,
          duration: const Duration(seconds: 3),
          //width: MediaQuery.of(context).size.width/2,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              color: cBlack.withOpacity(0.8)),
          child: Text(
            msg,
            style: textStyleSize12(context)?.copyWith(color: cWhite),
          ),
        ),
      ],
    );
  }

  Widget ShowErrorMessage(String msg, BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        AnimatedContainer(
          curve: Curves.easeIn,
          duration: const Duration(seconds: 3),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              color: cRed.withOpacity(0.8)),
          child: Text(
            msg,
            style: textStyleSize12(context)?.copyWith(color: cWhite),
          ),
        ),
      ],
    );
  }

  ///common toast widget for error
  void ShowErrorToast(String msg, BuildContext context) {
    showToast(msg,
        position:
            const StyledToastPosition(align: Alignment.topRight, offset: 20),
        context: context,
        animation: StyledToastAnimation.scale,
        backgroundColor: colorError.withOpacity(0.8),
        textStyle: const TextStyle(color: cWhite));
  }

  /// Padding
  static const double padding4x = 80;
  static const double padding3x = 60;
  static const double padding2_5x = 50;
  static const double paddingDouble = 40;
  static const double padding45 = 45;
  static const double paddingMidDouble = 30;
  static const double padding = 20;
  static const double paddingMidDoubleHalf = 25;
  static const double paddingMidHalf = 15;
  static const double paddingHalf = 10;
  static const double paddingHalfHalf = 5;
  static const double formPadding = 20;
  static const double formPaddingHalf = 10;
  static const double paddingSmall = 4;
  static const double padding7 = 7;
  static const double padding8 = 8;

  ///widget sizes
  static const double customTextFieldHeight = 50;
  static const double customDropDownHeight = 50;

  ///colors
  static const Color colorSurface = Color(0xfff5f5f5);
  static const Color colorPrimary = Color(0xff292929);
  static const Color colorOnSecondary = Color(0xff292929);
  static const Color colorError = Color(0xffff0000);
  static const Color colorOnError = Color(0xffffffff);
  static const Color colorDarkSurface = Vx.gray900;
  static const Color colorLightViolet = Color(0xff5D63FF);
  static const Color colorSelectedIndicator = Color(0xffFD9A30);
  static const Color colorSelectedIndicatorShadow = Color(0x40000000);
  static const Color colorGrey = Color(0xff9F9F9F);
  static const Color colorGreyTableHeaderBg = Color(0xffC8C8C8);
  static const Color colorGreyTableHeaderBgLight = Color(0xffDCDCDC);
  static const Color cBlack = Color(0xff000000);
  static const Color cWhite = Color(0xffffffff);
  static const Color cBlack5PerOpacity = Color(0x0D000000);
  static const Color cGreenLight = Color(0xff4c8439);
  static const Color cCyanLight = Color(0xff36A998);
  static const Color cRedLight = Color(0xffCA3C31);
  static const Color cGreenDark = Color(0xff315225);
  static const Color cCyanDark = Color(0xff235c5f);
  static const Color cOrangeDark = Color(0xfbc9392e);
  static const Color cRed = Color(0xfb9f2530);
  static const Color cGrayDark = Color(0xff3d3d3d);
  static const Color cBlueDark = Color(0xff2929b0);
  static const Color cBlueLight = Color(0xff6883ea);
  static const Color cBlueMedium = Color(0xff0659B5);
  static const Color cBlue = Color(0xff017AFF);
  static const Color cPinkDark = Color(0xff9c0e8c);
  static const Color cYellowDark = Color(0xffffa400);
  static const Color cPurple = Color(0xff7942a9);
  static const Color cPurpleDark = Color(0xff7A28AD);
  static const Color cDashboardCardColor = Color(0xffF6F6F6);
  static const Color cPinkLight = Color(0xffFC416F);
  static const Color cLightGray = Color(0xff9F9F9F);
  static const Color cFontLight = Color(0xff565656);

  /// Font Size
  static const double textSize10 = 10;
  static const double textSize7 = 7;
  static const double textSize5 = 5;
  static const double textSize8 = 8;
  static const double textSize9 = 9;
  static const double textSize11 = 11;
  static const double textSize12 = 12;
  static const double textSize13 = 13;
  static const double textSize14 = 14;
  static const double textSize15 = 15;
  static const double textSize18 = 18;
  static const double textSize16 = 16;
  static const double textSize19 = 19;
  static const double textSize20 = 20;
  static const double textSize25 = 25;
  static const double textSize29 = 29;
  static const double textSize30 = 30;
  static const double textSize32 = 32;
  static const double textSize35 = 35;
  static const double textSize40 = 40;

  static TextStyle? commonTextStyle(BuildContext context) {
    return context.theme.textTheme.bodyLarge;
  }

  static TextStyle? textStyleSize7(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize7,
    );
  }

  static TextStyle? textStyleSize5(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize5,
    );
  }

  static TextStyle? textStyleSize8(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize8,
    );
  }

  static TextStyle? textStyleSize9(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize9,
    );
  }

  static TextStyle? textStyleSize10(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize10,
    );
  }

  static TextStyle? textStyleSize11(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize11,
    );
  }

  static TextStyle? textStyleSize12(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize12,
    );
  }

  static TextStyle? textStyleSize13(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize13,
    );
  }

  static TextStyle? textStyleSize14(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize14,
    );
  }

  static TextStyle? textStyleSize15(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize15,
    );
  }

  static TextStyle? textStyleSize16(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize16,
    );
  }

  static TextStyle? textStyleSize18(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize18,
    );
  }

  static TextStyle? textStyleSize19(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize19,
    );
  }

  static TextStyle? textStyleSize20(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize20,
    );
  }

  static TextStyle? textStyleSize25(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize25,
    );
  }

  static TextStyle? textStyleSize29(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize29,
    );
  }

  static TextStyle? textStyleSize30(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize30,
    );
  }

  static TextStyle? textStyleSize32(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize32,
    );
  }

  static TextStyle? textStyleSize35(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize35,
    );
  }

  static TextStyle? textStyleSize40(BuildContext context) {
    return commonTextStyle(context)!.copyWith(
      fontSize: textSize40,
    );
  }

  static TextStyle themeColorTextStyle(
      BuildContext context, TextStyle textStyle) {
    return textStyle.copyWith(
      color: context.accentColor,
    );
  }
}
