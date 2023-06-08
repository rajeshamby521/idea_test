import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idea_test/utils/commons.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../../models/icon_text_model.dart';
import '../../service/consumableStore.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_strings.dart';
import '../model/subscription_model.dart';

final subscriptionProvider =
    ChangeNotifierProvider((ref) => SubscriptionProvider());

class SubscriptionProvider extends ChangeNotifier {
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> subscription;
  List<String> notFoundIds = <String>[];
  List<ProductDetails> products = <ProductDetails>[];
  List<PurchaseDetails> purchases = <PurchaseDetails>[];
  List<String> consumables = <String>[];
  bool isAvailable = false;
  bool purchasePending = false;
  String? queryProductError;

  int tabIndex = 1;

  final String _kConsumableId = "com.idea.smart.weekly";
  final List<String> _kProductIds = ["com.idea.smart.weekly"];
  final List<IconText> iconTextList = [
    IconText(
        imagePath: AppAssets.home,
        text: AppStrings.libraryOfHundredOfIncredibleAffectiveAds),
    IconText(
        imagePath: AppAssets.cal,
        text: AppStrings.hundredsPlusNewAdsAddedWeekly),
    IconText(
        imagePath: AppAssets.business, text: AppStrings.tenPlusBusinessType),
    IconText(
        text: AppStrings.fixedMonthlyPriceForUnlimitedProfits,
        imagePath: AppAssets.profit),
  ];

  void onInit() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        inAppPurchase.purchaseStream;
    subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();
  }

  onTapTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await inAppPurchase.isAvailable();
    if (!isAvailable) {
      this.isAvailable = isAvailable;
      products = <ProductDetails>[];
      purchases = <PurchaseDetails>[];
      notFoundIds = <String>[];
      this.consumables = <String>[];
      purchasePending = false;

      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      queryProductError = productDetailResponse.error!.message;
      this.isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      purchases = <PurchaseDetails>[];
      notFoundIds = productDetailResponse.notFoundIDs;
      this.consumables = <String>[];
      purchasePending = false;
      notifyListeners();
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      queryProductError = null;
      this.isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      purchases = <PurchaseDetails>[];
      notFoundIds = productDetailResponse.notFoundIDs;
      this.consumables = <String>[];
      purchasePending = false;
      notifyListeners();
      return;
    }

    final List<String> consumables = await ConsumableStore.load();

    this.isAvailable = isAvailable;
    products = productDetailResponse.productDetails;
    notFoundIds = productDetailResponse.notFoundIDs;
    this.consumables = consumables;
    purchasePending = false;
    notifyListeners();
  }


  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          Map<String, dynamic> receiptBody = {
            'receipt-data':
                purchaseDetails.verificationData.localVerificationData,
            'exclude-old-transactions': true,
            'password': Commons.password
          };
          final bool valid = await _verifyPurchase(receiptBody);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    /// IMPORTANT!! Always verify purchase details before delivering the product.

    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();

      purchasePending = false;
      this.consumables = consumables;
    } else {
      purchases.add(purchaseDetails);
      purchasePending = false;
    }
  }

  void showPendingUI() {
    purchasePending = true;
    notifyListeners();
  }

  void handleError(IAPError error) {
    purchasePending = false;
    ScaffoldMessenger.of(navKey.currentContext!)
        .showSnackBar(SnackBar(content: Text(error.message)));
    notifyListeners();
  }

  /// IMPORTANT!! Always verify a purchase before delivering the product.
  /// For the purpose of an example, we directly return true.
  Future<bool> _verifyPurchase(Map<String, dynamic> receiptBody,
      {bool isTest = true}) async {
    final String url = isTest ? Commons.sandboxUrl : Commons.itunesUrl;

    try {
      http.Response res = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(receiptBody),
      );
      final data = jsonDecode(res.body);
      bool isSuccess = data["status"] == 0 ? true : false;
      return isSuccess;
    } catch (e) {
      debugPrint("error in verification======>$e");
    }
    return false;
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    /// handle invalid purchase here if  _verifyPurchase` failed.
    debugPrint("this purchase is invalid");
  }

  onProductButton({required ProductDetails data}) async {
    finishPrevTransactions().then((value) async {
      PurchaseParam purchaseParam = PurchaseParam(
        productDetails: data,
      );

      await inAppPurchase
          .buyNonConsumable(purchaseParam: purchaseParam)
          .catchError((error) {
        ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(
            const SnackBar(content: Text(AppStrings.alreadySubscribed)));
        return error;
      });
    });
  }

  static Future finishPrevTransactions() async {
    var transactions = await SKPaymentQueueWrapper().transactions();
    debugPrint("transactions = ${transactions.length}");
    if (transactions.isNotEmpty) {
      for (int i = 0; i < transactions.length; i++) {
        await SKPaymentQueueWrapper().finishTransaction(transactions[i]);
      }
    }
  }
}
