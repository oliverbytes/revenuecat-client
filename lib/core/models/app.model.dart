class App {
  App({
    this.apiKey,
    this.appStoreSharedSecret,
    this.appleServerToServerNotificationsError,
    this.appleServerToServerNotificationsLastReceivedAt,
    this.appleServerToServerNotificationsToken,
    this.appleSubscriptionKeyId,
    this.bundleId,
    this.enablePriceExperiments,
    this.featureOverrides,
    this.googlePlayPubSubEnabled,
    this.googlePlayPubSubErrorStatus,
    this.googlePlayPubSubLastMessageReceivedAt,
    this.googlePlayPubSubTopicId,
    this.hasReceivedApiCall,
    this.id,
    this.macAppStoreSharedSecret,
    this.name,
    this.iconUrl,
    this.newOfferingsEnabled,
    this.playStoreCredentials,
    this.playStorePackageName,
    this.role,
    this.shouldSendAliasWebhooks,
    this.usesLegacyMacAppStore,
  });

  final String apiKey;
  final String appStoreSharedSecret;
  final dynamic appleServerToServerNotificationsError;
  final dynamic appleServerToServerNotificationsLastReceivedAt;
  final String appleServerToServerNotificationsToken;
  final String appleSubscriptionKeyId;
  final String bundleId;
  final bool enablePriceExperiments;
  final List<dynamic> featureOverrides;
  final bool googlePlayPubSubEnabled;
  final dynamic googlePlayPubSubErrorStatus;
  final dynamic googlePlayPubSubLastMessageReceivedAt;
  final String googlePlayPubSubTopicId;
  final bool hasReceivedApiCall;
  final String id;
  final dynamic macAppStoreSharedSecret;
  final String name;
  final String iconUrl;
  final bool newOfferingsEnabled;
  final String playStoreCredentials;
  final String playStorePackageName;
  final String role;
  final bool shouldSendAliasWebhooks;
  final bool usesLegacyMacAppStore;

  factory App.fromJson(Map<String, dynamic> json) => App(
        apiKey: json["api_key"] == null ? null : json["api_key"],
        appStoreSharedSecret: json["app_store_shared_secret"] == null
            ? null
            : json["app_store_shared_secret"],
        appleServerToServerNotificationsError:
            json["apple_server_to_server_notifications_error"],
        appleServerToServerNotificationsLastReceivedAt:
            json["apple_server_to_server_notifications_last_received_at"],
        appleServerToServerNotificationsToken:
            json["apple_server_to_server_notifications_token"] == null
                ? null
                : json["apple_server_to_server_notifications_token"],
        appleSubscriptionKeyId: json["apple_subscription_key_id"] == null
            ? null
            : json["apple_subscription_key_id"],
        bundleId: json["bundle_id"] == null ? null : json["bundle_id"],
        enablePriceExperiments: json["enable_price_experiments"] == null
            ? null
            : json["enable_price_experiments"],
        featureOverrides: json["feature_overrides"] == null
            ? null
            : List<dynamic>.from(json["feature_overrides"].map((x) => x)),
        googlePlayPubSubEnabled: json["google_play_pub_sub_enabled"] == null
            ? null
            : json["google_play_pub_sub_enabled"],
        googlePlayPubSubErrorStatus: json["google_play_pub_sub_error_status"],
        googlePlayPubSubLastMessageReceivedAt:
            json["google_play_pub_sub_last_message_received_at"],
        googlePlayPubSubTopicId: json["google_play_pub_sub_topic_id"] == null
            ? null
            : json["google_play_pub_sub_topic_id"],
        hasReceivedApiCall: json["has_received_api_call"] == null
            ? null
            : json["has_received_api_call"],
        id: json["id"] == null ? null : json["id"],
        macAppStoreSharedSecret: json["mac_app_store_shared_secret"],
        name: json["name"] == null ? null : json["name"],
        iconUrl: json["icon_url"] == null ? null : json["icon_url"],
        newOfferingsEnabled: json["new_offerings_enabled"] == null
            ? null
            : json["new_offerings_enabled"],
        playStoreCredentials: json["play_store_credentials"] == null
            ? null
            : json["play_store_credentials"],
        playStorePackageName: json["play_store_package_name"] == null
            ? null
            : json["play_store_package_name"],
        role: json["role"] == null ? null : json["role"],
        shouldSendAliasWebhooks: json["should_send_alias_webhooks"] == null
            ? null
            : json["should_send_alias_webhooks"],
        usesLegacyMacAppStore: json["uses_legacy_mac_app_store"] == null
            ? null
            : json["uses_legacy_mac_app_store"],
      );

  Map<String, dynamic> toJson() => {
        "api_key": apiKey == null ? null : apiKey,
        "app_store_shared_secret":
            appStoreSharedSecret == null ? null : appStoreSharedSecret,
        "apple_server_to_server_notifications_error":
            appleServerToServerNotificationsError,
        "apple_server_to_server_notifications_last_received_at":
            appleServerToServerNotificationsLastReceivedAt,
        "apple_server_to_server_notifications_token":
            appleServerToServerNotificationsToken == null
                ? null
                : appleServerToServerNotificationsToken,
        "apple_subscription_key_id":
            appleSubscriptionKeyId == null ? null : appleSubscriptionKeyId,
        "bundle_id": bundleId == null ? null : bundleId,
        "enable_price_experiments":
            enablePriceExperiments == null ? null : enablePriceExperiments,
        "feature_overrides": featureOverrides == null
            ? null
            : List<dynamic>.from(featureOverrides.map((x) => x)),
        "google_play_pub_sub_enabled":
            googlePlayPubSubEnabled == null ? null : googlePlayPubSubEnabled,
        "google_play_pub_sub_error_status": googlePlayPubSubErrorStatus,
        "google_play_pub_sub_last_message_received_at":
            googlePlayPubSubLastMessageReceivedAt,
        "google_play_pub_sub_topic_id":
            googlePlayPubSubTopicId == null ? null : googlePlayPubSubTopicId,
        "has_received_api_call":
            hasReceivedApiCall == null ? null : hasReceivedApiCall,
        "id": id == null ? null : id,
        "mac_app_store_shared_secret": macAppStoreSharedSecret,
        "name": name == null ? null : name,
        "icon_url": iconUrl == null ? null : iconUrl,
        "new_offerings_enabled":
            newOfferingsEnabled == null ? null : newOfferingsEnabled,
        "play_store_credentials":
            playStoreCredentials == null ? null : playStoreCredentials,
        "play_store_package_name":
            playStorePackageName == null ? null : playStorePackageName,
        "role": role == null ? null : role,
        "should_send_alias_webhooks":
            shouldSendAliasWebhooks == null ? null : shouldSendAliasWebhooks,
        "uses_legacy_mac_app_store":
            usesLegacyMacAppStore == null ? null : usesLegacyMacAppStore,
      };
}
