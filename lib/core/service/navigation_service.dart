// // lib/core/services/navigation_service.dart
// import 'package:car_care/core/routing/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// \
// class NavigationService {
//   static void goTo(BuildContext context, String path) {
//     context.go(path);
//   }

//   static void push(BuildContext context, String path) {
//     context.push(path);
//   }

//   static void goBack(BuildContext context) {
//     context.pop();
//   }

//   static void goToHome(BuildContext context) => goTo(context, Routes.home);
//   static void goToLogin(BuildContext context) => goTo(context, Routes.login);
//   static void goToRegister(BuildContext context) =>
//       goTo(context, Routes.register);
//   static void goToSchedules(BuildContext context) =>
//       goTo(context, Routes.schedules);
//   static void goToComplaints(BuildContext context) =>
//       goTo(context, Routes.complaints);
//   static void goToNewComplaint(BuildContext context) =>
//       goTo(context, Routes.newComplaint);
//   static void goToNotifications(BuildContext context) =>
//       goTo(context, Routes.notifications);
//   static void goToProfile(BuildContext context) =>
//       goTo(context, Routes.profile);
//   static void goToEditProfile(BuildContext context) =>
//       goTo(context, Routes.editProfile);


//   static void goToScheduleDetails(BuildContext context, String id) {
//     goTo(context, '/schedules/$id');
//   }

//   static void goToComplaintDetails(BuildContext context, String id) {
//     goTo(context, '/complaints/$id');
//   }
// }
