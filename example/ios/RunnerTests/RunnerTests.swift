import Flutter
import UIKit
import XCTest

@testable import screen_security

/// Unit tests for KidpechScreenSecurityPlugin that can run without a full UIKit
/// environment. Only paths that do not require an active UIWindow are covered
/// here; full enable/disable behavior is validated by the integration tests.
class RunnerTests: XCTestCase {

  // MARK: - Unknown method

  func testHandle_unknownMethod_returnsNotImplemented() {
    let plugin = KidpechScreenSecurityPlugin()

    let call = FlutterMethodCall(methodName: "unknownMethod", arguments: nil)
    var receivedResult: Any?

    let expectation = self.expectation(description: "result called")
    plugin.handle(call) { result in
      receivedResult = result
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)

    XCTAssertTrue(
      (receivedResult as? NSObject) === FlutterMethodNotImplemented,
      "Expected FlutterMethodNotImplemented for an unknown method, got \(String(describing: receivedResult))"
    )
  }

  // MARK: - enable without window

  func testHandle_enableScreenSecurity_withoutWindow_returnsError() {
    let plugin = KidpechScreenSecurityPlugin()

    let call = FlutterMethodCall(methodName: "enableScreenSecurity", arguments: nil)
    var receivedResult: Any?

    let expectation = self.expectation(description: "result called")
    plugin.handle(call) { result in
      receivedResult = result
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)

    // Without an active UIWindow the plugin should return a FlutterError.
    XCTAssertTrue(
      receivedResult is FlutterError,
      "Expected FlutterError when no window is available, got \(String(describing: receivedResult))"
    )

    if let error = receivedResult as? FlutterError {
      XCTAssertEqual(error.code, "NO_WINDOW")
    }
  }

  // MARK: - disable without window (idempotent guard)

  func testHandle_disableScreenSecurity_whenNotEnabled_completesSuccessfully() {
    let plugin = KidpechScreenSecurityPlugin()

    let call = FlutterMethodCall(methodName: "disableScreenSecurity", arguments: nil)
    var receivedResult: Any?
    var resultCalled = false

    let expectation = self.expectation(description: "result called")
    plugin.handle(call) { result in
      receivedResult = result
      resultCalled = true
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)

    XCTAssertTrue(resultCalled)
    // When security was never enabled, disableScreenSecurity should succeed
    // (returns nil) rather than throw an error.
    XCTAssertNil(
      receivedResult,
      "Expected nil result when disabling an already-disabled plugin, got \(String(describing: receivedResult))"
    )
  }
}
