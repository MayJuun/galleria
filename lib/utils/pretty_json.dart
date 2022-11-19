import 'dart:convert';

String prettyJson(Map map) => JsonEncoder.withIndent('    ').convert(map);
