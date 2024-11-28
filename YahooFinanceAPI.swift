import Foundation

func fetchYahooFinanceDividends(symbol: String, startDate: String, endDate: String, shares: Double, completion: @escaping (Result<Double, Error>) -> Void) {
    // Yahoo Finance API URL (replace with actual endpoint)
    let apiUrl = "https://query1.finance.yahoo.com/v7/finance/download/\(symbol)?period1=\(startDate)&period2=\(endDate)&interval=1d&events=div"

    guard let url = URL(string: apiUrl) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 1, userInfo: nil)))
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data", code: 1, userInfo: nil)))
            return
        }

        do {
            // Parse the CSV response (Yahoo Finance returns CSV for historical data)
            guard let csvString = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "Invalid response format", code: 1, userInfo: nil)
            }

            let lines = csvString.split(separator: "\n")
            guard lines.count > 1 else {
                throw NSError(domain: "No dividend data found", code: 1, userInfo: nil)
            }

            let dividendLines = lines.dropFirst()  // Skip the header
            var totalDividends = 0.0

            for line in dividendLines {
                let columns = line.split(separator: ",")
                if columns.count > 1, let dividend = Double(columns[1]) {
                    totalDividends += dividend
                }
            }

            completion(.success(totalDividends * shares))
        } catch {
            completion(.failure(error))
        }
    }

    task.resume()
}
