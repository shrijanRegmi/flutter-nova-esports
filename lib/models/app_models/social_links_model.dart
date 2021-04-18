class SocialLink {
  final String id;
  final String imgUrl;
  final String socialLink;

  SocialLink({
    this.id,
    this.imgUrl,
    this.socialLink,
  });

  SocialLink copyWith({
    final String id,
    final String imgUrl,
    final String socialLink,
  }) {
    return SocialLink(
      id: id,
      imgUrl: imgUrl,
      socialLink: socialLink,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img_url': imgUrl,
      'social_link': socialLink,
    };
  }

  static SocialLink fromJson(final Map<String, dynamic> data) {
    return SocialLink(
      id: data['id'],
      imgUrl: data['img_url'],
      socialLink: data['social_link'],
    );
  }
}
