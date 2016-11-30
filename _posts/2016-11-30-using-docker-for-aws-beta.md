---
layout: post
image: https://sukso96100.github.io/blogimgs/docker-for-aws-1.png
color: "#04abbb"
date: 2016-11-30
title: "Docker for AWS Public Beta 사용해 보기"
tags: docker aws tutorial note update
---
미국 라스베가스 시각으로 어제(2016.11.29) AWS re:Invent 2016 에서 [Docker for AWS 퍼블릭 베타 버전이 드디어 공개되었습니다.](https://blog.docker.com/2016/11/docker-aws-public-beta/) AWS 에서 Docker 를 사용하고 있는 입장이여서, 간단히 EC2 인스턴스에 Docker 를 설치하여 돌리는 것과, Docker for AWS 를 사용하는 것이 어떻게 다를지도 궁금했었고, 사용해 보는 것을 기대해 오기도 했습니다. 그동안 비공개 베타여서 사용해 보기 어려웠는데, 이번에 한번 사용해 보기로 했습니다.

## Docker for AWS
Docker 를 AWS 의 인프라와 더 깊게 연동해서 사용할 수 있는 버전의 Docker 라고 보면 될 것 같습니다. Docker for AWS 를 이용하면, 기존에 EC2 인스턴스에 직접 설치 후, 앱을 배포하는 방식 보다 더 효율적이고, 안전하고(secure), 스케일 가능하도록(scalable) 배포할 수 있다고 합니다. 또한 Docker 를 항상 최신 버전을 유지하고, 표준 Docker 플랫폼을 배포하기 때문에, 호환성 문제나 락-인(lock-in) 문제 등도 피할 수 있는 장점이 있다고 합니다.

## 시작하기
생각보다 간단합니다. [Docker for AWS 릴리즈 노트](https://beta.docker.com/docs/aws/release-notes/) 페이지로 가셔서, 최신 버전의 릴리즈 노트, 또는 원하시는 버전의 릴리즈 노트에 있는 `Launch Stack` 버튼을 눌러서, AWS 에서 바로 시작이 가능합니다.

![](/blogimgs/docker-for-aws-2.png)

- `Launch Stack` 버튼을 누르면, AWS CloudFormation Stack 를 새로 만드는 화면이 나오고, 템플릿 선택 화면이 나옵니다(Select Template). 이미 템플릿이 Docker for AWS 로 설정 되어 있기 때문에, `Next` 를 눌러 다음 단계로 이동합니다.
- Stack 설정 화면이 나타납니다. 다음을 참고하여, 원하시는 대로 설정 하시고, `Next` 를 눌러서 다음 단계로 갑니다.
  - Stack Name : 새로 만들 Stack 에 대한 이름을 정합니다.
  - Swarm Size
    - Number of Swarm managers? - Docker 에서는 다중 Docker 호스트로 이뤄진 클러스터를 Swarm 이라고 하는데, 이를 관리할 관리자 호스트의 수를 설정합니다.
    - Number of Swarm worker nodes? - Swarm Manager 의 하위 호스트 수를 설정합니다.
  - Swarm Properties
    - Which SSH key to use? - Swarm 을 구성하는 인스턴스에 접속시 사용할 SSH 키를 선택합니다.
    - Enable daily resource cleanup? - 켜면, 매일 불필요한 이미지, 컨테이너, 네트워크, 볼륨 등을 자동으로 정리합니다.
  - Swarm Manager Properties
    - Swarm manager instance type? - Swarm Manager 가 될 인스턴스의 유형을 고릅니다.
    - Manager ephemeral storage volume size? - Manager 가 될 인스턴스가 사용할 디스크 크기를 설정합니다.(최소 20GB)
    - Manager ephemeral storage volume type - Manager 가 될 인스턴스가 사용할 디스크 유형을 선택합니다.
  - Swarm Worker Properties
    - Agent worker instance type? - Worker 가 될 인스턴스의 유형을 고릅니다.
    - Worker ephemeral storage volume size? - Worker 가 될 인스턴스가 사용할 디스크 크기를 설정합니다.(최소 20GB)
    - Worker ephemeral storage volume type - Worker 가 될 인스턴스가 사용할 디스크 유형을 선택합니다.
- *Options* 화면이 나옵니다. 필요에 따라 추거적인 사항을 설절하고 넘어갑니다. 그냥 넘어가도 상관 없습니다.
- 설정 사항을 다시 한번 확인 하는 화면이 나옵니다. 설정 사항을 확인 후, *Capabilities* 부분에 있는, *I acknowledge that AWS CloudFormation might create IAM resources.* 를 체크 해 줍니다. Docker for AWS 실행 시 필요한 IAM 리소스를 자동으로 만들도록 하게 하기 위함입니다.
- 이제 `Create` 를 눌러, Docker for AWS 를 실행합니다. 필요한 리소스가 생성되는데 시간이 좀 걸립니다.

![](/blogimgs/docker-for-aws-3.png)

## SSH 로 로그인 해 보기
![](/blogimgs/docker-for-aws-4.png)
Docker for AWS 를 실행 했다면, Manager 인스턴스에 SSH 로 로그인 해 봅시다. 본인의 AWS 콘솔에서, 인스턴스를 확인하고, 아래와 같은 명령줄을 이용합니다.
Docker for AWS 의 경우, Docker for AWS 에 최적화된 OS 를 사용해서 그런지, 기본 계정이 `root` 가 아닌 `docker` 입니다.
때문에 로그인 하실 때 `docker` 로 로그인 하시면 됩니다. `root` 를 포함한 다른 계정으로는... 설정 한 적 없는(?) 비밀 번호를 추가적으로 요구해서 로그인을 하지 못합니다.

```bash
ssh -i "<로그인에 쓸 SSH키 파일>" docker@<Manager 인스턴스의 Public DNS 또는 고정IP>
```

## 이것저것 해 보기

이제 Docker 명령어로 이것저것 해 봅시다. 명령줄 앞에 따로 `sudo` 를 불일 필요 없이 Docker 명령어를 실행 할 수 있습니다. 먼저, Swarm 에 속한 호스트를 조회 해 봅시다. `docker node ls` 를 실행하여 조회합니다.

```bash
~/keys  ssh -i "**********" docker@**********
Welcome to Docker!
~ $ docker node ls
ID                           HOSTNAME                                         STATUS  AVAILABILITY  MANAGER STATUS
pt44bdyp9v7z3vk2eiqm22fys    ip-172-31-13-181.ap-northeast-2.compute.internal  Ready   Active        
rh8yuno9fwjrsnbh94kaimcan *  ip-172-31-4-253.ap-northeast-2.compute.internal   Ready   Active        Leader
zlrioewhnqxideigxeuveynto    ip-172-31-22-60.ap-northeast-2.compute.internal   Ready   Active           
~ $
```

이번에는 `nginx` 서비스를 하나 생성하여 실행하고 스케일도 조절해 봅시다. 먼저 아래와 같은 명령줄로 새로운 서비스를 생성합니다. `nginx` 이미지로 `my-nginx` 라는 이름의 서비스를 만들고, 서비스의 80번 포트를 호스트의 80번 포트로 노출합니다.

```bash
~ $ docker service create --name my-nginx --port target=80,published=80 nginx
sp55v4xvc9ailndxcef5dovus
```

서비스를 조회 해 본 다음 스케일을 3 으로 늘려 봅시다.

```bash
~ $ docker service ls
ID            NAME      MODE        REPLICAS  IMAGE
sp55v4xvc9ai  my-nginx  replicated  1/1       nginx:latest
~ $ docker service scale my-nginx=3
my-nginx scaled to 3
~ $ docker service ls
ID            NAME      MODE        REPLICAS  IMAGE
sp55v4xvc9ai  my-nginx  replicated  3/3       nginx:latest
~ $
```

우리가 스케일을 늘린 서비스 상태를 좀 더 자세히 봅시다. `docker service ps <서비스 이름>` 을 이용해서, 서비스를 구성하는 컨테이너와, 각 컨테이너가 어떤 호스트에 있는지도 볼 수 있습니다. 아래 예제에서는 각 컨테이너가 서로 다른 호스트에 있는 것을 볼 수 있습니다.

```bash
~ $ docker service ps my-nginx
NAME                     IMAGE         NODE                                             DESIRED STATE  CURRENT STATE          ERROR  PORTS
my-nginx.1.p7aqyci9kbul  nginx:latest  ip-172-31-0-195.ap-northeast-2.compute.internal  Running        Running 4 minutes ago         
my-nginx.2.f1js8wr5iq44  nginx:latest  ip-172-31-22-60.ap-northeast-2.compute.internal  Running        Running 2 minutes ago         
my-nginx.3.0prl4ebdzlc5  nginx:latest  ip-172-31-4-253.ap-northeast-2.compute.internal  Running        Running 2 minutes ago         
~ $
```

웹 브라우저에서 지금 돌아가고 있는 `nginx` 에 접속해 봅시다. Docker for AWS 를 실행하면서 자동으로 생성되어 Swarm 네트워크 앞에 붙여진 AWS ELB 의 Public DNS 를 이용해서 들어갈 수 있습니다. 해당 ELB 의 Public DNS 는, EC2 > LOAD BALANCING > Load Balanceres > 해당 로드벨런서 선택 > 하단 로드벨런서 정보 에서 확인 가능합니다. 이 DNS 를 그대로 복사해서, 브라우저 주소창에 붙여넣고 이동하면, `nginx` 시작 화면이 나오는 것을 볼 수 있습니다.

![](/blogimgs/docker-for-aws-5.png)

## 호스트 스케일링 하기
호스트를 스케일 하는 것은 아주 간단합니다. 먼저 EC2 > AUTO SCALING > Auto Scaling Groups 로 들어갑니다. 자동으로 생성된 Manager 스케일링 그룹과, Node(Swarm 네트워크에서 하위 호스트) 스케일링 그룹이 나타납니다. 스케일 하고자 하는 그룹을 선택하고, 하단에 나오는 상세 정보 화면에서, `Edit` 를 눌러 수정 합니다. 스케일을 늘릴 것이므로, *Desired* 항목 값을 3으로 변경하고, 저장합니다. 그러면 변경된 설정에 따라 Node 에 해당되는 인스턴스의 수가 조절됩니다. 새로 인스턴스가 생성되는 경우, 자동으로 Swarm 네트워크에 연결되고, 스케일을 줄여서 인스턴스가 사라지는 경우 자동으로 Swarm 네트워크에서 끊김니다.

아래는 Node 스케일을 2에서 3으로 늘린 결과 입니다. 자동으로 Swarm 네트워크에 연결 된 것을 볼 수 있습니다. 원래대로라면 직접 연결을 해 줘야 하거나, Docker Remote API 로 따로 설정을 해 줬어야 했을 겁니다.

```bash
~ $ docker node ls
ID                           HOSTNAME                                          STATUS  AVAILABILITY  MANAGER STATUS
kwxx2wwmowmkygefnvwh7xfgx    ip-172-31-0-195.ap-northeast-2.compute.internal   Ready   Active        
pt44bdyp9v7z3vk2eiqm22fys    ip-172-31-13-181.ap-northeast-2.compute.internal  Ready   Active        
rh8yuno9fwjrsnbh94kaimcan *  ip-172-31-4-253.ap-northeast-2.compute.internal   Ready   Active        Leader
zlrioewhnqxideigxeuveynto    ip-172-31-22-60.ap-northeast-2.compute.internal   Ready   Active        
~ $
```

아래는 스케일을 3에서 1로 줄인 결과입니다. 자동으로 Swarm 네트워크에서 빠진 것을 볼 수 있습니다.

```bash
~ $ docker node ls
ID                           HOSTNAME                                          STATUS  AVAILABILITY  MANAGER STATUS
kwxx2wwmowmkygefnvwh7xfgx    ip-172-31-0-195.ap-northeast-2.compute.internal   Ready   Active        
rh8yuno9fwjrsnbh94kaimcan *  ip-172-31-4-253.ap-northeast-2.compute.internal   Ready   Active        Leader
~ $
```

(당연하게도...)스케일에 따라 인스턴스가 자동으로 꺼지는 것도 볼 수 있습니다.
![](/blogimgs/docker-for-aws-6.png)

## 로깅
컨테이너나 서비스가 남기는 로그는, AWS CloudWatch 에서 확인 가능합니다. `docker logs <컨테이너 이름>` 과 `docker service logs <서비스 이름>` 은 Docker for AWS 에서 지원되지 않는다고 합니다. 실제로 실행을 한번 해 봤는데, 실행은 되지만 그냥 아무것도 나타나질 않더군요.

## Docker for AWS 제거
CloudFormation 에서 선택 후 제거하면, Docker for AWS 실행 시 만들어진 모든 리소스가 전부 다 자동으로 사라집니다.

## 결론
일단 간단히 한번 사용해 봤는데, 그냥 EC2 인스턴스에 직접 설치해 사용하는 것에 비해 편리한 점이 많은 것 같습니다. 특히 호스트를 스케일링 할 때, 자동으로 Swarm 에 연결/연결 해제 하는 기능이, 추후 오토 스케일링이 필요한 서비스를 Docker 를 이용해서 배포할 때 유용할 것 같습니다.

## 참조 & 참고자료
- [Docker for AWS Setup - Docker for AWS](https://beta.docker.com/docs/aws/)
- [Modifying Docker install on AWS - Docker for AWS](https://beta.docker.com/docs/aws/scaling/)
- [Docker for AWS Release notes - Docker for AWS](https://beta.docker.com/docs/aws/release-notes/)
- [Docker For AWS Public Beta - Docker Blog](https://blog.docker.com/2016/11/docker-aws-public-beta/)
- [Docker for AWS and Azure Private Beta - YouTube](https://www.youtube.com/watch?v=c-EHuF-e3oY)
