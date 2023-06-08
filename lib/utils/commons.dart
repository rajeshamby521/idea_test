
import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navKey = GlobalKey();
class Commons{
  final theme = Theme.of(navKey.currentContext!);
  static  const String sandboxUrl='https://sandbox.itunes.apple.com/verifyReceipt';
  static  const String itunesUrl='https://buy.itunes.apple.com/verifyReceipt';
  static  const String password='23778cdba7a94dceb6cc2f581bd73848';
}