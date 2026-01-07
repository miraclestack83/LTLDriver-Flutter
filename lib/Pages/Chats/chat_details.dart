import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:opentrip/Helpers/helper.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Models/chat_model.dart';
import 'package:opentrip/Pages/App/Provider/auth_provider.dart';
import 'package:opentrip/Pages/Chats/media_modal.dart';
import 'package:opentrip/Services/firestore_service.dart';
import 'package:opentrip/Widgets/overlay_loading.dart';
// import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:open_filex/open_filex.dart';

import '../../Configs/app_styles.dart';
import '../../Widgets/custom_appbar.dart';
import '../App/Styles/colors.dart';

class ChatDetails extends StatefulWidget {
  final RoomModel? roomModel;
  const ChatDetails({super.key, this.roomModel});

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  List<types.Message> _messages = [];
  types.User? _user;
  late RoomModel? _roomModel = widget.roomModel;
  bool _isLoading = false;
  @override
  void initState() {
    FirestoreService.currentRoomId = widget.roomModel?.id;
    _init();
    super.initState();
  }

  _init() {
    var user = AuthProvider.of(context).userChatModel;

    setState(() {
      _user = types.User(id: user!.docId!, firstName: user.name ?? "");
    });
    if (_roomModel != null) {
      int total = _roomModel!.unread?['total'] ?? 0;
      FirestoreService.checkReadMessages(
          roomId: _roomModel!.id!, userId: user!.docId!, total: total);

      FirestoreService.getListMessageStream(roomId: _roomModel!.id!)
          .listen((event) async {
        setState(() {
          _messages = event
              .map((e) {
                var role = user!.role!;
                if (role != UserRole.DISPATCHER &&
                    _roomModel?.type == AppConstans.roomPublic) {
                  try {
                    var sender = _roomModel!.users!
                        .firstWhere((element) => element.docId == e.author.id);
                    if (sender.role != UserRole.DISPATCHER &&
                        sender.docId != _user!.id) {
                      return null;
                    }
                  } catch (e) {}
                }
                if (e.type == types.MessageType.image) {
                  var uri = e.metaData != null
                      ? (e.metaData?['file_path'] ?? "")
                      : (e.message ?? "");
                  var size =
                      e.metaData != null ? (e.metaData?['fileSize'] ?? 0) : 0;
                  return types.ImageMessage(
                    author: e.author,
                    name: "image",
                    id: e.id,
                    size: size,
                    uri: uri,
                  );
                } else if (e.type == types.MessageType.video) {
                  var uri = e.metaData != null
                      ? (e.metaData?['file_path'] ?? "")
                      : (e.message ?? "");

                  return types.VideoMessage(
                    author: e.author,
                    name: "video",
                    id: e.id,
                    size: 10000,
                    metadata: e.metaData,
                    uri: uri,
                  );
                } else if (e.type == types.MessageType.file) {
                  var uri = e.metaData != null
                      ? (e.metaData?['file_path'] ?? "")
                      : (e.message ?? "");
                  final size =
                      e.metaData != null ? (e.metaData?['fileSize'] ?? 0) : 0;
                  return types.FileMessage(
                    author: e.author,
                    name: "file",
                    id: e.id,
                    size: size,
                    metadata: e.metaData,
                    uri: uri,
                  );
                }
                return types.TextMessage(
                  author: e.author,
                  id: e.id,
                  text: e.message ?? "",
                  createdAt: e.createdAt,
                  metadata: e.metadata,
                  type: e.type,
                  updatedAt: e.updatedAt,
                );
              })
              .where((element) => element != null)
              .whereType<types.Message>()
              .toList();
        });
      });
    }
  }

  void _addMessage(types.Message message) async {
    if (_roomModel != null) {
      List<UserChatModel> list = [];
      try {
        list = _roomModel!.users!.toList();
        list.removeWhere((element) => element.docId == _user!.id);
      } catch (e) {}
      await FirestoreService.sendAMessage(
          users: list,
          userId: _user!.id,
          room: _roomModel!,
          chatModel: ChatModel(
            author: message.author,
            metaData: message.metadata,
            id: message.id,
            type: message.type,
            createdAt: message.createdAt,
            message: message.toJson()['text'],
            //
          ));
    }
  }

  _handleAttachmentPressed() async {
    var result = await showModalBottomSheet(
      context: context,
      builder: (_) {
        return const MediaModal();
      },
      backgroundColor: Colors.transparent,
    );
    if (result == 'image') {
      _handleImageSelection(ImageSource.gallery);
    } else if (result == 'video') {
      _handleVideoSelection();
    } else if (result == "camera") {
      _handleImageSelection(ImageSource.camera);
    }
  }

