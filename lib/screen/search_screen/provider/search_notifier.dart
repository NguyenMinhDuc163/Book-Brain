import 'package:book_brain/screen/home/service/home_service.dart';
import 'package:book_brain/screen/preview/service/preview_service.dart';
import 'package:book_brain/screen/search_screen/service/search_service.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/search_book_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';

class SearchNotifier extends BaseNotifier {
  SearchService searchService = SearchService();
  late List<SearchBookResponse> searchBookResponse = [];
  bool hasMore = true;
  int currentLimit = 10;
  String currentKeyword = '';
  String currentSortOption = 'A-Z';

  Future<void> getData(String keyWord) async {
    currentKeyword = keyWord;
    currentLimit = 10;
    hasMore = true;
    searchBookResponse = [];
    await getSearchData(keyWord);
  }

  Future<bool> getSearchData(String keyWord) async {
    return await execute(() async {
      final newBooks =
          (await searchService.searchBook(
            keyword: keyWord,
            limit: currentLimit,
          ))!;
      if (newBooks.isEmpty) {
        hasMore = false;
      }
      searchBookResponse = newBooks;
      _sortBooks();
      notifyListeners();
      return true;
    });
  }

  Future<bool> loadMore() async {
    print("hasMore: $hasMore, isLoading: $isLoading");
    if (!hasMore || isLoading) {
      print("Không thể load more vì hasMore: $hasMore, isLoading: $isLoading");
      return false;
    }

    return await execute(() async {
      currentLimit += 10;
      print("Đang load more với limit: $currentLimit");
      final newBooks =
          (await searchService.searchBook(
            keyword: currentKeyword,
            limit: currentLimit,
          ))!;

      print(
        "Số sách mới: ${newBooks.length}, số sách cũ: ${searchBookResponse.length}",
      );
      if (newBooks.length <= searchBookResponse.length) {
        hasMore = false;
        print("Không còn sách để load more");
      } else {
        searchBookResponse = newBooks;
        _sortBooks();
        print("Đã load thêm sách thành công");
      }

      notifyListeners();
      return true;
    });
  }

  void sortBooks(String sortOption) {
    currentSortOption = sortOption;
    _sortBooks();
    notifyListeners();
  }

  void _sortBooks() {
    switch (currentSortOption) {
      case 'A-Z':
        searchBookResponse.sort(
          (a, b) => (a.title ?? '').toLowerCase().compareTo(
            (b.title ?? '').toLowerCase(),
          ),
        );
        break;
      case 'Z-A':
        searchBookResponse.sort(
          (a, b) => (b.title ?? '').toLowerCase().compareTo(
            (a.title ?? '').toLowerCase(),
          ),
        );
        break;
      case 'Đánh giá cao':
        searchBookResponse.sort((a, b) {
          double ratingA =
              double.tryParse((a.rating ?? '0/10').split('/')[0]) ?? 0;
          double ratingB =
              double.tryParse((b.rating ?? '0/10').split('/')[0]) ?? 0;
          return ratingB.compareTo(ratingA);
        });
        break;
      case 'Lượt xem nhiều':
        searchBookResponse.sort(
          (a, b) => (b.views ?? 0).compareTo(a.views ?? 0),
        );
        break;
    }
  }
}
