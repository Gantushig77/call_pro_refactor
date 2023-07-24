class RequestParam {
  int? page;
  int? limit;
  String? sortBy;

  RequestParam({this.page, this.limit, this.sortBy});
  Map<String, dynamic> toJson() => _$RequestParamToJson(this);
}

class RequestResult<T> {
  List<T>? results = [];
  int? totalResults = 0;
  int? totalPages = 0;
  int? page = 1;

  RequestResult({this.results, this.totalResults, this.totalPages, this.page});

  factory RequestResult.fromJson(dynamic json, Function fromJson) =>
      _$RequestResultFromJson(json, fromJson);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

RequestResult<T> _$RequestResultFromJson<T>(Map<String, dynamic> res, Function fromJson) {
  var data = res.containsKey('results') ? res['results'] : [];

  return RequestResult<T>(
    results:
        (data as List).map<T>((json) => fromJson(json as Map<String, dynamic>)).toList(),
    totalPages: res['totalPages'] as int? ?? 1,
    totalResults: res['totalResults'] as int? ?? 0,
    page: res['page'] as int? ?? 1,
  );
}

Map<String, dynamic> _$ResultToJson(RequestResult instance) => <String, dynamic>{
      'results': instance.results,
      'totalResults': instance.totalResults,
      'totalPages': instance.totalPages,
      'page': instance.page
    };

Map<String, dynamic> _$RequestParamToJson(RequestParam? instance) {
  Map<String, dynamic> params = {};

  if (instance?.page != null) params['page'] = instance?.page;
  if (instance?.limit != null) params['limit'] = instance?.limit;
  if (instance?.sortBy != null) params['sortBy'] = instance?.sortBy;

  return params;
}
