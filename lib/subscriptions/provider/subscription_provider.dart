import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool loading = true;
  String? queryProductError;
  // late StreamSubscription<List<PurchaseDetails>> subscription;
  // List<String> notFoundIds = <String>[];
  // List<ProductDetails> products = <ProductDetails>[];
   int tabIndex = 1;
  // List<PurchaseDetails> purchases = <PurchaseDetails>[];
  // List<String> consumable = <String>[];
  // bool isAvailable = false;
  // bool purchasePending = false;
  // String? queryProductError;
  String _kConsumableId = "com.idea.smart.weekly";
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
    ///first
    // final Stream<List<PurchaseDetails>> purchaseUpdated =
    //     inAppPurchase.purchaseStream;
    //
    //     purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
    //   debugPrint("listen====>");
    //   _listenToPurchaseUpdated(purchaseDetailsList);
    // }, onDone: () {
    //   debugPrint("this  is on done");
    // }, onError: (Object error) {
    //   debugPrint("on error $error");
    // });
    // initStoreInfo();
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
        loading = false;

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
        loading = false;
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
        loading = false;
    notifyListeners();
      return;
    }

    final List<String> consumables = await ConsumableStore.load();

      this.isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      notFoundIds = productDetailResponse.notFoundIDs;
      this.consumables = consumables;
      purchasePending = false;
      loading = false;

  }
///first
  // Future<void> initStoreInfo() async {
  //   final bool isAvailable = await inAppPurchase.isAvailable();
  //   if (!isAvailable) {
  //     this.isAvailable = isAvailable;
  //     products = <ProductDetails>[];
  //     purchases = <PurchaseDetails>[];
  //     notFoundIds = <String>[];
  //     consumable = <String>[];
  //     purchasePending = false;
  //     notifyListeners();
  //     return;
  //   }
  //
  //   if (Platform.isIOS) {
  //     final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
  //         inAppPurchase
  //             .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
  //     await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
  //   }
  //
  //   final ProductDetailsResponse productDetailResponse =
  //       await inAppPurchase.queryProductDetails(_kProductIds.toSet());
  //   if (productDetailResponse.error != null) {
  //     queryProductError = productDetailResponse.error!.message;
  //     this.isAvailable = isAvailable;
  //     products = productDetailResponse.productDetails;
  //     purchases = <PurchaseDetails>[];
  //     notFoundIds = productDetailResponse.notFoundIDs;
  //     consumable = <String>[];
  //     purchasePending = false;
  //     notifyListeners();
  //     return;
  //   }
  //
  //   if (productDetailResponse.productDetails.isEmpty) {
  //     queryProductError = null;
  //     this.isAvailable = isAvailable;
  //     products = productDetailResponse.productDetails;
  //     purchases = <PurchaseDetails>[];
  //     notFoundIds = productDetailResponse.notFoundIDs;
  //     consumable = <String>[];
  //     purchasePending = false;
  //     notifyListeners();
  //     return;
  //   }
  //
  //   final List<String> consumables = await ConsumableStore.load();
  //   this.isAvailable = isAvailable;
  //   products = productDetailResponse.productDetails;
  //   notFoundIds = productDetailResponse.notFoundIDs;
  //   consumable = consumables;
  //   purchasePending = false;
  //   notifyListeners();
  // }

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
  ///first
  // Future<void> _listenToPurchaseUpdated(
  //     List<PurchaseDetails> purchaseDetailsList) async {
  //   for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
  //     if (purchaseDetails.status == PurchaseStatus.pending) {
  //       showPendingUI();
  //     } else {
  //       if (purchaseDetails.status == PurchaseStatus.error) {
  //         handleError(purchaseDetails.error!);
  //       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
  //           purchaseDetails.status == PurchaseStatus.restored) {
  //         Map<String, dynamic> receiptBody = {
  //           'receipt-data':
  //               purchaseDetails.verificationData.localVerificationData,
  //           'exclude-old-transactions': true,
  //           'password': Commons.password
  //         };
  //         final bool valid = await _verifyPurchase(receiptBody);
  //         if (valid) {
  //           ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(
  //               const SnackBar(content: Text("Successfully purchased")));
  //           unawaited(deliverProduct(purchaseDetails));
  //           return;
  //         } else {
  //           _handleInvalidPurchase(purchaseDetails);
  //           return;
  //         }
  //       }
  //       if (purchaseDetails.pendingCompletePurchase) {
  //         print("this is complete purchase");
  //         await inAppPurchase.completePurchase(purchaseDetails);
  //       }
  //     }
  //   }
  //   notifyListeners();
  // }

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
    // handle invalid purchase here if  _verifyPurchase` failed.
    debugPrint("this purchase is invalid");
  }

  onProductButton({required ProductDetails data}) async {
    /* purchases.forEach((element) {
      if (element.status == PurchaseStatus.purchased &&
          element.productID == data.id) {
        debugPrint("already subsc");
        return;
      }
    });*/
    final queueWrapper = SKPaymentQueueWrapper();
    final transactions = await queueWrapper.transactions();
    final failedTransactions = transactions.where(
            (t) => t.transactionState == SKPaymentTransactionStateWrapper.failed);

    await Future.wait(
        failedTransactions.map((t) => queueWrapper.finishTransaction(t)));
    PurchaseParam purchaseParam = PurchaseParam(
      productDetails: data,
    );
    if (data.id == _kConsumableId) {
      inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: true);
    } else {
      inAppPurchase.buyNonConsumable(
          purchaseParam: purchaseParam);
    }
    /* if (Platform.isIOS) {
      final queueWrapper = SKPaymentQueueWrapper();
      final transactions = await queueWrapper.transactions();
      final failedTransactions = transactions.where(
          (t) => t.transactionState == SKPaymentTransactionStateWrapper.failed);

      await Future.wait(
          failedTransactions.map((t) => queueWrapper.finishTransaction(t)));
    }
*/

    //inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  static Future finishPrevTransactions() async {
    var transactions = await SKPaymentQueueWrapper().transactions();
     print("transactions = ${transactions.length}");
    if (transactions.isNotEmpty) {
      for (int i = 0; i < transactions.length; i++) {
        await SKPaymentQueueWrapper().finishTransaction(transactions[i]);
      }
    }
  }
}
