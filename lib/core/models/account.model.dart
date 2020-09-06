import 'app.model.dart';

class Account {
  Account({
    this.apps,
    this.billingInfo,
    this.currentPlan,
    this.distinctId,
    this.email,
    this.exceededBasicLimit,
    this.firstTransactionAt,
    this.hasConfiguredEntitlements,
    this.hasConfiguredNewOfferings,
    this.hasMadeAnyLivePurchase,
    this.hasMadeAnyPurchase,
    this.intercomHash,
    this.isConnectedToStripe,
    this.name,
    this.subscriptions,
  });

  final List<App> apps;
  final BillingInfo billingInfo;
  final String currentPlan;
  final String distinctId;
  final String email;
  final bool exceededBasicLimit;
  final DateTime firstTransactionAt;
  final bool hasConfiguredEntitlements;
  final bool hasConfiguredNewOfferings;
  final bool hasMadeAnyLivePurchase;
  final bool hasMadeAnyPurchase;
  final String intercomHash;
  final bool isConnectedToStripe;
  final String name;
  final Subscriptions subscriptions;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        apps: json["apps"] == null
            ? null
            : List<App>.from(json["apps"].map((x) => App.fromJson(x))),
        billingInfo: json["billing_info"] == null
            ? null
            : BillingInfo.fromJson(json["billing_info"]),
        currentPlan: json["current_plan"] == null ? null : json["current_plan"],
        distinctId: json["distinct_id"] == null ? null : json["distinct_id"],
        email: json["email"] == null ? null : json["email"],
        exceededBasicLimit: json["exceeded_basic_limit"] == null
            ? null
            : json["exceeded_basic_limit"],
        firstTransactionAt: json["first_transaction_at"] == null
            ? null
            : DateTime.parse(json["first_transaction_at"]),
        hasConfiguredEntitlements: json["has_configured_entitlements"] == null
            ? null
            : json["has_configured_entitlements"],
        hasConfiguredNewOfferings: json["has_configured_new_offerings"] == null
            ? null
            : json["has_configured_new_offerings"],
        hasMadeAnyLivePurchase: json["has_made_any_live_purchase"] == null
            ? null
            : json["has_made_any_live_purchase"],
        hasMadeAnyPurchase: json["has_made_any_purchase"] == null
            ? null
            : json["has_made_any_purchase"],
        intercomHash:
            json["intercom_hash"] == null ? null : json["intercom_hash"],
        isConnectedToStripe: json["is_connected_to_stripe"] == null
            ? null
            : json["is_connected_to_stripe"],
        name: json["name"] == null ? null : json["name"],
        subscriptions: json["subscriptions"] == null
            ? null
            : Subscriptions.fromJson(json["subscriptions"]),
      );

  Map<String, dynamic> toJson() => {
        "apps": apps == null
            ? null
            : List<dynamic>.from(apps.map((x) => x.toJson())),
        "billing_info": billingInfo == null ? null : billingInfo.toJson(),
        "current_plan": currentPlan == null ? null : currentPlan,
        "distinct_id": distinctId == null ? null : distinctId,
        "email": email == null ? null : email,
        "exceeded_basic_limit":
            exceededBasicLimit == null ? null : exceededBasicLimit,
        "first_transaction_at": firstTransactionAt == null
            ? null
            : firstTransactionAt.toIso8601String(),
        "has_configured_entitlements": hasConfiguredEntitlements == null
            ? null
            : hasConfiguredEntitlements,
        "has_configured_new_offerings": hasConfiguredNewOfferings == null
            ? null
            : hasConfiguredNewOfferings,
        "has_made_any_live_purchase":
            hasMadeAnyLivePurchase == null ? null : hasMadeAnyLivePurchase,
        "has_made_any_purchase":
            hasMadeAnyPurchase == null ? null : hasMadeAnyPurchase,
        "intercom_hash": intercomHash == null ? null : intercomHash,
        "is_connected_to_stripe":
            isConnectedToStripe == null ? null : isConnectedToStripe,
        "name": name == null ? null : name,
        "subscriptions": subscriptions == null ? null : subscriptions.toJson(),
      };
}

class BillingInfo {
  BillingInfo({
    this.currentMtr,
    this.mtrLimit,
    this.paymentCard,
    this.periodEnd,
    this.periodStart,
  });

  final int currentMtr;
  final int mtrLimit;
  final PaymentCard paymentCard;
  final DateTime periodEnd;
  final DateTime periodStart;

  factory BillingInfo.fromJson(Map<String, dynamic> json) => BillingInfo(
        currentMtr: json["current_mtr"] == null ? null : json["current_mtr"],
        mtrLimit: json["mtr_limit"] == null ? null : json["mtr_limit"],
        paymentCard: json["payment_card"] == null
            ? null
            : PaymentCard.fromJson(json["payment_card"]),
        periodEnd: json["period_end"] == null
            ? null
            : DateTime.parse(json["period_end"]),
        periodStart: json["period_start"] == null
            ? null
            : DateTime.parse(json["period_start"]),
      );

  Map<String, dynamic> toJson() => {
        "current_mtr": currentMtr == null ? null : currentMtr,
        "mtr_limit": mtrLimit == null ? null : mtrLimit,
        "payment_card": paymentCard == null ? null : paymentCard.toJson(),
        "period_end": periodEnd == null ? null : periodEnd.toIso8601String(),
        "period_start":
            periodStart == null ? null : periodStart.toIso8601String(),
      };
}

class PaymentCard {
  PaymentCard({
    this.brand,
    this.country,
    this.expirationMonth,
    this.expirationYear,
    this.lastDigits,
  });

  final dynamic brand;
  final dynamic country;
  final dynamic expirationMonth;
  final dynamic expirationYear;
  final dynamic lastDigits;

  factory PaymentCard.fromJson(Map<String, dynamic> json) => PaymentCard(
        brand: json["brand"],
        country: json["country"],
        expirationMonth: json["expiration_month"],
        expirationYear: json["expiration_year"],
        lastDigits: json["last_digits"],
      );

  Map<String, dynamic> toJson() => {
        "brand": brand,
        "country": country,
        "expiration_month": expirationMonth,
        "expiration_year": expirationYear,
        "last_digits": lastDigits,
      };
}

class Subscriptions {
  Subscriptions();

  factory Subscriptions.fromJson(Map<String, dynamic> json) => Subscriptions();

  Map<String, dynamic> toJson() => {};
}