  void _handleVideoSelection() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.video, allowMultiple: false);

    if (result != null && result.files.single.path != null) {
      try {
        setState(() {
          _isLoading = true;
        });
        String? thumbnail;
        var file = File(result.files.single.path!);
//upload video thumbnail
        {
          var thumbnailFile = await Helpers.getVideoThumbnail(file);
          var taskThumbnail =
              await FirestoreService.uploadFileToFireStorage(thumbnailFile);
          await taskThumbnail.whenComplete(() => null);
          thumbnail = await taskThumbnail.storage
              .ref(taskThumbnail.snapshot.metadata!.fullPath)
              .getDownloadURL();
        }

        var task = await FirestoreService.uploadFileToFireStorage(file);
        await task.whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
        String path = await task.storage
            .ref(task.snapshot.metadata!.fullPath)
            .getDownloadURL();

        setState(() {
          _isLoading = false;
        });
        final message = types.VideoMessage(
            author: _user!,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            name: result.files.single.name,
            size: result.files.single.size,
            uri: path,
            metadata: {
              "file_path": path,
              "thumbnail": thumbnail,
            });

        _addMessage(message);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleImageSelection(ImageSource source) async {
    try {
      final result = await ImagePicker().pickImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: source,
      );
      if (result != null) {
        try {
          setState(() {
            _isLoading = true;
          });
          final bytes = await result.readAsBytes();
          final image = await decodeImageFromList(bytes);
          var file = await Helpers.saveBytesToTemporaryFile(
              uint8list: bytes, extension: result.path.split('.').last);
          var task = await FirestoreService.uploadFileToFireStorage(file);
          await task.whenComplete(() {
            setState(() {
              _isLoading = false;
            });
          });
          String path = await task.storage
              .ref(task.snapshot.metadata!.fullPath)
              .getDownloadURL();

          setState(() {
            _isLoading = false;
          });
          final message = types.ImageMessage(
              author: _user!,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              height: image.height.toDouble(),
              id: const Uuid().v4(),
              name: result.name,
              size: bytes.length,
              uri: result.path,
              width: image.width.toDouble(),
              metadata: {
                "file_path": path,
                "thumbnail": null,
              });

          _addMessage(message);
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      openAppSettings();
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    // final index = _messages.indexWhere((element) => element.id == message.id);
    // final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
    //   previewData: previewData,
    // );

    // setState(() {
    //   _messages[index] = updatedMessage;
    // });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    FirestoreService.currentRoomId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = AuthProvider.of(context).userChatModel;
    bool canSendMessage = true;
    if (_roomModel?.type == AppConstans.roomPublic) {
      if (user?.role != UserRole.DISPATCHER) {
        canSendMessage = false;
      }
    }
    return OverlayLoading(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primary(context),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(_roomModel?.type == AppConstans.roomPublic
                    ? Icons.people
                    : Icons.person),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _roomModel?.title ?? "",
                      style: AppStyles.textSize22(
                          color: AppColors.white(context),
                          fontWeight: FontWeight.w700),
                    ),
                    if (_roomModel?.type == AppConstans.roomPrivate)
                      Builder(builder: (context) {
                        var role = '';
                        if (_roomModel?.users?.isNotEmpty ?? false) {
                          role = _roomModel?.users?.first.role ?? "";
                        }
                        return Text(formatRoleName(role),
                            style: AppStyles.textSize12(
                              color: AppColors.white(context),
                            ));
                      })
                  ],
                ),
              )
            ],
          ),
        ),
        body: Chat(
          customBottomWidget: canSendMessage ? null : Container(),
          messages: _messages,
          onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          showUserAvatars: true,
          avatarBuilder: (userId) {
            return Container(
              width: 30,
              margin: const EdgeInsets.only(right: 8),
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 18,
                color: Colors.white,
              ),
            );
          },
          showUserNames: true,
          user: _user!,
          videoMessageBuilder: (p0, {required messageWidth}) {
            String thumbnail = p0.metadata?['thumbnail'] ?? "";
            return GestureDetector(
              onTap: () {
                launchUrl(Uri.parse(p0.uri));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: thumbnail,
                      width: MediaQuery.of(context).size.width * 0.4,
                      fit: BoxFit.fitWidth,
                    ),
                    const Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          theme: DefaultChatTheme(
            inputBorderRadius: BorderRadius.zero,
            // inputTextColor: Colors.grey[300]!,
            documentIcon: Icon(
              Icons.attachment,
              color: AppColors.primary(context),
            ),
            sendButtonIcon: Icon(
              Icons.send,
              color: AppColors.primary(context),
            ),
            secondaryColor: Colors.blue[100]!,
            inputTextColor: AppColors.black(context),
            inputTextStyle:
                AppStyles.textSize14(color: AppColors.black(context)),
            backgroundColor: Colors.grey[100]!,
            inputContainerDecoration: BoxDecoration(
              color: AppColors.white(context),
            ),
            // inputBackgroundColor: AppColors.primary(context),
            // backgroundColor: AppColors.primary(context),
          ),
        ),
      ),
    );
  }
}
