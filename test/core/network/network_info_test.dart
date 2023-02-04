import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_bloc/core/network/network_info.dart';
import 'package:movie_app_bloc/mocks/mock_all.mocks.dart';

void main() {
  NetworkInfoImpl? networkInfo;
  MockDataConnectionChecker? mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      // arrange
      final tHasConnectionFuture = await Future.value(true);
      when(mockDataConnectionChecker!.hasConnection)
          .thenAnswer((_) async => tHasConnectionFuture);
      // act
      final result = await networkInfo!.isConnected;
      // assert
      verify(mockDataConnectionChecker!.hasConnection);

      expect(result, tHasConnectionFuture);
    });
  });
}
