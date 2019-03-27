---
layout: post
date: 2019-03-27
title: "Jib을 이용하여 JVM앱을 Heroku에 컨테이너로 배포하기"
tags: java jvm kotlin docker container heroku deploy jib gradle
---

참 오랜만에 블로그에 글을 쓰는 것 같습니다. 작년 9월에 공군 입대하고, 최근에 시간 날 때 마다 사이버 지식 정보방에서 간단한 개인 프로젝트를 하나 하고 있습니다. 작년 12월에 전입와서 개인 프로젝트를 쭉 해왔으니 한 2~3개월 가까지 사이버 지식 정보방 갈 수 있을 떄 마다 가서 작업을 한 것 같습니다.

그러다가 최근에 프로젝트를 거의 완성해서, 드디어 서버에 배포까지 했습니다. 오늘 이 포스트에서는 일단 어떻게 서버에 배포 하였는지에 대한 과정을 정리해보려 합니다.

## 병사는 돈이 없다...
네... 병역의 의무를 가지고 군 입대를 하는 사람 대부분은 병사로 입대하고... 이들 중 대다수는 돈이 없습니다...
월급도 30~40만원 정도만 받죠, 지금 이 시점에서 일병인 저는 33만원 정도를 받습니다. 물론 예전에 비해 많이 오르긴 했지만... AWS같은 클라우드 서비스에 카드 연결하고 넉넉한 사양의 VM 을 돌리기에는 좀 무리인 것 같네요. 

어짜피 간단히 만든 웹앱을 올릴 정도이니... 취미 삼아 개발한것 간단히 낮은 비용으로 올리기 좋은 곳을 떠올려 보다가, 많이들 사용하는 Heroku 를 사용하여 배포해 보기로 했습니다. PasS 라 운영 부담도 크지 않고, 무료 플랜으로 DB도 연결해서 간단한 웹앱 올리기에 별 무리도 없으니까요.

## Heroku 에 Container 로 앱을 배포할 수 있다.
이번에 Heroku 에 앱 배포하면서야 알게 되었습니다. 이제 Heroku 에도 Docker Container 로 앱을 배포할 수 있다는 사실을... 평소에 서버에 앱을 배포할 떄 Dockerize(Docker Image로 빌드해서 컨테이너로 배포)해서 배포 하는것을 선호했는데, Heroku 로 배포하면 Dockerfile 말고 다른걸 추가로 더 작성하고 설정해야 해서 좀 귀찮아 했습니다. 그런데 Heroku 에도 Container 로 배포할 수 있다는 것을 알고, Heroku 에 바로 배포 하기로 하였습니다.

## Jib 을 이용하여 이미지 빌드부터 레지스트리 업로드까지 간단히.
보통 웹앱을 Docker Image 로 만들 때, 이미지를 어떻게 빌드할 지 정의하는 `Dockerfile` 를 먼저 작성합니다. 저도 전에 Node.js 앱을 Docker 이미지로 빌드할 때 `Dockerfile` 을 작성 했구요. 그런데 이번에는 작성하지 않았습니다. 구글에서 개발한 [Jib](https://github.com/GoogleContainerTools/jib) 을 이용하면, 별도의 `Dockerfile` 작성 없이, 이미지 빌드 부터 레지스트리 업로드 까지 간단히 가능하기 때문입니다.

Jib 은 JVM 앱을 빌드할 떄 사용하는 빌드 툴킷인 Maven 또는 Gradle 의 플러그인 형태로 제공됩니다. 필자는 Gradle 을 사용해서, 이를 기준으로 작성하겠습니다. 기본적인 설정은 간단합니다. `plugins{ ... }` 블록에 Jib 을 추가 하기만 하면 됩니다.

```groovy
...
plugins {
  ...
  id 'com.google.cloud.tools.jib' version '1.0.2'
  ...
}
...
```

Docker 가 설치 되어 있는 경우, 이렇게만 해도 아래와 같은 명령줄을 통해 바로 사용할 수 있습니다.
아래 명령을 실행 하시면, 빌드부터 레지스트리 업로드 까지 모두 자동으로 진행 됩니다.

```bash
./gradlew jib --image=<원하는_이미지_이름>
```

실행 하시기 앞서, 해당 레지스트리에 먼저 로그인 하셔야 합니다. 예를 들어 Docke Hub 를 사용 하신다면, 아래와 같습니다.
```bash
docker login 
./gradlew -jib --image=<Docker Hub ID>/<저장소 이름>
```

Docker 가 설치되어 있지 않아도, 빌드 및 업로드 하는데 문제가 없습니다. 이 경우, [Docker Credential Helper 등의 방법을 이용하면 됩니다.(https://github.com/GoogleContainerTools/jib/tree/master/jib-gradle-plugin#authentication-methods)
