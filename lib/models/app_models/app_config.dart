class AppConfig {
  final int maxAdViews;
  final int adShowTimer;
  final int rewardCoins;
  final String bannerId;
  final String interstitialId;
  final String rewardId;
  final String appLink;
  final String aboutApp;
  final String supportEmail;

  AppConfig({
    this.maxAdViews,
    this.adShowTimer,
    this.rewardCoins,
    this.bannerId,
    this.interstitialId,
    this.rewardId,
    this.appLink,
    this.aboutApp,
    this.supportEmail,
  });

  AppConfig copyWith({
    final int maxAdViews,
    final int adShowTimer,
    final int rewardCoins,
    final String bannerId,
    final String interstitialId,
    final String rewardId,
    final String appLink,
    final String aboutApp,
    final String supportEmail,
  }) {
    return AppConfig(
      maxAdViews: maxAdViews ?? this.maxAdViews,
      adShowTimer: adShowTimer ?? this.adShowTimer,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      bannerId: bannerId ?? this.bannerId,
      interstitialId: interstitialId ?? this.interstitialId,
      rewardId: rewardId ?? this.rewardId,
      appLink: appLink ?? this.appLink,
      aboutApp: aboutApp ?? this.aboutApp,
      supportEmail: supportEmail ?? this.supportEmail,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max_ad_views': maxAdViews,
      'ad_show_timer': adShowTimer,
      'reward_coins': rewardCoins,
      'banner_id': bannerId,
      'interstitial_id': interstitialId,
      'reward_id': rewardId,
      'app_link': appLink,
      'about_app': aboutApp,
      'support_email': supportEmail,
    };
  }

  static AppConfig fromJson(final Map<String, dynamic> data) {
    return AppConfig(
      maxAdViews: data['max_ad_views'] ?? 5,
      adShowTimer: data['ad_show_timer'] ?? 5,
      rewardCoins: data['reward_coins'] ?? 5,
      bannerId: data['banner_id'] ?? 'ca-app-pub-3940256099942544/6300978111',
      interstitialId:
          data['interstitial_id'] ?? 'ca-app-pub-3940256099942544/1033173712',
      rewardId: data['reward_id'] ?? 'ca-app-pub-3940256099942544/5224354917',
      appLink: data['app_link'] ?? '',
      aboutApp: data['about_app'] ?? '',
      supportEmail: data['support_email'] ?? '',
    );
  }
}
