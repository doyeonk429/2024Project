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
    
    func checkAuthenticationStatus(completion: @escaping (String?) -> Void) {
        guard let accessToken = LoginViewController.keychain.get("serverAccessToken"),
              let accessTokenExpiryMillis = LoginViewController.keychain.get("accessTokenExpiresIn"),
              let expiryMillis = Int64(accessTokenExpiryMillis),
              let accessTokenExpiryDate = Date(milliseconds: expiryMillis) else {
            print("AccessToken이 존재하지 않음.")
            refreshAccessToken(completion: completion)
            return
        }
        
        if Date() < accessTokenExpiryDate {
            print("AccessToken 유효. 갱신 불필요.")
            completion(accessToken)
        } else {
            print("AccessToken 만료. RefreshToken으로 갱신 시도.")
            refreshAccessToken(completion: completion)
        }
    }
    
    private func refreshAccessToken(completion: @escaping (String?) -> Void) {
        guard let refreshToken = LoginViewController.keychain.get("serverRefreshToken") else {
            print("RefreshToken이 존재하지 않음.")
            completion(nil)
            return
        }
        
        let provider = MoyaProvider<LoginService>(plugins: [NetworkLoggerPlugin()])
        provider.request(.postRefresh(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(TokenDto.self)
                    LoginViewController.keychain.set(data.accessToken, forKey: "serverAccessToken")
                    LoginViewController.keychain.set(String(data.accessTokenExpiresIn), forKey: "accessTokenExpiresIn")
                    LoginViewController.keychain.delete("serverRefreshToken")
                    print("AccessToken 갱신 성공.")
                    completion(data.accessToken)
                } catch {
                    completion(nil)
                }
            case .failure(let error):
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(nil)
            }
        }
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        // 만약 accessToken이 있다면 Authorization 헤더에 추가합니다.
        if let token = accessToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }

    func prepare2(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        let semaphore = DispatchSemaphore(value: 0)
        var tokenToAdd: String?

        checkAuthenticationStatus { token in
            tokenToAdd = token
            semaphore.signal()
        }
        
        semaphore.wait()

        if let token = tokenToAdd {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}

extension Date {
    init?(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000.0)
    }
}
