import '../../../../../core/error/exception.dart';
import '../../../domain/entities/home/home.dart';

abstract class HomeRemoteDataSource {
  Future<List<Home>> getAllHomes();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<Home>> getAllHomes() async {
    try {
      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 1));
      return <Home>[
        Home(
          id: '1',
          displayName: 'Example Home 1',
          description: 'This is an example Home',
          address: '123 Main St',
          localizedCategory: 'Category 1',
          phoneNumber: '+1234567890',
          website: 'https://example1.com',
          latitude: 40.7128,
          longitude: -74.0060,
        ),
        Home(
          id: '2',
          displayName: 'Example Home 2',
          description: 'Another example Home',
          address: '456 Second Ave',
          localizedCategory: 'Category 2',
          phoneNumber: '+0987654321',
          website: 'https://example2.com',
          latitude: 34.0522,
          longitude: -118.2437,
        ),
      ];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
} 