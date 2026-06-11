import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/register_bloc/register_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/register_bloc/register_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/register_bloc/register_state.dart';
import 'package:oceanbit_timeclock/bloc_logic/user_detail_bloc/user_detail_bloc.dart';
import 'package:oceanbit_timeclock/constant/api.dart';
import 'package:oceanbit_timeclock/screen/admin_screens/employee_screen/widgets/alert_dialog.dart';
import 'package:oceanbit_timeclock/screen/profile/profile_screen.dart';
import 'package:oceanbit_timeclock/widget/new/custom_cardview.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../bloc_logic/add_update_personal_detail_bloc/add_update_personal_detail_bloc.dart';
import '../../../bloc_logic/department_bloc/department_bloc.dart';
import '../../../bloc_logic/department_bloc/department_event.dart';
import '../../../bloc_logic/department_bloc/department_state.dart';
import '../../../bloc_logic/user_list_bloc/user_list_bloc.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../models/get_department_model.dart';
import '../../../models/user_detail_model.dart';
import '../../../models/user_list_model.dart';
import '../../../utils/logger.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_container_button.dart';
import '../../../widget/custom_textfield_with_label.dart';
import '../../dashboard/dashboard.dart';
import 'current_employee.dart';

class PastEmployee extends StatefulWidget {
  const PastEmployee({Key? key, this.rowSegment, this.sizeTag})
    : super(key: key);
  final int? rowSegment;
  final int? sizeTag;

  @override
  State<PastEmployee> createState() => _PastEmployeeState();
}

bool isProfileDetail = false;
int selectedTabIndex = 0;
List<UserModelData> userListModel = [];
int selectedUserId = 0;

