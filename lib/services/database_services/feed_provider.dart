import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/comment_model.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';

class FeedProvider {
  final AppUser appUser;
  final AppUser user;
  final Feed feed;
  final Moment moment;
  FeedProvider({
    this.appUser,
    this.feed,
    this.moment,
    this.user,
  });

  final _ref = FirebaseFirestore.instance;

  // create post
  Future<Feed> createPost() async {
    try {
      final _postref = _ref.collection('posts').doc();
      Feed _feed = feed;
      _feed = _feed.copyWith(id: _postref.id, feedRef: _postref);
      await _postref.set(_feed.toJson());
      print('Success: Creating post');

      await _updatePhotosCount(feed.photos.length);

      if (feed.isFeatured) {
        await _saveFeatured(_feed);
      }

      return _feed;
    } catch (e) {
      print(e);
      print('Error!!!: Creating post');
      return null;
    }
  }

  // create moments
  Future<Moment> createMoment() async {
    try {
      final _momentRef = _ref.collection('moments').doc();
      final _moment = moment.copyWith(
        id: _momentRef.id,
      );

      await _momentRef.set(_moment.toJson());

      print('Success: Creating moment ${_moment.id}');
      return _moment;
    } catch (e) {
      print(e);
      print('Error!!!: Creating moment');
      return null;
    }
  }

  // send feed to friends timeline
  Future sendToTimelines() async {
    try {
      final _userRef = appUser.appUserRef;
      final _followersRef = _userRef.collection('followers');
      final _followersSnap = await _followersRef.get();
      if (_followersSnap.docs.isNotEmpty) {
        for (final _docSnap in _followersSnap.docs) {
          if (_docSnap.exists) {
            final _data = _docSnap.data();
            final _uid = _data['id'];
            final _timelineRef = _ref
                .collection('users')
                .doc(_uid)
                .collection('timeline')
                .doc(feed.id);

            await _timelineRef.set({
              'id': feed.id,
              'post_ref': feed.feedRef,
              'updated_at': DateTime.now().millisecondsSinceEpoch,
            });
            print('Success: Posting to $_uid timeline');
          }
        }
      }
      print('Success: Saving to followers timeline');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Saving to followers timeline');
      return null;
    }
  }

  // save featured post to users collection too
  Future _saveFeatured(final Feed _feed) async {
    try {
      final _userRef = appUser.appUserRef;
      final _featuredPostsRef =
          _userRef.collection('featured_posts').doc(_feed.id);

      await _featuredPostsRef.set({
        'post_ref': _feed.feedRef,
        'updated_at': _feed.updatedAt,
      });

      print('Success: Saving featured post ${feed.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Success: Saving featured post ${feed.id}');
      return null;
    }
  }

  // react to post
  Future reactPost() async {
    try {
      final _postRef = _ref.collection('posts').doc(feed.id);
      final _reactionsRef = _postRef.collection('reactions').doc(appUser.uid);

      final _reactionData = {
        'uid': appUser.uid,
        'unreacted': false,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      };

      await _reactionsRef.set(_reactionData);

      final _data = {
        'reaction_count': FieldValue.increment(1),
        'init_reactor': appUser.toFeedUser(),
        'reactors_photo': FieldValue.arrayUnion([appUser.photoUrl]),
      };

      if (feed.initialReactor != null &&
          feed.initialReactor.uid != appUser.uid) {
        _data.removeWhere((key, value) => key == 'init_reactor');
      }

      if (feed.reactorsPhoto.length >= 3) {
        _data.removeWhere((key, value) => key == 'reactors_photo');
      }

      await _postRef.update(_data);

      print('Success: Reacting to post ${feed.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Reacting to post ${feed.id}');
      return null;
    }
  }

  // unreact to post
  Future unReactPost() async {
    try {
      final _postRef = _ref.collection('posts').doc(feed.id);
      final _reactionsRef = _postRef.collection('reactions').doc(appUser.uid);

      await _reactionsRef.update({
        'unreacted': true,
      });

      Map<String, dynamic> _data = {
        'reaction_count': FieldValue.increment(-1),
        'init_reactor': appUser.toFeedUser(),
        'reactors_photo': FieldValue.arrayRemove([appUser.photoUrl]),
      };

      if (feed.initialReactor.uid == appUser.uid) {
        _data['init_reactor'] = null;
      } else {
        _data.removeWhere((key, value) => key == 'init_reactor');
      }

      await _postRef.update(_data);
      print('Success: Unreacting to post ${feed.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Unreacting to post ${feed.id}');
      return null;
    }
  }

