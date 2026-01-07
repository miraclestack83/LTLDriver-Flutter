import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Pages/App/Provider/auth_provider.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/CodePage/code_page.dart';
import 'package:opentrip/Pages/HomePage/home_page.dart';
import 'package:opentrip/Repositories/index.dart';
import 'package:opentrip/Services/firestore_service.dart';
import 'package:opentrip/Widgets/index.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

class SignInPage extends StatefulWidget {
  // SignInPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final pageStrings = new AppStrings();

  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontSize: 14.0);

  // Gloabal key for progress dialog
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  // Load
  bool _isLoading = false;
  String errorMessage = '';
  String progressMsg = '';
  final FlutterAppAuth appAuth = FlutterAppAuth();
// const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  /// -----------------------------------
  /// Get User Data from Backend
  /// -----------------------------------
  Future<void> getUserDataFromBackend(
      String email, String companyCode, String token) async {
    setState(() {
      _isLoading = true;
      progressMsg = "Getting data from server...";
    });

    try {
      Map<String, dynamic> data = {
        'email': email,
        // 'email': 'adamwalan@yahoo.com',
        'companyCode': companyCode,
      };

      Map<String, dynamic> res = await UserRepository.login(data);
      Logger().e(res['error']);
      // Error Check
      if (res == null || (res['error'] != null && res['error'] != "")) {
        if (res == null) {
          showError("User not found. Please retry!");
        } else {
          showError(res['error'].toString());
        }
        return;
      }

      ///-------------------------------------
      /// SAVE INFOS
      /// ------------------------------------
      await storeDataToLocal(
        key: AppLocalKeys.TOKEN,
        value: token,
        type: StorableDataType.String,
      );

      await storeDataToLocal(
          key: AppLocalKeys.DRIVER_ID,
          value: res[AppLocalKeys.DRIVER_ID] != null
              ? int.parse(res[AppLocalKeys.DRIVER_ID].toString())
              : 0,
          type: StorableDataType.INT);

      await storeDataToLocal(
          key: AppLocalKeys.TERMINAL_ID,
          value: res[AppLocalKeys.TERMINAL_ID] != null
              ? int.parse(res[AppLocalKeys.TERMINAL_ID].toString())
              : 0,
          type: StorableDataType.INT);

      await storeDataToLocal(
          key: AppLocalKeys.TRUCK_ID,
          value: res[AppLocalKeys.TRUCK_ID] != null
              ? int.parse(res[AppLocalKeys.TRUCK_ID].toString())
              : 0,
          type: StorableDataType.INT);

      await storeDataToLocal(
          key: AppLocalKeys.PROFILE,
          value: res[AppLocalKeys.PROFILE] ?? UserRole.DRIVER,
          type: StorableDataType.String);

      await storeDataToLocal(
          key: AppLocalKeys.USERNAME,
          value: res['Name'].toString() ?? "",
          type: StorableDataType.String);

      await storeDataToLocal(
        key: AppLocalKeys.EMAIL,
        // value: 'adamwalan@yahoo.com',
        value: email,
        type: StorableDataType.String,
      );

      await storeDataToLocal(
          key: AppLocalKeys.LAST_SHIPMENT,
          value: res[AppLocalKeys.LAST_SHIPMENT] != null
              ? int.parse(res[AppLocalKeys.LAST_SHIPMENT].toString())
              : 0,
          type: StorableDataType.INT);

      await storeDataToLocal(
          key: AppLocalKeys.PUNCH_REQ_GPS,
          value: res[AppLocalKeys.PUNCH_REQ_GPS] ?? false,
          type: StorableDataType.BOOL);

      await storeDataToLocal(
          key: AppLocalKeys.THEME,
          value: res[AppLocalKeys.THEME] ?? "a",
          type: StorableDataType.String);

      UserModel userModel = UserModel.fromJson(res);
      userModel.email = email;
      AuthProvider.of(context).setUserModel(userModel);

      /// Save Firebase User
      await FirestoreService.addUser(
        email: email,
        name: userModel.name,
        role: userModel.profile,
        companyCode: companyCode,
      );

      setState(() {
        _isLoading = false;
        progressMsg = '';
      });
      // ====== GO TO Track Option Page ==============
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print(e.toString());
      showError("ERROR: Line 175: \r\n" +
          "Expected profile: driver,dispatch,forfliftoperator. Got: null");
    }
  }

  /// ----------------------------------
  /// SHOW ERROR MSG
  /// ---------------------------------
  void showError(String message) {
    ToastAlart.error(context, message);
    setState(() {
      _isLoading = false;
      progressMsg = '';
    });
  }

  Map parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);
    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map> getUserDetails(String accessToken) async {
    const String url = 'https://${Constant.AUTH0_DOMAIN}/userinfo';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  ///---------------------------------------------
  /// Auth0 Login Function
  ///---------------------------------------------

  Future<void> loginAction() async {
    setState(() {
      _isLoading = true;
      progressMsg = "Authenticating with Auth0...";
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Constant.AUTH0_CLIENT_ID,
          Constant.AUTH0_REDIRECT_URI,
          issuer: 'https://${Constant.AUTH0_DOMAIN}',
          scopes: <String>[
            'openid',
            'profile',
            'offline_access',
            'api',
          ],
          additionalParameters: {'audience': Constant.AUTH0_AUDIENCE},
          promptValues: ['login'],
        ),
      );

      final Map idToken = parseIdToken(result!.idToken!);
      final Map profile = await getUserDetails(result.accessToken!);

      print("Access Token =====>\r\n");
      print(result.accessToken!);

      print("ID Token =====>\r\n");
      print(result.idToken ?? "NO NO");

      // await secureStorage.write(
      //     key: 'refresh_token', value: result.refreshToken);
      final email = idToken['name'];
      final token = result.accessToken ?? '';

      // final email = "padroscarlos@gmail.com";
      // // final email = "adamwalan@yahoo.com";
      // final token = "LIV";

      // final token =
      //     "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ijg1cXYteUZ2WWExd1laNFJ5TlJWcyJ9.eyIke25hbWVzcGFjZX0vZW1haWwiOiJhZGFtd2FsYW5AeWFob28uY29tIiwiaXNzIjoiaHR0cHM6Ly9kZXYteTJpcmpxZm8udXMuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDYyY2Y5OGI2MTMyNTNmMDZmY2VkNDUxYyIsImF1ZCI6WyJodHRwczovL2x0bGRyaXZlci9hcGkiLCJodHRwczovL2Rldi15MmlyanFmby51cy5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNjkzNzM0NDU2LCJleHAiOjE2OTM4MjA4NTYsImF6cCI6IldjTE52b0JGNGliYllWODhGRHlqNWxYQ1BLVlpSbDh0Iiwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSJ9.NQVxZUwbxR0uBLKvN3YvthhGDADVxfNPbgLNJAuFc0STbqlRoXSSGecYLOujSsL3LPntqw0jSNJahTbegwCFA45nd-J9hvNGa-X0WxzXX-eWulwHy32KJJxXdYnVffuc5coIhJ3Sh3aC0f161JAcjTIYlCkUjji9X7RGaguw7ldyeapWKwU0XB23Ce8Mt1NHvkXNPLJE0Qx3ZoXdnUxgNjDSFwQCSQuPJCH3p2xVZJgRW5uh2HgcmFZ3ptzGxM3AKUEs-WJN_tvPgEvIVK4Uel13cukBDd_srYL9_L52phrxXUFMN0Ermn_nJ4uQu39obMviOd91ezVX8gEiEBgSaA";
      final companyCode = await getDataInLocal(
              key: AppLocalKeys.CODE, type: StorableDataType.String) ??
          '';

      /// If Code is not exist , go to code page
      if (companyCode == '') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => CodePage()));
        return;
      }

      setState(() {
        _isLoading = false;
        progressMsg = '';
        // isLoggedIn = true;
        // name = idToken['name'].toString();
        // picture = profile['picture'].toString();
      });

      // Fetch User Data from Backend
      await getUserDataFromBackend(email, companyCode, token);
    } on Exception catch (e, s) {
      debugPrint('🎃 Auth0 login error: $s');

      setState(() {
        _isLoading = false;
        // isLoggedIn = false;
        progressMsg = '';
        errorMessage = e.toString();
      });
      showError('$s');
    }
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    // ======= Auth0 Button =====
    final auth0Buton = Container(
      height: 45,
      child: MaterialButton(
        elevation: 6.0,
        onPressed: () async {
          if (_isLoading) return;
          // _login(context);
          await loginAction();
        },
        color: Theme.of(context).primaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: (!_isLoading)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const FaIcon(
                    FontAwesomeIcons.signIn,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    pageStrings.login_auth0BtnTxt,
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    color: Colors.white,
                  )
                ],
              ),
      ),
    );

    /// Go To Code Page button
    final codePageButton = Container(
      height: 45,
      child: MaterialButton(
          elevation: 6.0,
          onPressed: () async {
            // await loginAction();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const CodePage()));
          },
          color: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.qr_code_2,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                pageStrings.login_codePageBtn,
                textAlign: TextAlign.center,
                style: style.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
              padding: EdgeInsets.only(top: statusBarHeight),
              height: MediaQuery.of(context).size.height,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Login Text
                    Container(
                      // margin: EdgeInsets.only(top: 20),
                      child: Column(
                        children: <Widget>[
                          Text(
                            pageStrings.login_title,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          Text(
                            pageStrings.login_subTitle,
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    ),

                    //=========== Sigin In Form ============
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //========= Auth0 Button =======
                          const SizedBox(
                            height: 20,
                          ),
                          auth0Buton,
                          const SizedBox(height: 20),
                          codePageButton,
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              progressMsg,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.deepOrange,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
    //   }),
    // );
  }
}
