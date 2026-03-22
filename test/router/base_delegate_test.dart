import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/router/base_delegate.dart";

void main() {
  group("indexFromUri", () {
    test("returns matching tab indices for known paths", () {
      expect(indexFromUri(Uri.parse("/app/transactions")), 0);
      expect(indexFromUri(Uri.parse("/app/accounts")), 1);
      expect(indexFromUri(Uri.parse("/app/plans")), 2);
      expect(indexFromUri(Uri.parse("/app/analytic")), 3);
    });

    test("falls back to transactions for nested unknown path", () {
      expect(indexFromUri(Uri.parse("/app/transactions/details/42")), 0);
      expect(indexFromUri(Uri.parse("/unknown")), 0);
    });
  });

  group("pathForIndex", () {
    test("returns matching paths for known indices", () {
      expect(pathForIndex(0), "/app/transactions");
      expect(pathForIndex(1), "/app/accounts");
      expect(pathForIndex(2), "/app/plans");
      expect(pathForIndex(3), "/app/analytic");
    });

    test("falls back to transactions for out of range indices", () {
      expect(pathForIndex(-1), "/app/transactions");
      expect(pathForIndex(99), "/app/transactions");
    });
  });
}
