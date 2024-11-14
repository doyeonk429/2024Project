//
//  OCRModel.swift
//  DrugBox
//
//  Created by 김도연 on 11/13/24.
//

import UIKit
import Vision

class OCRModel {
    // OCR을 수행하고 인식된 텍스트를 반환하는 함수
    func performOCR(on image: UIImage, completion: @escaping ([String]) -> Void) {
        guard let cgImage = image.cgImage else {
            print("Invalid image")
            completion([])
            return
        }
        
        // 텍스트 인식 요청 생성
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error recognizing text: \(error)")
                completion([])
                return
            }
            // 인식된 텍스트 처리
            let recognizedText = self.handleDetectedText(request: request)
            completion(recognizedText)
        }
        
        // 텍스트 인식 언어 및 속도 설정
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en", "ko"]
        
        // 이미지 요청 핸들러 생성
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // 텍스트 인식 실행
                try requestHandler.perform([request])
            } catch {
                print("Failed to perform OCR: \(error)")
                completion([])
            }
        }
    }
    
    // 인식된 텍스트를 처리하는 함수
    private func handleDetectedText(request: VNRequest) -> [String] {
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            return []
        }
        
        // 인식된 텍스트를 배열로 반환
        return observations.compactMap { observation in
            observation.topCandidates(1).first?.string
        }
    }
}
