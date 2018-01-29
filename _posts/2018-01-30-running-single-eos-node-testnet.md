---
layout: post
date: 2018-01-30
title: "EOS 단일 노드 테스트넷 돌려보기"
tags: blockchain eos tutorial
---
> 이 글은 [Steemit](https://steemit.com/kr/@youngbin/eos) 에서도 읽어보실 수 있습니다.

최근 블록체인 중에서 개인적으로는 [EOS](https://eos.io/) 에 관심을 많이 가지고 있습니다. EOS dApp(탈중앙화된 앱) 개발도 관심이 있어서 문서를 많이 찾아보려 하고 있습니다. 그러다가 몇일전에 EOS 싱글 노드 테스트넷 돌리는 것을 아주 잠깐 해봐서, 돌려본 김에 정리해서 기록으로 남겨두는겸 글을 쓰게 되었습니다. 이 글에서는 EOS 데몬과 명령행 도구 등을 빌드 하여 설치하는 것과 이를 이용해 로컬에서 테스트넷을 실행하는 방법을 다룹니다.

## 소스코드 받아서 빌드 하기

먼저 아래 명령행을 실행해서 소스코드를 받습니다. Git 이 미리 설치되어 있어야 합니다. 그리고 내려받은 소스코드 디렉토리로 들어갑니다.

```bash
git clone https://github.com/eosio/eos --recursive
cd eos
```

소스코드에 포함된 자동 빌드 스크립트를 이용하면, 빌드를 쉽게 할 수 있습니다. 빌드 스크립트는 Ubuntu 와 MacOS 를 지원합니다.
다른 환경(예: Windows) 를 사용 하신다면, [Docker 를 이용한 방법](https://github.com/EOSIO/eos/wiki/Local-Environment#3-docker) 을 참고하세요.

### MacOS 에서 빌드하기

먼저, 최신 버전의 XCode 와 Homebrew 를 미리 설치해 두어야 빌스 스크립트로 빌드를 하실 수 있습니다. EOS GitHub 위키에는 공식적으로 Sierra 버전 사용시 사용 가능하다고 나와 있는데요. 제가 시도해본 결과 High Sierra 에서도 사용하시는데 문제가 없었습니다. 참고하시면 되겠습니다.

XCode 최신 버전을 설치 하려면 아래 명령행을 실행합니다.

```bash
xcode-select --install
```

Homebrew 는 기본적으로 아래와 같은 명령행을 실행하여 설치할 수 있습니다. 다른 방법으로 설치를 원하신다면, [여기](https://docs.brew.sh/Installation.html)를 참고해 보세요.

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

빌드는 Full 빌드와 Incremental 빌드 중 하나를 선택하실 수 있습니다. Full 의 경우 처음부터 모두 다 빌드하는 방식이고, Incremental 은 이전에 빌드한 적이 없거나 새로 빌드해야 하는 부분만 빌드하는 방식입니다.

Full 방식으로 빌드하려면 아래 명령행을 실행합니다.

```
./build.sh darwin full
```

Incremental 방식으로 빌드하려면 아래와 같이 실행합니다.

```
./build.sh darwin
```

### Ubuntu 에서 빌드하기

Ubuntu 의 경우 16.10 버전에서 사용 가능하다고 위키에 나와 있습니다. 빌드 스크립트를 잠깐 열어 봤었는데, 의존성 설치 부분에서 설치할 패키지 목록이 하드코딩 되어 있더군요. 대부분의 의존성 패키지 설치에는 문제가 없겠지만, Ubuntu 의 경우 일부 패키지는 Ubuntu 버전에 따라서 패키지 이름지 조금씩 다르거나, 아예 제공이 되지 않는 경우도 있기 때문에, 다른 버전에서는 의존성 설치 시 오류가 날 수도 있다는 것을 참고하시고, 필요에 따라 수정을 하여 사용하시면 되겠습니다.

마찬가지로 Full, Incremental 방식 중 선택하여 빌드가 가능합니다.

Full 방식으로 빌드하려면 아래 명령행을 실행합니다.

```
./build.sh ubuntu full
```

Incremental 방식으로 빌드하려면 아래와 같이 실행합니다.

```
./build.sh ubuntu
```

## 단일 노드 테스트넷 실행해보기

빌드가 끝났다면, 실행해 봅시다. 빌드하여 생성된 것 중 `eosiod`(원래는 `eosd` 인데, DAWN 3.0 이 나오면서 변경된 듯 합니다.) 를 이용하여 단일 노드 테스트넷을 실행할 수 있습니다. 먼저 아래와 같은 명령행을 그냥 실행해 봅니다.

> 빌드하여 생성된 바이너리는 `build/programs/<프로그램 파일 이름>/` 에 위치해 있습니다.  
> 예 : `eosiod` -> `build/programs/eosiod/`

```bash
./eosiod
```

그러면 아래와 같은 오류가 발생하며 그냥 종료될 겁니다. 계속 실행된다면, `Crtl+C` 를 눌러서 바로 종료합니다.

~~~
2836411ms thread-0   chain_plugin.cpp:109          plugin_initialize    ] initializing chain plugin
2836412ms thread-0   http_plugin.cpp:141           plugin_initialize    ] host: 127.0.0.1 port: 8888
2836414ms thread-0   http_plugin.cpp:144           plugin_initialize    ] configured http to listen on 127.0.0.1:8888
2836414ms thread-0   net_plugin.cpp:2376           plugin_initialize    ] Initialize net plugin
2836414ms thread-0   net_plugin.cpp:2396           plugin_initialize    ] Setting net_plugin logging level to info
2836416ms thread-0   net_plugin.cpp:2422           plugin_initialize    ] host: 0.0.0.0 port: 9876
2836417ms thread-0   net_plugin.cpp:2498           plugin_initialize    ] my node_id is 71487b0ed5ccc9db85cdf83ba8f828f7320a8aed04aefb97e0c47f8597bdc0a5
2836421ms thread-0   main.cpp:85                   main                 ] eosiod version 7a0d099d
2836422ms thread-0   main.cpp:89                   main                 ] 10 assert_exception: Assert Exception
fc::exists( my->genesis_file ): unable to find genesis file '', check --genesis-json argument
    {"f":""}
    thread-0  chain_plugin.cpp:189 plugin_startup

    {"my->genesis_file.generic_string()":""}
    thread-0  chain_plugin.cpp:210 plugin_startup

