import 'dart:convert';
import 'dart:io';

import 'package:fhir/r4.dart';

Future<void> main() async {
  final directory = Directory('./lib/fhir_resources');
  final fileList = await directory.list().map((event) => event.path).toList();
  // const url =
  //     'https://healthcare.googleapis.com/v1/projects/demos-322021/locations/us-central1/datasets/stage/fhirStores/stage/fhir';
  final bundle = Bundle(
    type: BundleType.transaction,
    entry: <BundleEntry>[],
  );
  for (var file in fileList) {
    final fileString = await File(file).readAsString();
    final resource = Resource.fromJson(jsonDecode(fileString));
    bundle.entry!.add(
      BundleEntry(
        resource: resource,
        // fullUrl: resource.id == null
        //     ? null
        //     : FhirUri('$url/${resource.resourceTypeString()}/${resource.id}'),
        request: BundleRequest(
            method: BundleRequestMethod.post,
            url:
                // resource.id == null
                //     ?
                FhirUri('${resource.resourceTypeString()}')
            // : FhirUri('${resource.resourceTypeString()}/${resource.id}'),
            ),
      ),
    );
  }

  const jsonEncoder = JsonEncoder.withIndent('    ');
  await File('lib/bundle.json')
      .writeAsString(jsonEncoder.convert(bundle.toJson()));
}
