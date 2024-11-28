import SwiftUI

struct ContentView: View {
    @State private var stockEntries: [StockEntry] = [StockEntry()]  // Holds multiple stock inputs
    @State private var results: [StockResult] = []  // Stores calculated results
    @State private var errorMessage: String = ""    // Displays errors

    var body: some View {
        VStack {
            Text("Dividend Calculator")
                .font(.largeTitle)
                .padding()

            // Scrollable list of stock input fields
            ScrollView {
                ForEach($stockEntries, id: \.self) { $entry in
                    StockInputRow(entry: $entry)
                        .padding(.horizontal)
                }
            }

            // Add another stock button
            Button(action: {
                stockEntries.append(StockEntry())
            }) {
                Text("Add Another Stock")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            // Calculate button
            Button(action: calculateDividends) {
                Text("Calculate Dividends")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            // Results section
            if !results.isEmpty {
                List {
                    ForEach(results, id: \.self) { result in
                        VStack(alignment: .leading) {
                            Text("Stock: \(result.symbol)")
                            Text("Date Range: \(result.startDate) to \(result.endDate)")
                            Text("Shares: \(result.shares)")
                            Text("Total Dividends: $\(result.totalDividends, specifier: "%.2f")")
                        }
                        .padding()
                    }
                }
            }

            // Error message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }

    // Function to calculate dividends
    func calculateDividends() {
        results.removeAll()  // Clear previous results
        errorMessage = ""    // Clear previous errors

        for entry in stockEntries {
            guard let shares = Double(entry.shares), shares > 0 else {
                errorMessage = "Invalid number of shares for \(entry.symbol)"
                return
            }

            fetchYahooFinanceDividends(
                symbol: entry.symbol,
                startDate: entry.startDate,
                endDate: entry.endDate,
                shares: shares
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let totalDividends):
                        results.append(
                            StockResult(
                                symbol: entry.symbol,
                                startDate: entry.startDate,
                                endDate: entry.endDate,
                                shares: shares,
                                totalDividends: totalDividends
                            )
                        )
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

// Helper structs for data handling
struct StockEntry: Hashable {
    var symbol: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var shares: String = ""
}

struct StockResult: Hashable {
    let symbol: String
    let startDate: String
    let endDate: String
    let shares: Double
    let totalDividends: Double
}

// UI for a single stock input row
struct StockInputRow: View {
    @Binding var entry: StockEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Stock Symbol", text: $entry.symbol)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Start Date (YYYY-MM-DD)", text: $entry.startDate)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("End Date (YYYY-MM-DD)", text: $entry.endDate)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Number of Shares", text: $entry.shares)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
        }
    }
}
