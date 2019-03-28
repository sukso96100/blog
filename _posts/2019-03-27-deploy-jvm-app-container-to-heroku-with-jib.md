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

Jib 은 JVM 앱을 빌드할 때 사용하는 빌드 툴킷인 Maven 또는 Gradle 의 플러그인 형태로 제공됩니다. 필자는 Gradle 을 사용해서, 이를 기준으로 작성하겠습니다. 기본적인 설정은 간단합니다. `plugins{ ... }` 블록에 Jib 을 추가 하기만 하면 됩니다.

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

Docker 가 설치되어 있지 않아도, 빌드 및 업로드 하는데 문제가 없습니다. 이 경우, [Docker Credential Helper 등의 방법을 이용하면 됩니다.](https://github.com/GoogleContainerTools/jib/tree/master/jib-gradle-plugin#authentication-methods)

필요한 경우, `build.gradle` 의 `jib{...}` 안의 `container{...}` 에 `mainClass`를 설정하여 메인 클래스를 지정해 줍니다.  `build.gradle` 의 최상위에 정의된 `mainClassName`과 별개로 `jib{...}`쪽에도 설정해 주어야 나중에 컨테이너가 제대로 작동합니다. 아래는 예시 입니다.

```groovy
jib {
  container {
    mainClass = 'io.ktor.server.netty.EngineMain'
  }
}
```

## Heroku 배포 준비


빌드하는 방법을 알았으니, Heroku에 올려봅니다.

- [Heroku dashboard](https://dashboard.heroku.com) 에 먼저 로그인 합니다.
- *New * -> *Create new app* 을 선택해서 앱을 새로 만듭니다.
- [Heroku CLI를 설치합니다.](https://devcenter.heroku.com/articles/heroku-cli)
  - 저의 경우는 Standalone Installation 방식을 사용 했습니다. 아래 명령줄 하나면 됩니다.
```bash
curl https://cli-assets.heroku.com/install.sh | sh
```
- Heroku CLI 에서 로그인 합니다. 콘솔만 사용 가능한 환경인 경우, `-i `옵션을 이용해 로그인 합니다.
```bash
heroku login # 또는 heroku login -i
```

Heroku Container Registry 에 로그인 합니다. Heroku CLI 에서 로그인 하거나, Docker 에서 로그인 합니다.

```bash
heroku container:login
#또는
ker login --username=_ --password=$(heroku auth:token) registry.heroku.com
```

위 두 명령은 Heroku CLI와 Docker 모두 이용 가능한 환경에서만 사용 가능합니다. Docker 사용이 불가능한 경우, 프로젝트의 build.gradle에 아래와 같은 내용을 추가합니다. 이때 필요한 API Key 는 [계정 설정](https://dashboard.heroku.com/account) 화면에서 얻을 수 있습니다. Heroku CLI에 로그인 된 경우, `heroku auth:token`을 이용해서도 얻을 수 있습니다.

```groovy
...
jib { 
  to {
  ...
    auth { 
      username = '_' 
      password = '<Heroku API Key>'
    } 
  } 
}
...
```

이제 배포를 위해 아래 명령으로 빌드, 업로드를 진행합니다.
`<app>`에는 Heroku에서 생성한 앱 이름을, `<process-type>`은 `web`, `worker`, `urgentworker`, `clock` 같은 타입 중 하나를 넣습니다. 저의 경우 웹앱을 배포하므로, `web` 으로 넣었습니다.

```
./gradlew jib --image=registry.heroku.com/<app>/<process-type>
```

매번 `--image` 옵션을 넣고싶지 않다면, 이 또한 `build.gradle` 에 정의 해 둘 수 있습니다.

```groovy
...
jib { 
  to {
  ...
  image: 'registry.heroku.com/<app>/<process-type>'
  ...
  } 
}
...
```

## 추가 설정과 배포
이제 배포할 준비가 거의 다 되었습니다. 필요한 경우 데이타베이스 같은 리소스를 추가로 설정하고, 설정 탭의 Config Vars 에서 환경변수를 설정합니다. 이를 설정하는 방법은 검색하면 많이 다루므로, 여기서는 다루지 않겠습니다.

아래 명령줄을 이용하여 앱을 배포합니다.

```bash
heroku container:release <process-type> -a <app>
```

이후, `<app>.herokuapp.com` 에 접속하여 잘 돌아가는지 확인합니다.
잘 작동하지 않는다면, `heroku logs -s <app>` 명령을 실행하여, 로그를 확인해 봅니다.

이렇게 JVM기반 앱을 Heroku에 컨테이너로 배포하는 것을 완료 하였습니다. Jib 덕분에 Docker설치와 Dockerfile작성 없이도, JVM 앱을 쉽게 컨테이너로 배포할 수 있습니다.
Jib 플러그인과 Heroku 에 컨테이너로 배포하는 방법을 좀 더 자세히 알고 싶다면, 아래 링크를 참고해 보세요.

## 번외편
Heroku 의 컨테이너 레지스트리에 올라가는 이미지들은 `CMD` Instruction 이 있어야 합니다. 없으면 오류가 나면서 업로드가 중단 되는데요, Jib 으로 생성된 이미지에는 기본적으로 `ENTRYPOINT`만 있고, `CMD` 는 없습니다. 이 경우, `build.gradle` 에서 `jib{ ... }`안의 `container{...}` 에 `args`를 넣어주면 됩니다. `ENTRYPOINT` 에는 기본값으로 `java` 명령과 같이 실행할 인자들이 들어가기 때문에, `args` 에 `java`에 대한 인자를 하나 더 넣어주면 됩니다. 그러면 실제 컨테이너가 실행될 때, `ENTRYPOINT` 뒤에 `CMD` 가 붙여진 명령이 실행됩니다.

```groovy
...
jib {
  container {
    args = ['--verbose:gc']
  }
}
...
```

### 참고자료
- [Deploying with Docker - Heroku Dev Center](https://devcenter.heroku.com/categories/deploying-with-docker)
- [GoogleContainerTools/Jib - GitHub](https://github.com/GoogleContainerTools/jib/blob/master/README.md)
- [Jib - Containerize your Gradle Java project](https://github.com/GoogleContainerTools/jib/blob/master/jib-gradle-plugin/README.md)
- [The Heroku CLI - Heroku Dev Center](https://devcenter.heroku.com/articles/heroku-cli)
