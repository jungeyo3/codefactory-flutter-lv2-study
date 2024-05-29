import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

  return repository;
});

/// 이 패턴을 유지

@RestApi()
abstract class RestaurantRepository implements IBasePaginationRepository<RestaurantModel>{
  factory RestaurantRepository(Dio dio, {String baseUrl})
  = _RestaurantRepository;

  // http://$ip/restaurant/
  // 저 위에서 반환하는 것은 페이지 정보까지 있는 데이터
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
   @Queries() PaginationParams? paginationParams = const PaginationParams(),
});

  // http://$ip/restaurant/{id}
  @GET('/{id}')
  @Headers({
    'accessToken': 'true', // accessToken을 dio안에서 붙인뒤에 요청을 보냄
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
});

}