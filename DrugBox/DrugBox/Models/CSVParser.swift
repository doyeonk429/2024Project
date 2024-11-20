//
//  CSVParser.swift
//  DrugBox
//
//  Created by 김도연 on 11/20/24.
//

import Foundation

// CSV Row 데이터 모델
struct PillData {
    let 품목일련번호: String
    let 품목명: String
    let 큰제품이미지: String
    let 표시앞: String
    let 표시뒤: String
    let 분류명: String
    let 전문일반구분: String
}

class CSVParser {
    func parseCSV(filePath: String) -> [PillData] {
        var pillDataList: [PillData] = []

        do {
            // 파일 읽기
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = fileContents.components(separatedBy: "\n")

            // 헤더를 제외한 데이터 처리
            for row in rows.dropFirst() where !row.isEmpty {
                let columns = row.components(separatedBy: ",")
                if columns.count > 11 {
                    let pill = PillData(
                        품목일련번호: columns[0],
                        품목명: columns[1],
                        큰제품이미지: columns[2],
                        표시앞: columns[3],
                        표시뒤: columns[4],
                        분류명: columns[10],
                        전문일반구분: columns[11]
                    )
                    pillDataList.append(pill)
                }
            }
        } catch {
            print("Error reading CSV file: \(error)")
        }
        
        return pillDataList
    }
    
    func findMatchingPills(ocrResults: [String], pillDataList: [PillData]) -> [PillData] {
        // 완전히 일치하는 항목
        let exactMatches = pillDataList.filter { pill in
            ocrResults.contains { result in
                pill.표시앞 == result || pill.표시뒤 == result
            }
        }
        
        // 부분 일치하는 항목
//        let partialMatches = pillDataList.filter { pill in
//            ocrResults.contains { result in
//                (pill.표시앞.contains(result) || pill.표시뒤.contains(result)) &&
//                !(pill.표시앞 == result || pill.표시뒤 == result)
//            }
//        }
        
        // 완전히 일치하는 항목을 앞에 두고, 부분 일치하는 항목을 뒤에 추가
        return exactMatches
    }
    
    
    func searchPillDatas(by ocrResults : [String]) -> [PillData]? {
        // CSV 파일 경로 (Pill_OpenData_with_ratio.csv 파일 경로 설정)
        if let csvFilePath = Bundle.main.path(forResource: "Pill_OpenData_with_ratio", ofType: "csv") {
            print("CSV 파일 경로: \(csvFilePath)")
            let pillDataList = parseCSV(filePath: csvFilePath)
            let matchingPills = findMatchingPills(ocrResults: ocrResults, pillDataList: pillDataList)
            return matchingPills
        } else {
            print("CSV 파일을 찾을 수 없습니다.")
        }
        return nil
    }
}
