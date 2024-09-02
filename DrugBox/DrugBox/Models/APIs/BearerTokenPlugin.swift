//
//  BearerTokenPlugin.swift
//  DrugBox
//
//  Created by 김도연 on 8/27/24.
//
import Foundation
import Moya

final class BearerTokenPlugin: PluginType {
    private var accessToken: String? {
        return LoginViewController.keychain.get("serverAccessToken")
    }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request

        // 만약 accessToken이 있다면 Authorization 헤더에 추가합니다.
        if let token = accessToken {
//            print("토큰 추가 완료")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
