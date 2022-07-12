

class UrlController {

  // Staging
  static String kUserBaseURL = "https://sogo.fireworksmedia.com";

  // Live
  // static String kUserBaseURL = "https://member.sogo.com.my";

  ///////////////////////////////////  API End Points //////////////////////////////////////////

  // Login API
  String loginUrlEndpoint = "/loyalty/api2/login.php";
  String addDeviceTokenUrlEndpoint = "/loyalty/api2/addDeviceToken.php";
  String checkSessionUrlEndpoint = "/loyalty/api2/checkSession.php";
  String verifyPasswordUrlEndpoint = "/loyalty/api2/get_verify_password.php";
  String migrationResetPasswordUrlEndpoint = "/loyalty/migration_resetpass_email_api.php";

  // Sign up API
  String checkMigratedUserUrlEndpoint = "/loyalty/api2/checkMigrateExist.php";
  String getMigratedUserDataUrlEndpoint = "/loyalty/api2/getMigratedUserData.php";
  String sendOtpUrlEndpoint = "/loyalty/api2/otp_register.php";
  String verifyOtpUrlEndpoint = "/loyalty/api2/otp_register_verification.php";
  String signUpUrlEndpoint = "/loyalty/api2/register.php";
  String pointsDetailsUrlEndpoint = "/loyalty/api/PointDetails.php";
  String checkEmailUrlEndpoint = "/loyalty/api2/checkEmail.php";
  String registerFriendUrlEndpoint = "/loyalty/api2/registerfr.php";
  String registerJuniorUrlEndpoint = "/loyalty/api2/registerjr.php";
  String statesUrlEndpoint = "/loyalty/api2/branch_states.php";
  String statesWithoutTokenUrlEndpoint = "/loyalty/api/branch_states.php";

  // Dashboard
  String mallListUrlEndpoint = "/loyalty/api2/malllist.php";
  String mallListWithoutTokenUrlEndpoint = "/loyalty/api/malllist.php";
  String dashboardUrlEndpoint = "/loyalty/api2/dashboard.php";

  // Promotions and News
  String getNewsUrlEndpoint = "/loyalty/api2/getNews.php";
  String getNewsDetailsUrlEndpoint = "/loyalty/api2/getNewsDetails.php";

  // Rewards
  String rewardsListUrlEndpoint = "/loyalty/api2/webview_getRewards.php";
  String rewardDetailsUrlEndpoint = "/loyalty/api2/webview_getDetails.php";
  String rewardCategoryUrlEndpoint = "/loyalty/api2/webview_getCategory.php";
  String rewardCheckoutUrlEndpoint = "/loyalty/api2/checkout.php";
  String giftCheckoutUrlEndpoint = "/loyalty/api2/giftCheckout.php";
  String shippingPointsUrlEndpoint = "/loyalty/api2/get_shipping_points.php";

  String merchantDetailsUrlEndpoint = "/loyalty/api2/webview_aboutMerchant.php";

  //My Rewards
  String myRewardsListUrlEndpoint = "/loyalty/api2/webview_getWallet.php";
  String myMultiRewardsListUrlEndpoint = "/loyalty/api2/webview_multiWalletList.php";
  String myRewardDetailsUrlEndpoint = "/loyalty/api2/webview_getWalletDetails.php";

  // Events
  String eventsListUrlEndpoint = "/loyalty/api2/webview_getEvents.php";
  String eventDetailsUrlEndpoint = "/loyalty/api2/webview_eventDetails.php";
  String eventsCheckoutUrlEndpoint = "/loyalty/api2/event_checkout.php";

  // User Info
  String getProfileUrlEndpoint = "/loyalty/api2/profile.php";
  String updateProfileUrlEndpoint = "/loyalty/api2/updateProfile.php";
  String getProfileImageUrlEndpoint = "/loyalty/api2/getProfileImage.php";
  String transferPointsUrlEndpoint = "/loyalty/api2/merchantAddPoints.php";
  String deleteProfileUrlEndpoint = "/loyalty/api2/deleteCust.php";

