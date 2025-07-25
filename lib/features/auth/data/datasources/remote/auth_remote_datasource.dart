import '../../../../../core/error/exception.dart';
import '../../../domain/entities/auth/auth.dart';

abstract class AuthRemoteDataSource {
  Future<List<Auth>> getAllAuths();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<List<Auth>> getAllAuths() async {
    try {
      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 1));
      return <Auth>[
        Auth(
          id: '1',
          displayName: 'Example Auth 1',
          description: 'This is an example Auth',
          address: '123 Main St',
          localizedCategory: 'Category 1',
          phoneNumber: '+1234567890',
          website: 'https://example1.com',
          latitude: 40.7128,
          longitude: -74.0060,
        ),
        Auth(
          id: '2',
          displayName: 'Example Auth 2',
          description: 'Another example Auth',
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