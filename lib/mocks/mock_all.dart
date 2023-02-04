import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/popular_movies/data/datasources/popular_movies_remote_data_source.dart';
@GenerateNiceMocks([MockSpec<DataConnectionChecker>()])
@GenerateNiceMocks([MockSpec<SharedPreferences>()])
@GenerateNiceMocks([MockSpec<Dio>()])
@GenerateNiceMocks([MockSpec<DioAdapter>()])
@GenerateNiceMocks([MockSpec<PopularMoviesRemoteDataSource>()])
import 'mock_all.mocks.dart';
