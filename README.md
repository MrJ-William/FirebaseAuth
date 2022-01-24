# FirebaseAuth

FirebaseAuthの利用方法
2019年にリリースさせたアプリ『ミスユニ！』のログイン画面を利用して設定しています。

---

## Features

- パスワード認証
- メールリンク認証
- Google ログイン

[Firebase Pages](https://firebase.google.com/docs/auth/ios/password-auth?authuser=0)


<p align="left"> 
  <img alt="Top Langs" height="700px" src="https://user-images.githubusercontent.com/59042491/150689099-3e2bd44e-63ab-4b63-b3f6-005f274df5ba.png" />
  <img alt="github stats" height="700px" src="https://user-images.githubusercontent.com/59042491/150689111-2811f3b4-9ae1-4831-90dd-2cf492fcbfa2.png" />
</p>

## Installation
今回は、CocoaPodsとSwiftPackageManagerを併用します。

**CocoaPods**

```
pod install
```
**SwiftPackageManager**

以下のSDKリポジトリを追加します。
```
https://github.com/firebase/firebase-ios-sdk
```
ライブラリを選択します。
- Firebase Authentication 

## Firebase Init

1. Firebaseで新しいプロジェクトを作成
2. GoogleService-Info.plist をダウンロードして指定の場所に挿入
3. Xcode プロジェクトにカスタムURLスキームを追加

[Firebaseの設定](https://firebase.google.com/docs/auth/ios/google-signin?authuser=0#2_implement_google_sign-in)