class _PastEmployeeState extends State<PastEmployee> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidateMode = false;
  int selectedIndex = -1;
  UserData? data;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  List<DepartmentData> departments = [];

  @override
  void initState() {
    /* if(userListModel==null){
      BlocProvider.of<UserListBloc>(context)
          .add(FetchUserListEvent(context: context));
    }*/
    BlocProvider.of<MyDepartmentBloc>(
      context,
    ).add(GetDepartmentEvent(context: context));
    super.initState();
  }

  // @override
  //   void didChangeDependencies() {
  //   BlocProvider.of<UserListBloc>(context).add(FetchUserListEvent(context: context));
  //   // isProfileDetail = false;
  //   print('employee init state');
  //   //selectedTabIndex = 0;
  //     super.didChangeDependencies();
  //   }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserListBloc()..add(FetchUserListEvent(context: context)),
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserListBloc, UserListState>(
            listener: (context, state) {
              if (state is GetUserListErrorState) {
                msgList.add(Constant().ShowErrorMessage(state.error, context));
                Constant.myLoader.hide();
                //Constant().ShowErrorToast(state.error, context);
              } else if (state is GetUserListLoadedState) {
                setState(() {
                  userListModel = List.generate(
                    state.data!.data!.length,
                    (index) => state.data!.data![index],
                  );

                  userListModel = userListModel
                      .where((map) => map.isActive == 0)
                      .toList();
                });
              }
            },
          ),
          BlocListener<
            AddUpdatePersonalDetailBloc,
            AddUpdatePersonalDetailState
          >(
            listener: (context, state) {
              if (state is UserStatusUpdateError) {
                msgList.add(Constant().ShowErrorMessage(state.error, context));
                Constant.myLoader.hide();
                //Constant().ShowErrorToast(state.error, context);
              } else if (state is UserStatusUpdateLoaded) {
                BlocProvider.of<UserListBloc>(
                  context,
                ).add(FetchUserListEvent(context: context));
                Navigator.pop(context);
              }
            },
          ),
          BlocListener<UserDetailBloc, UserDetailState>(
            listener: (context, state) {
              if (state is UserDetailErrorState) {
                Constant.myLoader.hide();
                msgList.add(Constant().ShowErrorMessage(state.error, context));
                // Constant().ShowErrorToast(state.error, context);
              } else if (state is UserDetailLoadedState) {
                setState(() {
                  data = state.data;
                  userDataInAdmin = data;
                  isProfileDetail = true;
                  Logger.println('past page data :: ${data!.id}');
                });
              }
            },
          ),
          BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterLoadedState) {
                Navigator.pop(context);
                emailController.clear();
                phoneController.clear();
                firstNameController.clear();
                lastNameController.clear();
                passwordController.clear();
                confirmPasswordController.clear();
                msgList.add(
                  Constant().ShowMessage(state.data!.message!, context),
                );
                BlocProvider.of<UserListBloc>(
                  context,
                ).add(FetchUserListEvent(context: context));
              } else if (state is RegisterErrorState) {
                msgList.add(Constant().ShowErrorMessage(state.error, context));
                Constant.myLoader.hide();

                Constant().ShowErrorToast(state.error, context);
              }
            },
          ),
          BlocListener<MyDepartmentBloc, DepartmentState>(
            listener: (context, state) {
              if (state is GetDepartmentLoading) {
                Constant.myLoader.show(context);
              } else {
                Constant.myLoader.hide();
                setState(() {});
              }

              if (state is GetDepartmentError) {
                msgList.add(Constant().ShowErrorMessage(state.errors, context));
                Constant.myLoader.hide();
                Logger.println('error ${state.errors}');
                //Constant().ShowToast(state.errors, context);
              } else if (state is GetDepartmentLoaded) {
                departments.clear();

                departments = List.generate(
                  state.data.data.length,
                  (index) => state.data.data[index],
                );
              }
            },
          ),
        ],
        child: isProfileDetail
            ? ProfileScreen(
                menuItem: Strings.adminDrawerItem[13],
                isEmployee: isProfileDetail,
                userDetail: data,
                isBack: (val) {
                  isProfileDetail = val;
                  setState(() {});
                },
                rowSegment: widget.rowSegment,
                sizeTag: widget.sizeTag,
              )
            : CustomHeaderContainer(
                padding: const EdgeInsets.symmetric(
                  vertical: Constant.paddingMidHalf,
                ),
                headerWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.employee,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Constant.cWhite),
                    ),
                    CustomContainerButton(
                      text: Strings.addEmployee,
                      textStyle: Constant.textStyleSize13(
                        context,
                      )!.copyWith(color: Constant.cBlack),
                      color: Constant.cWhite,
                      width: 110,
                      onTap: () {
                        emailController.clear();
                        phoneController.clear();
                        firstNameController.clear();
                        lastNameController.clear();
                        passwordController.clear();
                        confirmPasswordController.clear();
                        showDialog(
                          context: context,
                          builder: ((context) {
                            return Material(
                              color: Constant.cBlack.withOpacity(0.1),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: Constant.padding3x,
                                  left: MediaQuery.of(context).size.width * 0.2,
                                ),
                                child: Center(child: customDialog()),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    BlocConsumer<UserListBloc, UserListState>(
                      listener: (context, state) {
                        if (state is GetUserListErrorState) {
                          // Constant().ShowErrorToast(state.error, context);
                          msgList.add(
                            Constant().ShowErrorMessage(state.error, context),
                          );
                          Constant.myLoader.hide();
                        } else if (state is GetUserListLoadedState) {
                          userListModel = List.generate(
                            state.data!.data!.length,
                            (index) => state.data!.data![index],
                          );

                          userListModel = userListModel
                              .where((map) => map.isActive == 0)
                              .toList();
                        }
                      },
                      builder: (context, state) {
                        if (state is GetUserListLoadingState) {
                          return const Flexible(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Constant.cWhite,
                              ),
                            ),
                          );
                        }
                        return userListModel.isNotEmpty
                            ? Expanded(
                                child: ResponsiveGridList(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  rowMainAxisAlignment: MainAxisAlignment.start,
                                  desiredItemWidth: 120,
                                  minSpacing: 20,
                                  children: userListModel.map((i) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: Constant.paddingHalfHalf,
                                      ),
                                      child: customEmployeeNameWithProfilePic(
                                        i,
                                      ),
                                    );
                                  }).toList(),
                                ) /*Container(
                              child: customEmployeeNameWithProfilePic(widget.rowSegment!),
                            ),*/,
                              )
                            : const Flexible(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Constant.cWhite,
                                  ),
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget customEmployeeNameWithProfilePic(var data) {
    return /*GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(Constant.paddingHalf),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: rowSegment == 1 ? 4: rowSegment == 2 ? 7 : 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: MediaQuery.of(context).size.height * 0.23,
      ),
      itemCount: userListModel?.data?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            print('Id ::: ${userListModel?.data?[index].id!}');
            BlocProvider.of<UserDetailBloc>(context).add(
              FetchUserDetailEvent(id: "${userListModel?.data?[index].id}"),
            );
          },
          child: */ GestureDetector(
      onTap: () {
        Logger.println('past page Id ::: ${data.id!}');
        selectedUserId = data.id!;
        BlocProvider.of<UserDetailBloc>(
          context,
        ).add(FetchUserDetailEvent(id: "${data.id}", context: context));
        setState(() {});
      },
      child: CustomCardView(
        height: 181,
        child: Padding(
          padding: const EdgeInsets.all(Constant.paddingHalf),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: data.lastTimeSlot != null
                    ? data.lastTimeSlot.actionType == Strings.time_status[0] ||
                              data.lastTimeSlot.actionType ==
                                  Strings.time_status[2]
                          ? Constant.cGreenLight
                          : data.lastTimeSlot.actionType ==
                                Strings.time_status[1]
                          ? Constant.cYellowDark
                          : Constant.cRedLight
                    : Constant.cWhite,
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    "${Api.baseurl}${data.imageUrl}",
                  ),
                ),
              ),
              Constant.paddingHalfHalf.heightBox,
              SizedBox(
                height: 45,
                child: Text(
                  "${data.firstName} ${data.lastName}",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: Constant.textStyleSize15(context)?.copyWith(
                    // fontSize: 11.sp,
                    color: Constant.cBlack,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Constant.paddingHalfHalf.heightBox,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: ((context) {
                            return Material(
                              color: Constant.cBlack.withOpacity(0.1),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: Constant.padding3x,
                                  left: MediaQuery.of(context).size.width * 0.2,
                                ),
                                child: Center(
                                  child: customCertificateDialog(
                                    context,
                                    data!,
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                      child: Text(
                        Strings.certificate,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: Constant.textStyleSize10(context)?.copyWith(
                          // fontSize: 9.sp,
                          color: Constant.cGreenLight,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: ((context) {
                            return Material(
                              color: Constant.cBlack.withOpacity(0.1),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: Constant.padding3x,
                                  left: MediaQuery.of(context).size.width * 0.2,
                                ),
                                child: Center(
                                  child: AlertDialogue(
                                    id: data.id,
                                    isCurrent: false,
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                      child: Text(
                        Strings.pastEmployee,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: Constant.textStyleSize10(context)?.copyWith(
                          // fontSize: 9.sp,
                          color: Constant.cRed,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //     );
    //   },
    // );
  }

  String? selectedRole;
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  Widget customCertificateDialog(BuildContext context, var data) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.paddingHalf),
                color: Constant.colorSelectedIndicator,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Constant.paddingHalf),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(Constant.paddingHalf),
                          topLeft: Radius.circular(Constant.paddingHalf),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            Strings.changePassword,
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: Constant.cWhite),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Constant.cWhite,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Constant.cWhite,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(Constant.paddingHalf),
                        bottomLeft: Radius.circular(Constant.paddingHalf),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Constant.padding,
                        left: Constant.padding,
                        bottom: Constant.padding,
                        right: Constant.padding,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// 🔹 Role Dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   "Role",
                                //   style: Theme.of(context).textTheme.bodyMedium,
                                // ),
                                // const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: selectedRole,
                                  dropdownColor: Colors.white,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  iconEnabledColor: Colors.black,
                                  decoration: InputDecoration(
                                    hintText: "Select Role",
                                    hintStyle: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                    labelText: "Role",
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: departments
                                      .map(
                                        (role) => DropdownMenuItem<String>(
                                          value: role.name,
                                          child: Text(role.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRole = value;
                                    });
                                  },
                                  validator: (value) => value == null
                                      ? "Please select role"
                                      : null,
                                ),
                              ],
                            ),

                            Constant.padding.heightBox,

                            /// 🔹 Start Date
                            LabelWithTextField(
                              widgetWidth: 150,
                              labelText: "Start Date",
                              controller: startDateController,
                              hintText: "Select start date",
                              isRequired: true,

                              isEnable: true,
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year - 5),
                                  lastDate: DateTime(DateTime.now().year + 5),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Colors.black,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black,
                                          ),
                                        ),
                                        dialogBackgroundColor: Colors.white,
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (picked != null) {
                                  setState(() {
                                    selectedStartDate = picked;
                                    startDateController.text =
                                        "${picked.day}/${picked.month}/${picked.year}";

                                    /// Reset end date if it's before start date
                                    if (selectedEndDate != null &&
                                        selectedEndDate!.isBefore(picked)) {
                                      selectedEndDate = null;
                                      endDateController.clear();
                                    }
                                  });
                                }
                              },
                            ),

                            Constant.padding.heightBox,

                            /// 🔹 End Date
                            LabelWithTextField(
                              widgetWidth: 150,
                              labelText: "End Date",
                              controller: endDateController,
                              hintText: "Select end date",
                              isRequired: true,
                              isEnable: true,
                              onTap: () async {
                                if (selectedStartDate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please select start date first",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      selectedEndDate ?? selectedStartDate!,
                                  firstDate: selectedStartDate!, // ✅ key point
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Colors.black,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    selectedEndDate = pickedDate;
                                    endDateController.text =
                                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                  });
                                }
                              },
                            ),

                            Constant.padding.heightBox,

                            /// 🔹 Submit Button
                            CustomButton(
                              height: 35,
                              width: 120,
                              color: Constant.colorSelectedIndicator,
                              text: "Submit",
                              textStyle: Constant.textStyleSize13(
                                context,
                              )?.copyWith(color: Constant.cWhite),
                              onTap: () {
                                if (_formKey.currentState!.validate() &&
                                    selectedRole != null) {
                                  print("Role: $selectedRole");
                                  print(
                                    "Start Date: ${startDateController.text}",
                                  );
                                  print("End Date: ${endDateController.text}");

                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return Material(
                                        color: Constant.cBlack.withOpacity(0.1),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right: Constant.padding3x,
                                            left:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.2,
                                          ),
                                          child: Center(
                                            child: certificatePreviewDialog(
                                              context,
                                              data!,
                                              startDateController.text,
                                              endDateController.text,
                                              selectedRole!,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget customDialog() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.paddingHalf),
                color: Constant.cWhite,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Constant.paddingHalf),
                        topLeft: Radius.circular(Constant.paddingHalf),
                      ),
                      color: Constant.colorSelectedIndicator,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Constant.paddingHalf),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Strings.addEmployee,
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: Constant.cWhite),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Constant.cWhite,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(Constant.paddingHalf),
                        bottomLeft: Radius.circular(Constant.paddingHalf),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Constant.padding,
                        left: Constant.padding,
                        bottom: Constant.padding,
                        right: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidateMode
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LabelWithTextField(
                              labelText: Strings.firstName,
                              controller: firstNameController,
                              validatorString: Strings.firstNameEmpty,
                              hintText: Strings.firstNameHint,
                              isRequired: true,
                            ),
                            Constant.paddingHalf.heightBox,
                            LabelWithTextField(
                              labelText: Strings.lastName,
                              controller: lastNameController,
                              validatorString: Strings.lastNameEmpty,
                              hintText: Strings.lastNameHint,
                              isRequired: true,
                            ),
                            Constant.paddingHalf.heightBox,
                            LabelWithTextField(
                              labelText: Strings.email,
                              controller: emailController,
                              validatorFunction: (val) {
                                RegExp regExp = RegExp(Strings.emailValidate);
                                if (val!.isEmpty) {
                                  return Strings.emailEmpty;
                                } else if (!regExp.hasMatch(
                                  emailController.text,
                                )) {
                                  return Strings.emailValid;
                                }
                                return null;
                              },
                              validatorString: Strings.emailEmpty,
                              hintText: Strings.emailHint,
                              isRequired: true,
                            ),
                            Constant.paddingHalf.heightBox,
                            LabelWithTextField(
                              labelText: Strings.phone,
                              controller: phoneController,
                              validatorString: Strings.phoneEmpty,
                              hintText: Strings.phoneHint,
                              isRequired: true,
                            ),
                            Constant.paddingHalf.heightBox,
                            LabelWithTextField(
                              labelText: Strings.password,
                              controller: passwordController,
                              validatorString: Strings.passwordEmpty,
                              hintText: Strings.passwordHint,
                              isRequired: true,
                            ),
                            Constant.paddingHalf.heightBox,
                            LabelWithTextField(
                              labelText: Strings.confirmPassword,
                              controller: confirmPasswordController,
                              validatorFunction: (val) {
                                if (val!.isEmpty) {
                                  return Strings.confirmPasswordEmpty;
                                } else if (val != passwordController.text) {
                                  return Strings.confirmPasswordMisMatch;
                                }
                                return null;
                              },
                              hintText: Strings.confirmPasswordHint,
                              isRequired: true,
                            ),
                            Constant.padding.heightBox,
                            CustomContainerButton(
                              height: 40,
                              width: 140,
                              text: Strings.submit,
                              textStyle: Constant.textStyleSize14(
                                context,
                              )?.copyWith(color: Constant.cWhite),
                              color: Constant.colorSelectedIndicator,
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<RegisterBloc>(context).add(
                                    FetchRegisterEvent(
                                      context: context,
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      password: passwordController.text,
                                      confirmPassword:
                                          confirmPasswordController.text,
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _autoValidateMode = true;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
