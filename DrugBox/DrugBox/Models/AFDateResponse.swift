//
//  AFDateResponse.swift
//  DrugBox
//
//  Created by 김도연 on 2/9/24.
//

import Foundation

/**
 * API 응답 구현체 값
 */
struct AFDataResponse<T: Codable>: Codable {
    
    // 응답 결과값
    let result: T?
    
    // 응답 코드
    let result_code: Int?
    
    // 응답 메시지
    let result_message: String?
    
    enum CodingKeys: CodingKey {
        case result_code, result_message, result
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        result_code = (try? values.decode(Int.self, forKey: .result_code)) ?? nil
        result_message = (try? values.decode(String.self, forKey: .result_message)) ?? nil
        result = (try? values.decode(T.self, forKey: .result)) ?? nil
    }
    
}
