import 'package:flutter/material.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Widgets/custom_appbar.dart';

import '../../../Helpers/local_storage.dart';
import '../../../Repositories/app_repository.dart';
import '../../../Widgets/loading_container.dart';
import '../../../Widgets/toast_alert.dart';

class TimeCard extends StatefulWidget {
  const TimeCard({Key? key}) : super(key: key);

  @override
  State<TimeCard> createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard> {
  bool _isLoading = false;
  List<dynamic> timeCards = [];
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final driverId = await getDataInLocal(
          key: AppLocalKeys.DRIVER_ID, type: StorableDataType.INT);
      final dateTime =
          formatTime(dateTime: DateTime.now(), newPattern: "yyyy-MM-dd");
      timeCards = await AppRepository.getTimeCard("$driverId", dateTime);
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
    return LoadingContainer(
      isLoading: _isLoading,
      context: context,
      child: Scaffold(
        appBar: const CustomAppBar(title: "Timecard"),
        body: timeCards.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Table(
                  border: TableBorder.all(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Container(
                          height: 32,
                          alignment: Alignment.center,
                          child: const Text("Day"),
                        ),
                        Container(
                          height: 32,
                          alignment: Alignment.center,
                          child: const Text("In"),
                        ),
                        Container(
                          height: 32,
                          alignment: Alignment.center,
                          child: const Text("Out"),
                        ),
                      ],
                    ),
                    ...List.generate(7, (index) {
                      var date = DateTime.now().add(Duration(days: index));
                      return TableRow(
                        children: <Widget>[
                          Container(
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(formatTime(
                                dateTime: date, newPattern: "MM/dd")),
                          ),
                          Container(
                            height: 32,
                            alignment: Alignment.center,
                            // child: Text('234'),
                            child: (timeCards[0]['inDay${index + 1}'] != null &&
                                    timeCards[0]['inDay${index + 1}'] != '')
                                ? Text(
                                    '${timeCards[0]['inDay${index + 1}']}',
                                  )
                                : Text('N/A'),
                          ),
                          Container(
                            height: 32,
                            alignment: Alignment.center,
                            // child: Text('65756'),
                            child: (timeCards[0]['outDay${index + 1}'] !=
                                        null &&
                                    timeCards[0]['outDay${index + 1}'] != '')
                                ? Text(
                                    '${timeCards[0]['outDay${index + 1}']}',
                                  )
                                : Text('N/A'),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
      ),
    );
  }
}
