import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../high_q_notifications.dart';

@pragma('vm:entry-point')
Future<String?> downloadHighQImage({String? url, String? fileName}) async {
  if (url != null) {
    final DioEither response = await highQSl<HighQApiClient>().get(
      endPoint: url,
      options: Options(responseType: ResponseType.bytes),
    );

    final directory = await getTemporaryDirectory();
    final filePath = path.join(directory.path, fileName);
    final file = File(filePath);

    response.fold(
      (l) {
        return Future.error(l.message).then((value) {
          throw HighQRequestSourceFailure(
            message: 'Error in Download sound: An unexpected error occurred.',
          );
        });
      },
      (r) async {
        await file.writeAsBytes(r.data as List<int>);

      },
    );

    return filePath;
  }
  return null;
}
