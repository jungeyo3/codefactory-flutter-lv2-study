import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 왜 extends? dart에는 generic에서 implement를 사용할 수 없다
class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  // IBasePaginationRepository 에는 무조건 paginate 함수가 존재함을 인지
  final U repository;

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false, // 추가 데이터 (true = 추가 데이터 / false = 새로 고침)
    bool forceRefetch = false, // 강제 로딩
  }) async {
    try {
      /// 5가지 가능성 = State의 상태

      /// 1) CursorPagniation = 정상적으로 데이터 o
      /// 2) CursorPagniation = 데이터가 로딩중 (캐시 x)
      /// 3) CursorPagniationError = 에러 o
      /// 4) CursorPagniationRefetching = 첫번째부터 다시 데이터를 가져올 때
      /// 5) CursorPagninationFetchMore = 추가 데이터를 pagniate 해오라는 요청을 받았을 때

      /// 바로 반환하는 상황
      /// 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 것)
      /// 2) 로딩중 - fetchMore : true
      /// (추가로 데이터를 가지고 오는 상황 - 요청이 계속 들어올 수 있음. 20개 요청한 후 같은 20개를 또 요청할 수도 있다!)
      ///   fetchMore가 아닐 때 - 새로고침의 의도 -> pagniate 실행

      // 1번 상황
      // 데이터가 있고 강제 새로고침을 요청하지 않았을 경우
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination; // 이게 아닌 상황은 올 수 없음

        if (!pState.meta.hasMore) {
          // 더 데이터가 없다.
          return;
        }
      }

      // 2번 상황
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PagniationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore - 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        // fetchMore이 가능 -> 데이터가 보여지고 있음 -> CursorPagination 가능
        final pState = state as CursorPagination<T>;

        // 모델 안넣었는데 왜 에러 안나지!? => dynamic으로 가정한 것
        // IModelWithId를 상속해 id가 필수적이도록 함!
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 api 요청
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          // 나머지 상황 - 데이터 유지 필요 x
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        // 기존 데이터에 새로운 데이터 추가
        state = resp.copyWith(
          data: [
            ...pState.data, // 기존 데이터
            ...resp.data, // 신규 데이터
          ],
        );
      } else {
        // 맨 처음 20개의 데이터
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state =
          CursorPaginationError(message: '데이터를 가져오지 못했습니다. ${e.toString()}');
    }
  }
}
