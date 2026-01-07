import 'package:flutter/material.dart';
import 'package:opentrip/Configs/app_routes.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Models/Equipment.dart';
import 'package:opentrip/Pages/Truck/truck_page.dart';
import 'package:opentrip/Widgets/custom_appbar.dart';
import 'package:opentrip/Widgets/loading_container.dart';

import '../../Repositories/app_repository.dart';
import '../../Widgets/toast_alert.dart';

class InsepctionPage extends StatefulWidget {
  const InsepctionPage({Key? key}) : super(key: key);

  @override
  State<InsepctionPage> createState() => _InsepctionPageState();
}

class _InsepctionPageState extends State<InsepctionPage> {
  List<Equipment> list = [];
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
      list = await AppRepository.findEquipment({"name": query});
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "Find Equipment"),
        body: LoadingContainer(
          isLoading: _isLoading,
          context: context,
          child: Padding(
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
                            hintText: "Find Equipment...",
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
                      return GestureDetector(
                        onTap: () {
                          AppRoutes.push(
                              context,
                              TruckPage(
                                trailerId: item.truckNum,
                                title: "${item.truckName} (${item.category}) ${item.builYear} ${item.make}",
                              ));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                      "${item.truckName} (${item.category}) ${item.builYear} ${item.make}"),
                                ),
                                const SizedBox(
                                  width: 10,
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
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
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
}
