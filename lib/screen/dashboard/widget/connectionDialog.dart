import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_event.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';

class ConnectionDialog extends StatefulWidget {
  const ConnectionDialog({Key? key, this.sizeTag}) : super(key: key);
  final int? sizeTag;

  @override
  State<ConnectionDialog> createState() => _ConnectionDialogState();
}

class _ConnectionDialogState extends State<ConnectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.15,
          // vertical: 270,
        ),
        child: Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Constant.paddingHalf),
                      topLeft: Radius.circular(Constant.paddingHalf)),
                  color: Constant.colorSelectedIndicator,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Constant.paddingHalf),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Connection Status',
                        style: Constant.textStyleSize14(context)
                            ?.copyWith(color: Constant.cWhite),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Constant.paddingHalf),
                      bottomRight: Radius.circular(Constant.paddingHalf)),
                  color: Constant.cWhite,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(Constant.paddingDouble),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Strings.offlineMsg,
                        style: Constant.textStyleSize14(context)
                            ?.copyWith(color: Constant.cBlack),
                      ),
                    ],
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
