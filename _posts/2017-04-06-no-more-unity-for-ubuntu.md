---
layout: post
date: 2017-04-06
image: https://sukso96100.github.io/blogimgs/ubuntu-unity.png
title: "Ubuntu 를 위한 Unity 는 이제 없다."
tags: ubuntu linux unity gnome essay
---

아쉽게도 그리고 갑작스럽게도 우분투에 기본으로 탑제되던 Unity 데스크탑 환경이 우분투 18.04 LTS 부터 사라지고,
Unity 이전에 기본으로 탑제하던 GNOME 으로 대체된다고 한다.
또한, 기본 데스크탑 환경이 GNOME으로 변경됨과 동시에, Unity 7(현제 우분투의 기본 데스크탑 환경), Unity 8(모바일, 테블릿, PC 통합 데스크탑 환경), 우분투 터치(모바일 기기용 우분투) 그리고 Unity 8 을 의해 독자적으로 개발했던 디스플레이 서버인 Mir까지 포기 한다고 한다.

글을 쓴 마크 셔틀워스(우분투를 개발하고 캐노니컬을 창립한 사람)는 컨버전스를 위해 Unity 8, 우분투 터치를 개발한 것이 잘못이였다고 생각하는데,
내 생각에는 우분투 터치와 Unity 8을 개발한 것이 잘못이 아니다. 이걸 개발한 것 자체는 굉장히 좋은 시도였다고 생각한다.
그리고 개인적으로 많이 기대했다. 우분투 터치와 Unity 8 둘다 정말 기대해 왔다.

Unity 8과 우분투 터치 그리고 컨버전스 기능을 개발한다고 Mir 라는 독자적인 디스플레이 서버를 만들어 독자노선을 밟고 삽질을 한 것이 문제라고 생각한다.
Xorg 를 대체하려 하지만, 여전히 안정화가 필요하다고 하는 디스플레이 서버인 Wayland 하나 지원하는데도 오래 걸린다고 한다.
이런 상황에서 Mir 를 따로 만들면 하드웨어 제조사들이 Wayland 지원하느라 바쁜데, Mir 지원을 해 주기나 할까?

그리고 Unity 에 커스텀 버전의 GTK 를 넣어서 다른 데스크탑 환경에서 멀쩡히 돌아가던 GTK 기반 앱들이
Unity 환경에서 UI 등이 깨지는 호환성 문제 등을 야기한 것도 잘못이라 생각한다.
(예를 들어, GNOME 환경에서는 UI가 멀쩡하게 노틸러스 파일 탐색기 앱이 Unity에서는 UI 가 깨져서 나온다.

우분투 터치의 경우, 시기적으로 너무 늦은것도 있다. 이미 Android 와 iOS가 시장을 다 점유한 상황에서, 새로운 모바일 OS나 플렛폼이 그 틈에 쉽게 끼어들 수 있을까?
전혀 쉽지 않을 것이다. 이미 모질라에서 Firefox OS 만들어서 휴대전화 만들어 볼려 했다가 접었고, Windows Phone 도 좀처럼 점유율이 늘지 않았다.
우분투 터치를 달고 나온 모바일 기기들도 마찬가지로 잘 안 팔렸을 것이다. 잘 팔려 나갔었다면 필자가 이미 쓰고 있었겠지...

그나저나 우분투 터치 나왔을 때 그걸로 앱 개발하던 사람들과, 우분투 터치 쓰던 사람들, Unity 7 쓰던 사람들은 이제 어찌 될려나... 이제 막 익숙해 진 사람들도 있을텐데...

캐노니컬은 우분투 터치, Unity 8을 포기하고, 대신 클라우드와 사물 인터넷에 더 집중할 것이라고 한다.
우분투는 이미 클라우드 컴퓨팅과 서버 등의 인프라 쪽이나 사물인터넷 분야는 꽤나 선방하고 있으니, 앞으로도 이 분야에서는 잘 나갈 것 같다.
서버 운영에 사용하는 유명한 소프트웨어(Openstack, Docker, Kubernetes 등)들 문서가 대부분이 우분투 기준으로 작성되어 있던데, 그럼 이미 말 다 했지 뭐.

업데이트 : 캐노니컬에서 Unity 8 을 포기하니, 이 프로젝트를 포크해서 이어 가려는 사람들이 나타났다. 어쩌면 이게 훨씬 더 좋을지도 모르겠다. 프로젝트 이름은 처음에는 Unity8org 였다가 지금은 yunit(윤잇?) 으로 변경되어서 지속되고 있다.

## 참고 링크

- [Ubuntu Insights - Growing Ubuntu for cloud and IoT, rather than phone and convergence](https://insights.ubuntu.com/2017/04/05/growing-ubuntu-for-cloud-and-iot-rather-than-phone-and-convergence/)
- [yunit - A community-driven unity8 fork](https://yunit.io/)