  // Manage password
  String changePasswordUrlEndpoint = "/loyalty/api2/changepass.php";
  String resetPasswordUrlEndpoint = "/loyalty/e-commerce/api/forgetPass.php";

  // Transaction
  String transactionHistoryUrlEndpoint = "/loyalty/api2/merchantTransactionHistoryNew.php";
  String transactionDetailsUrlEndpoint = "/loyalty/api2/merchantTransactionHistorySingle.php";

  // Referral
  String getReferralInfoUrlEndpoint = "/loyalty/api2/getReferralRewardData.php";

  // Daily Rewards
  String dailyRewardUrlEndpoint = "/loyalty/api2/get_daily_check_in_rewards.php";
  String dailyCheckInUrlEndpoint = "/loyalty/api2/daily_check_in_rewards.php";

  // Settings
  String getNotificationSettingsUrlEndpoint = "/loyalty/api2/getnoti.php";
  String updateNotificationSettingsUrlEndpoint = "/loyalty/api2/savenoti.php";

  // Useful links
  String usefulLinksUrlEndpoint = "/loyalty/api2/usefullinks.php";

  // Facilities
  String facilityCategoriesUrlEndpoint = "/loyalty/api2/facility_categories.php";
  String getFacilityFloorUrlEndpoint = "/loyalty/api2/getFacilityFloor.php";
  String getFacilityUrlEndpoint = "/loyalty/api2/getFacilities.php";
  String facilityDetailsUrlEndpoint = "/loyalty/api2/webview_aboutFacility.php";

  // Directory
  String directoryCategoriesUrlEndpoint = "/loyalty/api2/categories.php";
  String getDirectoryFloorUrlEndpoint = "/loyalty/api2/getDirectoryFloor.php";
  String getDirectoryUrlEndpoint = "/loyalty/api2/getDirectoryList.php";
  String directoryDetailsUrlEndpoint = "/loyalty/api2/webview_aboutMerchant.php";

  // Support
  String createTicketUrlEndpoint = "/loyalty/information/support_mailer.php";

  // Notifications
  String inboxListingUrlEndpoint = "/loyalty/api2/inbox_listing.php";
  String inboxActionUrlEndpoint = "/loyalty/api2/inbox_action.php";


  sendOtpUrl() {
    return kUserBaseURL + sendOtpUrlEndpoint;
  }

  verifyOtpUrl() {
    return kUserBaseURL + verifyOtpUrlEndpoint;
  }

  pointsDetailsUrl() {
    return kUserBaseURL + pointsDetailsUrlEndpoint;
  }

  checkEmailUrl() {
    return kUserBaseURL + checkEmailUrlEndpoint;
  }

  checkMigrateUserUrl() {
    return kUserBaseURL + checkMigratedUserUrlEndpoint;
  }

  getMigratedUserDataUrl() {
    return kUserBaseURL + getMigratedUserDataUrlEndpoint;
  }

  signUpUrl() {
    return kUserBaseURL + signUpUrlEndpoint;
  }

  statesUrl(bool withoutToken) {
    if(withoutToken){
      return kUserBaseURL + statesWithoutTokenUrlEndpoint;
    }
    return kUserBaseURL + statesUrlEndpoint;
  }

  addDeviceTokenUrl() {
    return kUserBaseURL + addDeviceTokenUrlEndpoint;
  }

  loginUrl() {
    return kUserBaseURL + loginUrlEndpoint;
  }

  checkSessionUrl() {
    return kUserBaseURL + checkSessionUrlEndpoint;
  }

  migrationResetPasswordUrl() {
    return kUserBaseURL + migrationResetPasswordUrlEndpoint;
  }

  dashboardUrl() {
    return kUserBaseURL + dashboardUrlEndpoint;
  }

  profileUrl() {
    return kUserBaseURL + getProfileUrlEndpoint;
  }

  updateProfileUrl() {
    return kUserBaseURL + updateProfileUrlEndpoint;
  }