~~~

그러면서 `eosiod` 가 있는 디렉토리에 `data-dir` 디렉토리가 생성되는 것을 보실 수 있습니다. 그리고 그 안에는 테스트넷 실행에 사용할 설정 파일, `config.ini` 가 생성된 것을 보실 수 있습니다. 이를 조금 수정하여 테스트넷을 실행 할 수 있도록 해봅시다.

`enable-stale-production` 옵션을 `true` 로 합니다. 로컬에서 잠깐 실행할 테스트넷 이므로, 가지고 있는 블록이 최신 상태가 아니여도 블록을 계속 생산하도록 합니다.

~~~
enable-stale-production = true
~~~

`genesis-json` 값을 설정해 줍니다. 앞에 `#` 을 붙어서 주석처리 되어 있다면 이를 지워서 주석을 풀어줍니다. 초기 블록 생성자 등을 지정하는 `genesis.json` 파일의 절대 경로를 값으로 넣어주면 됩니다. 소스코드에 포함된 `genesis.json` 을 사용해도 무방합니다.

그리고 아래와 같은 내용을 뒤에 붙여 넣습니다. 블록 생성을 켜거나, 플러그인 등을 지정하는 내용을 포함한 설정값 입니다.

~~~
# Enable block production with the testnet producers
producer-name = inita
producer-name = initb
producer-name = initc
producer-name = initd
producer-name = inite
producer-name = initf
producer-name = initg
producer-name = inith
producer-name = initi
producer-name = initj
producer-name = initk
producer-name = initl
producer-name = initm
producer-name = initn
producer-name = inito
producer-name = initp
producer-name = initq
producer-name = initr
producer-name = inits
producer-name = initt
producer-name = initu
# Load the block producer plugin, so you can produce blocks
plugin = eosio::producer_plugin
# Wallet plugin
plugin = eosio::wallet_api_plugin
# As well as API and HTTP plugins
plugin = eosio::chain_api_plugin
plugin = eosio::http_plugin
~~~

수정한 설정 파일을 저장하고, 다시 `eosiod` 를 실행해 봅니다.

```bash
./eosiod
```

이제 아래와 같은 로그가 터미널에 찍히면서 테스트넷이 잘 돌아가며 블록이 생산되는 것을 확인하실 수 있습니다.

