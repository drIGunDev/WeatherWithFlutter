
import 'log.dart';

final class LogTest {
  bool foo() {
    void foo1() {
      throw throw FormatException('Expected at least 1 section');
    }

    Log.t("trace", tag: "supervisor1234567");
    Log.d("debug", tag: "w");
    Log.w("warning");
    Log.e("error");
    Log.f("fatal");
    try {
      foo1();
    } on FormatException catch (e, s) {
      Log.e(e, stackTrace: s);
    }
    return true;
  }
}

void main() {
    final test = LogTest();
    test.foo();
}