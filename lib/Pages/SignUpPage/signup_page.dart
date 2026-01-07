// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// // import 'package:simple_animations/simple_animations.dart';
// import 'package:within/Helpers/index.dart';
// import 'package:within/Models/index.dart';
// import 'package:within/Modules/index.dart';
// import 'package:within/Pages/App/Provider/app_provider.dart';
// import 'package:within/Pages/App/Provider/auth_provider.dart';
// import 'package:within/Pages/SignInPage/signin_page.dart';
// import 'package:within/Pages/TrackOptionPage/track_option_page.dart';
// import 'package:within/Repositories/user_repository.dart';
// import 'package:within/Services/api.dart';
// import 'package:within/Utilities/index.dart';
// import 'package:within/Utilities/toast_alert.dart';
// import 'Styles/colors.dart';
// import 'Styles/strings.dart';
// import 'Styles/styles.dart';
// import 'Styles/styles.dart';
// import 'package:flutter/services.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:provider/provider.dart';

// class SignUpPage extends StatefulWidget {
//   // SignUpPage({Key key, this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   // final String title;

//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   SignUpPageColors pageColors = new SignUpPageColors();
//   SignUpPageStrings pageStrings = new SignUpPageStrings();
//   SignUpPageStyles pageStyles = new SignUpPageStyles();

//   /// Which holds the selected date
//   /// Defaults to today's date.
//   DateTime selectedDate = DateTime.now();

//   String _gender = "Male";

//   String _dobValue = '';

//   // TextField Controllers
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPassController = TextEditingController();
//   final dobController = TextEditingController();
//   final medicineController = TextEditingController();
//   final _medicationFormKey = GlobalKey<FormState>();
//   List medicationList = [];

//   void _addMedication() {
//     Map data = {
//       'medicine': medicineController.text,
//     };
//     setState(() {
//       medicationList.add(data);
//     });
//   }

//   void _removeMedication(item) {
//     setState(() {
//       medicationList.remove(item);
//     });
//   }

//   // Form Validation Global key
//   final _formKey = GlobalKey<FormState>();

//   // Load
//   bool _isLoading = false;

//   // AuthProvider
//   AuthProvider _authProvider;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _gender = "Male";
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPassController.dispose();
//     dobController.dispose();
//     medicineController.dispose();
//     super.dispose();
//   }

//   // DOB Date Select Function
//   _selectDate(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate, // Refer step 1
//       firstDate: DateTime(1930),
//       lastDate: DateTime(2900),
//     );
//     if (picked != null && picked != selectedDate) {
//       String formattedDate = DateFormat('MM/dd/yyyy').format(picked);
//       _dobValue = DateFormat('yyyy-MM-dd').format(picked);
//       setState(() {
//         selectedDate = picked;
//         dobController.text = formattedDate;
//       });
//     }
//   }

//   //=========== Register Function =================
//   void _register() async {
//     setState(() {
//       _isLoading = true;
//     });
//     var data = {
//       'email': emailController.text,
//       'password': passwordController.text,
//       'firstname': firstNameController.text,
//       'lastname': lastNameController.text,
//       // 'birthday': dobController.text,
//       'birthday': _dobValue,
//       'gender': _gender,
//       'medicine': jsonEncode(medicationList),
//     };

//     UserModel userModel = new UserModel.fromJson(data);

//     Map res = await UserRepository.register(userModel);

//     if (res['success']) {
//       ToastAlart.success(context, pageStrings.successReg);

//       String token = res['token'];

//       // ====== SAVE ISLOGIN ========
//       await storeDataToLocal(
//           key: AppLocalKeys.isLogin, value: true, type: StorableDataType.BOOL);

//       // ===== SAVE LOGIN TYPE ======
//       await storeDataToLocal(
//           key: AppLocalKeys.loginType,
//           value: LoginType.email.index,
//           type: StorableDataType.INT);

//       // ====== SAVE TOKEN ========
//       await storeDataToLocal(
//           key: AppLocalKeys.token, value: token, type: StorableDataType.String);

//       // ====== SAVE USER DATA ========
//       String userJson = json.encode(res['user']);
//       await storeDataToLocal(
//           key: AppLocalKeys.userData,
//           value: userJson,
//           type: StorableDataType.String);

//       // ====== Auth Provider Notifier ==========
//       UserModel userData = new UserModel.fromJson(res['user']);
//       // _authProvider.setUserModel(userData, isNotifiable: true);
//       AuthProvider.of(context).setUserModel(userData);

