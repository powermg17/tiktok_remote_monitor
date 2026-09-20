p = 'lib/main.dart'
with open(p, 'r') as f:
    d = f.read()

if 'package:flutter_background_service' not in d:
    imports = (
        "import 'package:firebase_core/firebase_core.dart';\n"
        "import 'package:cloud_firestore/cloud_firestore.dart';\n"
        "import 'package:flutter_background_service/flutter_background_service.dart';\n"
        "import 'package:shelf_router/shelf_router.dart' as shelf;\n"
    )
    d = imports + d

with open(p, 'w') as f:
    f.write(d)
print("Successfully updated main.dart")
