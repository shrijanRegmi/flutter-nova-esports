class SocialLink {
  final String imgUrl;
  final String socialLink;

  SocialLink({
    this.imgUrl,
    this.socialLink,
  });

  SocialLink copyWith({
    final String imgUrl,
    final String socialLink,
  }) {
    return SocialLink(
      imgUrl: imgUrl,
      socialLink: socialLink,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'img_url': imgUrl,
      'social_link': socialLink,
    };
  }

  static SocialLink fromJson(final Map<String, dynamic> data) {
    return SocialLink(
      imgUrl: data['img_url'],
      socialLink: data['social_link'],
    );
  }
}
