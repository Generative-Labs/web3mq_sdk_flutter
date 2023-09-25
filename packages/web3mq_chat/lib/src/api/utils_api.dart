import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:web3mq_core/models.dart';

class UtilsApi {
  final dio = Dio();

  /// Get the domain with lowest latency.
  Future<String> findTheLowestLatencyEndpoint() async {
    final domains = TestnetEndpoint.all;
    final results = await Future.wait(domains.map((e) => mesure(e)));
    final lowest = results.min;
    return domains[results.indexOf(lowest)];
  }

  Future<int> mesure(String domain) async {
    final stopWatch = Stopwatch();
    stopWatch.start();
    await dio.get('$domain/api/ping/');
    stopWatch.stop();
    return stopWatch.elapsed.inMicroseconds;
  }
}
