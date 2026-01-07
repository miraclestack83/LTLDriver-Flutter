import 'package:flutter/material.dart';

class AppStrings {
  String title = "Detail";
  String serverError = "Error occured. Please retry later";
  String noDataError = "No data exist";
  String connectionError =
      "Unknown error occured. Please check your connection";
  String analyzeBtn = "Analyze";
  String defaultImg = 'lib/Assets/Images/news.jpg';
  String logoImg = "lib/Assets/Images/icon.png";

  /***************************
   * Login Page
   */

  String login_title = "Sign In";
  String login_subTitle = "Login to your existant account";
  String login_emailLabel = "Username";
  String login_passwordLabel = "Password";
  String login_remember = "Remember me";
  String login_createBtnTxt = "Create Account";
  String login_signInBtnTxt = "  Sign In";
  String login_auth0BtnTxt = "  Sign In with Auth0.com";
  String login_codePageBtn = "  Company Code";
  String login_signDesc = "or use one of your social profiles";
  String login_forgetTxt = "Forgot Password?";
  String login_signUpTxt = "Sign Up";
  String login_signUpDesc = "Don't have an account?  ";
  String login_successLogin = "Logined Successfly. Redirecting...";
  String login_errorLogin = "Some error occured. Please retry!";

  /***************************
   * Trip Stops Page
   */
  String tripStops_title = "Trip Stops";
  String tripStops_acKnow = "Trip Acknowledged:";

  /***************************
   * Trip Tasks Page
   */
  String tripTasks_title = "Trip Tasks";
  String tripTasks_appt = "Appt:";
  String tripTasks_note = "Note:";

  /***************************
   * Stop Details
   */
  String stopDetails_title = "Stop Details";

  /**************************
   * Update Place
   */
  String updatePlace_title = "Update Place";
  String updatePlace_originalPieces = "Original Pieces: ";
  String updatePlace_originalWeight = "Original Weight: ";
  String updatePlace_actualPieces = "Actual Pieces: ";
  String updatePlace_actualWeight = "Actual Weight: ";
  String updatePlace_actualSpots = "Actual Spots: ";
  String updatePlace_trailer = "Trailer# : ";
  String updatePlace_seal = "Seal# : ";
  String updatePlace_bol = "BoL# : ";

  /**************************
   * Add Note
   */
  String addNote_title = "Add Note";
  String addNote_desc = "Type in a comment/note about this place and hit Save";

  /**************************
   * Ship Picture
   */
  String shipPicture_title = "Shipment Pictures";
  String shipPicture_desc = "Note...";
  String shipPicture_save = "UPLOAD FILE";

  /**************************
   * Ship Picture
   */
  String pod_title = "Upload Signed POD";
  String pod_save = "UPLOAD FILE";

  /**************************
   * My Truck
   */
  String truck_title = "My Truck";

  /**************************
   * Trunk ODO
   */
  String truck_ODO_title = "Odometer Update";

  /**************************
   * Trunk Problem
   */
  String truck_problem_title = "Equipment Problem";

  /**************************
   * Trunk Repair
   */
  String truck_repair_title = "Equipment Repair History";
}
