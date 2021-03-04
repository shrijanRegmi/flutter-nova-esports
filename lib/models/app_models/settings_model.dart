class SettingModel {
  final String imgPath;
  final String title;
  SettingModel({this.imgPath, this.title});
}

List<SettingModel> generalSettings = [
  SettingModel(
    imgPath: 'assets/images/svgs/wrench.svg',
    title: 'Profile Information',
  ),
  SettingModel(
    imgPath: 'assets/images/svgs/building.svg',
    title: 'Your Addresses',
  ),
  SettingModel(
    imgPath: 'assets/images/svgs/notification.svg',
    title: 'Notifications',
  ),
  SettingModel(
    imgPath: 'assets/images/svgs/privacy.svg',
    title: 'Privacy and Security',
  ),
  SettingModel(
    imgPath: 'assets/images/svgs/logout.svg',
    title: 'Log out',
  ),
];