//       // Provider.of<AuthProvider>(context).setUserModel(userData);
//       // ====== GO TO Track Option Page ==============
//       Navigator.pushReplacement(
//         context,
//         new MaterialPageRoute(builder: (context) => TrackOptionPage()),
//       );
//     } else {
//       if (res['message'] != null) {
//         res['message'].keys.forEach((key) {
//           ToastAlart.error(context, '${res['message'][key][0]}. Please retry!');
//         });
//       } else {
//         ToastAlart.error(context, 'Server Error. Please retry!');
//       }
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double statusBarHeight = MediaQuery.of(context).padding.top;
//     TextStyle style = TextStyle(
//         fontFamily: 'Montserrat', color: pageColors.textColor, fontSize: 18.0);

//     List<String> medicines = AppProvider.of(context).medicineList;

//     // ==== FIRST NAME FIELD =========
//     final firstNameField = customTextForm(
//       icon: Icon(
//         Icons.person_outline,
//         color: Color(0xff33499f),
//       ),
//       fieldname: pageStrings.firstNameLabel,
//       hint: pageStrings.firstNameLabel,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter some text';
//         }
//         return null;
//       },
//       getDateFun: () {},
//       controller: firstNameController,
//     );

//     // ==== LAST NAME FIELD =========
//     final lastNameField = customTextForm(
//       icon: Icon(
//         Icons.person_outline,
//         color: Color(0xff33499f),
//       ),
//       fieldname: pageStrings.lastNameLabel,
//       hint: pageStrings.lastNameLabel,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter some text';
//         }
//         return null;
//       },
//       getDateFun: () {},
//       controller: lastNameController,
//     );

//     // ==== EMAIL FIELD =========
//     final emailField = customTextForm(
//       icon: Icon(
//         Icons.mail_outline,
//         color: Color(0xff33499f),
//       ),
//       fieldname: pageStrings.emailLabel,
//       hint: pageStrings.emailLabel,
//       validator: (value) {
//         return EmailValidator.validate(value)
//             ? null
//             : "Please enter a valid email";
//       },
//       getDateFun: () {},
//       controller: emailController,
//     );

//     // ==== DOB FIELD =========

//     // ==== EMAIL FIELD =========
//     final dobField = customTextForm(
//       icon: IconButton(
//           icon: Icon(
//             Icons.calendar_today_outlined,
//             color: Color(0xff33499f),
//           ),
//           onPressed: () {
//             _selectDate(context);
//           }),
//       fieldname: 'MM/DD/YYYY',
//       hint: 'MM/DD/YYYY',
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select valid date';
//         }
//         return null;
//       },
//       getDateFun: () {
//         _selectDate(context);
//       },
//       controller: dobController,
//     );

//     // ==== PASSWORD FIELD =========

//     final passwordField = customTextForm(
//       obscureText: true,
//       icon: Icon(
//         Icons.lock_outline,
//         color: Color(0xff33499f),
//       ),
//       fieldname: pageStrings.passwordLabel,
//       hint: pageStrings.passwordLabel,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter some text';
//         } else if (value.length < 8) {
//           return 'The password must be at least 8 characters.';
//         }
//         return null;
//       },
//       getDateFun: () {},
//       controller: passwordController,
//     );

//     // ==== CONFIRM PASS FIELD =========

//     final confirmPassField = customTextForm(
//       obscureText: true,
//       icon: Icon(
//         Icons.lock_outline,
//         color: Color(0xff33499f),
//       ),
//       fieldname: pageStrings.confirmPassLabel,
//       hint: pageStrings.confirmPassLabel,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter some text';
//         } else if (value.length < 8) {
//           return 'The password must be at least 8 characters.';
//         } else if (value != passwordController.text) {
//           return 'The password confirmation does not match.';
//         }
//         return null;
//       },
//       getDateFun: () {},
//       controller: confirmPassController,
//     );

//     //=========== MEDICINE AUTOFILL FIELD =============
//     final medicineField = autofillField(
//         icon: Icon(
//           Icons.medical_services_outlined,
//           color: Color(0xff33499f),
//         ),
//         fieldname: pageStrings.medicineLable,
//         hint: pageStrings.medicineLable,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter some text';
//           }
//           return null;
//         },
//         suggestion: medicines,
//         controller: medicineController,
//         onSubmit: (text) {});

//     // ==== SIGNUP BUTTON FIELD =========
//     final signUpButon = (_isLoading)
//         ? Container(
//             // // margin: EdgeInsets.only(top: 40),
//             // padding: EdgeInsets.symmetric(
//             //   horizontal: 30,
//             // ),
//             height: 45,
//             width: double.infinity,
//             child: MaterialButton(
//               elevation: 6.0,
//               onPressed: () {},
//               color: Colors.green,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.0)),
//               child: CircularProgressIndicator(
//                 backgroundColor: Colors.white,
//               ),
//             ),
//           )
//         : Container(
//             // // margin: EdgeInsets.only(top: 40),
//             // padding: EdgeInsets.symmetric(
//             //   horizontal: 30,
//             // ),
//             width: double.infinity,
//             height: 45,
//             child: MaterialButton(
//               elevation: 6.0,
//               onPressed: () {
//                 if (_formKey.currentState.validate()) {
//                   _register();
//                 }
//               },
//               color: Colors.green,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.0)),
//               child: Text(
//                 ' ${pageStrings.signUpBtnTxt}',
//                 textAlign: TextAlign.center,
//                 style: style.copyWith(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           );

