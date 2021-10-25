# JKOAuthenticate

## Requirements
- iOS 11.0+

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

        JKOAuthService.shared.application(application, didFinishLaunchingWithOptions: launchOptions, debugMode: { Depend on your config })

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        JKOAuthService.shared.application(app, open: url, options: options)
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
        JKOAuthService.shared.application(UIApplication.shared, open: urlContext.url, options: urlContext.options)
    }

}
```

## Start JKOAuthManager
```swift
import UIKit
import JKOAuth

class ViewController: UIViewController {

    let jkoAuth = JKOAuthManager()

    let jkoAuthBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Start JKOAuth", for: .normal)
        btn.addTarget(self, action: #selector(tapJKOAuthBtnAction(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupViews()
        jkoAuthBtn.addTarget(self, action: #selector(tapJKOAuthButton(_:)), for: .touchUpInside)
    }

    private func setupViews() {
        self.view.addSubview(jkoAuthBtn)
        jkoAuthBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        jkoAuthBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        jkoAuthBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc private func tapJKOAuthBtnAction(_ sender: UIButton) {
        jkoAuth.delegate = self
        jkoAuth.start(scopes: [{Scopes}], userID: {Your User's ID, Optional, See document for more details})
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
    
    /// Finish authorization with error. See documents for more details.
    /// - Parameter error: -
    func authDidFailed(error: JKOAuthError)
    
    /// Can NOT find JKOS App in user's device.
    func jkosAppNotFound()
}
```
  
## 參數

### Input parameters
| Name | Description | 
| --- | --- |
| scopes | 開發者欲申請之授權項目。授權項目詳情見下方`SCOPE` 列表。| 
| userID | 若開發者欲申請之授權項目中，需將街口 User ID 與開發者之系統 User ID 進行連結，需填入欲連結之開發者之系統UserID 。 |

### scopes
| Name | Description |
| --- | --- |
| binding | 用戶同意是否允許第三方平台用戶與街口用戶的建立關聯，獲得授權綁定關係後，後續部分業務行為會進行綁定關係的驗證。若欲申請此項 SCOPE 需於 input params 中輸入參數您的用戶userID 。 |
| pointTransmit | 用戶同意從第三方帳戶補儲值至個別用戶的街口帳戶，於補儲值的過程中，會驗證用戶綁定狀態、資金方帳戶、收款方狀態等業務邏輯。 |


## 錯誤處理
說明關於 iOS JKOAuth SDK 中出現的相關錯誤，如：
```swift
func authDidFailed(error: JKOAuthError) {
    // Error handling
}
```
`JKOAuthError` 是符合 Swift `Error` Protocol 的列舉（enumeration）。除了使用者未完成授權`userCancelled`之外，其他錯誤會由`failed(code, message)`取得。`message`會具有相關錯誤`code`的描述，說明錯誤發生的原因。
```swift
public enum JKOAuthError : Error {
    case userCancelled
    case failed(code: String, message: String)
}
```

### 部分錯誤代碼揭露
| code | message  | 
| --- | --- |
| 206 | 無效的 `clientId`。| 
| 207 | 無效的 `scopesApply`。| 
| 208 | 該開發者並無申請之 `scopesApply` 使用權限。|
| 209 | 無效的 `isv_user_id`|

## 使用者未安裝街口支付
### 引導使用者開啟 AppStore 街口支付主頁
若觸發`jkosAppNotFound()`，表示使用者的裝置中沒有安裝街口支付App。  
開發者可以自行運用SDK提供的API呼叫`JKOAuthService.goToJKOSAppStore()`引導使用者安裝街口支付App。

### 後續處理
轉導至AppStore街口支付主頁後，SDK並沒有提供Deferred DeepLink或其他方式完成後續授權流程。  
因此，使用者安裝街口支付App之後，需要回到開發者App再次觸發`start(scopes: [String], userID: String?)`才能再次啟動授權流程。


## Author

ken.lee@jkos.com
  
jack.kuo@jkos.com
  
agnes.lo@jkos.com
  
chiahan.kuo@jkos.com

## License

JKOAuthenticate is available under the MIT license. See the LICENSE file for more info.