~~~
152239ms thread-0   chain_plugin.cpp:109          plugin_initialize    ] initializing chain plugin
152253ms thread-0   wallet_plugin.cpp:35          plugin_initialize    ] initializing wallet plugin
152253ms thread-0   http_plugin.cpp:141           plugin_initialize    ] host: 127.0.0.1 port: 8888
152255ms thread-0   http_plugin.cpp:144           plugin_initialize    ] configured http to listen on 127.0.0.1:8888
152255ms thread-0   net_plugin.cpp:2376           plugin_initialize    ] Initialize net plugin
152255ms thread-0   net_plugin.cpp:2396           plugin_initialize    ] Setting net_plugin logging level to info
152255ms thread-0   net_plugin.cpp:2422           plugin_initialize    ] host: 0.0.0.0 port: 9876
152256ms thread-0   net_plugin.cpp:2498           plugin_initialize    ] my node_id is a9f5b571d04fb2c1e0cad757a629243e2caa4d0f263fe6817f5c489dcafe95f1
152257ms thread-0   main.cpp:85                   main                 ] eosiod version 7a0d099d
152288ms thread-0   block_log.cpp:92              open                 ] Opening block log at /Users/youngbin/projects/eos/build/programs/eosiod/data-dir/blocks/blocks.log
153135ms thread-0   chain_controller.cpp:1087     operator()           ] applying genesis transaction
153210ms thread-0   chain_controller.cpp:1100     operator()           ] done applying genesis transaction
153211ms thread-0   chain_plugin.cpp:201          plugin_startup       ] starting chain in read/write mode
153212ms thread-0   chain_plugin.cpp:206          plugin_startup       ] Blockchain started; head block is #0, genesis timestamp is 2017-03-30T12:00:00.000
153212ms thread-0   producer_plugin.cpp:152       plugin_startup       ] producer plugin:  plugin_startup() begin
153212ms thread-0   producer_plugin.cpp:157       plugin_startup       ] Launching block production for 21 producers.

*******************************
*                             *
*   ------ NEW CHAIN ------   *
*   -  Welcome to EOSIO!  -   *
*   -----------------------   *
*                             *
*******************************

Your genesis seems to have an old timestamp
Please consider using the --genesis-timestamp option to give your genesis a recent timestamp

153219ms thread-0   producer_plugin.cpp:167       plugin_startup       ] producer plugin:  plugin_startup() end
153219ms thread-0   http_plugin.cpp:156           plugin_startup       ] start processing http thread
153226ms thread-0   http_plugin.cpp:213           plugin_startup       ] start listening for http requests
153241ms thread-0   http_plugin.cpp:218           plugin_startup       ] http io service exit
153241ms thread-0   wallet_api_plugin.cpp:70      plugin_startup       ] starting wallet_api_plugin
153243ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/wallet/create
153243ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/wallet/get_public_keys
153243ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/wallet/import_key
153243ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/wallet/list_keys
153243ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/wallet/list_wallets
153243ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/wallet/lock
153243ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/wallet/lock_all
153243ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/wallet/open
153244ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/wallet/set_timeout
153244ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/wallet/sign_transaction
153244ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/wallet/unlock
153244ms thread-0   chain_api_plugin.cpp:62       plugin_startup       ] starting chain_api_plugin
153245ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/abi_bin_to_json
153245ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/abi_json_to_bin
153245ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/get_account
153245ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/get_block
153245ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/get_code
153245ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/get_currency_balance
153245ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/get_currency_stats
153246ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/get_info
153246ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/get_required_keys
153246ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/get_table_rows
153246ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/push_block
153246ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/push_transaction
153246ms thread-0   http_plugin.cpp:242           add_handler          ] add api url: /v1/chain/push_transactions
153246ms thread-0   net_plugin.cpp:2510           plugin_startup       ] starting listener, max clients is 25
153503ms thread-0   chain_controller.cpp:863      validate_block_heade ] head_block_time 2017-03-30T12:00:00.000, next_block 2018-01-29T17:02:33.500, block_interval 500
153503ms thread-0   chain_controller.cpp:865      validate_block_heade ] Did not produce block within block_interval 500ms, took 26370153500ms)
inits generated block b2df7df0... #1 @ 2018-01-29T17:02:33.500 with 0 trxs
inita generated block dda0c96d... #2 @ 2018-01-29T17:02:34.000 with 0 trxs
inita generated block 0488dd37... #3 @ 2018-01-29T17:02:34.500 with 0 trxs
inita generated block 9028fea5... #4 @ 2018-01-29T17:02:35.000 with 0 trxs
inita generated block d90e35d8... #5 @ 2018-01-29T17:02:35.500 with 0 trxs
initb generated block 26119be5... #6 @ 2018-01-29T17:02:36.000 with 0 trxs
initb generated block 4c5794b1... #7 @ 2018-01-29T17:02:36.500 with 0 trxs
initb generated block d20af52c... #8 @ 2018-01-29T17:02:37.000 with 0 trxs
initb generated block cfea4c49... #9 @ 2018-01-29T17:02:37.500 with 0 trxs
initb generated block 099029a1... #10 @ 2018-01-29T17:02:38.000 with 0 trxs
initb generated block c96cc6ae... #11 @ 2018-01-29T17:02:38.500 with 0 trxs
initc generated block f556d75a... #12 @ 2018-01-29T17:02:39.000 with 0 trxs
~~~

## 참고자료
- [Local Environment - EOSIO/eos Wiki @ GitHub](https://github.com/EOSIO/eos/wiki/Local-Environment)
