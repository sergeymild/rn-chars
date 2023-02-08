

@objc(RnChartsViewManager)
class RnChartsViewManager: RCTViewManager {
    
    override func view() -> (RnChartsView) {
        return RnChartsView(frame: .zero)
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }
}

class RnChartsView : UIView {
    let chartView: StockChartView
    
    private lazy var formatter: DateFormatter = {
        let fornatter = DateFormatter()
        fornatter.dateFormat = "HH:mm"
        return fornatter
    }()
    
    //{
    //close: 1.07404,
    //high: 1.07405,
    //low: 1.074,
    //open: 1.07401,
    //time: 1675741680000,
    //volume: 0,
    //},
    @objc
    var data: [[String: Any]] = [] {
        didSet {
            self.serData(data: data)
            debugPrint("++++++++")
        }
    }
    
    @objc
    func setAddCandle(_ candle: NSDictionary) {
        debugPrint("=====", candle)
        candlesticks.append(createCandlestick(item: candle as! [String : Any]))
        chartView.didInsertData()
    }
    
    private var candlesticks: [Candlestick] = []
    
    private func createCandlestick(item: [String: Any]) -> Candlestick {
        var stick = Candlestick()
        stick.close = item["close"] as! Double
        stick.open = item["open"] as! Double
        stick.low = item["low"] as! Double
        stick.high = item["high"] as! Double
        stick.volume = item["high"] as! Double
        stick.volume = item["volume"] as! Double
        stick.date = Date(timeIntervalSince1970: (item["time"] as! Double) / 1000)
        return stick
    }
    
    private func serData(data: [[String: Any]]) {
        candlesticks.removeAll(keepingCapacity: true)
        for item in data {
            candlesticks.append(createCandlestick(item: item))
        }
    }
    
    override init(frame: CGRect) {
        chartView = StockChartView()
        super.init(frame: frame)
        addSubview(chartView)
        initChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initChart() {
        chartView.dataSource = self
        chartView.delegate = self
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = .init(origin: .zero, size: frame.size)
    }
    
   
}


extension RnChartsView: StockChartViewDataSource {
    func numberOfCandlesticks() -> Int {
        return candlesticks.count
    }
    
    func numberOfLines() -> Int {
        return 0
    }
    
    func candlestick(atIndex index: Int) -> Candlestick {
        return candlesticks[index]
    }
    
    func line(atIndex index: Int) -> Line {
        return Line(values: [])
    }
    
    func format(volume: CGFloat, forElement: Element) -> String {
        return String(format: "%.0f", volume)
    }
    
    func format(price: CGFloat, forElement: Element) -> String {
        return String(format: "%.3f", price)
    }
    
    func format(date: Date, forElement: Element) -> String {
        return formatter.string(from: date)
    }
    
    func color(forLineAtIndex index: Int) -> CGColor {
        switch index {
        case 0:
            return UIColor(hex: 0xe8de85, alpha: 1).cgColor
        default:
            return UIColor(hex: 0xe8de85, alpha: 1).cgColor
        }
    }
    
    // TODO optimize
    func bounds(inVisibleRange visibleRange: CandlestickRange, maximumVisibleCandles: Int) -> GraphBounds {
        print("GET BOUNDS")
        let buffer = maximumVisibleCandles / 2
        let startIndex = max(0, visibleRange.lowerBound - buffer)
        let endIndex = max(startIndex, min(candlesticks.count - 1, visibleRange.upperBound + buffer))
        
        var maxPrice = CGFloat.leastNormalMagnitude
        var minPrice = CGFloat.greatestFiniteMagnitude
        var maxVolume = CGFloat.leastNormalMagnitude
        var minVolume = CGFloat.greatestFiniteMagnitude
        let range = startIndex...endIndex
        
        guard startIndex < endIndex else {
            return GraphBounds()
        }
        
        for index in range {
            let entity = candlesticks[index]
            maxPrice = max(maxPrice, entity.high)
            minPrice = min(minPrice, entity.low)
            
            maxVolume = max(maxVolume, entity.volume)
            minVolume = min(minVolume, entity.volume)
        }
        
        return GraphBounds(
            price: Bounds(min: minPrice, max: maxPrice),
            volume: Bounds(min: 0, max: 0)
        )
    }
}

extension RnChartsView: StockChartViewDelegate {
    func performedLongPressGesture(atIndex index: Int) {
        chartView.showDetails(forCandleAtIndex: index)
    }
    
    func releasedLongPressGesture() {
        chartView.hideDetails()
    }
    
    func performedTap(atIndex index: Int) {
//        if lineBriefView.isHidden {
//            chartView.showDetails(forCandleAtIndex: index)
//        } else {
//            chartView.hideDetails()
//        }
    }
    
    func showedDetails(atIndex index: Int){
//        let candlestick = graphData.candlesticks[index]
//        lineBriefView.configureView(candlestick: candlestick)
//        lineBriefView.isHidden = false
    }
    
    func hidDetails() {
        //lineBriefView.isHidden = true
    }
}
