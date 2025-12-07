import 'dart:typed_data';

/// 동네생활 게시글 데이터 모델
class NeighborhoodPost {
  final String id;
  final String category;
  final String title;
  final String content;
  final String authorName;
  final String location;
  final DateTime createdAt;
  final List<Uint8List>? images; // 첨부 이미지 바이트 데이터
  int likes;
  List<NeighborhoodComment> comments;
  bool isLiked;

  NeighborhoodPost({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.authorName,
    required this.location,
    required this.createdAt,
    this.images,
    this.likes = 0,
    List<NeighborhoodComment>? comments,
    this.isLiked = false,
  }) : comments = comments ?? [];

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return '방금';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays == 1) return '어제';
    return '${diff.inDays}일 전';
  }
}

/// 댓글 데이터 모델
class NeighborhoodComment {
  final String id;
  final String authorName;
  final String content;
  final DateTime createdAt;

  NeighborhoodComment({
    required this.id,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return '방금';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays == 1) return '어제';
    return '${diff.inDays}일 전';
  }
}

/// 전역 동네생활 게시글 리스트
List<NeighborhoodPost> neighborhoodPosts = [
  NeighborhoodPost(
    id: 'post_001',
    category: '동네정보',
    title: '이 동네 맛집 추천해주세요!',
    content: '이사온지 얼마 안됐는데 맛집 추천 부탁드려요~\n특히 분식이나 한식 좋아해요!',
    authorName: '새이웃',
    location: '아라동',
    createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    likes: 5,
    comments: [
      NeighborhoodComment(
        id: 'comment_001',
        authorName: '동네사람',
        content: '아라분식 추천해요! 떡볶이 맛있어요~',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      NeighborhoodComment(
        id: 'comment_002',
        authorName: '맛집탐방러',
        content: '한식은 할매순대국 가보세요!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
    ],
  ),
  NeighborhoodPost(
    id: 'post_002',
    category: '동네정보',
    title: '주말에 아라동 축제 한다고 하네요',
    content: '이번 주말에 동네 축제가 열린다고 합니다. 다들 오세요!\n아이들이랑 가기 좋을 것 같아요.',
    authorName: '축제좋아',
    location: '아라동',
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    likes: 23,
    comments: [
      NeighborhoodComment(
        id: 'comment_003',
        authorName: '동네주민',
        content: '오 좋은 정보 감사해요!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
    ],
  ),
  NeighborhoodPost(
    id: 'post_003',
    category: '취미 및 일상',
    title: '같이 러닝하실 분 계신가요?',
    content: '매주 토요일 아침에 같이 러닝하실 분 구해요.\n초보도 환영합니다!',
    authorName: '러닝맨',
    location: '아라동',
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    likes: 15,
    comments: [
      NeighborhoodComment(
        id: 'comment_004',
        authorName: '운동초보',
        content: '저요저요! 어디서 모이나요?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
      NeighborhoodComment(
        id: 'comment_005',
        authorName: '건강맨',
        content: '저도 참여하고 싶어요~',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
  ),
  NeighborhoodPost(
    id: 'post_004',
    category: '동네정보',
    title: '아라동 새로 생긴 카페 다녀왔어요',
    content: '분위기도 좋고 커피도 맛있어요.\n디저트도 추천합니다!',
    authorName: '카페러버',
    location: '아라동',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    likes: 31,
  ),
  NeighborhoodPost(
    id: 'post_005',
    category: '분실/실종',
    title: '강아지를 찾습니다',
    content: '하얀색 말티즈입니다. 이름은 뽀삐예요.\n아라공원 근처에서 잃어버렸어요. 보시면 연락주세요!',
    authorName: '걱정되는주인',
    location: '아라동',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    likes: 45,
    comments: [
      NeighborhoodComment(
        id: 'comment_006',
        authorName: '동네이웃',
        content: '빨리 찾으시길 바랍니다 ㅠㅠ',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ],
  ),
];

/// 게시글 추가
void addNeighborhoodPost(NeighborhoodPost post) {
  neighborhoodPosts.insert(0, post);
}

/// 카테고리별 게시글 필터링
List<NeighborhoodPost> getPostsByCategory(String? category) {
  if (category == null || category.isEmpty) {
    return neighborhoodPosts;
  }
  return neighborhoodPosts.where((post) => post.category == category).toList();
}

/// 댓글 추가
void addComment(NeighborhoodPost post, String content, String authorName) {
  final comment = NeighborhoodComment(
    id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
    authorName: authorName,
    content: content,
    createdAt: DateTime.now(),
  );
  post.comments.add(comment);
}

/// 좋아요 토글
void toggleLike(NeighborhoodPost post) {
  if (post.isLiked) {
    post.likes--;
    post.isLiked = false;
  } else {
    post.likes++;
    post.isLiked = true;
  }
}
