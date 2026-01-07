import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:opentrip/Configs/app_routes.dart';
import 'package:opentrip/Models/documents.dart';
import 'package:opentrip/Models/plan.dart';
import 'package:opentrip/Pages/InboundPlans/view_image_page.dart';
import 'package:opentrip/Widgets/custom_appbar.dart';
import 'package:opentrip/Widgets/loading_container.dart';

import '../../Configs/app_styles.dart';
import '../../Repositories/app_repository.dart';
import '../../Widgets/toast_alert.dart';

class PlanDetailsPage extends StatefulWidget {
  final Plan plan;
  const PlanDetailsPage({Key? key, required this.plan}) : super(key: key);

  @override
  State<PlanDetailsPage> createState() => _PlanDetailsPageState();
}

class _PlanDetailsPageState extends State<PlanDetailsPage> {
  List<PlanDetails> planDetails = [];
  bool _isLoading = false;
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      Logger().d(widget.plan.planId);
      planDetails = await AppRepository.getPlanDetails("${widget.plan.planId}");
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
      appBar: CustomAppBar(title: "Plan #${widget.plan.planId} Details"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    "Trailer: ${widget.plan.trailerNumber ?? 'N/A'}",
                    style: AppStyles.textSize17(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Trailer: ${widget.plan.trailerNumber ?? 'N/A'}"),
                      Text("Notes: ${widget.plan.planNotes ?? "N/A"}")
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                ),
              ],
            ),
            ...planDetails.map((e) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "PRO #${e.shipNum}, Images: ${e.proPics}",
                            style: AppStyles.textSize17(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                // isScrollControlled: true,

                                builder: (_) {
                                  return ListImageWidget(pro: "${e.shipNum}");
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text("View"),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${e.pcs1} ${e.uom}",
                              style: AppStyles.textSize16(
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              " - ${e.weight} Lb",
                              style: AppStyles.textSize16(),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Shipper:",
                              style: AppStyles.textSize16(
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              " ${e.shiperCityStateo}",
                              style: AppStyles.textSize16(),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Consignee:",
                              style: AppStyles.textSize16(
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              " ${e.consigCityStateale}",
                              style: AppStyles.textSize16(),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delv:",
                              style: AppStyles.textSize16(
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              " ${e.delvFromShort}",
                              style: AppStyles.textSize16(),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class ListImageWidget extends StatefulWidget {
  final String pro;
  const ListImageWidget({Key? key, required this.pro}) : super(key: key);

  @override
  State<ListImageWidget> createState() => _ListImageWidgetState();
}

class _ListImageWidgetState extends State<ListImageWidget> {
  List<Document> images = [];
  bool _isLoading = false;
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      images = await AppRepository.getProPictures(widget.pro);
      print('images');
      print(images);
      Logger().d(images);
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
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Builder(builder: (context) {
          if (_isLoading) {
            return const CircularProgressIndicator();
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: images.map((e) {
                return GestureDetector(
                  onTap: () {
                    AppRoutes.push(context, ViewImagePage(image: e.picture!));
                  },
                  child: Card(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${e.descr}",
                                style: AppStyles.textSize16(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.image,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )),
                );
              }).toList(),
            ),
          );
        }),
      ),
    );
  }
}
