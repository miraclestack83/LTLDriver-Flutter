import 'package:flutter/material.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Repositories/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../Models/company_contact.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/loading_container.dart';
import '../../../Widgets/toast_alert.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  bool _isLoading = false;
  List<CompanyContact> contacts = [];
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future _fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      contacts = await AppRepository.getListCompanyContact();

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
      appBar: const CustomAppBar(title: "Company's Contacts"),
      body: LoadingContainer(
          context: context,
          isLoading: _isLoading,
          child: Builder(builder: (context) {
            if (_isLoading == false && contacts.isEmpty) {
              return Center(
                child: Text("No Data Found"),
              );
            }
            return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemBuilder: (_, index) {
                  final contact = contacts[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            child: Row(
                              children: [
                                Text(
                                  "${contact.fullName}",
                                  style: AppStyles.textSize16(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Title: ${contact.position}",
                                  style: AppStyles.textSize15(),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Email: ",
                                      style: AppStyles.textSize15(),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        final Uri emailLaunchUri = Uri(
                                          scheme: 'mailto',
                                          path: 'smith@example.com',
                                        );

                                        launchUrl(emailLaunchUri);
                                      },
                                      child: Text(
                                        "${contact.email}",
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: contacts.length);
          })),
    );
  }
}