  // comment in a post
  Future commentPost(final Comment comment) async {
    try {
      final _feedRef = _ref.collection('posts').doc(feed.id);
      final _commentRef = _feedRef.collection('comments').doc();
      final _comment = comment.copyWith(id: _commentRef.id);

      await _commentRef.set(_comment.toJson());
      print('Success: Commenting in post ${feed.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Commenting in post ${feed.id}');
      return null;
    }
  }

  // update photos count
  Future _updatePhotosCount(final int count) async {
    try {
      final _userRef = appUser.appUserRef;

      await _userRef.update({
        'photos': FieldValue.increment(count),
      });

      print('Success: Updating photos count');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating photos count');
    }
  }

  // delete my post
  Future deletePost() async {
    try {
      final _postRef = feed.feedRef;
      final _featuredPostsRef =
          appUser.appUserRef.collection('featured_posts').doc(feed.id);

      await _postRef.delete();
      await _featuredPostsRef.delete();
      print("Success: Deleting my post ${feed.id}");

      return _updatePhotosCount(-feed.photos.length);
    } catch (e) {
      print(e);
      print('Error!!!: Deleting my post ${feed.id}');
      return null;
    }
  }

  // save post
  Future savePost() async {
    try {
      final _savedPostRef =
          appUser.appUserRef.collection('saved_posts').doc(feed.id);

      final _data = {
        'post_ref': feed.feedRef,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      };

      await _savedPostRef.set(_data);
      print('Success: Saving feed ${feed.id}');
      return feed;
    } catch (e) {
      print(e);
      print('Error!!!: Saving feed ${feed.id}');
      return null;
    }
  }

  // remove saved post
  Future removeSavedPost() async {
    try {
      final _savedPostRef =
          appUser.appUserRef.collection('saved_posts').doc(feed.id);

      await _savedPostRef.delete();
      print('Success: Deleting saved feed ${feed.id}');
      return feed;
    } catch (e) {
      print(e);
      print('Error!!!: Deleting saved feed ${feed.id}');
      return null;
    }
  }

  // see moment
  Future viewMoment() async {
    try {
      final _momentRef = _ref.collection('moments').doc(moment.id);
      final _seenUsersRef =
          _momentRef.collection('seen_users').doc(appUser.uid);

      await _seenUsersRef.set({
        'uid': appUser.uid,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      });
      print('Success: Viewing moment ${moment.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Viewing moment ${moment.id}');
      return null;
    }
  }

  // get list of feeds
  Future<List<Feed>> _getFeedsList(final QuerySnapshot postsSnap,
      {bool isTimelinePosts = true, AppVm appVm}) async {
    final _feeds = <Feed>[];

    try {
      if (postsSnap.docs.isNotEmpty) {
        for (final doc in postsSnap.docs) {
          if (doc.exists) {
            final _data = doc.data();
            DocumentReference _postRef;
            DocumentSnapshot _postSnap;

            if (isTimelinePosts) {
              _postRef = _data['post_ref'];
              _postSnap = await _postRef.get();
            }

            final _postData = _postSnap != null && _postSnap.exists
                ? _postSnap.data()
                : _data;

            Feed _feed = Feed.fromJson(_postData);

            final _reactionsRef = _ref
                .collection('posts')
                .doc(_feed.id)
                .collection('reactions')
                .doc(appUser.uid);

            final _savedPostRef =
                appUser.appUserRef.collection('saved_posts').doc(_feed.id);

            final _reactionSnap = await _reactionsRef.get();
            final _savedPostSnap = await _savedPostRef.get();

            if (_reactionSnap.exists) {
              final _reactionData = _reactionSnap.data();
              final _isUnreacted = _reactionData['unreacted'] ?? false;

              _feed = _feed.copyWith(isReacted: !_isUnreacted);
            } else {
              _feed = _feed.copyWith(isReacted: false);
            }

            _feed = _feed.copyWith(isSaved: _savedPostSnap.exists);

            if (_feed.initialReactor != null &&
                _feed.initialReactor.uid == appUser.uid &&
                _feed.reactorsPhoto.contains(appUser.photoUrl)) {
              _feed = _feed.copyWith(initialReactor: appUser);
            }

            _feeds.add(_feed);

            if (appVm != null) {
              appVm.addToFeedList(_feed);
            }
          }
        }
      }
    } catch (e) {
      print(e);
      print('Error!!!: Getting feeds list');
    }
    return _feeds;
  }

