//
//  BoxManager.swift
//  DrugBox
//
//  Created by 김도연 on 1/31/24.
//

import UIKit
import Alamofire

protocol BoxManagerDelegate {
    func didFailWithError(error: Error)
}

//struct ImageFile {
//    let filename: String
//    let data: Data
//    let type: String
//}

struct BoxManager {
    var delegate: BoxManagerDelegate?
    
    let url = "http://104.196.48.122:8080/drugbox/"
    let boxURL = "http://localhost:8080/drugbox/"
    
    func sendNewBoxModel(_ userId: Int, _ boxName: String, _ boxImage: String) {
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
            "src": boxImage,
            "type": "file"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
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
                // 에러터짐..
              let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://localhost:8080/drugbox/add")!,timeoutInterval: Double.infinity)
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
    
    func fileUpload(_ userId: Int, _ boxName: String, _ img: UIImage, completion: @escaping (String)->Void) {
//         서버 url
        let url: String = "http://localhost:8080/drugbox/add"
       
        // 헤더 구성 : Content-Type 필드에 multipart 타입추가
        let header: HTTPHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "multipart/form-data"
        ]
        
        let parameters : [String: Any] = [
            "userId" : userId, "name" : boxName
        ]
        let imageData = img.jpegData(compressionQuality: 1)
             
        AF.upload(multipartFormData: { MultipartFormData in
            // body 추가
            for (key, value) in parameters {
                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            // img 추가 data로 타입 변경 필요!
            if let image = imageData {
                MultipartFormData.append(image, withName: "file", fileName: "test.jpeg", mimeType: "image/jpeg")
            }
        }, to: url, method: .post, headers: header)
        .validate()
//        .responseDecodable(of: GetUrl.self, completionHandler:  { response in
//            switch response.result{
//            case .success(let data):
//                print("url : \(data.url)")
//                completion(data.url)
//            case .failure(let error):
//              print(error)
//            }
//        })
    }
//    func setBoxParameters(_ userId: String, _ boxName: String) -> [[String : Any]] {
//        // 딕셔너리로 바꾸는 거 가능?
//        let parameters = [
//          [
//            "key": "userId",
//            "value": "\(userId)",
//            "type": "text"
//          ],
//          [
//            "key": "name",
//            "value": boxName,
//            "type": "text"
//          ],
//          [
//              "key": "image",
//              "src": "",
//              "type": "file"
//            ]] as [[String : Any]]
//        
//        return parameters
//    }
    
//    func performAddBoxPOST(userId: String, boxName: String) {
//        let boundary = "Boundary-\(UUID().uuidString)"
//        var body = ""
//        var error: Error? = nil
//        let parameters = self.setBoxParameters(userId, boxName)
//        
//        // api 예시 그대로 가져옴
//        for param in parameters {
//          if param["disabled"] == nil {
//            let paramName = param["key"]!
//            body += "--\(boundary)\r\n"
//            body += "Content-Disposition:form-data; name=\"\(paramName)\""
//            if param["contentType"] != nil {
//              body += "\r\nContent-Type: \(param["contentType"] as! String)"
//            }
//            let paramType = param["type"] as! String
//            if paramType == "text" {
//              let paramValue = param["value"] as! String
//              body += "\r\n\r\n\(paramValue)\r\n"
//            } else {
//              let paramSrc = param["src"] as! String
//              let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data // optional 처리 재확인
//              let fileContent = String(data: fileData, encoding: .utf8)!
//              body += "; filename=\"\(paramSrc)\"\r\n"
//                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
//            }
//          }
//        }
//        body += "--\(boundary)--\r\n";
//        let postData = body.data(using: .utf8)
//
//        var request = URLRequest(url: URL(string: boxURL + "add")!,timeoutInterval: Double.infinity)
//        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//        request.httpBody = postData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//              guard let data = data else {
//                  print(String(describing: error))
//                return
//              }
//              print(String(data: data, encoding: .utf8)!)
//            }
//            task.resume()
//    }

//    func performRequest(with request: URLRequest) {
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
    
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//              guard let data = data else {
//                  print(String(describing: error))
//                return
//              }
//              print(String(data: data, encoding: .utf8)!)
//            }
//            task.resume()
//        }
    
    
    func postInvitationCode(by userid: Int, with inviteCode: String) {
        // invitecode가 data화 된거면 처리해주기 string 그대로면 입력 ㄱ
        let postURL = self.url + "/add/invite-code?inviteCode=\(inviteCode)e&userId=\(userid)"
        var request = URLRequest(url: URL(string: postURL)!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeDate = data {
                print(String(data: safeDate, encoding: .utf8)!)
            }
        }
        
        task.resume()
    }
    
}
