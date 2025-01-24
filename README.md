# 수현이랑
![image](https://github.com/user-attachments/assets/a0b289d6-2de6-4600-8ebd-0eaf8987d440)

## 🅿️ 프로젝트 설명 
완벽하게 엄빠 몰래 가는 여행 **수현이랑**</br></br>

## 📍 주요 기능 
- **여행지에서 미션을 수행해 줄 “수현이”를 찾는 “수현이 찾기” 기능**
- **필요한 사진을 다운로드, 업로드 할 수 있는 “갤러리” 기능**
- **“수현이”와의 약속을 잡을 수 있는 1:1 “채팅” 기능**

- **핵심기능 1) 수현이 찾기**: 연인과의 완벽한 여행을 위해 가짜친구 역할을 해줄 수 있는 다른 사용자를 매칭해줍니다.
- **핵심기능 2) 공유앨범**: 지금 당장 여행 인증 사진이 필요하다면 공유 앨범에서 자신의 상황에 맞는 사진을 찾아볼 수 있습니다.
</br></br>

## 👤 팀원별 역할 분담

| ![상욱](https://github.com/user-attachments/assets/156d76f9-7065-468b-96eb-45bf2185c414)|![지원](https://github.com/user-attachments/assets/6d11d016-991a-4efd-89fd-0506afead861)|![예지](https://github.com/user-attachments/assets/42115edb-6f9f-4fe7-b07f-e49980fe8fc6)|
|:---------:|:---------:|:---------:|
|👑[우상욱](https://github.com/Sangwook123)|[정지원](https://github.com/codeJiwon)|[김예지](https://github.com/mnbvcxzyj)|
| `홈, 갤러리, 채팅` | `수현이 찾기` | `회원가입, 로그인, 차단 번호` | </br>

## ⚙️ 기술 및 아키텍쳐
+ `IDE - Xcode 16.2`</br>
+ `SwiftUI`</br>
+ `Architecture - MVI, Clean Architecture`</br>
+ `Network - Alamofire`</br>
+ `Asynchronous - Combine`</br>
+ `Image - KingFisher`</br>


### 의존성 역전 원칙을 기반으로 한 Clean Architecture 구조 채택

![image-12](https://github.com/user-attachments/assets/3f0814fb-79bd-4721-8f0a-6d1a04ee7b83)

- **도입 이유 -** 앱의 확장성과 유지보수성을 높이기 위해, 각 레이어의 책임을 명확히 하고, 의존성 관리의 효율성을 높이기 위해 채택. 또한, 기능별로 독립적인 변경이 가능하여 새로운 기능 추가 및 변경이 용이하고, 테스트가 쉬운 구조로 개선.
- 앱잼의 한정된 기간으로 인해 모듈화 x 단순 폴더 구조로 구현 → 추후에 모듈화 가능
- `Domain` 을 가장 고수준 레이어로 두고, 그외 `Infra Structure` 가 `Domain`을 참조
- 이외의 여러 레이어에서 참조하는 기능은, 기능별로 `Core`에 작성
- 추상화를 기반으로 하기때문에, 별도의 `DIContainer` 에서 앱 내 의존성 관리 후 `property wrapper`로 의존성 주입 구현

![image](https://github.com/user-attachments/assets/251084cd-7791-43d5-9b11-5eb07034ab22)
</br></br>
### 단방향 아키텍쳐 MVI 채택

- 도입 이유 - 상태의 관리가 중요한 선언형 UI 특성으로 인해, MVC, MVVM 등 여타 디자인 패턴에서의 상태 변경 로직의 파편화로 인한 추적 및 상태관리의 어려움, 이를 상태의 변경을 한 곳에서 집중관리하고, 데이터의 흐름을 일방향으로 유지하는 방식으로 해결하기 위함.
- MVI 흐름은 사용자의 `Intent`(의도)만을 `Reducer`에 전달 → `Reducer`가 상태를 갱신 → 갱신된 상태가 `View`에 리렌더링 → 상태 변경에 따라 필요한 `SideEffect`가 실행

![image](https://github.com/user-attachments/assets/0cde2b6a-1df5-46c0-a209-8f239da7e1a0)
</br></br>
### 채팅기능 구현을 위한 웹소켓 프로토콜 채택

- 도입 이유 - 실시간 메시지 전송 및 즉각적인 반응이 중요한 채팅 기능에서, 웹소켓을 선택한 이유는 지속적인 연결을 유지하면서 서버와 클라이언트 간 빠르고 효율적인 데이터 교환을 가능하게 하기 위함. 이를 통해 높은 빈도의 메시지 처리와 실시간 알림을 효과적으로 구현할 수 있음.
- 서버와 클라이언트 간의 지속적인 연결을 유지 → 클라이언트가 메시지를 보내면 서버가 즉시 응답 → 서버가 새로운 메시지를 클라이언트에 실시간으로 전달.
</br></br>
### 네비게이션 라우터 방식 채택

- **도입 이유 -** 네비게이션 흐름을 중앙 집중적으로 관리하고, 화면 전환 로직을 하나의 객체에서 처리함으로써 복잡한 화면 전환을 효율적으로 관리하기 위함. 또한, 상태 변화가 명확하게 추적될 수 있어 디버깅과 유지보수가 용이해짐.
- 화면 전환을 담당하는 `RouterRegistry`가  `Path`를 관리 → `navigate(to:)` 메서드로 새로운 목적지로 네비게이션 → `popBack()`으로 이전 화면으로 돌아가기 → `currentDestination()`으로 현재 화면 확인 → 필요시 `replaceWith(_:)`로 목적지 변경
</br></br>

## ❗ 컨벤션 규칙 및 브랜치 전략

**깃 컨벤션:**  [Git Convention]() </br>
**코드 컨벤션:**  [Code Convention]() </br>
**브랜치 전략:**  [Branch Strategy]() </br></br>

## 프로젝트 구조
앱잼의 한정된 기간으로 인해 모듈화 x 단순 폴더 구조로 구현 → 추후에 **모듈화** 가능
```
├── WithSuhyeon-iOS
│   ├── Application                 // 애플리케이션 레벨 설정
│   │   ├── DIContainer+.swift      // 의존성 주입 컨테이너
│   │   └── WithSuhyeon_iOSApp.swift 
│   ├── Config                      // 환경 설정 파일 (.xcconfig)
│   │   ├── Dev.xcconfig            // 개발 환경 설정
│   │   └── Release.xcconfig        // 릴리즈 환경 설정
│   ├── Core                        // 앱의 공통 모듈 기능
│   │   ├── Common                  // 공통 유틸리티
│   │   │   ├── Configuration.swift // 공통 설정 파일
│   │   │   └── Extension          
│   │   ├── DIContainer             // 의존성 주입 관련 파일
│   │   │   ├── DIContainer.swift   // 의존성 주입 컨테이너 정의
│   │   │   └── Inject.swift        // Property Wrapper로 의존성 주입 구현
│   │   ├── DesignSystem            // 공통 UI 컴포넌트 및 리소스
│   │   │   ├── Component           // 재사용 가능한 UI 컴포넌트
│   │   │   │   ├── CustomDatePicker.swift
│   │   │   │   ├── WithSuhyeonAlert.swift
│   │   │   ├── Foundation          // Color, Font
│   │   │   ├── Modifier            // SwiftUI Modifier
│   │   │   └── Resource            // 앱 리소스 (Assets, Images)
│   │   ├── KeyChain                // Keychain 관리
│   │   ├── Network                 // 네트워크 관련 파일
│   │   │   ├── AuthInterceptor.swift // 인증 관련 네트워크 인터셉터
│   │   │   ├── NetworkClient.swift  // 네트워크 요청 클라이언트
│   │   │   └── 기타 파일들          // 네트워크 요청 처리 관련 파일
│   │   ├── Router                  // 화면 전환 관리
│   │   │   ├── Router.swift        // 라우팅 관리
│   │   │   └── RouterRegistry.swift // 네비게이션 경로 정의
│   │   ├── Socket                  // WebSocket 클라이언트
│   │   │   ├── WebSocketClient.swift
│   │   │   ├── WebSocketTarget.swift
│   │   └── UI                      // 공통 UI 유틸리티
│   │       ├── Extension           
│   │       ├── Feature.swift       // 상태 관리 모델
│   │       └── ObservableScrollView.swift // 스크롤 상태 감지
│   ├── Data                        // 데이터 레이어 (Infra 역할)
│   │   ├── 각 도메인 폴더들         // Auth, BlockingAccount, Chat 등
│   │   │   ├── Model               // DTO 및 데이터 모델 정의
│   │   │   ├── Repository          // repository 구현체
│   │   │   └── Source              // API 작성 
│   ├── Domain                      // 도메인 레이어 (비즈니스 로직)
│   │   ├── 각 도메인 폴더들         // Auth, BlockingAccount, Chat 등
│   │   │   ├── Entity              // 비즈니스 엔터티
│   │   │   ├── Repository          // repository protocol
│   │   │   └── UseCase             // UseCase 정의 (비즈니스 로직)
│   ├── Presentation                // Presentation 레이어 (UI, MVI 상태 관리)
│   │   ├── 각 화면 폴더들           // Chat, Gallery, Home 등
│   │   │   ├── Feature             // MVI 상태 관리 로직
│   │   │   ├── Component           // 화면별 UI 컴포넌트
│   │   │   ├── View                // SwiftUI 화면
```
**레이어별 역할**

1. `Domain` 
    - 핵심 비즈니스 로직을 포함하고 있는 가장 고수준의 레이어
    - 구성 요소
        - Entity : 비즈니스 로직에서 사용하는 데이터 모델
        - Repository Protocol : 데이터를 가져오는 방식에 대한 추상화 프로토콜
        - UseCase : 비즈니스 로직 캡슐화하여 제공
</br></br>
2. `Data`
    - 실제 데이터 관리, Infra 구조의 역할, Domain을 참조하여 Repository protocol 구현
    - 구성 요소
        - Model : 네트워크와 DB의 DTO 정의
        - Repository : 데이터 프로토콜 구현체
        - Source : API 호출 등의 데이터 소스 처리
</br></br>
3. `Core`
    - 여러 레이어에서 사용하는 공통 유틸리티와 기능 작성
    - 구성 요소
        - Common : 전역 사용 유틸리티 작성
        - DIContainer : 의존성 주입 관리
        - DesignSystem : 공용 컴포넌트 및 리소스
        - Router : 화면 전환 관리
</br></br>
4. `Presentation`
    - UI 및 상태 관리
    - 구성 요소
        - Feature : 화면별 state, intent, side effect 정의
        - Component : UI 컴포넌트
        - View : View 화면
</br></br>

## 👨‍👩‍👧‍👦 파트원 사진
<img src="https://github.com/user-attachments/assets/12c285eb-561e-4309-91f4-642b7bd467a1" width="700"></br>



