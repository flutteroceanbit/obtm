import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/quote_bloc/quote_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/quote_bloc/quote_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/quote_bloc/quote_state.dart';
import 'package:oceanbit_timeclock/models/quotes/get_quotes_model.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../utils/logger.dart';
import '../dashboard/dashboard.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({Key? key}) : super(key: key);

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  List<QuoteData> allQuotes = [];

  @override
  void initState() {
    BlocProvider.of<MyQuoteBloc>(context).add(
      GetQuoteEvent(context: context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyQuoteBloc, QuoteState>(
      listener: (context, state) {
        if (state is GetQuoteLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetQuoteError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetQuoteLoaded) {
          allQuotes.clear();
          allQuotes = List.generate(
              state.data.data.length, (index) => state.data.data[index]);
        }
      },
      child: CustomHeaderContainer(
        // headerText: Strings.oceanQuote,
        headerWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Strings.oceanQuotes,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Constant.cWhite),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: allQuotes.isEmpty
                  ? const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'No Data',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              )
                  : ListView.builder(
                itemCount: allQuotes.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Constant.padding),
                    child: Row(
                      children: [
                        bulletPoint(color: Constant.cBlack),
                        Constant.padding.widthBox,
                        Expanded(
                          child: Text(
                            allQuotes[index].quotes,
                            style: Constant.textStyleSize13(context)
                                ?.copyWith(color: Constant.cBlack),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bulletPoint({Color? color}) {
    return Container(
      height: 7,
      width: 7,
      decoration:
          BoxDecoration(color: color ?? Colors.black54, shape: BoxShape.circle),
    );
  }
}
