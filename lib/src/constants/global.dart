
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/models/auth/login_profile_model.dart';

class ApplicationGlobal{
  static String bearerToken = '';
  static const String secretKey = "fireworks!12*SP#Se";
  static const String deleteAccountKey = "kjf93j9asr10";
  static Mall? selectedMall;
  static LoginProfileModel? profile;
  static MallListModel? mallList;

  //Registration flow parameters
  static String? firstName;
  static String? lastName;
  static String? email;
  static String? socialToken;
  static String? socialType;
  static String? referralCode;
  static bool? newsSubscription;
  static PhoneNumber? phone;
  static String? password;
  static String? memberCardNo;
  static int? pointsBalance;
  static int migrate = 0;

  static String? custId;

  //Update profile extra parameters
  static String? title;
  static String? dob;
  static String? nric;
  static int? idType;
  static String? displayName;
  static int? gender;
  static String? loveAnniversary;
  static String? nationality;
  static String? country;
  static String? race;
  static int? householdincome;
  static String? selectedinterests;
  static String? address1;
  static String? address2;
  static String? state;
  static String? city;
  static String? postcode;
  static int? mall;

  static List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
}