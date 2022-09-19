//
//  FirebaseLogger.swift
//  AidenSeed
//
//  Created by Aiden on 2022/09/14.
//

import Foundation
import FirebaseAnalytics

class FirebaseLogger {
    
    enum EventParamName: String {
        case `class` = "CLASS"
        case file = "FILE"
        case function = "FUNCTION"
    }
    
    /// 이벤트명 SCREEN_VIEW인 파이어베이스 이벤트 로그를 발생시킴.
    ///
    /// 화면 진입 시 호출하여 로그를 기록
    static func screenLogEvent(_ className: String = "", _ fileName: String = "", _ functionName: String = "") {
        
        let parameters = [
            EventParamName.class.rawValue: className,
            EventParamName.file.rawValue: fileName,
            EventParamName.function.rawValue: functionName
        ]
        
        Analytics.logEvent("SCREEN_VIEW", parameters: parameters)
    }
}

