---
layout: post
date: 2018-06-02
title: "Node.js 프로젝트와 React Native 프로젝트에 ESLint 적용해 보기"
tags: javascript eslint nodejs react-native develop note
image: https://sukso96100.github.io/blogimgs/apply-eslint-1.png
---
최근 학내에 있는 동아리에서 활동하면서, Javascript 기반의 프로젝트 두 가지에 참여하고 있습니다. 하나는 Node.js 프로젝트, 또 하나는 React Native 프로젝트 입니다. JS 는 다른 프로그래밍 언어에 비해 편리한 점도 있지만,
문법 체크가 엄격하지 않은 편이나 보니, 일관성이나 가독성이 좋지 않은 코드가 나오는 경우도 많습니다. 여러명에서 협업을 하면 코딩 스타일이 다른 점 때문에 같은 코드임에도 이해를 잘 못하는 경우가 있기도 합니다.(이는 JS 뿐만 아니라, 문법 체크가 엄격하지 않은 언어라면 마찬가지일 겁니다.) 제가 참여중인 두 프로젝트도 아주 심각하지는 않지만, 몇몇 문제점이 조금씩 보였습니다. 문자열 선언할 떄 어떤곳은 큰따옴표(Double Quotes, `"`)를 어떤곳은 작은 따옴표(Single Quotes, `'`)를 쓰고. 인덴트 처리도 어떤곳은 스페이스, 어떤곳은 탭. 세미콜론도 어떤곳은 있고, 어떤곳은 빠져있는 등. 제각각인 문제가 조금씩 있었습니다.

그래서 두 프로젝트 모두 이번 기회에 Linter 를 적용해서 문법이나 코딩 스타일 체크와 교정을 해 보기로 했습니다. (~~그대로 뒀다가는 나중에 마치 *유지보수하기 어렵게 코딩하는 방법:평생 개발자로 먹고 살 수 있다* 라는 책에 나오는 예제 코드처럼 될 위험이 있기에...~~) JSHint, JSLint 등의 다른 Linter 도 있지만, 아무래도 ESLint 가 문서화도 잘 되어있고 제공되는 기능과 플러그인으로 확장하기도 좋아 ESLint 를 사용하기로 했습니다.

## 설치
그냥 `npm` 혹은 `yarn` 을 사용하면 됩니다. 둘 다 JS 패키지 관리자 입니다. 요즘 JS 로 프로젝트 하면 필수적으로 쓰죠.
명령줄 도구로 쓰려면 Global 모듈로 설치하고, `package.json` 파일에 명령줄을 적어둔 후 나중에 `npm`, `yarn` 으로 바로 쓰려면 `dev` 의존성 모듈로 설치합니다.

```bash
# npm 사용하여 global 모듈로 설치
npm install -g eslint
# npm 사용하여 devDependencies 로 설치
npm install --save-dev eslint
# yarn 사용하여 global 모듈로 설치
yarn global add eslint
# yarn 사용하여 devDependencies 로 설치
yarn add --dev eslint
```

## 설정파일 생성
명령줄에서 프로젝트 경로에 접근한 다음, 아래 명령줄을 실행해서 설정을 시작합니다.

```bash
# global 모듈로 설치한 경우
eslint --init
# devDependencies 로 설치한 경우
./node_modules/.bin/eslint --init
```

그럼 몇가지 질문에 대한 응답을 통해 설정 파일을 생성할 수 있게 됩니다. 코딩 스타일에 대한 질문으로 설정하기, 인기있는 스타일 가이드 사용하기, 소스코드 분석하여 설정하기 등이 있습니다. 저는 여기서 첫번째인 *Answer questions about your style (코딩 스타일에 대한 질문에 응답)* 으로 설정했습니다.
Node.js 프로젝트에 대해 먼저 설정한다고 가정하고 진행해 보겠습니다.

```
? How would you like to configure ESLint? (Use arrow keys)
❯ Answer questions about your style 
  Use a popular style guide 
  Inspect your JavaScript file(s) 
```

ECMAScript 6(ES6) 기능(`const`, `let`, 화살표 함수 등)을 사용하냐고 물어보네요. 제가 참여중인 프로젝트는 사용중 이므로 `y` 라고 입력했습니다.

```
? Are you using ECMAScript 6 features? (y/N) 
```

