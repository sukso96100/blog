---
layout: post
date: 2017-07-09
title: "Android LocalBroadcastManager"
tags: android update kotlin develop tip
---

Android 에서는 `BoradcastReceiver` 를 사용해 앱 컴포넌트에서 원하는 범주의 이벤트를 수신할 수 있습니다.
예를 들면 배터리 상태나 네트워크 상태 등의 시스템 이벤트 부터, 개발자가 만든 커스텀 이벤트까지 다양하게 수신할 수 있습니다.

커스텀으로 이벤트(액션) 을 만들어 방송(Broadcast) 하는 것에는 여러 이유가 있습니다. 기기에 설치된 다른 앱이 본인이 개발한 앱으로부터
이벤트를 수신할 수 있도록 하려고 사용할 수도 있고, 같은 앱의 다른 컴포넌트간에 `startActivity()`, `startService()` 등 만으로
데이터를 주고받기 어려워서 사용할 수도 있습니다.

만약 같은 앱의 다른 컴포넌트간에 데이터를 주고받기 위해서 방송(Broadcast) 을 한다면, Android [API 22](https://developer.android.com/topic/libraries/support-library/revisions.html) 부터 추가된 [`LocalBroadcastManager`](https://developer.android.com/reference/android/support/v4/content/LocalBroadcastManager.html) 를 사용하는것이 더 효율적입니다. 기존의 방식(그냥 `sendBroadcast()` 호출)은 모든 앱에 방송을 하지만, `LocalBroadcastManager` 를 이용해서 방송할 경우, 같은 앱 내에 있는 앱 컴포넌트에만 방송이 되기 때문입니다. ~~글쓰면서 이제야 생각해보는건데 이거 뒷북이네...  API 22 에서 추가된 거면... 확실히 뒷북이군... 왜 지금까지 모른거지...~~

`LocalBroadcastManager` 를 통해 방송하는 방법은 기존의 방법과 크게 다르지 않습니다. 그저 `LocalBroadcastManager` 객체를 하나 만들어서 해당 객체의 `sendBroadcast()` 를 호출할 뿐입니다.

예를 들어 `Activity` 에서 방송 하려는 경우 아래와 같은 코드를 작성할 수 있습니다.

```kotlin
...
val mLocalBM = LocalBroadcastManager.getInstance(this)
var intent = Intent("com.example.MY_LOCAL_BROADCAST")
mLocalBM.sendBroadcast(intent)
...
```

방송을 수신을 위해 리시버를 등록하거나 해제하는 경우도 크게 차이는 없습니다.

```kotlin
...
// A BroadcastReceiver
val receiver = object : BroadcastReceiver(){
        override fun onReceive(context: Context?, intent: Intent?) {
          // Do something with received broadcast
        }
    }
...
// Registering BroadcastReceiver using LocalBroadcastManager
val filter = IntentFilter("com.example.MY_LOCAL_BROADCAST")
val mLocalBM = LocalBroadcastManager.getInstance(this)
mLocalBM.registerReceiver(filter, receiver)
...
// Unregistering BroadcastReceiver using LocalBroadcastManager
mLocalBM.unregisterReceiver(receiver)
...
```

이렇게 앱 컴포넌트간에 `BroadcastReceiver` 를 통해 데이터를 주고 받아야 할때, 외부 앱에서 수신할 필요가 없거나 수신해서는 안되는 방송을 해야하는 경우, `LocalBroadcastManager` 를 이용하면 됨을 알 수 있습니다. 방법도 기존 방법과 크게 차이가 없습니다. 끝. 그냥 오세 안드로이드 삽질 다시 하다가 알게 되서 기록할 겸 블로그 글로 써 봤습니다.

참고로, `LocalBroadcastManager` 는 API 22 에서 추가 되었지만, [v4 Support Library](https://developer.android.com/topic/libraries/support-library/features.html#v4) 에 포함된 것이여서 크게 안드로이드 버전에 신경쓰지 않고 사용할 수 있습니다.

## 참고자료
 - [Broadcasts - Android Developers](https://developer.android.com/guide/components/broadcasts.html)
 - [LocalBroadcastManager - Android Developers ](https://developer.android.com/reference/android/support/v4/content/LocalBroadcastManager.html)
