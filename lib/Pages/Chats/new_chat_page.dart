import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Helpers/constant.dart';
import 'package:opentrip/Helpers/helper.dart';
import 'package:opentrip/Helpers/navigator_service.dart';
import 'package:opentrip/Models/chat_model.dart';
import 'package:opentrip/Pages/App/Provider/auth_provider.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Chats/chat_details.dart';
import 'package:opentrip/Services/firestore_service.dart';
import 'package:opentrip/Widgets/overlay_loading.dart';

import '../../Widgets/custom_appbar.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  List<UserChatModel> _users = [];
  List<UserChatModel> _originalList = [];
  List<UserChatModel> _usersSelected = [];
  bool _canSelectMulti = false;
  bool _isLoading = false;
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    var user = AuthProvider.of(context).userChatModel;
    if (user!.role == UserRole.DISPATCHER) {
      _canSelectMulti = true;
    }
    _users = await FirestoreService.getListUsers(
        companyCode: user.companyCode!, currentUserId: user.docId!);
    _originalList = _users.toList();
    setState(() {});
  }

  _createRoom() async {
    if (_usersSelected.isNotEmpty) {
      try {
        setState(() {
          _isLoading = true;
        });
        var user = AuthProvider.of(context).userChatModel;
        var dateTime = DateTime.now().toUtc();
        var userIds =
            _usersSelected.map((e) => e.docId!).toList() + [user!.docId!];
        RoomModel? existRoom = await FirestoreService.checkRoomExist(userIds);

        if (existRoom != null) {
          setState(() {
            _isLoading = false;
          });
          replace(
              context,
              ChatDetails(
                roomModel: existRoom,
              ));
        } else {
          String roomId = await FirestoreService.createRoom(RoomModel(
              companyCode: _usersSelected.first.companyCode,
              createdAt: dateTime,
              isGeneral: false,
              updatedAt: dateTime,
              userIds: userIds,
              users: _usersSelected + [user],
              type: _usersSelected.length == 1
                  ? AppConstans.roomPrivate
                  : AppConstans.roomPublic,
              title: _usersSelected
                  .map((e) => e.name!)
                  .reduce((value, element) => "$value, $element")));
          RoomModel room = await FirestoreService.getRoomDetails(roomId);
          setState(() {
            _isLoading = false;
          });
          replace(
              context,
              ChatDetails(
                roomModel: room,
              ));
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
      },
      child: OverlayLoading(
        isLoading: _isLoading,
        child: Scaffold(
            appBar: CustomAppBar(
              title: "New Chat",
              centerTitle: false,
            ),
            bottomNavigationBar: SafeArea(
              child: GestureDetector(
                onTap: _createRoom,
                child: Container(
                  height: 50,
                  margin:
                      EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: BoxDecoration(
                    color: AppColors.primary(context),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Center(
                    child: Text(
                      "Create Chat",
                      style: AppStyles.textSize14(
                        color: AppColors.white(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                _users = _originalList.toList();
                              });
                            } else {
                              _users = _users
                                  .where((element) => element.name!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                              setState(() {});
                            }
                          },
                          style: AppStyles.textSize14(),
                          decoration: InputDecoration(
                            hintText: "Search contacts",
                            hintStyle: AppStyles.textSize14(
                              color: AppColors.grey1(context),
                            ),
                            constraints: const BoxConstraints(
                                minHeight: 45, maxHeight: 45),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          height: 45,
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,

                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primary(context),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  "Search",
                                  style: AppStyles.textSize14(
                                    color: AppColors.white(context),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.search,
                                size: 20,
                                color: AppColors.white(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Builder(builder: (context) {
                        if (_users.isNotEmpty) {
                          var groups = groupBy(_users, (p0) {
                            return p0.role;
                          });
                          return Column(
                            children: List.generate(groups.length, (index) {
                              var key = groups.keys.toList()[index]!;
                              // return GroupItem(
                              //   title: groups.keys.toList()[index]!,
                              //   users: groups[key]!,
                              // );
                              var list = groups[key] ?? [];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 16)
                                            .copyWith(top: 21),
                                    child: Text(
                                      formatRoleName(key),
                                      style: AppStyles.textSize16(
                                        color: AppColors.primary(context),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children:
                                        List.generate(list.length, (index) {
                                      var user = list[index];
                                      bool isSelected =
                                          _usersSelected.contains(user);
                                      return Item(
                                        onChanged: (p0) {
                                          if (isSelected) {
                                            _usersSelected.remove(user);
                                          } else {
                                            if (_canSelectMulti == false) {
                                              _usersSelected.clear();
                                            }
                                            _usersSelected.add(user);
                                          }
                                          setState(() {});
                                        },
                                        isSelected: isSelected,
                                        user: user,
                                      );
                                    }),
                                  ),
                                ],
                              );
                            }),
                          );
                        }
                        return Center(
                          child: Text("No Users Found"),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final UserChatModel user;
  final bool isSelected;
  final Function(bool) onChanged;
  const Item(
      {super.key,
      required this.user,
      required this.isSelected,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isSelected);
      },
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${user.name}",
                    style: AppStyles.textSize16(),
                  ),
                ),
                Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      onChanged(value!);
                    }),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
