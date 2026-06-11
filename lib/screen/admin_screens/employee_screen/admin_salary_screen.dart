import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
import 'package:oceanbit_timeclock/screen/my_salary/my_salary_screen.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../bloc_logic/salary_bloc/salary_bloc.dart';
import '../../../bloc_logic/salary_bloc/salary_repository.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';

class AdminSalaryScreen extends StatefulWidget {
  const AdminSalaryScreen({Key? key, this.sizeTag}) : super(key: key);
  final int? sizeTag;

  @override
  State<AdminSalaryScreen> createState() => _AdminSalaryScreenState();
}

class _AdminSalaryScreenState extends State<AdminSalaryScreen> {
  bool isEmployee = false;
  late final SalaryRepository repository;

  @override
  void initState() {
    repository = context.read<SalaryRepository>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeaderContainer(
      headerText: Strings.salary,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Constant.cBlack.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEmployee = false;
                        });
                        repository.page = 1;
                        allSalary.clear();
                        BlocProvider.of<SalaryBloc>(context).add(
                          FetchSalaryEvent(
                            context: context,
                            userId: MyLocalStorage().getUser()?.id,
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: !isEmployee
                              ? Constant.colorSelectedIndicator
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Constant.paddingHalf),
                          child: Center(
                            child: Text(
                              Strings.mySalary,
                              style: Constant.textStyleSize20(context)
                                  ?.copyWith(
                                    color: !isEmployee
                                        ? Constant.colorOnError
                                        : Constant.cBlack,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEmployee = true;
                        });
                        allSalary.clear();
                        repository.page = 1;
                        BlocProvider.of<SalaryBloc>(
                          context,
                        ).add(FetchSalaryEvent(context: context));
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: isEmployee
                              ? Constant.colorSelectedIndicator
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Constant.paddingHalf),
                          child: Center(
                            child: Text(
                              Strings.employeeSalary,
                              style: Constant.textStyleSize20(context)
                                  ?.copyWith(
                                    color: isEmployee
                                        ? Constant.colorOnError
                                        : Constant.cBlack,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Constant.paddingMidDouble.heightBox,
          Expanded(
            child: isEmployee
                ? const MySalaryScreen(isEmployee: false)
                : const MySalaryScreen(isEmployee: true),
          ),
        ],
      ),
    );
  }
}
