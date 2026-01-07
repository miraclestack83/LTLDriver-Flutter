import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
// as CustomeDateTimePicker;
import 'package:opentrip/Configs/app_routes.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/InboundPlans/plan_details_page.dart';
import 'package:opentrip/Widgets/custom_appbar.dart';
import 'package:opentrip/Widgets/loading_container.dart';

import '../../Models/plan.dart';
import '../../Repositories/app_repository.dart';
import '../../Widgets/toast_alert.dart';

class InboundPlans extends StatefulWidget {
  const InboundPlans({Key? key}) : super(key: key);

  @override
  State<InboundPlans> createState() => _InboundPlansState();
}

class _InboundPlansState extends State<InboundPlans> {
  DateTime _dateTime = DateTime.now();
  bool _isLoading = false;
  List<Plan> inboundPlans = [];
  @override
  void initState() {
    _fecthData(formatTime(dateTime: _dateTime, newPattern: "yyyy-MM-dd"));
    super.initState();
  }

  _fecthData(String dateTime) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final terminalId = await getDataInLocal(
          key: AppLocalKeys.TERMINAL_ID, type: StorableDataType.INT);

      print('inboundplans');
      print(dateTime);
      inboundPlans = await AppRepository.getInboundPlans({
        "terminalID": terminalId,
        "day": dateTime,
      });
      print(inboundPlans);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ToastAlart.error(context, e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Inbound Plans"),
      body: LoadingContainer(
        isLoading: _isLoading,
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.date_range),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        DateTime currentDate = DateTime.now();
                        DateTime tenYearsAfter =
                            currentDate.add(Duration(days: 365 * 10));
                        final DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: _dateTime,
                          firstDate: DateTime(2000),
                          lastDate: tenYearsAfter,
                        );
                        print("Picked DateTime");
                        print(dateTime);

                        await _fecthData(
                          formatTime(
                              dateTime: dateTime!, newPattern: "MM-dd-yyyy"),
                        );
                        setState(() {
                          _dateTime = dateTime!;
                        });
                        // CustomeDateTimePicker.DatePicker.showDatePicker(context,
                        //     currentTime: _dateTime,
                        //     minTime: DateTime.now(), onConfirm: (dateTime) {
                        //   _dateTime = dateTime;

                        // });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Text(
                          formatTime(
                              dateTime: _dateTime, newPattern: "yyyy-MM-dd"),
                          style: AppStyles.textSize16(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(child: Builder(builder: (_) {
                if (_isLoading == false && inboundPlans.isEmpty) {
                  return const Center(
                    child: Text("No Plans Found."),
                  );
                }
                if (inboundPlans.isNotEmpty) {
                  return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemBuilder: (_, index) {
                        var item = inboundPlans[index];
                        return GestureDetector(
                          onTap: () {
                            AppRoutes.push(
                                context, PlanDetailsPage(plan: item));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Plan #${item.planId}",
                                          style: AppStyles.textSize17(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                            "Trailer: ${(item.trailerNumber != null) ? item.trailerNumber : 'N/A'}"),
                                        Text(
                                            "Notes: ${item.planNotes ?? "N/A"}")
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, index) {
                        return SizedBox(
                          height: 4,
                        );
                      },
                      itemCount: inboundPlans.length);
                }
                return Container();
              }))
            ],
          ),
        ),
      ),
    );
  }
}