//     //============== Content ===========
//     return GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Container(
//           padding: EdgeInsets.only(top: statusBarHeight),
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("lib/Assets/Images/11.png"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Container(
//               // margin: EdgeInsets.only(top: statusBarHeight),
//               padding: EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: pageStyles.pagePadding,
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: <Widget>[
//                     // =========== Title ============
//                     Container(
//                       // padding: EdgeInsets.only(top: 70),
//                       child: Text(
//                         pageStrings.title,
//                         // style: Theme.of(context).textTheme.headline4,
//                         style: TextStyle(
//                           fontSize: 35,
//                           fontWeight: FontWeight.bold,
//                           color: pageColors.titleColor,
//                         ),
//                       ),
//                     ),

//                     //=========== Sigin In Form ============
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.only(top: 20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           //===== First Name ============
//                           // Container(
//                           //   padding: EdgeInsets.symmetric(
//                           //     vertical: 10,
//                           //   ),
//                           //   child: Text(
//                           //     pageStrings.firstNameLabel,
//                           //     style: TextStyle(
//                           //       color: pageColors.textColor,
//                           //       fontWeight: FontWeight.bold,
//                           //     ),
//                           //   ),
//                           // ),

//                           firstNameField,
//                           SizedBox(height: 15.0),

//                           //===== Last Name ============
//                           // Container(
//                           //   padding: EdgeInsets.symmetric(
//                           //     vertical: 10,
//                           //   ),
//                           //   child: Text(
//                           //     pageStrings.lastNameLabel,
//                           //     style: TextStyle(
//                           //       color: pageColors.textColor,
//                           //       fontWeight: FontWeight.bold,
//                           //     ),
//                           //   ),
//                           // ),
//                           lastNameField,
//                           SizedBox(height: 15.0),

//                           // //===== User Name ============
//                           // Container(
//                           //   padding: EdgeInsets.symmetric(
//                           //     vertical: 10,
//                           //   ),
//                           //   child: Text(
//                           //     pageStrings.emailLabel,
//                           //     style: TextStyle(
//                           //       color: pageColors.textColor,
//                           //       fontWeight: FontWeight.bold,
//                           //     ),
//                           //   ),
//                           // ),
//                           // emailField,
//                           // SizedBox(height: 15.0),

//                           //===== Email ============
//                           // Container(
//                           //   padding: EdgeInsets.symmetric(
//                           //     vertical: 10,
//                           //   ),
//                           //   child: Text(
//                           //     pageStrings.emailLabel,
//                           //     style: TextStyle(
//                           //       color: pageColors.textColor,
//                           //       fontWeight: FontWeight.bold,
//                           //     ),
//                           //   ),
//                           // ),
//                           emailField,
//                           SizedBox(height: 15.0),

//                           //===== Password ============
//                           // Container(
//                           //   padding: EdgeInsets.symmetric(
//                           //     vertical: 10,
//                           //   ),
//                           //   child: Text(
//                           //     pageStrings.passwordLabel,
//                           //     style: TextStyle(
//                           //       color: pageColors.textColor,
//                           //       fontWeight: FontWeight.bold,
//                           //     ),
//                           //   ),
//                           // ),
//                           passwordField,
//                           SizedBox(height: 15.0),
//                           //===== Confrim Password ============
//                           // Container(
//                           //   padding: EdgeInsets.symmetric(
//                           //     vertical: 10,
//                           //   ),
//                           //   child: Text(
//                           //     pageStrings.confirmPassLabel,
//                           //     style: TextStyle(
//                           //       color: pageColors.textColor,
//                           //       fontWeight: FontWeight.bold,
//                           //     ),
//                           //   ),
//                           // ),
//                           confirmPassField,

//                           //======= Birthday =========
//                           SizedBox(height: 15.0),
//                           // Container(
//                           //   padding: EdgeInsets.symmetric(
//                           //     vertical: 10,
//                           //   ),
//                           //   child: Text(
//                           //     pageStrings.dobLabel,
//                           //     style: TextStyle(
//                           //       color: pageColors.textColor,
//                           //       fontWeight: FontWeight.bold,
//                           //     ),
//                           //   ),
//                           // ),
//                           dobField,

//                           SizedBox(height: 15.0),

//                           // =========== Gender ==============
//                           Container(
//                             // padding: EdgeInsets.symmetric(
//                             //     vertical: 0.0, horizontal: 10.0),
//                             decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(30)),
//                               // border: Border.all(color: Colors.black, width: 1),
//                               color: Color(0xfff9e5c4),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: <Widget>[
//                                     CircleAvatar(
//                                       radius: 26,
//                                       backgroundColor: Color(0xffffbb56),
//                                       child: Icon(
//                                         Icons.person_outline,
//                                         color: pageColors.textColor,
//                                       ),
//                                     ),
//                                     Text(
//                                       "  Gender",
//                                       style: style,
//                                     ),
//                                   ],
//                                 ),
//                                 Container(
//                                   child: DropdownButtonHideUnderline(
//                                     child: DropdownButton<String>(
//                                       value: _gender,
//                                       //elevation: 5,
//                                       isExpanded: false,
//                                       style: TextStyle(color: Colors.black),

//                                       items: <String>[
//                                         'Male',
//                                         'Female',
//                                         'Non-binary',
//                                       ].map<DropdownMenuItem<String>>(
//                                           (String value) {
//                                         return DropdownMenuItem<String>(
//                                           value: value,
//                                           child: Text(value),
//                                         );
//                                       }).toList(),
//                                       hint: Text(
//                                         "Please choose a gender",
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                       onChanged: (String value) {
//                                         setState(() {
//                                           _gender = value;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           SizedBox(height: 40.0),
//                           // ========== Medicine ============
//                           // Row(
//                           //   children: [
//                           //     Expanded(
//                           //       child: medicineField,
//                           //     ),
//                           //     InkWell(
//                           //       onTap: () {
//                           //         if (medicineController.text != '') {
//                           //           _addMedication();
//                           //         }
//                           //       },
//                           //       child: Container(
//                           //         margin: EdgeInsets.only(
//                           //           left: 10,
//                           //         ),
//                           //         decoration: BoxDecoration(
//                           //           borderRadius: BorderRadius.circular(30),
//                           //           color: pageColors.textColor,
//                           //         ),
//                           //         padding: EdgeInsets.all(5),
//                           //         child: Icon(
//                           //           Icons.add,
//                           //           color: Colors.white,
//                           //         ),
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),
//                           // SizedBox(
//                           //   height: 10,
//                           // ),

//                           // Row(
//                           //   children: [
//                           //     SizedBox(
//                           //       width: 40,
//                           //     ),
//                           //     Expanded(
//                           //       child: Column(
//                           //         children: medicationList
//                           //             .map(
//                           //               (item) => Container(
//                           //                 margin: EdgeInsets.only(bottom: 6),
//                           //                 child: Row(
//                           //                   children: <Widget>[
//                           //                     Expanded(
//                           //                       child:
//                           //                           Text("${item['medicine']}  "),
//                           //                     ),
//                           //                     InkWell(
//                           //                       onTap: () {
//                           //                         _removeMedication(item);
//                           //                       },
//                           //                       child: Container(
//                           //                         padding: EdgeInsets.all(5),
//                           //                         decoration: BoxDecoration(
//                           //                           borderRadius:
//                           //                               BorderRadius.circular(
//                           //                             30,
//                           //                           ),
//                           //                           color: Colors.redAccent[400],
//                           //                         ),
//                           //                         child: Icon(
//                           //                           Icons.close,
//                           //                           color: Colors.white,
//                           //                           size: 12,
//                           //                         ),
//                           //                       ),
//                           //                     )
//                           //                   ],
//                           //                 ),
//                           //               ),
//                           //             )
//                           //             .toList(),
//                           //       ),
//                           //     ),
//                           //     SizedBox(
//                           //       width: 20,
//                           //     ),
//                           //   ],
//                           // ),

//                           // SizedBox(
//                           //   height: 35.0,
//                           // ),

//                           // ========= Sign In Button ==========
//                           signUpButon,

//                           // // ========== Description ===========
//                           // Center(
//                           //   child: Container(
//                           //     margin: EdgeInsets.only(top: 15),
//                           //     child: Text(
//                           //       pageStrings.signDesc,
//                           //       textAlign: TextAlign.center,
//                           //       style: TextStyle(
//                           //         fontSize: 16,
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),

//                           SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               //========= Forget Password =====
//                               Expanded(
//                                 child: Container(
//                                   padding: EdgeInsets.only(top: 10),
//                                   child: Text(
//                                     pageStrings.signDesc,
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               //======= SiginIn =============
//                               InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => SignInPage()),
//                                   );
//                                 },
//                                 child: Container(
//                                   child: Text(
//                                     pageStrings.signinTxt,
//                                     style: TextStyle(
//                                       color: pageColors.signInBtnColor,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