  // get my moments
  Future<List<Moment>> getMyMoments() async {
    final _moments = <Moment>[];
    try {
      final _momentsRef =
          _ref.collection('moments').where('owner_id', isEqualTo: appUser.uid);
      final _momentsSnap = await _momentsRef.get();
      if (_momentsSnap.docs.isNotEmpty) {
        for (var doc in _momentsSnap.docs) {
          if (doc.exists) {
            final _moment = Moment.fromJson(doc.data());
            _moments.add(_moment);
          }
        }
      }
      print('Success: Getting my moments');
    } catch (e) {
      print(e);
      print('Error!!!: Getting my moments');
    }

    return _moments;
  }

  // get moments
  Future<List<Moment>> getMoments() async {
    final _moments = <Moment>[];
    try {
      final _momentsRef = appUser.appUserRef.collection('moments');
      final _momentsSnap = await _momentsRef.get();
      if (_momentsSnap.docs.isNotEmpty) {
        for (var doc in _momentsSnap.docs) {
          if (doc.exists) {
            final DocumentReference _momentRef = doc['moment_ref'];
            final _momentSnap = await _momentRef.get();
            if (_momentSnap.exists) {
              final _momentData = _momentSnap.data();
              Moment _moment = Moment.fromJson(_momentData);

              final _seenRef =
                  _momentRef.collection('seen_users').doc(appUser.uid);
              final _seenSnap = await _seenRef.get();

              _moment = _moment.copyWith(
                isSeen: _seenSnap.exists,
              );
              _moments.add(_moment);
            }
          }
        }
      }
      print('Success: Getting moments');
    } catch (e) {
      print(e);
      print('Error!!!: Getting moments');
    }

    return _moments;
  }

  // get single post by id
  Future<Feed> getSinglePostById(final String id) async {
    Feed _feed;
    try {
      final _feedRef = _ref.collection('posts').doc(id);
      final _feedSnap = await _feedRef.get();

      if (_feedSnap.exists) {
        final _feedData = _feedSnap.data();

        _feed = Feed.fromJson(_feedData);

        final _reactionsRef = _ref
            .collection('posts')
            .doc(_feed.id)
            .collection('reactions')
            .doc(appUser.uid);

        final _savedPostRef =
            appUser.appUserRef.collection('saved_posts').doc(_feed.id);

        final _reactionSnap = await _reactionsRef.get();
        final _savedPostSnap = await _savedPostRef.get();

        if (_reactionSnap.exists) {
          final _reactionData = _reactionSnap.data();
          final _isUnreacted = _reactionData['unreacted'] ?? false;

          _feed = _feed.copyWith(isReacted: !_isUnreacted);
        } else {
          _feed = _feed.copyWith(isReacted: false);
        }

        _feed = _feed.copyWith(isSaved: _savedPostSnap.exists);

        if (_feed.initialReactor != null &&
            _feed.initialReactor.uid == appUser.uid &&
            _feed.reactorsPhoto.contains(appUser.photoUrl)) {
          _feed = _feed.copyWith(initialReactor: appUser);
        }
        print('Success: Getting single post by id $id');
      }
    } catch (e) {
      print(e);
      print('Error!!!: Getting single post by id $id');
    }
    return _feed;
  }

  // get posts by id
  Future<List<Feed>> getPostsById() async {
    try {
      List<Feed> _feeds = [];

      final _postsRef = _ref
          .collection('posts')
          .where('owner_id', isEqualTo: user.uid)
          .orderBy('updated_at', descending: true)
          .limit(6);

      final _postSnap = await _postsRef.get();

      _feeds = await _getFeedsList(_postSnap, isTimelinePosts: false);

      print('Success: Getting my posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting my posts');
      return null;
    }
  }

  // get featured posts by id
  Future<List<Feed>> getFeaturedPostsById() async {
    try {
      List<Feed> _feeds = [];

      final _featuredPosts = user.appUserRef
          .collection('featured_posts')
          .orderBy('updated_at', descending: true)
          .limit(6);
      final _featuredPostsSnap = await _featuredPosts.get();

      _feeds = await _getFeedsList(_featuredPostsSnap);

      print('Success: Getting featured posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting featured posts');
      return null;
    }
  }

