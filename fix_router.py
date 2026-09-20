p = 'lib/main.dart'
with open(p, 'r') as f:
    d = f.read()

if "import 'package:flutter/material.dart';" in d and "hide Router" not in d:
    d = d.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart' hide Router;")

d = d.replace("import 'package:shelf_router/shelf_router.dart' as shelf;", "import 'package:shelf_router/shelf_router.dart';")
d = d.replace('shelf.Router()', 'Router()')

with open(p, 'w') as f:
    f.write(d)
print("Router conflict successfully fixed!")
