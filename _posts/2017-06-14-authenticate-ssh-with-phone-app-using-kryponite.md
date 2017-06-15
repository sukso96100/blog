---
layout: post
date: 2017-06-15
image: https://sukso96100.github.io/blogimgs/1-6ukcssmC_nJcvZ8MY7yCzQ.png
title: "Kryptonite : 모바일 앱으로 ssh 연결 인증 승인하기"
tags: ssh app
---
요즘 웹사이트 마다 OTP나 앱을 이용한 2차인증을 많이 사용하는데요, ssh 로 서버에 원격접속을 하거나 git 저장소 복제 등을 할 때도 이와 유사한 방식으로 인증을 하는 방법이 있습니다. [Kryptonite](https://krypt.co) 라는 서비스 인데요. 올해 4월 쯤 시작된 서비스 입니다.
ssh 로 인증이 필요한 작업을 하면, 모바일 앱에서 인증을 승인하는 방식으로 인증을 진행할 수 있습니다.
요즘 구글이나 페이스북에서 앱을 통해 2차 인증을 제공하는 것과 비슷하게 ssh 인증을 할 수 있는 것입니다.

서비스를 이용하려면 일단 스마트폰에 앱을 설치합니다. 앱을 이용해서 폰에서 비밀키와 공개키를 생성하고 보관 및 관리 하게 됩니다.
비밀 키는 오직 폰에만 보관 된다고 합니다.

- [Android 용](https://play.google.com/store/apps/details?id=co.krypt.kryptonite)
- [iOS 용](https://itunes.apple.com/us/app/kryptonite-protect-your-ssh-private-key/id1161494806)

앱을 열고, 앱의 안내에 따라서 키 쌍을 하나 만들어 봅시다. 그냥 버튼 누르고 기다리면 만들어 지고, 후에 이메일 주소를 입력해 주고 마치면 됩니다.
![Generate Key Pair on Phone](https://sukso96100.github.io/blogimgs/Screenshot_20170615-171909-COLLAGE-COLLAGE.jpg)

데스크탑이나 노트북에서 `kr` 이라는 Kryptonite 클라이언트를 설치해 줍니다. 터미널을 열고 아래 명령어를 실행하면 자동으로 설치됩니다.
리눅스와 MacOS 에서 현재 사용 가능하고, Windows 의 경우 Windows Subsystem for Linux 를 이용해서 설치해야 합니다.
아직 Windows 를 정식으로 지원하지 않는다고 하네요. OS 별 자세한 설치 방법은 [여기](https://krypt.co/install/) 를 참고하면 됩니다.

```bash
curl https://krypt.co/kr | sh
```

그리고, 데스크탑/노트북 을 휴대전화와 페어링 합니다. 아래와 같은 명령어를 입력해서 나오는 QR 코드를 휴대전화 앱에서 스캔 하면 됩니다.

```bash
kr pair
```

![Pair with Phone](https://sukso96100.github.io/blogimgs/IMG_20170615_173530.jpg)

그 다음, Kryptonite 에서 만든 키 쌍 중 공개키를 원하는 곳에 업로드 하여, ssh 인증시 앱으로 승인하도록 할 수 있습니다.
GitHub, GitLab 등의 저장소 호스팅 서비스에 업로드 하여, 저장소 복제 등을 할 때 인증을 받을 수 있고,
리눅스 서버 등에 업로드 하여 원격 접속 시 인증을 폰에서 승인할 수 있습니다.

다음을 실행하여 공개키를 클립보드로 복사할 수 있습니다.

```bash
kr copy
```

- 복사된 공개키를 GitHub 에 추가하려면, [여기](https://github.com/settings/keys) 에서 추가하면 됩니다.
- AWS, Azure, Digital Ocean 등의 클라우드 컴퓨팅 서비스에서 사용하려면 미리 공개키를 등록해 놓고, VM 생성 시 해당 공개키로 인증하도록 설정하면 됩니다.

이제 한번 기능을 사용해 봅시다. 앱과 페어링 한 데스크탑이나 노트북에서 미리 공개키를 설정한 곳에 평상시에 ssh 사용하듯 연결하거나 인증 하면 됩니다.
그러면 휴대전화에 알림이 나타나고, 알림에서 인증을 승인해서 ssh 인증을 완료하면 됩니다.

![Auth with phone](https://sukso96100.github.io/blogimgs/스크린샷%202017-06-15%20오후%206.15.01.png)

이제 매번 비공개 키를 새로 만들거나 기존 것을 복사해서 새 컴퓨터에 넣을 필요 없이 컴퓨터와 폰을 앱으로 페어링 하면, 공개키를 업로드 해 둔 곳에 ssh 로 접속하거나 인증을 쉽게 할 수 있습니다. 폰에서 승인을 추가로 해야 하기 때문에 좀 더 안전해 지기도 합니다.

페어링을 해제 하려면, `unpair` 합니다.

```bash
kr unpair
```

업그레이드 하려면 `upgrade`, 컴퓨터에서 프로그램을 제거하려면 `unistall` 하면 됩니다.

```bash
# Upgrade kr
kr upgrade

# Uninstall kr
kr uninstall
```