  deleteProfileUrl() {
    return kUserBaseURL + deleteProfileUrlEndpoint;
  }

  changePasswordUrl() {
    return kUserBaseURL + changePasswordUrlEndpoint;
  }

  resetPasswordUrl() {
    return kUserBaseURL + resetPasswordUrlEndpoint;
  }

  mallListUrl(bool withoutToken) {
    if(withoutToken){
      return kUserBaseURL + mallListWithoutTokenUrlEndpoint;
    }
    return kUserBaseURL + mallListUrlEndpoint;
  }

  newsListUrl() {
    return kUserBaseURL + getNewsUrlEndpoint;
  }

  newsDetailsListUrl() {
    return kUserBaseURL + getNewsDetailsUrlEndpoint;
  }

  rewardsListUrl() {
    return kUserBaseURL + rewardsListUrlEndpoint;
  }

  rewardsCategoryListUrl() {
    return kUserBaseURL + rewardCategoryUrlEndpoint;
  }

  rewardDetailsUrl() {
    return kUserBaseURL + rewardDetailsUrlEndpoint;
  }

  rewardCheckoutUrl() {
    return kUserBaseURL + rewardCheckoutUrlEndpoint;
  }

  myRewardsListUrl() {
    return kUserBaseURL + myRewardsListUrlEndpoint;
  }

  myMultiRewardsListUrl() {
    return kUserBaseURL + myMultiRewardsListUrlEndpoint;
  }

  myRewardDetailsUrl() {
    return kUserBaseURL + myRewardDetailsUrlEndpoint;
  }

  merchantDetailsUrl() {
    return kUserBaseURL + merchantDetailsUrlEndpoint;
  }

  eventsListUrl() {
    return kUserBaseURL + eventsListUrlEndpoint;
  }

  eventDetailsListUrl() {
    return kUserBaseURL + eventDetailsUrlEndpoint;
  }

  transactionHistoryUrl() {
    return kUserBaseURL + transactionHistoryUrlEndpoint;
  }

  transactionDetailsUrl() {
    return kUserBaseURL + transactionDetailsUrlEndpoint;
  }

  getReferralInfoUrl() {
    return kUserBaseURL + getReferralInfoUrlEndpoint;
  }

  dailyRewardsUrl() {
    return kUserBaseURL + dailyRewardUrlEndpoint;
  }

  dailyCheckInUrl() {
    return kUserBaseURL + dailyCheckInUrlEndpoint;
  }

  getNotificationSettingsUrl() {
    return kUserBaseURL + getNotificationSettingsUrlEndpoint;
  }

  updateNotificationSettingsUrl() {
    return kUserBaseURL + updateNotificationSettingsUrlEndpoint;
  }

  facilityCategoriesUrl() {
    return kUserBaseURL + facilityCategoriesUrlEndpoint;
  }

  getFacilityFloorUrl() {
    return kUserBaseURL + getFacilityFloorUrlEndpoint;
  }

  getFacilityUrl() {
    return kUserBaseURL + getFacilityUrlEndpoint;
  }

  facilityDetailsUrl() {
    return kUserBaseURL + facilityDetailsUrlEndpoint;
  }

  directoryCategoriesUrl() {
    return kUserBaseURL + directoryCategoriesUrlEndpoint;
  }

  getDirectoryFloorUrl() {
    return kUserBaseURL + getDirectoryFloorUrlEndpoint;
  }

  getDirectoryUrl() {
    return kUserBaseURL + getDirectoryUrlEndpoint;
  }

  directoryDetailsUrl() {
    return kUserBaseURL + directoryDetailsUrlEndpoint;
  }

  createTicketUrl() {
    return kUserBaseURL + createTicketUrlEndpoint;
  }

  inboxListingUrl() {
    return kUserBaseURL + inboxListingUrlEndpoint;
  }

  inboxActionUrl() {
    return kUserBaseURL + inboxActionUrlEndpoint;
  }
}
