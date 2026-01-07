import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Pages/App/Provider/auth_provider.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/HomePage/home_page.dart';
import 'package:opentrip/Repositories/index.dart';
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

  //======== Text Fiels Controllers =======
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isRemember = false;
  // Gloabal key for progress dialog
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  // Form Validation Global key
  final _formKey = GlobalKey<FormState>();

  // Load
  bool _isLoading = false;
  bool isBusy = false;
  String errorMessage = '';

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

  // LOGIN FUNCTION
  Future<void> _login(BuildContext context) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> data = {
        'username': emailController.text,
        'pass': passwordController.text,
      };

      if (isRemember) {
        await storeDataToLocal(
            key: AppLocalKeys.USERNAME,
            value: data['username'],
            type: StorableDataType.String);
        await storeDataToLocal(
            key: AppLocalKeys.PASSWORD,
            value: data['pass'],
            type: StorableDataType.String);
        await storeDataToLocal(
            key: AppLocalKeys.IS_REMEMBER,
            value: true,
            type: StorableDataType.BOOL);
      } else {
        await storeDataToLocal(
            key: AppLocalKeys.USERNAME,
            value: "",
            type: StorableDataType.String);
        await storeDataToLocal(
            key: AppLocalKeys.PASSWORD,
            value: "",
            type: StorableDataType.String);
        await storeDataToLocal(
            key: AppLocalKeys.IS_REMEMBER,
            value: false,
            type: StorableDataType.BOOL);
      }

      Map<String, dynamic> res = await UserRepository.login(data);
      print(res);

      // Error Check
      if (res == null || (res['Error'] != null && res['Error'] != "")) {
        if (res == null) {
          showError("Something went wrong. Please retry!");
        } else {
          showError(res['Error'].toString());
        }
        return;
      }

      // ------ SAVE INFOS ---------
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
          value: res[AppLocalKeys.PROFILE],
          type: StorableDataType.String);

      await storeDataToLocal(
          key: AppLocalKeys.USERNAME,
          value: emailController.text,
          type: StorableDataType.String);

      await storeDataToLocal(
          key: AppLocalKeys.LAST_SHIPMENT,
          value: res[AppLocalKeys.LAST_SHIPMENT] != null
              ? int.parse(res[AppLocalKeys.LAST_SHIPMENT].toString())
              : 0,
          type: StorableDataType.INT);

      await storeDataToLocal(
          key: AppLocalKeys.PUNCH_REQ_GPS,
          value: res[AppLocalKeys.PUNCH_REQ_GPS],
          type: StorableDataType.BOOL);

      // await storeDataToLocal(
      //     key: AppLocalKeys.THEME,
      //     value: res[AppLocalKeys.THEME],
      //     type: StorableDataType.String);

      //
      UserModel userModel = UserModel.fromJson(res);
      AuthProvider.of(context).setUserModel(userModel);

      setState(() {
        _isLoading = false;
      });
      // ====== GO TO Track Option Page ==============
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print(e.toString());
      showError("Network error. Please try again!");
    }
  }

  // SHOW ERROR MSG
  void showError(String message) {
    ToastAlart.error(context, message);
    setState(() {
      _isLoading = false;
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

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Constant.AUTH0_CLIENT_ID,
          Constant.AUTH0_REDIRECT_URI,
          issuer: 'https://${Constant.AUTH0_DOMAIN}',
          scopes: <String>['openid', 'profile', 'offline_access'],
          // promptValues: ['login'],
        ),
      );

      final Map idToken = parseIdToken(result!.idToken!);
      final Map profile = await getUserDetails(result.accessToken!);

      // await secureStorage.write(
      //     key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        // isLoggedIn = true;
        // name = idToken['name'].toString();
        // picture = profile['picture'].toString();
      });
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        // isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> logoutAction() async {
    // await secureStorage.delete(key: 'refresh_token');
    setState(() {
      // isLoggedIn = false;
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    // ==== EMAIL FIELD =========
    final usernameField = customTextForm(
      context: context,
      icon: FaIcon(
        FontAwesomeIcons.user,
        color: Theme.of(context).primaryColor,
        size: 18,
      ),
      fieldname: pageStrings.login_emailLabel,
      hint: pageStrings.login_emailLabel,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else if (value.length < 3) {
          return 'The password must be at least 3 characters.';
        }
        return null;
      },
      controller: emailController,
    );

    // ==== PASSWORD FIELD =========
    final passwordField = customTextForm(
      context: context,
      obscureText: true,
      icon: Icon(
        Icons.lock_outline,
        color: Theme.of(context).primaryColor,
      ),
      fieldname: pageStrings.login_passwordLabel,
      hint: pageStrings.login_passwordLabel,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else if (value.length < 3) {
          return 'The password must be at least 3 characters.';
        }
        return null;
      },
      controller: passwordController,
    );

    // ===== Remember Me ============
    final rememberMe = Checkbox(
      activeColor: Theme.of(context).primaryColor,
      value: isRemember,
      onChanged: (bool? value) {
        // This is where we update the state when the checkbox is tapped
        setState(() {
          isRemember = value!;
        });
      },
    );

    // ======= Login Button =====
    final loginButon = Container(
      height: 45,
      child: MaterialButton(
        elevation: 6.0,
        onPressed: () {
          if (_isLoading) return;
          if (_formKey.currentState!.validate()) {
            _login(context);
          }
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
                    pageStrings.login_signInBtnTxt,
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

    // ======= Auth0 Button =====
    final auth0Buton = Container(
      height: 45,
      child: MaterialButton(
        elevation: 6.0,
        onPressed: () async {
          if (isBusy) return;
          // _login(context);
          await loginAction();
        },
        color: Theme.of(context).primaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: (!isBusy)
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

    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => AuthProvider()),
    //   ],
    //   child: Builder(builder: (context) {
    //     _authProvider = AuthProvider.of(context);
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
            child: SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  // Logo
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(pageStrings.logoImg),
                  ),
                  // Login Text
                  Container(
                    margin: EdgeInsets.only(top: 20),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //===== Email ============

                          usernameField,
                          SizedBox(height: 10.0),

                          //===== Password ============
                          passwordField,

                          // RememberMe
                          Row(
                            children: <Widget>[
                              rememberMe,
                              Text(
                                pageStrings.login_remember,
                              )
                            ],
                          ),

                          SizedBox(
                            height: 35.0,
                          ),

                          // ========= Sign In Button ==========
                          loginButon,

                          //========= Auth0 Button =======
                          SizedBox(
                            height: 20,
                          ),
                          auth0Buton,

                          // ========== Description ===========
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    pageStrings.login_forgetTxt,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // Go to Forget password
                                  //-------- Go To SignUp Page ----
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           ForgetPasswordPage()),
                                  // );
                                },
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //========= Desc =====
                              Text(
                                pageStrings.login_signUpDesc,
                              ),

                              //======= SiginUp =============
                              InkWell(
                                onTap: () {
                                  //-------- Go To SignUp Page ----
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => SignUpPage()),
                                  // );
                                },
                                child: Container(
                                  child: Text(
                                    "SignUp",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
    //   }),
    // );
  }
}
