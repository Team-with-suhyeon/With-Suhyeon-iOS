//
//  SignUpFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import Foundation
import Combine

class SignUpFeature: Feature {
    struct State {
        var userId: Int = 0
        var progress: Double = 0.0
        var isAgree: Bool = false
        var buttonState: WithSuhyeonButtonState = .disabled
        
        var phoneNumber: String = ""
        var authCode: String = ""
        var isAuthButtonEnabled: Bool = false
        var isAuthNumberCorrect: Bool = false
        var phoneAuthStep: PhoneAuthStep = .enterPhoneNumber
        var isExistsUser: Bool = false
        var errorMessage: String = ""
        var isAuthCodeRequest: Bool = false
        
        var nickname: String = ""
        var isNicknameValid: Bool = false
        var nicknameErrorMessage: String? = nil
        
        var birthYear: Int = 2006
        var isYearSelected: Bool = false
        
        var gender: String = ""
        var isGenderSelected: Bool = false
        var genderImages: [GenderImage] = [
            GenderImage(defaultImage: .imgBoyDefault, selectedImage: .imgBoySelected),
            GenderImage(defaultImage: .imgGirlDefault, selectedImage: .imgGirlSelected)
        ]
        
        var profileImages: [ProfileImage] = [
            ProfileImage(
                beforeImage: .imgBlueSumaBefore,
                defaultImage: .imgBlueSuma,
                selectedImage: .imgBlueSumaBorder
            ),
            ProfileImage(
                beforeImage: .imgPurpleSumaBefore,
                defaultImage: .imgPurpleSuma,
                selectedImage: .imgPurpleSumaBorder
            ),
            ProfileImage(
                beforeImage: .imgRedSumBefore,
                defaultImage: .imgRedSuma,
                selectedImage: .imgRedSumaBorder
            ),
            ProfileImage(
                beforeImage: .imgGreenSumaBefore,
                defaultImage: .imgGreenSuma,
                selectedImage: .imgGreenSumaBorder
            )
        ]
        
        var profileImageStates: [ImageState] = [.unselected, .unselected, .unselected, .unselected]
        var selectedProfileImageIndex: Int? = nil
        var isProfileImageSelected: Bool = false
        
        var locationOptions: [Region] = []
        var mainLocationIndex: Int = -1
        var subLocationIndex: Int? = nil
        var isLocationSelected: Bool {
            return subLocationIndex != nil
        }
    }
    
    struct ProfileImage {
        let beforeImage: WithSuhyeonImage
        let defaultImage: WithSuhyeonImage
        let selectedImage: WithSuhyeonImage
    }
    
    struct GenderImage {
        let defaultImage: WithSuhyeonImage
        let selectedImage: WithSuhyeonImage
    }
    
    enum PhoneAuthStep {
        case enterPhoneNumber
        case enterAuthCode
        case completed
    }
    
    enum ImageState {
        case unselected
        case selected
        case confirmed
    }
    
    enum Intent {
        case tapBackToStart
        case tapButton
        case tapBackButton
        case updatePhoneNumber(String)
        case requestAuthCode
        case updateAuthCode(String)
        case validateAuthCode
        case updateNickname(String)
        case selectedYear(Int)
        case selectedGender(String)
        case selectedProfileImage(Int)
        case confirmProfileImage
        case updateLocation(Int, Int)
        case completeSignUp
        case enterScreen
        case tapServiceTerms
        case tapPrivacyPolicy
    }
    
    enum SideEffect {
        case navigateToSignUpComplete(String)
        case navigateToStartView
        case hideKeyboard
        case navigateToWebView(url: URL, title: String)
    }
    
    @Published private(set) var state = State()
    @Published var currentContent: SignUpContentCase = .termsOfServiceView
    private var cancellables = Set<AnyCancellable>()
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    @Inject var nicknameValidateUseCase : NickNameValidateUseCase
    @Inject var authRepository: AuthRepository
    @Inject var getRegionsUseCase: GetRegionsUseCase
    @Inject private var signUpUseCase: SignUpUseCase
    @Inject private var oauthRepository: OAuthRepository
    
    init(userId: Int) {
        state.userId = userId
        
        bindIntents()
        updateProgress()
        receiveState()
    }
    
    private func bindIntents() {
        intentSubject.sink { [weak self] intent in
            self?.handleIntent(intent)
        }.store(in: &cancellables)
    }
    
