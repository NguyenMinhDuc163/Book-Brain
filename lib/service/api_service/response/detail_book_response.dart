import 'base_response.dart';

class DetailBookResponse extends BaseResponse{
  DetailBookResponse({
    required this.bookId,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.excerpt,
    required this.views,
    required this.status,
    required this.rating,
    required this.authorId,
    required this.authorName,
    required this.authorBiography,
    required this.categoryId,
    required this.categoryName,
    required this.createdAt,
    required this.updatedAt,
    required this.totalChapters,
    required this.chapters,
    required this.currentChapter,
    required this.totalReviews,
    required this.isSubscribed,
    required this.isFavorited,
  });

  final int? bookId;
  final String? title;
  final String? url;
  final dynamic imageUrl;
  final dynamic excerpt;
  final int? views;
  final String? status;
  final dynamic rating;
  final int? authorId;
  final String? authorName;
  final dynamic authorBiography;
  final int? categoryId;
  final String? categoryName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? totalChapters;
  final List<Chapter> chapters;
  final CurrentChapter? currentChapter;
  final int? totalReviews;
  final bool? isSubscribed;
  final bool? isFavorited;

  factory DetailBookResponse.fromJson(Map<String, dynamic> json){
    return DetailBookResponse(
      bookId: json["book_id"],
      title: json["title"],
      url: json["url"],
      imageUrl: json["image_url"],
      excerpt: json["excerpt"],
      views: json["views"],
      status: json["status"],
      rating: json["rating"],
      authorId: json["author_id"],
      authorName: json["author_name"],
      authorBiography: json["author_biography"],
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      totalChapters: json["total_chapters"],
      totalReviews: json["total_reviews"],
      isSubscribed: json["is_subscribed"],
      isFavorited: json["is_favorited"],
      chapters: json["chapters"] == null ? [] : List<Chapter>.from(json["chapters"]!.map((x) => Chapter.fromJson(x))),
      currentChapter: json["current_chapter"] == null ? null : CurrentChapter.fromJson(json["current_chapter"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "title": title,
    "url": url,
    "image_url": imageUrl,
    "excerpt": excerpt,
    "views": views,
    "status": status,
    "rating": rating,
    "author_id": authorId,
    "author_name": authorName,
    "author_biography": authorBiography,
    "category_id": categoryId,
    "category_name": categoryName,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "total_chapters": totalChapters,
    "totalReviews": totalReviews,
    "is_subscribed": isSubscribed,
    "is_favorited": isFavorited,
    "chapters": chapters.map((x) => x.toJson()).toList(),
    "current_chapter": currentChapter?.toJson(),
  };

  @override
  String toString(){
    return "$bookId, $title, $url, $imageUrl, $excerpt, $views, $status, $rating, $authorId, $authorName, $authorBiography, $categoryId, $categoryName, $createdAt, $updatedAt, $totalChapters, $chapters, $currentChapter, ";
  }
}

class Chapter {
  Chapter({
    required this.chapterId,
    required this.title,
    required this.url,
    required this.chapterOrder,
  });

  final int? chapterId;
  final String? title;
  final String? url;
  final int? chapterOrder;

  factory Chapter.fromJson(Map<String, dynamic> json){
    return Chapter(
      chapterId: json["chapter_id"],
      title: json["title"],
      url: json["url"],
      chapterOrder: json["chapter_order"],
    );
  }

  Map<String, dynamic> toJson() => {
    "chapter_id": chapterId,
    "title": title,
    "url": url,
    "chapter_order": chapterOrder,
  };

  @override
  String toString(){
    return "$chapterId, $title, $url, $chapterOrder, ";
  }
}

class CurrentChapter {
  CurrentChapter({
    required this.chapterId,
    required this.title,
    required this.chapterOrder,
    required this.nextChapterUrl,
    required this.prevChapterUrl,
    required this.content,
  });

  final int? chapterId;
  final String? title;
  final int? chapterOrder;
  final String? nextChapterUrl;
  final String? prevChapterUrl;
  final String? content;

  factory CurrentChapter.fromJson(Map<String, dynamic> json){
    return CurrentChapter(
      chapterId: json["chapter_id"],
      title: json["title"],
      chapterOrder: json["chapter_order"],
      nextChapterUrl: json["next_chapter_url"],
      prevChapterUrl: json["prev_chapter_url"],
      content: json["content"],
    );
  }

  Map<String, dynamic> toJson() => {
    "chapter_id": chapterId,
    "title": title,
    "chapter_order": chapterOrder,
    "next_chapter_url": nextChapterUrl,
    "prev_chapter_url": prevChapterUrl,
    "content": content,
  };

  @override
  String toString(){
    return "$chapterId, $title, $chapterOrder, $nextChapterUrl, $prevChapterUrl, $content, ";
  }
}
