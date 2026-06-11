import 'package:flutter/material.dart';

import '../../constant/strings.dart';
import '../../widget/new/custom_header_container.dart';

class MyTaskScreen extends StatelessWidget {
  const MyTaskScreen({Key? key}) : super(key: key);

  /*@override
  Widget build(BuildContext context) {
    return */ /*Flexible(
      flex: 1,
      child: */ /*Container(
        color: Constant.cGrayDark,
        child: Container(
          color: Constant.cWhite.withOpacity(0.2),
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 70,
                  color: Constant.cWhite.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:Constant.paddingHalfHalf,horizontal: Constant.paddingHalf),
                    child: Text(
                      Strings.myTask,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(color: Constant.cWhite),
                    ),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Constant.paddingHalf),
                  child: Container(width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.22,
                    //color: Constant.cWhite.withOpacity(0.2),
                    child: Container(
                        color: Constant.cGrayDark,
                        child:  Container()

                    ),),
                ),
              )

            ],
          ),
        ),
      );
    // );
  }*/

  @override
  Widget build(BuildContext context) {
    return const CustomHeaderContainer(
      headerText: Strings.myTask,
    );
  }
}
