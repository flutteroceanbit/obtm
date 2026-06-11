import 'dart:ui';

class SizeConfig{
  static double pixelRatio = window.devicePixelRatio;

//Size in physical pixels
  static var physicalScreenSize = window.physicalSize;
  static double physicalWidth = physicalScreenSize.width;
  static double physicalHeight = physicalScreenSize.height;

//Size in logical pixels are same as MediaQuery.of(context).size  --- recommended to use this
  static var logicalScreenSize = window.physicalSize / pixelRatio;
  static double logicalWidth = logicalScreenSize.width;
  static double logicalHeight = logicalScreenSize.height;

//Padding in physical pixels
  static var padding = window.padding;
//safe area in physical pixels
  static double safePhysicalHeight=physicalHeight-padding.top-padding.bottom;
  static double safePhysicalWidth=physicalWidth-padding.left-padding.right;

//Safe area paddings in logical pixels
  static double paddingLeft = window.padding.left / window.devicePixelRatio;
  static double paddingRight = window.padding.right / window.devicePixelRatio;
  static double paddingTop = window.padding.top / window.devicePixelRatio;
  static double paddingBottom = window.padding.bottom / window.devicePixelRatio;

//Safe area in logical pixels
  static double safeWidth = logicalWidth - paddingLeft - paddingRight;
  static double safeHeight = logicalHeight - paddingTop - paddingBottom;
}