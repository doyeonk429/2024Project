//
//  BoxManager.swift
//  DrugBox
//
//  Created by 김도연 on 1/31/24.
//

import UIKit
import Alamofire

protocol BoxManagerDelegate {
    func didUpdateBox(_ boxManager: BoxManager, _ box: BoxModel)
    func didFailWithError(error: Error)
}

//struct ImageFile {
//    let filename: String
//    let data: Data
//    let type: String
//}

struct BoxManager {
    let boxURL = "http://localhost:8080/drugbox/"
    let header: HTTPHeaders = [
        "Content-Type" : "multipart/form-data"
    ]
    
    func setBoxParameters(_ userId: String, _ boxName: String) -> [[String : Any]] {
        // 딕셔너리로 바꾸는 거 가능?
        let parameters = [
          [
            "key": "userId",
            "value": "\(userId)",
            "type": "text"
          ],
          [
            "key": "name",
            "value": boxName,
            "type": "text"
          ],
          [
              "key": "image",
              "src": "",
              "type": "file"
            ]] as [[String : Any]]
        
        return parameters
    }
    
    func performAddBoxPOST(userId: String, boxName: String) {
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        let parameters = self.setBoxParameters(userId, boxName)
        
        // api 예시 그대로 가져옴
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
              body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
              let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data // optional 처리 재확인
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: boxURL + "add")!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                  print(String(describing: error))
                return
              }
              print(String(data: data, encoding: .utf8)!)
            }
            task.resume()
    }

    func performRequest(with request: URLRequest) {
//        var error: Error? = nil

//        // 1. create a URL
//        if let url = URL(string: urlString) {
//            // 2. create a URLSession
//            let session = URLSession(configuration: .default)
//            // 3. give the session a task
//            let task = session.dataTask(with: url) { data, response, error in
//                if error != nil {
//                    self.delegate?.didFailWithError(error: error!)
//                    return
//                }
//                if let safeData = data {
//                    if let weather = self.parseJSON(safeData) {
//                        let weatherVC = WeatherViewController()
//                        self.delegate?.didUpdateWeather(self, weather)
//                    }
//                }
//            }
//            // 4. start the task
//            task.resume()
//
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                  print(String(describing: error))
                return
              }
              print(String(data: data, encoding: .utf8)!)
            }
            task.resume()
        }
    
    

}