    private func receiveState() {
        $state.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateButtonState()
            }
        }.store(in: &cancellables)
        
        $currentContent.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateButtonState()
            }
        }.store(in: &cancellables)
    }
    
    func send(_ intent: Intent) {
        intentSubject.send(intent)
    }
    
    func handleIntent(_ intent: Intent) {
        switch intent {
        case .tapBackToStart:
            sideEffectSubject.send(.navigateToStartView)
        case .tapButton:
            switch currentContent {
            case .authenticationView:
                validateAuthCode()
            default:
                moveToNextStep()
            }
        case .tapBackButton:
            if currentContent == .termsOfServiceView {
                sideEffectSubject.send(.navigateToStartView)
            } else {
                moveToPreviousStep()
            }
        case .updatePhoneNumber(let phoneNumber):
            updatePhoneNumber(phoneNumber)
        case .requestAuthCode:
            requestAuthCode()
        case .updateAuthCode(let authCode):
            updateAuthCode(authCode)
        case .validateAuthCode:
            validateAuthCode()
        case .updateNickname(let nickname):
            updateNickname(nickname)
        case .selectedYear(let year):
            selectedBirthYear(year)
        case .selectedGender(let gender):
            selectedGender(gender)
        case .selectedProfileImage(let index):
            updateProfileImageState(selectedIndex: index)
        case .confirmProfileImage:
            confirmProfileImage()
        case .updateLocation(let mainLocationIndex, let subLocationIndex):
            updateLocation(mainLocationIndex, subLocationIndex)
        case .completeSignUp:
            completeSignUp()
        case .enterScreen:
            getLocationOptions()
        case .tapServiceTerms:
            if let url = URL(string: "https://serious-option-36e.notion.site/Service-Terms-of-Use-1d7640cebba080c1b094cd33de1e117d?pvs=74") {
                sideEffectSubject.send(.navigateToWebView(url: url, title: "서비스 이용약관"))
            }
            
        case .tapPrivacyPolicy:
            if let url = URL(string: "https://serious-option-36e.notion.site/Privacy-Policy-1d7640cebba080f9b5eaec2cb6f0e3da?pvs=74") {
                sideEffectSubject.send(.navigateToWebView(url: url, title: "개인정보처리방침"))
            }
            
        }
    }
    
    private func updateAuthButtonState() {
        switch state.phoneAuthStep {
        case .enterPhoneNumber:
            state.isAuthButtonEnabled = state.phoneNumber.count >= 11 && !state.isExistsUser
        default:
            state.isAuthButtonEnabled = false
        }
    }
    
    private func updatePhoneNumber(_ phoneNumber: String) {
        if(phoneNumber.count > 11) {
            state.phoneNumber = String(phoneNumber.prefix(11))
            return
        }
        state.phoneNumber = phoneNumber
        state.isExistsUser = false
        state.phoneAuthStep = .enterPhoneNumber
        state.errorMessage = ""
        updateAuthButtonState()
    }
    
    private func requestAuthCode() {
        guard !state.isAuthCodeRequest else { return }
        state.isAuthCodeRequest = true
        
        authRepository.sendAuthCode(flow: "signup", phoneNumber: state.phoneNumber) { [weak self] result in
            DispatchQueue.main.async {
                self?.state.isAuthCodeRequest = false

                switch result {
                case .success:
                    self?.state.phoneAuthStep = .enterAuthCode
                    self?.state.authCode = ""
                    self?.state.isExistsUser = false
                    self?.state.isAuthButtonEnabled = false
                    print("✅ 회원가입 인증번호 요청 성공")
                case .failure(let error):
                    print("인증번호 요청 실패: \(error.localizedDescription)")
                    self?.state.isExistsUser = true
                    self?.state.isAuthButtonEnabled = false
                }
            }
        }
        
        updateAuthButtonState()
    }
    
    private func validateAuthCode() {
        authRepository.validateAuthCode(flow: "signup", authCode: state.authCode, phoneNumber: state.phoneNumber) { [weak self] result in
            switch result {
            case .success:
                self?.state.isAuthNumberCorrect = true
                self?.state.phoneAuthStep = .completed
                self?.state.errorMessage = ""

                self?.moveToNextStep()
                print("✅ 회원가입 인증번호 검증 성공")
            case .failure(let error):
                print("실패실패실패")
                self?.state.isAuthNumberCorrect = false
                
                if let networkError = error as? NetworkError {
                    switch networkError {
                    case .userNotRegistered:
                        self?.state.errorMessage = "등록된 회원이 아니에요"
                    case .userAlreadyRegistered:
                        self?.state.errorMessage = "이미 가입된 번호에요"
                    case .invalidCertificationNumber:
                        self?.state.errorMessage = "인증번호를 다시 확인해주세요"
                    case .expiredCertificationNumber:
                        self?.state.errorMessage = "인증번호가 만료되었어요"
                    default:
                        self?.state.errorMessage = ""
                    }
                } else {
                    self?.state.errorMessage = "서버 에러가 발생했어요"
                }
                self?.state.isExistsUser = false
            }
            self?.updateButtonState()
        }
    }
    
    private func updateAuthCode(_ authCode: String) {
        if authCode.count > 6 {
            state.authCode = String(authCode.prefix(6))
            return
        }
        
        state.authCode = authCode
        state.isAuthNumberCorrect = false
        state.errorMessage = ""
        
        updateAuthButtonState()
    }
    
    private func moveToNextStep() {
        if let currentIndex = SignUpContentCase.allCases.firstIndex(of: currentContent),
           currentIndex < SignUpContentCase.allCases.count - 1 {
            currentContent = SignUpContentCase.allCases[currentIndex + 1]
            updateProgress()
            sideEffectSubject.send(.hideKeyboard)
        }
    }
    
    private func moveToPreviousStep() {
        if let currentIndex = SignUpContentCase.allCases.firstIndex(of: currentContent),
           currentIndex > 0 {
            currentContent = SignUpContentCase.allCases[currentIndex - 1]
            updateProgress()
        }
    }
    
    private func updateProgress() {
        if let currentIndex = SignUpContentCase.allCases.firstIndex(of: currentContent) {
            state.progress = Double(currentIndex + 1) / Double(SignUpContentCase.allCases.count) * 100
        }
    }
    
    private func updateButtonState() {
        let newButtonState: WithSuhyeonButtonState
        
        switch currentContent {
        case .termsOfServiceView :
            newButtonState = state.isAgree ? .enabled : .disabled
        case .authenticationView :
            if state.phoneAuthStep == .enterPhoneNumber {
                newButtonState = .disabled
            } else if state.phoneAuthStep == .enterAuthCode {
                newButtonState = (state.authCode.count == 6) ? .enabled : .disabled 
            } else {
                newButtonState = .disabled
            }
        case .nickNameView :
            newButtonState = state.isNicknameValid ? .enabled : .disabled
        case .genderView :
            newButtonState = state.isGenderSelected ? .enabled : .disabled
        case .profileImageView :
            newButtonState = state.isProfileImageSelected ? .enabled : .disabled
        case .activeAreaView :
            newButtonState = state.isLocationSelected ? .enabled : .disabled
        default:
            newButtonState = .enabled
        }
        
        guard state.buttonState != newButtonState else {
            return
        }
        
        state.buttonState = newButtonState
    }
    
    func changeSelectedContent(signUpContentCase: SignUpContentCase) {
        currentContent = signUpContentCase
    }
    
    func updateIsAgree(_ newValue: Bool) {
        state.isAgree = newValue
    }
    
    private func updateNickname(_ nickname: String) {
        state.nickname = nickname
        
        if nickname.count < 2 {
            state.isNicknameValid = false
            state.nicknameErrorMessage = nil
        } else if nickname.count > 12 {
            state.isNicknameValid = false
            state.nicknameErrorMessage = "12자까지 입력할 수 있어요"
        } else if !nicknameValidateUseCase.execute(nickname) {
            state.isNicknameValid = false
            state.nicknameErrorMessage = "특수기호를 제거해주세요"
        } else {
            state.isNicknameValid = true
            state.nicknameErrorMessage = nil
        }
        
        updateButtonState()
    }
    
    func selectedBirthYear(_ year: Int) {
        state.birthYear = year
        state.isYearSelected = true
    }
    
    func selectedGender(_ gender: String){
        state.gender = gender
        state.isGenderSelected = true
        
        updateButtonState()
    }
    
    func updateProfileImageState(selectedIndex: Int) {
        state.profileImageStates = state.profileImageStates.map { _ in .unselected }
        
        state.profileImageStates[selectedIndex] = .selected
        state.selectedProfileImageIndex = selectedIndex
        state.isProfileImageSelected = true
        
        updateButtonState()
    }
    
    func confirmProfileImage() {
        if let selectedIndex = state.selectedProfileImageIndex {
            state.profileImageStates[selectedIndex] = .confirmed
        }
    }
    
    func updateLocation(_ mainIndex: Int, _ subIndex: Int) {
        state.mainLocationIndex = mainIndex
        
        if mainIndex == 0 {
            state.subLocationIndex = 0
        } else{
            state.subLocationIndex = subIndex
        }
        updateButtonState()
    }
    
    private func completeSignUp() {
        guard let member = createSignUpMemberInfo() else {
            return
        }
        
        signUpUseCase.execute(member: member) { [weak self] result in
            switch result {
            case .success:
                print("✅ 회원가입, 로그인 성공")
                self?.sideEffectSubject.send(.navigateToSignUpComplete(self?.state.nickname ?? ""))
            case .failure(let error):
                print("❌ 회원가입/로그인 실패: \(error)")
            }
        }
    }
    
    private func createSignUpMemberInfo() -> Member? {
        let profileImage = state.profileImages[state.selectedProfileImageIndex!].defaultImage.rawValue
        let region = state.locationOptions[state.mainLocationIndex].subLocation[state.subLocationIndex ?? 0]
        
        return Member(
            phoneNumber: state.phoneNumber,
            nickname: state.nickname,
            birthYear: state.birthYear,
            gender: state.gender == "남성",
            profileImage: profileImage,
            region: region,
            userId: state.userId
        )
    }
    
    private func getLocationOptions() {
        getRegionsUseCase.execute { [weak self] result in
            self?.state.locationOptions = result
        }
    }
}
