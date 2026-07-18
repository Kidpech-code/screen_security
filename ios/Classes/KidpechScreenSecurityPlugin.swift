import Flutter
import UIKit

class SecureTextField: UITextField {
  override var canBecomeFirstResponder: Bool { return false }
}

public class KidpechScreenSecurityPlugin: NSObject, FlutterPlugin {
  private var secureTextField: SecureTextField?
  private var secureView: UIView?
  private var isSecurityEnabled = false

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "kidpech_screen_security", binaryMessenger: registrar.messenger())
    let instance = KidpechScreenSecurityPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  public override init() {
    super.init()
    setupObservers()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "enableScreenSecurity": enableScreenSecurity(result: result)
    case "disableScreenSecurity": disableScreenSecurity(result: result)
    default: result(FlutterMethodNotImplemented)
    }
  }

  private func enableScreenSecurity(result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      guard let window = self.activeWindow(),
        let flutterViewController = window.rootViewController as? FlutterViewController,
        let flutterView = flutterViewController.view
      else {
        result(FlutterError(code: "NO_WINDOW", message: "Cannot find active window", details: nil))
        return
      }
      self.isSecurityEnabled = true
      self.ensureSecurityViewAttached(window: window, flutterView: flutterView)
      result(nil)
    }
  }

  private func disableScreenSecurity(result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      guard self.isSecurityEnabled else { return result(nil) }
      self.isSecurityEnabled = false
      guard let window = self.activeWindow(),
        let flutterViewController = window.rootViewController as? FlutterViewController,
        let flutterView = flutterViewController.view
      else {
        self.cleanupSecureViews()
        return result(nil)
      }

      if flutterView.superview !== window {
        flutterView.removeFromSuperview()
        window.addSubview(flutterView)
        window.sendSubviewToBack(flutterView)
      }
      flutterView.frame = window.bounds
      flutterView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.cleanupSecureViews()
      result(nil)
    }
  }

  private func ensureSecurityViewAttached(window: UIWindow, flutterView: UIView) {
    guard isSecurityEnabled else { return }
    if secureTextField == nil || secureTextField?.superview == nil {
      let field = SecureTextField(frame: window.bounds)
      field.isSecureTextEntry = true
      field.isUserInteractionEnabled = true
      field.backgroundColor = .clear
      field.textColor = .clear
      field.text = " "
      field.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      window.addSubview(field)
      field.setNeedsLayout()
      field.layoutIfNeeded()
      self.secureTextField = field
      self.secureView = resolveSecureContainer(in: field)
    }

    guard let targetView = secureView else { return }
    targetView.isUserInteractionEnabled = true
    if flutterView.superview !== targetView {
      flutterView.removeFromSuperview()
      targetView.addSubview(flutterView)
    }
    flutterView.frame = targetView.bounds
    flutterView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  private func resolveSecureContainer(in field: UIView) -> UIView {
    for subview in field.subviews {
      let className = String(describing: type(of: subview))
      if className.contains("TextLayoutCanvasView") || className.contains("TextFieldCanvasView")
        || className.contains("Secure")
      {
        return subview
      }
    }
    return field.subviews.first ?? field
  }

  private func cleanupSecureViews() {
    secureTextField?.removeFromSuperview()
    secureTextField = nil
    secureView = nil
  }

  private func activeWindow() -> UIWindow? {
    // Flutter's AppDelegate always holds a window reference
    if let delegate = UIApplication.shared.delegate, let window = delegate.window {
      return window
    }
    // Modern fallback via UIWindowScene (avoids deprecated UIApplication.shared.windows)
    if #available(iOS 15.0, *) {
      return UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first { $0.activationState == .foregroundActive }?
        .keyWindow
    }
    return UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
  }

  private func setupObservers() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(handleAppLifecycle),
      name: UIApplication.didBecomeActiveNotification, object: nil)
  }

  @objc private func handleAppLifecycle() {
    guard isSecurityEnabled else { return }
    DispatchQueue.main.async {
      if let window = self.activeWindow(),
        let flutterViewController = window.rootViewController as? FlutterViewController,
        let flutterView = flutterViewController.view
      {
        self.ensureSecurityViewAttached(window: window, flutterView: flutterView)
      }
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
    cleanupSecureViews()
  }
}