  // get my timeline
  Future<List<Feed>> getTimeline() async {
    try {
      AppUserProvider(uid: appUser.uid).updateUserDetail(data: {
        'new_posts': false,
      });
      List<Feed> _feeds = [];

      final _userRef = appUser.appUserRef;
      final _timelineRef = _userRef
          .collection('timeline')
          .orderBy('updated_at', descending: true)
          .limit(6);

      final _timelineSnap = await _timelineRef.get();

      _feeds = await _getFeedsList(_timelineSnap);

      print('Success: Getting my posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting my posts');
      return null;
    }
  }

  // get old featured posts by id
  Future<List<Feed>> getOldFeaturedPostsById() async {
    try {
      List<Feed> _feeds = [];

      final _userRef = user.appUserRef;

      final _featuredPostsRef = _userRef
          .collection('featured_posts')
          .orderBy('updated_at', descending: true)
          .startAfter([feed.updatedAt]).limit(5);
      final _featuredPostsSnap = await _featuredPostsRef.get();

      _feeds = await _getFeedsList(_featuredPostsSnap);

      print('Success: Getting old featured posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting old featured posts');
      return null;
    }
  }

  // get old posts by id
  Future<List<Feed>> getOldPostsById() async {
    try {
      List<Feed> _feeds = [];

      final _postsRef = _ref
          .collection('posts')
          .where('owner_id', isEqualTo: user.uid)
          .orderBy('updated_at', descending: true)
          .startAfter([feed.updatedAt]).limit(5);

      final _postSnap = await _postsRef.get();

      _feeds = await _getFeedsList(_postSnap, isTimelinePosts: false);

      print('Success: Getting old posts by id');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting old posts by id');
      return null;
    }
  }

  // get old posts of timeline
  Future<List<Feed>> getOldTimelinePosts(final AppVm appVm) async {
    try {
      List<Feed> _feeds = [];

      final _userRef = appUser.appUserRef;

      final _timelineRef = _userRef
          .collection('timeline')
          .orderBy('updated_at', descending: true)
          .startAfter([feed.updatedAt]).limit(5);
      final _timelineSnap = await _timelineRef.get();

      _feeds = await _getFeedsList(_timelineSnap, appVm: appVm);

      print('Success: Getting old timeline posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting old timeline posts');
      return null;
    }
  }

  // get new posts of timeline
  Future<List<Feed>> getNewTimelinePosts() async {
    try {
      List<Feed> _feeds = [];

      final _userRef = appUser.appUserRef;

      final _timelineRef = _userRef
          .collection('timeline')
          .orderBy('updated_at', descending: true)
          .endBefore([feed.updatedAt]).limit(5);
      final _timelineSnap = await _timelineRef.get();

      _feeds = await _getFeedsList(_timelineSnap, isTimelinePosts: true);

      print('Success: Getting new timeline posts');
      return _feeds;
    } catch (e) {
      print(e);
      print('Error!!!: Getting new timeline posts');
      return null;
    }
  }

  // get saved feeds
  Future<List<Feed>> getSavedPosts() async {
    List<Feed> _feeds = [];
    try {
      final _savedPostsRef = appUser.appUserRef.collection('saved_posts');
      final _savedPostsSnap = await _savedPostsRef.get();

      _feeds = await _getFeedsList(_savedPostsSnap);

      print('Success: Getting saved posts');
    } catch (e) {
      print(e);
      print('Error!!!: Getting saved posts');
    }

    return _feeds;
  }

  // get comment
  Future<List<Comment>> getComments() async {
    try {
      List<Comment> _comments = [];

      final _commentRef = feed.feedRef
          .collection('comments')
          .orderBy('updated_at', descending: true)
          .limit(10);
      final _commentSnap = await _commentRef.get();

      if (_commentSnap.docs.isNotEmpty) {
        for (final commentDoc in _commentSnap.docs) {
          final _commentData = commentDoc.data();
          final DocumentReference _userRef = _commentData['user_ref'];
          final _userSnap = await _userRef.get();
          if (_userSnap.exists) {
            final _userData = _userSnap.data();
            final _user = AppUser.fromJson(_userData);
            final _comment = Comment.fromJson(_commentData, _user);

            _comments.add(_comment);
          }
        }
      }

      print('Success: Getting all comments');
      return _comments;
    } catch (e) {
      print(e);
      print('Error!!!: Getting all comments');
      return null;
    }
  }
}