ES6 모듈을 사용하냐는 질문입니다. Node.js 에서는 ES6 모듈이 아닌, CommonJS 모듈을 사용하므로 `n` 을 선택했습니다.

```
? Are you using ES6 modules? (y/N) 
```

코드 실행 환경에 대한 질문입니다. 제가 참여하는 Node.js 프로젝트는 프론트엔드 코드가 없습니다. `Node` 만 선택 했습니다.

```
? Where will your code run? (Press <space> to select, <a> to toggle all, <i> to inverse selection)
❯◉ Browser
 ◯ Node
```

JSX 를 사용하는지에 대한 질문입니다. JSX 는 XML, HTML 문법 형태로 레이아웃이나 화면 요소를 작성해서 JS 코드에 바로 넣으면 이를 JS 형태로 변환해주는 기능입니다. 주로 React 로 작성된 프론트엔드 코드에서 쉽게 볼 수 있습니다. 제가 참여중인 프로젝트에서는 사용하지 않으므로, `n` 을 선택 했습니다.

```
? Do you use JSX? (y/N) 
```

인덴트를 Tab 과 Space 중 무엇으로 처리하는지에 대한 질문입니다. 저는 `Tab` 을 선택 했습니다.

```
? What style of indentation do you use? (Use arrow keys)
❯ Tabs 
  Spaces 
```

문자열을 정의할 떄, 큰따옴표와 작은 따옴표 중 무엇을 사용하는지에 대한 질문입니다. 저는 `Double`(큰따옴표) 로 선택 했습니다.

```
? What quotes do you use for strings? (Use arrow keys)
❯ Double 
  Single 
```

줄바꿈 스타일에 대한 질문입니다. 보통 유닉스 스타일을 많이 사용하니, `Unix` 로 하였습니다.

```
? What line endings do you use? (Use arrow keys)
❯ Unix 
  Windows 
```

세미콜론 사용을 강제할지에 대한 질문입니다.

```
? Do you require semicolons? (Y/n) 
```

설정 파일을 어떤 포맷으로 저장할지에 대한 질문입니다. 저는 YAML 을 선택 했습니다.

```
? What format do you want your config file to be in? (Use arrow keys)
❯ JavaScript 
  YAML 
  JSON 
```

설정파일이 생성 되었습니다. 파일을 열어봅시다.

```
? How would you like to configure ESLint? Answer questions about your style
? Are you using ECMAScript 6 features? Yes
? Are you using ES6 modules? No
? Where will your code run? Node
? Do you use JSX? No
? What style of indentation do you use? Tabs
? What quotes do you use for strings? Double
? What line endings do you use? Unix
? Do you require semicolons? Yes
? What format do you want your config file to be in? YAML
Successfully created .eslintrc.yml file in /Users/youngbin/projects/skhu-backend
```
## 설정파일 열어보고 수정해 보기
아래와 같이 eslint 설정 파일이 생성된 것을 볼 수 있습니다.

```yaml
env:
  es6: true
  node: true
extends: 'eslint:recommended'
rules:
  indent:
    - error
    - tab
  linebreak-style:
    - error
    - unix
  quotes:
    - error
    - double
  semi:
    - error
    - always
```

설정 파일 구조를 간단히 살펴봅시다.

