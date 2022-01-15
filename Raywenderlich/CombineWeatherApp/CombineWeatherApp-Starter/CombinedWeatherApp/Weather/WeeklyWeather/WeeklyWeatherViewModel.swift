/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import Combine

// 1. データバインディングができるようにする
class WeeklyWeatherViewModel: ObservableObject, Identifiable {
  // 2.cityプロパティを監視できるように
  @Published var city: String = ""
  // 3. ViewModel内にデータソースを保持しておく。
  @Published var dataSource: [DailyWeatherRowViewModel] = []
  
  private let weatherFetcher: WeatherFetchable
  
  // 4. こうすることで、ネットワークが接続され、サーバー側のレスポンスを得ることができる
  private var disposables = Set<AnyCancellable>()
  
  init(weatherFetcher: WeatherFetchable) {
    self.weatherFetcher = weatherFetcher
  }
  
  func fetchWeather(forCity city: String) {
    // 1. OpenWeatherMapのAPIからデータを取得する
    weatherFetcher.weeklyWeatherForecast(forCity: city)
      .map { response in
        // 2. WeeklyForecastResponseをDailyWeatherRowViewModelの配列にマッピングする
        // WeeklyForecastResponseをそのままViewに渡すこともできるが、Viewがモデルから返ってきたものをフォーマットさせることになるので
        // 良くない。Viewはレンダリングのみにフォーカスさせるべき
        response.list.map(DailyWeatherRowViewModel.init)
      }
      // 3. 
      .map(Array.removeDuplicates)
      // 4. サーバーからのデータ取得やJSONのパースは、バックグラウンドで行われることがあるが
      // UIの更新は、メインスレッドで行う必要がある。
      // receiveを使うことで、5,6,7の処理が正しいスレッドで行われるようにすることができる
      .receive(on: DispatchQueue.main)
      // 5. このsinkメソッドを通じて、publisherが始まる
      // 成功したか失敗したかで処理を制御する
      .sink(
        receiveCompletion: { [weak self] value in
            guard let self = self else { return }
            switch value {
            case .failure:
                // 6. 失敗したらdataSourceを空にする
                self.dataSource = []
            case .finished:
                break
            }
        },
        receiveValue: { [weak self] forecast in
            guard let self = self else { return }
            
            // 7. 新しいforecastが来たら、dataSourceを更新する
            self.dataSource = forecast
        }
      )
      // 8. cancellableの参照を、disposableに追加する
      .store(in: &disposables)
  }
}
