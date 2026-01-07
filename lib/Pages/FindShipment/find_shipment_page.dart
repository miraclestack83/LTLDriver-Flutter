import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:opentrip/Configs/app_routes.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Helpers/library.dart';
import 'package:opentrip/Models/shipment_model.dart';
import 'package:opentrip/Pages/ShipmentPage/shipment_page.dart';
import 'package:opentrip/Pages/Truck/truck_page.dart';
import 'package:opentrip/Widgets/custom_appbar.dart';
import 'package:opentrip/Widgets/loading_container.dart';

import '../../Repositories/app_repository.dart';
import '../../Widgets/toast_alert.dart';

class FindShipmentPage extends StatefulWidget {
  const FindShipmentPage({Key? key}) : super(key: key);

  @override
  State<FindShipmentPage> createState() => _FindShipmentPageState();
}

class _FindShipmentPageState extends State<FindShipmentPage> {
  List<ShipmentModel> list = [];
  bool _isLoading = false;
  final TextEditingController _textEditingController = TextEditingController();
  _search(String query) async {
    if (query.isEmpty) {
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      list = await AppRepository.findShipment({"keyword": query});
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Logger().e(e.toString());
      ToastAlart.error(context, e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "Find Shipment by Ref# or Cust"),
        body: LoadingContainer(
          isLoading: _isLoading,
          context: context,
          child: Container(
            color: Color.fromARGB(255, 243, 247, 249),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        onSubmitted: _search,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              size: 22,
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            hintText: "Find ShipmentModel...",
                            prefixIconConstraints: BoxConstraints(
                                minHeight: 50, maxHeight: 50, minWidth: 40),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            constraints: BoxConstraints(maxHeight: 50)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _search(_textEditingController.text);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Text(
                          "Search",
                          style: AppStyles.textSize15(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemBuilder: (_, index) {
                      final item = list[index];
                      return listItem(
                          context: context,
                          onTap: () {
                            AppRoutes.push(
                                context,
                                ShipmentPage(
                                  shipment: item,
                                ));
                          },
                          shipment: item);
                    },
                    itemCount: list.length,
                    separatorBuilder: (_, index) {
                      return const SizedBox(
                        height: 2,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listItem({
    required BuildContext context,
    required ShipmentModel shipment,
    required Function onTap,
  }) {
    return ListTile(
      onTap: () {
        onTap();
      },
      title: Text(
        'Ref# ${shipment.ref1} - Bill To: ${shipment.FullName}',
        overflow: TextOverflow.fade,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      subtitle: Column(
        children: [
          Text(
              'PRO# ${shipment.shipNum} CM: ${shipment.movescount}; Consignee: ${shipment.Consignee} \r\nDelivery: ${stringToDateFormat(shipment.createTime ?? '', 'MM/dd/yyyy h:mm a')} - ${stringToDateFormat(shipment.soonestDelvDate ?? '', 'MM/dd h:mm a')}'),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }
}
