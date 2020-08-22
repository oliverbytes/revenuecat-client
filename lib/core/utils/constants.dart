// CONSTANTS

import 'package:flutter/foundation.dart';

const String kApptitle = 'RevenueCat';

const String kCorsAnywhere = 'https://cors-anywhere.herokuapp.com/';

const String kBaseAPIUrl = 'https://api.revenuecat.com/v1';

final baseAPIUrl = (kIsWeb ? kCorsAnywhere : '') + kBaseAPIUrl;

final String overviewUrl = '$baseAPIUrl/developers/me/overview';

final String transactionsUrl = '$baseAPIUrl/developers/me/transactions';

const String kGithubProjectUrl =
    'https://github.com/nemoryoliver/revenuecat-client';

const kWebMaxWidth = 800.0;

const String kInternetError = 'Please check your internet connection.';
