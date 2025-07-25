import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../network/client/client.dart';
import '../network/network_info/network_info.dart';
import '../network/network_info/network_info_impl.dart';

@module
abstract class NetworkModule {
  @singleton
  InternetConnection get internetConnection => InternetConnection();

  @singleton
  NetworkInfo provideNetworkInfo(InternetConnection connection) =>
      NetworkInfoImpl(connection);

  @singleton
  Client provideClient() => Client();

  @singleton
  Dio provideDio(Client client) => client.dio;
} 