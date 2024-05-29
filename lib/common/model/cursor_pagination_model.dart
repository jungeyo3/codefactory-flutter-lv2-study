import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

// 클래스로 로딩의 상태를 확인
abstract class CursorPaginationBase {}

// 실패
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

// 로딩
class CursorPaginationLoading extends CursorPaginationBase {}

// 성공
@JsonSerializable(
  genericArgumentFactories: true, // genericArgument를 고려함
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination(meta: meta ?? this.meta, data: data ?? this.data);
  }

  CursorPagination({required this.meta, required this.data});

  /// 매우 중요!!!!
  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta copyWith({int? count, bool? hasMore}) {
    return CursorPaginationMeta(
        count: count ?? this.count, hasMore: hasMore ?? this.hasMore);
  }

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

// 다시 불러오기 / 새로고침 - 데이터가 있으므로 CursorPagination을 가져옴
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({required super.meta, required super.data});
}

// 리스트의 맨 아래로 내려서 추가 데이터를 요청하는 중일 때
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({required super.meta, required super.data});
}
