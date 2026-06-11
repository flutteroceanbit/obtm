import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_ocean_team/get_ocean_team_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_ocean_team/get_ocean_team_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_ocean_team/get_ocean_team_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_ocean_team/get_ocean_team_state.dart';
import 'package:oceanbit_timeclock/widget/new/custom_cardview.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constant/api.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';

class OceanTeamScreen extends StatefulWidget {
  OceanTeamScreen({Key? key, required this.sizeTag}) : super(key: key);
  int sizeTag;

  @override
  State<OceanTeamScreen> createState() => _OceanTeamScreenState();
}

class _OceanTeamScreenState extends State<OceanTeamScreen> {
  List<String> flutterList = [
    'Jay Gohil',
    'Dilip Chavda',
    'Kavita Savani',
    'Nihar Thakkar',
    'Daxit savaliya',
    'Narayan gadhiya',
    'Aniket Tank',
  ];
  List<String> androidList = [
    'Aniket Tank',
    'Narayan Gadhiya',
    'Daxit Savaliya',
    'Nihar Thakkar',
  ];
  List<String> designerList = ['Vishal Meniya'];
  late GetOceanTeamRepository repo;
  @override
  void initState() {
    repo = context.read<GetOceanTeamRepository>();
    BlocProvider.of<GetOceanTeamBloc>(
      context,
    ).add(FetchOceanTeam(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetOceanTeamBloc, OceanTeamState>(
      listener: (context, state) {
        if (state is GetOceanTeamLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
        }
        if (state is GetOceanTeamLoaded) {
          setState(() {});
        }
      },
      child: CustomHeaderContainer(
        headerText: Strings.oceanTeam,
        // isExpand: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Constant.paddingHalfHalf),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  repo.oceanTeamList[index].employees.isEmpty
                  ? SizedBox()
                  : CustomHeaderContainer(
                      padding: const EdgeInsets.symmetric(
                        vertical: Constant.padding,
                      ),
                      isExpand: false,
                      headerWidget: Row(
                        children: [
                          Text(
                            repo.oceanTeamList[index].departmentName,
                            style: Constant.textStyleSize15(
                              context,
                            )?.copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                      headerContainerColor: Constant.cBlack5PerOpacity,
                      child: ResponsiveGridList(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        rowMainAxisAlignment: MainAxisAlignment.start,
                        desiredItemWidth: 100,
                        minSpacing: 20,
                        children: repo.oceanTeamList[index].employees.map((i) {
                          return customEmployeeCard(
                            '${i.user.firstName} ${i.user.lastName}',
                            i.user.imageUrl,
                          );
                        }).toList(),
                      ),
                    ),
              separatorBuilder: (context, index) =>
                  repo.oceanTeamList[index].employees.isEmpty
                  ? SizedBox()
                  : Constant.padding.heightBox,
              itemCount: repo.oceanTeamList.length,
            ) /*Column(
              children: [
                CustomHeaderContainer(
                  padding: const EdgeInsets.symmetric(
                    vertical: Constant.padding,
                  ),
                  isExpand: false,
                  headerWidget: Row(
                    children: [
                      Text(
                        'Flutter Developer',
                        style: Constant.textStyleSize15(
                          context,
                        )?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  headerContainerColor: Constant.cBlack5PerOpacity,
                  child: ResponsiveGridList(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    rowMainAxisAlignment: MainAxisAlignment.start,
                    desiredItemWidth: 100,
                    minSpacing: 20,
                    children: flutterList.map((i) {
                      return customEmployeeCard(i);
                    }).toList(),
                  ),
                ),
                Constant.padding.heightBox,
                CustomHeaderContainer(
                  padding: const EdgeInsets.symmetric(
                    vertical: Constant.padding,
                  ),
                  isExpand: false,
                  headerWidget: Row(
                    children: [
                      Text(
                        'Android Developer',
                        style: Constant.textStyleSize15(
                          context,
                        )?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  headerContainerColor: Constant.cBlack5PerOpacity,
                  child: ResponsiveGridList(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    rowMainAxisAlignment: MainAxisAlignment.start,
                    desiredItemWidth: 100,
                    minSpacing: 20,
                    children: androidList.map((i) {
                      return customEmployeeCard(i);
                    }).toList(),
                  ) */ /*GridView.builder(
                      shrinkWrap: true,
                      itemCount: androidList.length,
                      padding: const EdgeInsets.all(Constant.paddingHalfHalf),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 40,
                          mainAxisExtent:
                              MediaQuery.of(context).size.height * 0.19),
                      itemBuilder: (context, index) {
                        return customEmployeeCard(androidList[index]);
                      }),*/ /*,
                ),
                Constant.padding.heightBox,
                CustomHeaderContainer(
                  padding: const EdgeInsets.symmetric(
                    vertical: Constant.padding,
                  ),
                  isExpand: false,
                  headerWidget: Row(
                    children: [
                      Text(
                        'Designer',
                        style: Constant.textStyleSize15(
                          context,
                        )?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  headerContainerColor: Constant.cBlack5PerOpacity,
                  child: ResponsiveGridList(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    rowMainAxisAlignment: MainAxisAlignment.start,
                    desiredItemWidth: 100,
                    minSpacing: 20,
                    children: designerList.map((i) {
                      return customEmployeeCard(i);
                    }).toList(),
                  ) */ /*GridView.builder(
                      shrinkWrap: true,
                      itemCount: designerList.length,
                      padding: const EdgeInsets.all(Constant.paddingHalfHalf),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 40,
                          mainAxisExtent:
                              MediaQuery.of(context).size.height * 0.19),
                      itemBuilder: (context, index) {
                        return customEmployeeCard(designerList[index]);
                      }),*/ /*,
                ),
              ],
            ),*/,
          ),
        ),
      ),
    );
  }

  Widget customEmployeeCard(String name, String image) {
    return CustomCardView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Constant.paddingHalf,
          horizontal: Constant.paddingHalf,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 37,
              backgroundColor: Constant.colorSelectedIndicator,
              child: CircleAvatar(
                radius: 35,
                // backgroundColor: Constant.cBlack,
                backgroundImage: NetworkImage("${Api.baseurl}${image}"),
              ),
            ),
            Constant.paddingHalf.heightBox,
            SizedBox(
              height: 45,
              child: Text(
                name,
                softWrap: true,
                textAlign: TextAlign.center,
                style: Constant.textStyleSize15(context)?.copyWith(
                  color: Constant.cBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Constant.paddingHalfHalf.heightBox,
            // Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           showDialog(
            //             context: context,
            //             builder: ((context) {
            //               return Material(
            //                 color: Constant.cBlack.withOpacity(0.1),
            //                 child: Padding(
            //                   padding: EdgeInsets.only(
            //                       right: Constant.padding3x,
            //                       left: MediaQuery.of(context)
            //                           .size
            //                           .width *
            //                           0.2),
            //                   child: Center(child: AlertDialogue()),
            //                 ),
            //               );
            //             }),
            //           );
            //         },
            //         child: Text(
            //           "${Strings.resetPassword}",
            //           softWrap: true,
            //           textAlign: TextAlign.center,
            //           style:
            //           Constant.textStyleSize10(context)?.copyWith(
            //             // fontSize: 9.sp,
            //             color: Constant.cRed,
            //             decoration: TextDecoration.underline,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  /*Random r = Random();

  Widget rectangleWidget(int a) {
    return InkWell(
      onTap: () {
        print('clicked');
      },
      child:CustomCardView(
        width: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:Constant.paddingHalf,horizontal: Constant.paddingHalf),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Constant.colorSelectedIndicator,
                child: CircleAvatar(
                  backgroundColor: Constant.cWhite,
                    radius: 18,
                  child: Icon(Icons.person,size: 25,color: Constant.colorSelectedIndicator,
                  ),
                ),
              ),
              Constant.paddingHalfHalf.heightBox,
              Text(
                "Name",
                softWrap: true,
                textAlign: TextAlign.center,
                style: Constant.textStyleSize10(context)?.copyWith(
                  color: Constant.cBlack,
                ),
              ),
              Text(
                "Desi.",
                softWrap: true,
                textAlign: TextAlign.center,
                style: Constant.textStyleSize8(context)?.copyWith(
                  color: Constant.cBlack
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final Graph graph = Graph()..isTree = false;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    final node1 = Node.Id(1);
    final node2 = Node.Id(2);
    final node3 = Node.Id(3);
    final node4 = Node.Id(4);
    final node5 = Node.Id(5);
    final node6 = Node.Id(6);
    final node8 = Node.Id(7);
    final node7 = Node.Id(8);
    final node9 = Node.Id(9);
    final node10 = Node.Id(10);
    final node11 = Node.Id(11);
    final node12 = Node.Id(12);

    graph.addEdge(node1, node2,paint: Paint()..color = Colors.black);
    graph.addEdge(node1, node3, paint: Paint()..color = Colors.black);
    graph.addEdge(node1, node4, paint: Paint()..color = Colors.black);
    graph.addEdge(node1, node5,paint: Paint()..color = Colors.black);
    graph.addEdge(node1, node6,paint: Paint()..color = Colors.black);
    graph.addEdge(node2, node7, paint: Paint()..color = Colors.black);
    graph.addEdge(node7, node8, paint: Paint()..color = Colors.black);
    graph.addEdge(node8, node9,paint: Paint()..color = Colors.black);
    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (30)
      ..subtreeSeparation = (100)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }*/
}