- `env` 는 eslint 상에서 쓰이는 전역 환경 값입니다. [*여기*](https://eslint.org/docs/user-guide/configuring#specifying-environments) 에서 사용 가능한 환경변수를 더 볼 수 있습니다.
    - `es6: true` - 앞서 설정 단계에서 ES6 기능 사용 설정을 했기 떄문에, 해당 변수인 `es6` 값이 `true` 로 되었습니다. ES 모듈을 제외한 나머지 ES6 기능을 켜고 코드 검사를 하도록 합니다.
    - `node: true` - Node.js 환경에서 실행되는 코드임을 명시합니다. Node.js 에서 추가적으로 쓰는 문법에 맞게 코드를 검사하도록 합니다.
- `extends` 를 사용해서 사전에 작성된 설정 셋을 기반 설정으로 사용할 수 있습니다. `eslint:recommended` 설정셋은 글자 그대로 eslint 에서 권장하는 설정값 입니다. 어떤 설정값이 적용되어 있는지는 [*여기*](https://eslint.org/docs/rules/) 에서 좌측에 체크 표시된 항목을 확인하시면 됩니다.
- `rules` - 코드 검사에 사용된 규칙입니다. 아까 질문에 답하면서 설정한 `indent`(인덴트 처리), `linebreak-style`(줄바꿈 스타일), `quotes`(문자열 정의에 쓰는 따옴표 종류), `semi`(세미콜론 강제 여부) 설정값이 포함되어 있습니다.

구조를 간단히 보았으니, 제가 참여중인 Node.js 프로젝트에 맞춰 설정값을 좀 더 추가해 보겠습니다. 

우선 프로젝트에서 `async` 와 `await` 키워드를 이용한 비동기 처리를 많이 하는데요, `async`, `await` 는 [ECMAScript 8 (혹은 ES2017)*](https://www.ecma-international.org/ecma-262/8.0/#sec-async-function-definitions) 에서 추가된 기능입니다. 그러므로, eslint 가 ES8 문법에 따라 검사하도록 하기 위해 다음을 추가합니다.

```yaml
parserOptions:
  ecmaVersion: 8
```

그리고 몇가지 규측을 좀 더 추가해 보겠습니다. 우선 변수 선언시, `var`키워드 사용을 금지하고, `let`, `const` 만 사용하도록 설정 했습니다.
프로젝트가 Node.js 10.x 버전대로 하기 때문에 ES6 문법 대다수 사용이 가능해서, `var` 사용할 필요가 없습니다.
이를 위해, `rules` 아래에 `no-var` 추가하고, 그 아래에 `error` 항목을 추가하여. `var` 사용을 오류로 간주하도록 합니다.

```yaml
...
rules:
...
  no-var:
    - error
```

비슷한 이유로, 콜백함수 작성 시 화살표 함수 사용을 강제 했습니다. `prefer-arrow-callback` 을 추가하고, 위반시 오류로 취급하도록 했습니다.

```yaml
...
rules:
...
  no-var:
    - error
  prefer-arrow-callback:
    - error
```

`console.log()`, `console.err()` 등의 로깅 함수 사용(`no-console`), 선언하고 사용하지 않은 변수(`no-unused-vars`), 한번만 할당하고 재할당이 없는 변수는 상수로 대신 선언(`prefer-const`) 등을 추가로 설정하고, 위반시 경고가 나오도록 `warn` 항목을 각 규칙 아래에 추가 했습니다.

```yaml
rules:
  ...
  no-console:
    - warn
  no-var:
    - error
  no-unused-vars:
    - warn
  prefer-const:
    - warn
  prefer-arrow-callback:
    - error
```

여기까지 추가로 수정한 부분이며, 수정이 완료된 설정파일을 아래와 같습니다. `rules` 부분에 추가 가능한 규칙은 [*여기*](https://eslint.org/docs/rules/) 에서 더 보실 수 있습니다.

```yaml
env:
  es6: true
  node: true
extends: 'eslint:recommended'
parserOptions:
  ecmaVersion: 8
rules:
  indent:
    - error
    - tab
  linebreak-style:
    - error
    - unix
  quotes:
    - error
    - double
  semi:
    - error
    - always
  no-console:
    - warn
  no-var:
    - error
  no-unused-vars:
    - warn
  prefer-const:
    - warn
  prefer-arrow-callback:
    - error
```

## 문법 검사와 지정 규칙에 따른 자동 수정
설정도 다 되었으니, ESLint 를 사용하여 코드를 검사해 봅시다. 명령줄 인자로 파일이나 디렉터리를 주어 검사를 할 수 있습니다.
아래 명령줄은 `app.js` 파일과 `routes` 디렉터리 내부의 소스코드를 모두 검사합니다.

```bash
# eslint 파일1 파일2 ... [명령줄 옵션]
eslint app.js routes/*
```

그러면 아래처럼, eslint 가 사전에 설정한 것에 따라 소스코드를 검사하면서 틀린 문법을 모두 잡아 보여줍니다. (내용이 너무 많아 일부만 넣었습니다.)
그럼 이제 오류가 나온 것을 보고 수정을 해서 코드 품질을 개선하면 됩니다.

```
...
/home/travis/build/s-owl/skhu-backend/routes/ph_form.js
   19:5   error    Unexpected var, use let or const instead  no-var
   29:5   error    Unexpected var, use let or const instead  no-var
   29:9   error    'i' is already defined                    no-redeclare
   30:2   error    'phantom' is not defined                  no-undef
   41:17  warning  'status' is defined but never used        no-unused-vars
   45:32  warning  'status' is defined but never used        no-unused-vars
   49:5   error    'document' is not defined                 no-undef
   53:4   error    'document' is not defined                 no-undef
   58:4   warning  Unexpected console statement              no-console
   59:4   error    'phantom' is not defined                  no-undef
   62:5   error    'document' is not defined                 no-undef
  100:4   warning  Unexpected console statement              no-console
  102:4   error    'phantom' is not defined                  no-undef
/home/travis/build/s-owl/skhu-backend/routes/scholarship/history.js
   5:24  warning  'next' is defined but never used  no-unused-vars
   6:2   warning  Unexpected console statement      no-console
  36:4   warning  Unexpected console statement      no-console
...
✖ 222 problems (73 errors, 149 warnings)
```

만약 코드 품질 개선을 위해 고쳐야 할 부분이 너무 많다면, `--fix` 옵션을 넣어, ESLint 가 자동으로 미리 설정한 규칙에 따라 모두 수정하도록 할 수 있습니다.
설정에 따라 사진처럼 인덴트 처리부터 키워드 사용까지 자동으로 전부 다 고쳐줍니다. 그렇다고 모든 파일을 완벽히 고쳐 주지는 않는데, ESLint 가 고쳐주지 못한 부분은 아쉽게도 직접 고쳐줘야 합니다.

![ESLint auto fix example](https://sukso96100.github.io/blogimgs/apply-eslint-1.png)

## React Native 프로젝트에서 사용하기
React Native 에서 사용하려면, 몇가지 패키지를 추가로 설치하고 설정값도 몇가지 더 추가 해줘야 합니다.
우선 패키지를 먼저 추가적으로 설치하겠습니다. `babel-eslint`, `eslint-plugin-react`, `eslint-plugin-react-native` 패키지를 설치합니다.
앞서 eslint 를 어떻게 설치했는지와 프로젝트에서 사용하는 패키지 관리자에 따라 다르게 설치하면 됩니다. 저희 경우 React Native 프로젝트 의존성 패키지 관리에 `yarn` 을 사용하며, `package.json` 에 스크립트를 넣을 예정이므로 아래와 같이 실행 하였습니다.

```bash
yarn add --dev babel-eslint eslint-plugin-react eslint-plugin-react-native
```

초기에 설정파일 생성시에는 아래와 같이 답변합니다.

```bash
? How would you like to configure ESLint? Answer questions about your style
? Are you using ECMAScript 6 features? Yes # React, React Native 는 ES6 기능 대부분 사용
? Are you using ES6 modules? Yes # React, React Native 는 ES6 모듈 사용
? Where will your code run? Browser # 브라우저 환경
? Do you use CommonJS? No # React, React Native 는 ES6 모듈 사용
? Do you use JSX? Yes # React, React Native 는 JSX 로 화면 레이아웃 정의
? Do you use React? Yes # 당연히 Yes
? What style of indentation do you use? Tabs # 여기서 부터는 본인 프로젝트 스타일에 따라 답변
? What quotes do you use for strings? Double
? What line endings do you use? Unix
? Do you require semicolons? Yes
? What format do you want your config file to be in? YAML
```

그러면 아래와 같이 설정파일에 생성됩니다. 여기에 설정값을 조금 더 추가해야 합니다.

```yaml
env:
  browser: true
  es6: true
extends: 'eslint:recommended'
parserOptions:
  ecmaFeatures:
    experimentalObjectRestSpread: true
    jsx: true
  sourceType: module
plugins:
  - react
rules:
  indent:
    - error
    - tab
  linebreak-style:
    - error
    - unix
  quotes:
    - error
    - double
  semi:
    - error
    - always
```

먼저 `babel-eslint` 를 `parser` 로 설정합니다. [*eslint 의 기본 parser 인 `espree` 는 React Native 프로젝트에서 종종 쓰이는 정적 속성을 지원하지 않습니다.*](https://github.com/yannickcr/eslint-plugin-react/issues/43#issuecomment-107101415) 아래과 같은 줄을 추가합니다.

```yaml
...
extends: 'eslint:recommended'
parser: babel-eslint # 이 줄 추가
parserOptions:
...
```

React Native 의 테스트 코드도(`App.test.js` 등) 같이 검사 하시려면, `env` 에 `jest` 를 추가하고 이를 `true` 로 합니다. 
React Native 에서 테스트 프레임워크로 쓰는 Jest 지원을 켜고 검사를 하도록 합니다.

```yaml
env:
  browser: true
  es6: true
  jest: true # 이 줄 추가
...
```

`plugins` 에 `react-native` 항목을 추가해서 React Native 에서 사용하는 추가적인 문법 지원을 켜고 검사 하도록 합니다.
필요한 경우, [*ESLint 용 React Native 플로그인에서 지원하는 규칙*](https://github.com/intellicode/eslint-plugin-react-native#list-of-supported-rules)을 추가하여 사용이 가능합니다.

```yaml
plugins:
  - react
  - react-native # 이 줄 추가
...
```

명령줄 실행을 통한 코드 검사는 앞서 설명한 방식으로 하면 됩니다.

## `package.json` 에 스크립트로 추가하여 사용하기
`package.json` 의 `script` 부분에 추가하여, `npm` 또는 `yarn` 으로 ESLint 가 실행되도록 할 수 있습니다.
아래는 예시 입니다. `"lint": "eslint *.js src/*"`와 `"lint-fix": "eslint *.js src/* --fix"`를 추가 했습니다.

```json
{
  "name": "app",
  "version": "0.1.0",
  "private": true,
  "devDependencies": {
    ...
  },
  "scripts": {
    ...
    "lint": "eslint *.js src/*", 
    "lint-fix": "eslint *.js src/* --fix"
  },
  "jest": {
    "preset": "react-native"
  },
  "dependencies": {
    "react": "16.2.0",
    "react-native": "0.55.3",
    ...
  }
}

```

그러면 이제 아래과 같이 실행하여 ESLint 로 코드 검사를 하도록 할 수 있습니다.

```bash
# 코드 검사 - npm
npm run lint
# 코드 검사 및 자동 수정 - npm
npm run lint-fix
# 코드 검사 - yarn
yarn run lint
# 코드 검사 및 자동 수정 - yarn
yarn run lint-fix
```

## Visual Studio Code 에서 사용하기
Visual Studio Code 를 사용한다면, [*ESLint 확장기능*](https://github.com/Microsoft/vscode-eslint)을 설치해서 프로젝트에 있는 ESLint 설정파일(`.eslintrc` 등)에 나와있는 규칙에 따라 코드를 검사하고, 검사 결과에 따른 문제를 편집기 상에 바로 표시하도록 할 수 있습니다.
VSCode 의 확장기능 창에서 ESLint 를 검색해 나오는 것을 설치한 뒤 나오는 플러그인을 설치하고 VSCode 를 다시 로드 하면 바로 사용이 가능합니다. 필요에 따라 [*확장기능 설정을 변경해 자동 수정 기능 등을 사용할 수 있습니다.*](https://github.com/Microsoft/vscode-eslint#settings-options)

## Travis CI, GitLab CI 에 연동하여 사용하기
ESLint 로 코드 검사를 해서, 정해진 규칙에 따라 코드를 수정해 가며 코드 품질을 관리하는 이유는 앞에서도 말했지만, 여려명에서 작업을 하는 경우 때문이죠.
이런 경우에 로컬에서(본인 노트북이나 데스크톱) 에서 검사를 돌리는 것도 좋지만, GitHub 나 GitLab 저장소를 통해 소스코드를 공유하고 브랜치를 나눠서 관리한다면, CI 연동을 통해 새 커밋이나 새 Pull Request 가 올라올 때 마다 자동으로 코드 검사를 수행하도록 하면 더 좋을 것입니다. 브랜치 병합을 등을 하기 앞서 다시 한번 확인할 수 있으니까요.

GitHub 저장소의 경우, 보통 Travis CI 를 연동해서 사용합니다. 프로젝트 최상위 루트에 `.travis.yml` 파일을 생성합니다.
그리고 열어서 아래와 같이 작성합니다. 아래 코드는 `npm` 을 사용하는 Node.js 프로젝트에 사용하는것을 가정하고 작성한 코드입니다.
작성한 뒤, 커밋하여 저장소에 푸시하고. [*여기*](https://docs.travis-ci.com/user/getting-started/) 를 참고해서, Travis CI 가 해당 저장소와 연동 되도록 설정합니다.

```yaml
language: node_js # 언어는 Node.js 로
node_js:
  - "10" # 버전은 10.x
install: # 스크립트 실행 전 설치 작업
  - npm install # 스크립트 실행 전 의존성 설치
script: # CI 본 스크립트
  - npm run lint # package.json 에 정의해 둔 lint 명령 실행
```

GitLab 의 경우는, GitLab 에 GitLab CI 가 내장되어 있어 이를 많이 사용합니다. GitLab CI 의 경우 기본적으로 모든 저장소에 활성화가 되어 있으므로, `.gitlab-ci.yml` 파일을 작성하여 커밋하고 푸시만 해 주면 별도 설정 없이 자동으로 작동합니다.
이번에는 `yarn` 의존성을 관리하는 React Native 프로젝트용으로 작성하였습니다. 큰 차이는 없습니다.

```yaml
image: node:latest # Docker Hub 의 node:latest 이미지 환경 기반으로 실행

lint: # lint 라는 작업 정의
  before_script: # 스크립트 실행 전 작업
    - npm install -g yarn # yarn 설치
    - yarn install # yarn 으로 의존성 설치
  script: # lint 작업의 CI 본 스크립트
    - yarn run lint # package.json 에 정의해 둔 lint 명령 실행
```

적용 후, 사진처럼 각 커밋마다 CI 작동하여 ESLint 가 코드 검사를 수행하는 것을 볼 수 있습니다.

![travis-ci](https://sukso96100.github.io/blogimgs/apply-eslint-2.png)
![travis-ci](https://sukso96100.github.io/blogimgs/apply-eslint-3.png)

## 마무리
이렇게 해서 ESLint 를 두 JS 프로젝트에 적용 해 보고, CI 연동까지 간단히 해 보았습니다. ESLint 를 적용하면서 ESLint 보고에 따라 수정 작업(autofix 랑 필요에 따라 수동 수정 까지)도 같이 했는데요, 하고 나니 확실히 원래 코드보다 보기도 좋고, 일관성도 좋아져서 코드가 많이 개선 되었습니다. 규칙 검사가 자동이니 이제 코드 리뷰 하는 시간도 어느정도 단축이 가능해 질 듯 합니다. 여러분들도 JavaSciprt 프로젝트를 하신다면, 그리고 그 프로젝트가 팀 프로젝트라면 ESLint 를 한번 적용해 보시기 바랍니다. 코드도 깔끔히 잘 정리해 주고, 많이 하는 실수 등도 잘 잡아줘서, 한번 적용 해 두면 많은 시간 절약이 가능할 겁니다.

## 참고 링크
- [ESLint - The pluggable linting utility for JavaScript and JSX](https://eslint.org/)
- [Getting Started with ESLint](https://eslint.org/docs/user-guide/getting-started)
- [Configuring ESLint](https://eslint.org/docs/user-guide/configuring)
- [Rules - ESLint](https://eslint.org/docs/rules/)
- [Integrations - ESLint](https://eslint.org/docs/user-guide/integrations)
- [ECMAScript® 2017 Language Specification (ECMA-262, 8th edition, June 2017) - 14.6 Async Function Definitions](https://www.ecma-international.org/ecma-262/8.0/#sec-async-function-definitions)
- [full classes compatibility (with static properties) #43 - yannickcr/eslint-plugin-react - GitHub](https://github.com/yannickcr/eslint-plugin-react/issues/43#issuecomment-107101415)
- [intellicode/eslint-plugin-react-native - GitHub](https://github.com/intellicode/eslint-plugin-react-native)
- [Microsoft/vscode-eslint - GitHub](https://github.com/Microsoft/vscode-eslint)
- [Getting eslint right in React Native - Medium](https://medium.com/the-react-native-log/getting-eslint-right-in-react-native-bd27524cc77b)
- [Intellicode/eslint-plugin-react-native - GitHub](https://github.com/Intellicode/eslint-plugin-react-native)
- [yannickcr/eslint-plugin-react - GitHub](https://github.com/yannickcr/eslint-plugin-react#list-of-supported-rules)
- [babel/babel-eslint - GitHub](https://github.com/babel/babel-eslint)