import Charts

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
    let chartView: CandleStickChartView
    
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
        
        let stick = createCandlestick(index: chartView.data?.entryCount ?? 0, item: candle as! [String : Any])
        chartView.data?.appendEntry(stick, toDataSet: 0)
        chartView.notifyDataSetChanged()
    }
    
    private var candlesticks: [CandleChartDataEntry] = []
    
    private func createCandlestick(index: Int, item: [String: Any]) -> CandleChartDataEntry {
        var stick = CandleChartDataEntry(
            x: Double(index),
            shadowH: item["high"] as! Double,
            shadowL: item["low"] as! Double,
            open: item["open"] as! Double,
            close: item["close"] as! Double
        )
        
        return stick
    }
    
    private func serData(data: [[String: Any]]) {
        candlesticks.removeAll(keepingCapacity: true)
        var index: Int = -1
        for item in data {
            index += 1
            candlesticks.append(createCandlestick(index: index, item: item))
        }
        
        let set1 = CandleChartDataSet(entries: candlesticks, label: "Data Set")
        set1.drawIconsEnabled = false
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))

        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor.green
        set1.increasingFilled = true
        set1.neutralColor = .blue
        set1.drawValuesEnabled = false
        
        let data = CandleChartData(dataSet: set1)
        chartView.data = data
        
        chartView.setScaleMinima(4, scaleY: 1)
        chartView.pinchZoomEnabled = false
        chartView.scaleXEnabled = true
        chartView.scaleYEnabled = false
        chartView.moveViewToX(Double(chartView.data?.entryCount ?? 0))
    }
    
    override init(frame: CGRect) {
        chartView = CandleStickChartView()
        super.init(frame: frame)
        addSubview(chartView)

        chartView.chartDescription.enabled = false
        
        chartView.dragEnabled = true
        chartView.gridBackgroundColor = .clear
        chartView.backgroundColor = .clear
        chartView.maxVisibleCount = 60
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        
        chartView.leftAxis.labelCount = 7
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        

        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = .init(origin: .zero, size: frame.size)
    }
    
   
}
