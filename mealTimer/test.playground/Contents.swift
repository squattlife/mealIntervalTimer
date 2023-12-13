import Foundation

// API 키를 설정합니다.
let API_KEY = "9471bd3293e040e2bbac"

// 식품명을 설정합니다.
let FOOD_NAME = "대구"

struct FoodSafetyKoreaAPIResponse: Decodable {
    var data: [FoodSafetyKoreaAPIData]
}

struct FoodSafetyKoreaAPIData: Decodable {
    var foodName: String
    var nutrients: [FoodSafetyKoreaAPINutrient]
}

struct FoodSafetyKoreaAPINutrient: Decodable {
    var nutrientName: String
    var value: Double
    var unit: String
}

// API 호출합니다.
let url = URL(string: "https://www.foodsafetykorea.go.kr/api/openApiInfo.do?menu_grp=MENU_GRP31&menu_no=661&show_cnt=10&start_idx=1&svc_no=I2790&svc_type_cd=API_TYPE06&q=\(FOOD_NAME)&api_key=\(API_KEY)")!
let request = URLRequest(url: url)
let session = URLSession.shared
let dataTask = session.dataTask(with: request) { data, response, error in
    guard error == nil else {
        print(error!)
        return
    }

    guard let data = data else {
        print("Data is empty")
        return
    }

    let responseJSON = try? JSONDecoder().decode(FoodSafetyKoreaAPIResponse.self, from: data)
    guard let responseJSON = responseJSON else {
        print("Response JSON is invalid")
        return
    }

    // 식품 영양정보를 출력합니다.
    for item in responseJSON.data {
        print("식품명: \(item.foodName)")
        print("칼로리: \(item.nutrients[0].value)")
        print("탄수화물: \(item.nutrients[1].value)")
        print("단백질: \(item.nutrients[2].value)")
        print("지방: \(item.nutrients[3].value)")
    }
}
dataTask.resume()

