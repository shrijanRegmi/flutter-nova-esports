import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/user_model.dart';

class Feed {
  String id;
  final DocumentReference feedRef;
  final String ownerId;
  final DocumentReference ownerRef;
  final AppUser owner;
  final int updatedAt;
  final String caption;
  final List<String> photos;
  final AppUser initialReactor;
  final int reactionCount;
  final List<String> reactorsPhoto;
  final bool isReacted;
  final bool isFeatured;
  final bool isSaved;

  Feed({
    this.id,
    this.feedRef,
    this.ownerId,
    this.ownerRef,
    this.owner,
    this.updatedAt,
    this.caption,
    this.photos,
    this.initialReactor,
    this.reactionCount,
    this.reactorsPhoto = const [],
    this.isReacted = false,
    this.isFeatured,
    this.isSaved = false,
  });

  Feed copyWith({
    String id,
    final DocumentReference feedRef,
    final String ownerId,
    final DocumentReference ownerRef,
    final AppUser owner,
    final int updatedAt,
    final String caption,
    final List<String> photos,
    final AppUser initialReactor,
    final int reactionCount,
    final List<String> reactorsPhoto,
    final bool isReacted,
    final bool isFeatured,
    final bool isSaved,
  }) {
    return Feed(
      id: id ?? this.id,
      feedRef: feedRef ?? this.feedRef,
      ownerId: ownerId ?? this.ownerId,
      ownerRef: ownerRef ?? this.ownerRef,
      owner: owner ?? this.owner,
      updatedAt: updatedAt ?? this.updatedAt,
      caption: caption ?? this.caption,
      photos: photos ?? this.photos,
      initialReactor: initialReactor ?? this.initialReactor,
      reactionCount: reactionCount ?? this.reactionCount,
      reactorsPhoto: reactorsPhoto ?? this.reactorsPhoto,
      isReacted: isReacted ?? this.isReacted,
      isFeatured: isFeatured ?? this.isFeatured,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  static Feed fromJson(final Map<String, dynamic> data) {
    final _ref = FirebaseFirestore.instance;
    return Feed(
      id: data['id'],
      feedRef: _ref.collection('posts').doc(data['id']),
      ownerId: data['owner_id'],
      updatedAt: data['updated_at'] ?? DateTime.now().millisecondsSinceEpoch,
      caption: data['caption'] ?? '',
      photos: List<String>.from(data['photos'] ?? []),
      ownerRef: data['owner_ref'],
      owner: data['owner'] == null ? null : AppUser.fromJson(data['owner']),
      initialReactor: data['init_reactor'] == null
          ? null
          : AppUser.fromJson(data['init_reactor']),
      reactionCount: data['reaction_count'] ?? 0,
      reactorsPhoto: List<String>.from(data['reactors_photo'] ?? []),
      isReacted: data['is_reacted'] ?? false,
      isFeatured: data['is_featured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'owner_ref': ownerRef,
      'updated_at': updatedAt,
      'caption': caption,
      'photos': photos,
      'is_featured': isFeatured,
      'owner': owner.toFeedUser()
    };
  }
}
