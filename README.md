# ios_login_sdk

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

### [CocoaPods](https://cocoapods.org)

To install it, simply add the following line to your Podfile:

```ruby
pod '{PodName}'
```

### [Swift Package Manager](https://swift.org/package-manager/)

- File > Swift Packages > Add Package Dependency
- Add {Repository URL}

## Configure Your Project

使用包含您應用程式資料的 XML 程式碼片段來設定 Info.plist 檔案。

1. 在 Info.plist 上點擊右鍵，然後選擇以原始碼形式開啟。
2. 複製以下 XML 程式碼片段並貼至檔案主體`<dict>...</dict>`。

```ruby
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>jkos</string>
</array>
<key>JKOClientID</key>
<string>JKOS-ID</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>JKOSURLSchemes</string>
    </array>
  </dict>
</array>
```
3. 在 `JKOClientID` 索引鍵的 <string> 中，將 JKOS-ID 替換為您申請的應用程式編號。
4. 在 `CFBundleURLSchemes` 索引鍵的 <array><string> 中，將 `JKOSURLSchemes` 替換為 `jkos{JKOS-ID}`。

## Connect the App Delegate

以下列程式碼取代 AppDelegate 方法中的程式碼。此程式碼會在應用程式啟動時初始化 SDK

```swift
//
//  AppDelegate.swift
//

import UIKit
import JKOAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        JKOAuthService.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        JKOAuthService.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
}
```

## 

iOS 13 已將開啟網址功能移至 SceneDelegate。如果您使用的是 iOS 13，請將下列方法新增至 SceneDelegate，這樣登入或分享等操作才能正常運作：

```swift
//
//  SceneDelegate.swift
//

import UIKit
import JKOAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
// ...

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else { return }
        JKOAuthService.shared.application(UIApplication.shared, open: urlContext.url, sourceApplication: urlContext.options.sourceApplication, annotation: urlContext.options.annotation)
    }

}
```

## Start JKOAuthManager
```swift
import UIKit
import JKOAuth

class ViewController: UIViewController {

    let jkoAuth = JKOAuthManager()

    let jkoAuthButton: JKOAuthButton = {
        let btn = JKOAuthButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupViews()
        jkoAuthButton.addTarget(self, action: #selector(tapJKOAuthButton(_:)), for: .touchUpInside)
    }

    private func setupViews() {
        self.view.addSubview(jkoAuthButton)
        jkoAuthButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        jkoAuthButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        jkoAuthButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc private func tapJKOAuthButton(_ sender: JKOAuthButton) {
        jkoAuth.delegate = self
        jkoAuth.start(scopes: [{Scopes}], userID: {Your User's ID})
    }
}
```

## Delegate with JKOAuthDelegate
```swift
public protocol JKOAuthDelegate: AnyObject {
    /// Finish authorization successfully with auth code.
    /// - Parameter authCode: -
    /// - Parameter grantedScopes: Scopes that user has granted.
    /// - Parameter jkosUserID: **Optional** value. User ID of JKO service. Look up the document for more details.
    /// - Parameter userID: **Optional** value. User ID of your service. Look up the document for more details.
    func authDidSuccess(authCode: String, grantedScopes: [String], jkosUserID: String?, userID: String?)
    
    /// Finish authorization with error.
    /// - Parameter error: -
    func authDidFailed(error: JKOAuthError)
    
    /// Can NOT find JKOS App in user's device.
    func jkosAppNotFound()
}
```
  
## 參數
### scopes
| Name | Description |
| --- | --- |
| binding | 用戶同意是否允許第三方平台用戶與街口用戶的建立關聯，獲得授權綁定關係後，後續部分業務行為會進行綁定關係的驗證。若欲申請此項 SCOPE 需於 input params 中輸入參數您的用戶userID 。 |
| pointtransmit | 用戶同意從第三方帳戶補儲值至個別用戶的街口帳戶，於補儲值的過程中，會驗證用戶綁定狀態、資金方帳戶、收款方狀態等業務邏輯。 |
## 錯誤處理
說明關於 iOS JKOAuth SDK 中出現的相關錯誤，如：
```swift
func authDidFailed(error: JKOAuthError) {
}
```
`JKOAuthError` 是符合 Swift `Error` Protocol 的列舉（enumeration）。其中每一個 case 皆對應到各自的 Reason；Reason 也是列舉，包含更詳細的錯誤原因。
```swift
case cipherError(reason: CipherErrorReason)
case clientParameterError(reason: OAuthParameterErrorReason)
case sdkInfoError(reason: SDKInfoErrorReason)
case authorizationError(reason: AuthorizationErrorReason)
case jkoAPIError(reason: JKOAPIErrorReason)
```


| Error case       | Reason           | 說明         |
| ---------------- | ---------------- |---------------- |
| cipherError     | CipherErrorReason      | SDK 加解密過程發生的錯誤。|
| clientParameterError     | OAuthParameterErrorReason     | 使用 SDK 時有參數發生錯誤，如 ClientID 對應錯誤、UserID 已存在。|
| sdkInfoError     | SDKInfoErrorReason     | SDK 資訊檢查時發生的錯誤，如：查無 ClientID。|
| authorizationError     | AuthorizationErrorReason     | 使用者拒絕授權時發生的錯誤。|
| jkoAPIError     | JKOAPIErrorReason     |街口內部 API 發生錯誤。|


以 `CipherErrorReason` 為例：
```swift
public enum CipherErrorReason {
    case encryptionError
    case decryptionError
}
```

## Author

ken.lee@jkos.com
  
jack.kuo@jkos.com
  
agnes.lo@jkos.com
  
chiahan.kuo@jkos.com

## License

ios_login_sdk is available under the MIT license. See the LICENSE file for more info.
