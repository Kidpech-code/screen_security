import Flutter
import UIKit
import XCTest

@testable import screen_security

/// Unit tests for method routing, window-resolution errors, and an enable/disable
/// cycle against the test host's live UIWindow. Physical capture behavior remains
/// covered by the release device checks.
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
    let plugin = KidpechScreenSecurityPlugin(windowProvider: { nil })

    var receivedResult: Any?
    let expectation = expectation(description: "enable result called")
    plugin.handle(FlutterMethodCall(methodName: "enableScreenSecurity", arguments: nil)) {
      result in
      receivedResult = result
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)

    guard let error = receivedResult as? FlutterError else {
      return XCTFail(
        "Expected FlutterError when no window is available, got \(String(describing: receivedResult))"
      )
    }
    XCTAssertEqual(error.code, "NO_WINDOW")
  }

  // MARK: - enable/disable against the live host window

  /// The test host app has a real UIWindow whose root view controller is a
  /// FlutterViewController, so `enable` must resolve the window through the
  /// scene-based lookup (the app delegate's `window` is nil under test) and
  /// complete the real secure-view attachment. `disable` restores the view
  /// hierarchy so later tests see the original state.
  func testHandle_enableThenDisable_withHostWindow_succeeds() {
    let plugin = KidpechScreenSecurityPlugin()

    var enableResult: Any? = "unset"
    let enableExpectation = expectation(description: "enable result called")
    plugin.handle(FlutterMethodCall(methodName: "enableScreenSecurity", arguments: nil)) {
      result in
      enableResult = result
      enableExpectation.fulfill()
    }
    waitForExpectations(timeout: 10)
    XCTAssertNil(
      enableResult,
      "Expected enable to succeed in a windowed host, got \(String(describing: enableResult))"
    )

    var disableResult: Any? = "unset"
    let disableExpectation = expectation(description: "disable result called")
    plugin.handle(FlutterMethodCall(methodName: "disableScreenSecurity", arguments: nil)) {
      result in
      disableResult = result
      disableExpectation.fulfill()
    }
    waitForExpectations(timeout: 10)
    XCTAssertNil(
      disableResult,
      "Expected disable to restore the view hierarchy, got \(String(describing: disableResult))"
    )
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
