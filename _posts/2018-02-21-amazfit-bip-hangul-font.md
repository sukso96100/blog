---
layout: post
date: 2018-02-21
title: "Amazfit Bip(米动手表 青春版) 한글 폰트 작업"
tags: amazfit-bip smartwatch gadget china font hangul korean
image: https://sukso96100.github.io/blogimgs/amazfit-kr-font.png
---

![amazfit-bip.jpg](https://sukso96100.github.io/blogimgs/amazfit-bip.jpg)

> [Steemit 에서도 이 글을 보실 수 있습니다.](https://steemit.com/kr/@youngbin/amazfit-bip)

최근 고등학교 때 친구들과 함께 중국 베이징(北京) 여행을 갔다 왔습니다. 여행 중에 잠깐 샤오미 오프라인 스토어(小米之家) 에 방문해서 출시 한지는 좀 되었지만(?) 꽤 쓸만하고 가격도 괜찮다고 하는 Amazfit Bip(米动手表 青春版) 을 하나 구입 했습니다. 그런데 이게 다른건 좋은데, 내장 폰트가 한글 지원을 하지 않습니다. 그래서 한글이 깨집니다. 친구로부터 카카오톡 알림이 오면 한글 부분은 다 깨저서 사각형으로 나오더군요.

그래서 귀국 후 한글 폰트가 있는지 검색을 해 봤습니다. 없더군요, 그래서 직접 작업을 해 보기로 했습니다. 나온지 좀 된 제품이여서 그런지 이미 해외에서 이 제품 관련 각종 커스텀 펌웨어나 펌웨어 다루는 도구를 만들어 두었더군요. 펌웨어 관련해서 문서화도 어느정도 되어 있어서, 생각보다 어렵지 않게 할 수 있었습니다.

- [Amazfit Bip 펌웨어 조작 툴 모음](https://github.com/amazfitbip/tools)
- [Amazfit Bip 펌웨어 분석한 결과를 정리한 문서](https://github.com/amazfitbip/documentation/wiki)
- [가젯브릿지(Gadgetbridge)팀의 Amazfit Bip 문서](https://github.com/Freeyourgadget/Gadgetbridge/wiki/Amazfit-Bip)

## 펌웨어 파일 구하기

Amazfit Bip 의 펌웨어 파일은 어렵지 않게 구할 수 있습니다. Mi Fit 앱 apk 파일을 분해하면 금방 얻을 수 있습니다. 또한 Mi Fit 앱의 apk 파일 또한 쉽게 구할 수가 있구요. 중국판 앱의 경우는 [바이두(百度)](http://www.baidu.com)에서 小米运动을 검색하면 바로 검색 결과에서 다운로드 받을 수 있고. 국제버전의 경우는 [APK Mirror](https://www.apkmirror.com/) 등의 사이트에서 구할 수 있습니다.

`*.apk` 파일을 다운로드 받아서, 압축 해제 앱으로 바로 압축을 풀어 들여다 보면 각종 파일과 디렉토리가 보이는데요. 여기서 `assets` 로 들어가면 각종 샤오미의 스마트벤드, 스마트워치 제품 펌웨어 파일이 있습니다. Amazfit Bip 의 경우는 `Mili_chaohu.*`로 시작하는 파일이며, 아래와 같은 파일이 Amazfit Bip 의 펌웨어 파일에 해당됩니다.

- `Mili_chaohu.ft` - 글꼴 파일(중국어, 영문 기본 알파벳)
- `Mili_chaohu.ft.latin` - 영어 알파벳 라틴 확장
- `Mili_chaohu.fw` - 펌웨어
- `Mili_chaohu.gps` - GPS 관련 리소스 파일
- `Mili_chaohu.res` - 리소스 파일

## 폰트파일 작업하기

폰트만 패치할 것이므로, `Mili_chaohu.ft` 만 뽑으면 됩니다. 그리고 이제 폰트를 언패키징 해서 작업해 봅시다. [GitHub amazfitbip/tools](https://github.com/amazfitbip/tools)저장소에 있는 [`bipfont.py`](https://github.com/amazfitbip/tools/blob/master/bipfont.py) 스크립트를 이용해서 폰트파일을 해제할 수 있습니다.

스크립트를 사용하기 앞서 `pillow` 라는 Python 패키지를 하나 설치합니다. Python PIL의 Fork로, 이미지 처리를 하는 라이브러리 입니다.

```bash
pip3 install pillow
```

그리고 이제 폰트 파일을 해제합니다.
```bash
python3 bipfont.py unpack Mili_chaohu.ft
```

폰트가 해제 되면, `bmp` 디렉토리가 생성되면서 그 안에 각 글자별 이미지가 생성됩니다. 영문 알파벳 문자와 중국어 간체자 문자만 있는데요, 여기에 한글 문자 이미지를 작업하여 넣고 다시 패키징 하면 한글이 지원되는 폰트가 됩니다. 각 이미지 파일 이름을 보면 5자의 숫자와 알파벳으로 되어 있는데요. 앞의 4자는 해당 이미지 파일이 보여주는 문자의 유니코드 값 입니다. 가장 뒤 한자리는 무슨 규칙으로 숫자가 정해지는지 잘 모르겠네요. 폰트 패키징 스크립트 보면 바이트 값을 읽어들여서 16으로 나눈 나머지를 사용하고 있는데 무슨 의미인지 잘 모르겠습니다.

![amazfit-kr-font.png](https://sukso96100.github.io/blogimgs/amazfit-kr-font.png)

한글 글자 이미지를 생성해 봅시다. 저는 Python pillow (PIL 호환되는 라이브러리) 로 간단한 스크립트를 작성 했고, 스크립트와 폰트파일을 이용해 일괄적으로 생성 했습니다. [여기](https://github.com/sukso96100/amazfit-bip-kr/blob/master/ttf2bmp.py)에서 제가 사용한 스크립트를 보실 수 있습니다. 저의 경우는 한글 자모(U+1100~U+11FF)와 한글 글자마디(U+AC00~U+D7AF)에 해당하는 파일만 생성하였습니다. 기존 글자 이미지 파일 중 이미 한글 자모에 해당하는 파일이 있는데요, 대부분이 파일명 마지막 자리가 4여서 그냥 스크립트에서 파일 생성시 뒤에 4를 붙이도록 했습니다. 4가 아닌 글자는 따로 비교해서 파일명 수정 작업을 했습니다.

생성한 이미지를 `bmp` 디렉토리에 넣어 합치고 다시 패키징 합니다. 그러면 패키징 된 폰트 파일이 생성 되는데, 이를 이제 기기에 설치하면 됩니다.

```bash
python3 bipfont.py pack Mili_chaohu_kr.ft
```

## 폰트파일 플래싱 하기

플래싱은 간단합니다.

- 생성된 폰트파일을 Amazfit Bip 이 연결된 안드로이드 휴대전화에 넣습니다.
- Mi Fit 앱을 설치합니다. 구글 플레이 또는 바이두(百度)에서 검색하면 바로 나옵니다.
- 가젯브릿지(Gadgetbridge) 앱을 설치합니다. [F-Droid](https://f-droid.org/packages/nodomain.freeyourgadget.gadgetbridge/)에서 받아 설치 가능합니다.
- Mi Fit 에서 Amazfit Bip 을 연결합니다. 그리고 그 다음에 가젯 브릿지 앱에서 Amazfit Bip 을 연결합니다.
- 파일 탐색기 앱에서 이전에 작업한 폰트 파일을 선택합니다. 가젯브릿지 펌웨어 설치 화면이 나타납니다.
- 가젯브릿지 앱으로 폰트 펌웨어 설치를 진행합니다.

이제 Amazfit Bip 에서 한글이 잘 출력되는 것을 확인하실 수 있습니다.

![amazfit-bip-kr-in-action.jpg](https://sukso96100.github.io/blogimgs/amazfit-bip-kr-in-action.jpg)


## 폰트 펌웨어 받기
GitHub 를 통해 배포하고 있습니다. [여기](https://github.com/sukso96100/amazfit-bip-kr/releases) 에서 확인 가능합니다.

## 참고
- [GitHub sukso96100/amazfit-bip-kr](https://github.com/sukso96100/amazfit-bip-kr/releases)
- [GitHub amazfitbip/tools](https://github.com/amazfitbip/tools)
- [GitHub amazfit/font](https://github.com/amazfitbip/font)
- [GitHub amazfit/documentation Wiki](https://github.com/amazfitbip/documentation/wiki)
- [Amazfit Bip Firmware Update](https://github.com/Freeyourgadget/Gadgetbridge/wiki/Amazfit-Bip-Firmware-Update)
- [Pillow (PIL Fork)](https://pillow.readthedocs.io/en/latest/)
