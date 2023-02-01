import 'package:flutter/material.dart';

import 'app.model.dart';

class RootTransactions {
  RootTransactions({
    this.firstPurchaseMs,
    this.lastPurchaseMs,
    this.transactions,
  });

  final int firstPurchaseMs;
  final int lastPurchaseMs;
  final List<Transaction> transactions;

  factory RootTransactions.fromJson(Map<String, dynamic> json) =>
      RootTransactions(
        firstPurchaseMs: json["first_purchase_ms"] == null
            ? null
            : json["first_purchase_ms"],
        lastPurchaseMs:
            json["last_purchase_ms"] == null ? null : json["last_purchase_ms"],
        transactions: json["transactions"] == null
            ? null
            : List<Transaction>.from(
                json["transactions"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "first_purchase_ms": firstPurchaseMs == null ? null : firstPurchaseMs,
        "last_purchase_ms": lastPurchaseMs == null ? null : lastPurchaseMs,
        "transactions": transactions == null
            ? null
            : List<dynamic>.from(transactions.map((x) => x.toJson())),
      };
}

class Transaction {
  Transaction({
    this.app,
    this.expiresDate,
    this.isInIntroductoryPricePeriod,
    this.isRenewal,
    this.isSandbox,
    this.isTrialConversion,
    this.isTrialPeriod,
    this.productIdentifier,
    this.purchaseDate,
    this.revenue,
    this.storeTransactionIdentifier,
    this.subscriberCountryCode,
    this.subscriberId,
    this.wasRefunded,
  });

  final App app;
  final DateTime expiresDate;
  final bool isInIntroductoryPricePeriod;
  final bool isRenewal;
  final bool isSandbox;
  final bool isTrialConversion;
  final bool isTrialPeriod;
  final String productIdentifier;
  final DateTime purchaseDate;
  final double revenue;
  final String storeTransactionIdentifier;
  final String subscriberCountryCode;
  final String subscriberId;
  final bool wasRefunded;

  bool get isRealRenewal => isRenewal && (revenue ?? 0) > 0;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        app: json["app"] == null ? null : App.fromJson(json["app"]),
        expiresDate: json["expires_date"] == null
            ? null
            : DateTime.parse(json["expires_date"]).toLocal(),
        isInIntroductoryPricePeriod:
            json["is_in_introductory_price_period"] == null
                ? null
                : json["is_in_introductory_price_period"],
        isRenewal: json["is_renewal"] == null ? null : json["is_renewal"],
        isSandbox: json["is_sandbox"] == null ? null : json["is_sandbox"],
        isTrialConversion: json["is_trial_conversion"] == null
            ? null
            : json["is_trial_conversion"],
        isTrialPeriod:
            json["is_trial_period"] == null ? null : json["is_trial_period"],
        productIdentifier: json["product_identifier"] == null
            ? null
            : json["product_identifier"],
        purchaseDate: json["purchase_date"] == null
            ? null
            : DateTime.parse(json["purchase_date"]).toLocal(),
        revenue: json["revenue"] == null ? 0 : json["revenue"].toDouble(),
        storeTransactionIdentifier: json["store_transaction_identifier"] == null
            ? null
            : json["store_transaction_identifier"],
        subscriberId:
            json["subscriber_id"] == null ? null : json["subscriber_id"],
        subscriberCountryCode: json["subscriber_country_code"] ?? '',
        wasRefunded: json["was_refunded"] == null ? null : json["was_refunded"],
      );

  Map<String, dynamic> toJson() => {
        "app": app == null ? null : app.toJson(),
        "expires_date":
            expiresDate == null ? null : expiresDate.toIso8601String(),
        "is_in_introductory_price_period": isInIntroductoryPricePeriod == null
            ? null
            : isInIntroductoryPricePeriod,
        "is_renewal": isRenewal == null ? null : isRenewal,
        "is_sandbox": isSandbox == null ? null : isSandbox,
        "is_trial_conversion":
            isTrialConversion == null ? null : isTrialConversion,
        "is_trial_period": isTrialPeriod == null ? null : isTrialPeriod,
        "product_identifier":
            productIdentifier == null ? null : productIdentifier,
        "purchase_date":
            purchaseDate == null ? null : purchaseDate.toIso8601String(),
        "revenue": revenue == null ? null : revenue,
        "store_transaction_identifier": storeTransactionIdentifier == null
            ? null
            : storeTransactionIdentifier,
        "subscriber_id": subscriberId == null ? null : subscriberId,
        "subscriber_country_code":
            subscriberCountryCode == null ? null : subscriberCountryCode,
        "was_refunded": wasRefunded == null ? null : wasRefunded,
      };

  Status get platform {
    if (storeTransactionIdentifier.contains('GPA')) {
      return Status('google', Colors.lightGreenAccent.withOpacity(0.6));
    } else {
      return Status('apple', Colors.white);
    }
  }

  List<Status> get statuses {
    final List<Status> value = [];

    if (isInIntroductoryPricePeriod) {
      value.add(Status('introductory price', Colors.purple));
    } else if (isRealRenewal) {
      value.add(Status('renewal', Colors.lightBlue));
    } else if (isTrialPeriod) {
      value.add(Status('trial', Colors.grey));
    } else if (isTrialConversion) {
      value.add(Status('trial conversion', Colors.yellow.withOpacity(0.7)));
    } else if (wasRefunded) {
      value.add(Status('refunded', Colors.red));
    } else if (isSandbox) {
      value.add(Status('sandbox', Colors.white));
    } else {
      if (productIdentifier.contains('rc_promo')) {
        value.add(Status('promo', Colors.pinkAccent));
      } else {
        value.add(Status('purchased', Colors.lightGreen));
      }
    }

    return value;
  }
}

class Status {
  final String name;
  final Color color;

  Status(this.name, this.color);
}
