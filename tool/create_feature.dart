



import 'dart:io';

import 'package:flutter/foundation.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    if (kDebugMode) {
      print(
        'Usage: fvm dart tool/create_feature.dart <feature_name> <page_names...>',
      );
    }
    return;
  }

  final featureName = args[0];
  final pages = args.sublist(1).isEmpty ? [featureName] : args.sublist(1);
  final featurePath = 'lib/features/$featureName';

  String toPascal(String s) =>
      s.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join();

  String toCamel(String s) =>
      toPascal(s)[0].toLowerCase() + toPascal(s).substring(1);

  final pascalFeature = toPascal(featureName);

  // 1. Create folders
  _createDirectories(featurePath);

  // 2. Generate domain & data layers
  _generateLogic(featurePath, featureName, pascalFeature, pages, toCamel);

  // 3. Generate presentation layer
  _generatePresentation(
    featurePath,
    featureName,
    pascalFeature,
    pages,
    toPascal,
  );

  // 4. Update routing
  _automateRouting(featureName, pages, toPascal);

  print(
    '🚀 Feature [$featureName] created successfully. Routing updated.',
  );
}

void _createDirectories(String path) {
  final folders = [
    '$path/data/data_sources',
    '$path/data/models',
    '$path/data/repositories',
    '$path/domain/entities',
    '$path/domain/repositories',
    '$path/presentation/bloc',
    '$path/presentation/pages',
    '$path/presentation/widgets',
  ];

  for (final folder in folders) {
    Directory(folder).createSync(recursive: true);
  }
}

void _generateLogic(
  String path,
  String name,
  String pascal,
  List<String> pages,
  Function camel,
) {
  _writeFile(
    '$path/domain/entities/${name}_entity.dart',
    '''
class ${pascal}Entity {
  const ${pascal}Entity({required this.id});
  final String id;
}
''',
  );

  _writeFile(
    '$path/domain/repositories/i_${name}_repository.dart',
    '''
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/failures.dart';
import '../entities/${name}_entity.dart';

abstract class I${pascal}Repository {
  ${pages.map((p) =>
      'Future<Either<Failure, ${pascal}Entity>> ${camel(p)}(Map<String, dynamic> params);').join('\n  ')}
}
''',
  );

  _writeFile(
    '$path/data/data_sources/${name}_remote_data_source.dart',
    '''
import 'package:car_care/core/network/api_service.dart';

class ${pascal}RemoteDataSource {
  const ${pascal}RemoteDataSource(this._apiService);
  final ApiService _apiService;

  ${pages.map((p) =>
      "Future<Map<String, dynamic>> ${camel(p)}(Map<String, dynamic> data) async => _apiService.post(endPoint: '$name/$p', data: data);").join('\n  ')}
}
''',
  );
}

void _generatePresentation(
  String path,
  String name,
  String pascal,
  List<String> pages,
  Function toPascal,
) {
  _writeFile(
    '$path/presentation/bloc/${name}_bloc.dart',
    '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '${name}_event.dart';
import '${name}_state.dart';

class ${pascal}Bloc extends Bloc<${pascal}Event, ${pascal}State> {
  ${pascal}Bloc() : super(${pascal}Initial()) {
    on<${pascal}Event>((event, emit) {});
  }
}
''',
  );

  _writeFile(
    '$path/presentation/bloc/${name}_event.dart',
    '''
abstract class ${pascal}Event {}
''',
  );

  _writeFile(
    '$path/presentation/bloc/${name}_state.dart',
    '''
abstract class ${pascal}State {}

class ${pascal}Initial extends ${pascal}State {}
''',
  );

  for (final page in pages) {
    _writeFile(
      '$path/presentation/pages/${page}_page.dart',
      '''
import 'package:flutter/material.dart';

class ${toPascal(page)}Page extends StatelessWidget {
  const ${toPascal(page)}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('${toPascal(page)} Page'),
      ),
    );
  }
}
''',
    );
  }
}

void _automateRouting(
  String feature,
  List<String> pages,
  Function toPascal,
) {
  final routesFile = File('lib/core/routing/routes.dart');
  final routerFile = File('lib/core/routing/app_router.dart');

  for (final page in pages) {
    if (routesFile.existsSync()) {
      var content = routesFile.readAsStringSync();
      if (!content.contains("static const String $page")) {
        content = content.replaceFirst(
          '}',
          "  static const String $page = '/$page';\n}",
        );
        routesFile.writeAsStringSync(content);
      }
    }

    if (routerFile.existsSync()) {
      var content = routerFile.readAsStringSync();

      final importLine =
          "import 'package:car_care/features/$feature/presentation/pages/${page}_page.dart';";

      final routeBlock = '''
      GoRoute(
        path: Routes.$page,
        name: '/$page',
        builder: (context, state) => const ${toPascal(page)}Page(),
      ),
''';

      if (!content.contains(importLine)) {
        content = '$importLine\n$content';
      }

      if (!content.contains('Routes.$page')) {
        content = content.replaceFirst('],', '$routeBlock      ],');
      }

      routerFile.writeAsStringSync(content);
    }
  }
}

void _writeFile(String path, String content) {
  File(path).writeAsStringSync(content.trim());
}
