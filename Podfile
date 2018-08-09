# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'hotnono' do
  
    use_frameworks! # 스위프트를 사용하지 않고 동적 라이브러리를 이용하지 않는다면 아래 구문을 주석처리 합니다

    # = 0.1 : 0.1 버전을 사용
    # > 0.1 : 0.1 버전 이후에 나온 최신버전을 사용
    # >= 0.1 : 0.1 버전 또는 그 이후에 나온 최신버전을 사용
    # < 0.1 : 0.1 이전에 나온 최신버전을 사용
    # <= 0.1 : 0.1버전 또는 그 이전에 나온 최신버전을 사용
    # ~> 0.1.2 : 0.1.2 ~ 0.2 버전사이에 있는 버전중 가장 최신의 버전을 사용. >= 0.1.2 와 < 0.2.0가 결합된 것

    # 여기에 설치할 라이브러리를 나열합니다.
    pod 'Firebase/Core', '5.4.0'    #필수 조건 라이브러리 및 애널리틱스
    pod 'Firebase/AdMob'    #AdMob
    pod 'Firebase/Messaging'    #클라우드 메시징
    pod 'Firebase/Database'    #실시간 데이터베이스
    pod 'Firebase/DynamicLinks'    #동적 링크
    pod 'Firebase/Crash'    #오류 보고
    pod 'Firebase/RemoteConfig'    #원격 구성
    pod 'Firebase/Auth'    #인증
    pod 'Firebase/Storage'    #저장소
    pod 'Firebase/Performance'    #성능 모니터링
    pod 'Firebase/Firestore'    #Cloud Firestore
    pod 'Firebase/Functions'    #Firebase용 Cloud 함수 클라이언트 SDK
    pod 'GoogleSignIn'
    
    pod 'MaterialComponents/Buttons+ColorThemer'
    pod 'MaterialComponents/Buttons'
    pod 'MaterialComponents/Buttons+ButtonThemer'
    
  target 'hotnonoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'hotnonoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
