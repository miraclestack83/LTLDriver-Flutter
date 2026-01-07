import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:opentrip/Configs/app_assets.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Helpers/helper.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Helpers/navigator_service.dart';
import 'package:opentrip/Models/chat_model.dart';
import 'package:opentrip/Pages/App/Provider/auth_provider.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Chats/chat_details.dart';
import 'package:opentrip/Pages/Chats/new_chat_page.dart';
import 'package:opentrip/Services/firestore_service.dart';
import 'package:mime/mime.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<RoomModel> _rooms = [];
  @override
  Widget build(BuildContext context) {
    var user = AuthProvider.of(context).userChatModel;
    if (user == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary(context),
        title: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(1000),
            //   child: CachedNetworkImage(
            //     imageUrl:
            //         "https://timsackett.com/wp-content/uploads/2020/01/people-person.jpg",
            //     width: 40,
            //     height: 40,
            //   ),
            // ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                "${user?.name}",
                style: AppStyles.textSize22(
                    color: AppColors.white(context),
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
        actions: [
          if (user?.role == UserRole.DISPATCHER)
            IconButton(
              onPressed: () {
                var allMembers = _rooms.firstWhere((element) =>
                    element.isGeneral == true &&
                    element.type == AppConstans.roomPublic);
                push(
                    context,
                    ChatDetails(
                      roomModel: allMembers,
                    ));
              },
              icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white(context),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.groupIcon2,
                      width: 24,
                      color: AppColors.primary(context),
                    ),
                  )),
            ),
          IconButton(
            onPressed: () {
              push(context, NewChatPage());
            },
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white(context),
              ),
              child: Center(
                  child: Icon(
                Icons.person,
                size: 22,
                color: AppColors.primary(context),
              )),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<RoomModel>>(
          stream: FirestoreService.getListRoomsStream(
              companyCode: user!.companyCode!, userId: user.docId!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var list = snapshot.data ?? [];
              print("✨-------> ${list.length}");
              if (list.isEmpty) {
                return Center(
                  child: Text("No Messages Found"),
                );
              }
              _rooms = list;
              var groups = groupBy(list, (RoomModel value) {
                return value.type;
              });
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  children: List.generate(groups.length, (index) {
                    var group = groups[groups.keys.toList()[index]];
                    var title = groups.keys.toList()[index];
                    if (title == AppConstans.roomPublic) {
                      title = 'Group channels';
                    } else {
                      title = "Private";
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: GroupItem(
                        title: title,
                        rooms: group!,
                        userId: user.docId!,
                      ),
                    );
                  }),
                ),
              );
            }
            return Container();
          }),
      // body: SingleChildScrollView(
      //   padding: EdgeInsets.all(15),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.only(bottom: 11),
      //         child: Text(
      //           "Group Channels",
      //           style: AppStyles.textSize13(),
      //         ),
      //       ),
      //       Column(
      //         children: List.generate(3, (index) {
      //           return Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 8),
      //             child: RoomItem(),
      //           );
      //         }),
      //       ),
      //       SizedBox(
      //         height: 16,
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(bottom: 11),
      //         child: Text(
      //           "Group Channels",
      //           style: AppStyles.textSize13(),
      //         ),
      //       ),
      //       Column(
      //         children: List.generate(3, (index) {
      //           return Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 8),
      //             child: RoomItem(),
      //           );
      //         }),
      //       ),
      //       SizedBox(
      //         height: 16,
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(bottom: 11),
      //         child: Text(
      //           "Group Channels",
      //           style: AppStyles.textSize13(),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class GroupItem extends StatelessWidget {
  final String title;
  final List<RoomModel> rooms;
  final String userId;
  const GroupItem(
      {super.key,
      required this.title,
      required this.rooms,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: Text(
            title,
            style: AppStyles.textSize13(),
          ),
        ),
        Column(
          children: List.generate(rooms.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: RoomItem(
                roomModel: rooms[index],
                userId: userId,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class RoomItem extends StatelessWidget {
  final RoomModel roomModel;
  final String userId;
  const RoomItem({super.key, required this.roomModel, required this.userId});

  @override
  Widget build(BuildContext context) {
    int unread = 0;
    if (roomModel.unread != null) {
      int total = roomModel.unread!['total'] ?? 0;
      int my = roomModel.unread![userId] ?? 0;
      unread = total - my;
    }
    return GestureDetector(
      onTap: () {
        push(
            context,
            ChatDetails(
              roomModel: roomModel,
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white(context),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              // child: ClipRRect(
              //   borderRadius: BorderRadius.circular(1000),
              //   child: CachedNetworkImage(
              //     width: 50,
              //     height: 50,
              //     imageUrl:
              //         "https://cdn.britannica.com/17/126517-050-9CDCBDDF/semi-semitrailer-truck-tractor-highway.jpg",
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Helpers.getRandomColorFromList(),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.white(context),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Builder(builder: (context) {
                          String title = roomModel.title ?? "";
                          var user = AuthProvider.of(context).userChatModel;
                          if (roomModel.type == AppConstans.roomPrivate) {
                            try {
                              var users = roomModel.users?.toList() ?? [];
                              users.removeWhere(
                                  (element) => element.docId == user!.docId);
                              title = users.first.name ?? "";
                            } catch (e) {}
                          }
                          return Text(
                            title,
                            style: AppStyles.textSize16(),
                            overflow: TextOverflow.clip,
                          );
                        }),
                      ),
                      Text(
                        "${Helpers.formatDateTime(roomModel.updatedAt?.toString() ?? "", fomat: "dd/MM/yy HH:mm")}",
                        // roomModel.updatedAt ?? "",
                        style: AppStyles.textSize10(
                          color: Color(0xff949494),
                        ),
                      ),
                    ],
                  ),
                  if (roomModel.users!.length > 1)
                    Text(
                      roomModel.users!
                          .map((e) => e.name!)
                          .reduce((value, element) => value + ', ' + element),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.textSize10(
                        color: Colors.blue[300],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: Builder(builder: (context) {
                          String text = roomModel.lastedMessage ?? "";
                          // if (roomModel.metaData != null) {
                          //   var path = roomModel.metaData!['file_path'];
                          //   var uri = Uri.parse(path);
                          //   path = uri.path;
                          //   var type = lookupMimeType(path)!.split('/').first;
                          //   if (type == 'image') {
                          //     return Icon(
                          //       Icons.image,
                          //       color: Color(0xff949494),
                          //     );
                          //   }
                          //   return Icon(
                          //     Icons.video_collection_sharp,
                          //     color: Color(0xff949494),
                          //   );
                          // }
                          return Text(
                            text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.textSize14(
                              color: Color(0xff949494),
                            ),
                          );
                        }),
                      ),
                      if (unread > 0)
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 10,
                          child: Text(
                            "${unread}",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
