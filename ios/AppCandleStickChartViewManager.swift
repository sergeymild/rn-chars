import Charts

@objc(AppCandleStickChartViewManager)
class AppCandleStickChartViewManager: RCTViewManager {
    
    override func view() -> AppCandleStickChart {
        return AppCandleStickChart(frame: .zero)
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

@objc
class AppCandleStickChart: CandleStickChartView, AxisValueFormatter {
    func stringForValue(_ value: Double, axis: Charts.AxisBase?) -> String {
        return String(value.rounded(toPlaces: 4))
    }
    
    private lazy var formatter: DateFormatter = {
        let fornatter = DateFormatter()
        fornatter.dateFormat = "HH:mm"
        return fornatter
    }()
    
    var didInitiallyMove = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setScaleMinima(4, scaleY: 1)
        pinchZoomEnabled = false
        scaleXEnabled = true
        scaleYEnabled = false
        
        chartDescription.enabled = false
        
        dragEnabled = true
        gridBackgroundColor = .clear
        backgroundColor = .clear
        maxVisibleCount = 60
        pinchZoomEnabled = false
        drawGridBackgroundEnabled = false
        
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = true
        xAxis.gridColor = .gray.withAlphaComponent(0.5)
        xAxis.labelTextColor = .white

        leftAxis.setLabelCount(5, force: true)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridColor = .gray.withAlphaComponent(0.5)
        leftAxis.labelTextColor = .white
        leftAxis.drawAxisLineEnabled = false
        leftAxis.valueFormatter = self
        
        
        rightAxis.enabled = false
        legend.enabled = false
        setDragOffsetX(100)
        //autoScaleMinMaxEnabled = true
    }
    
    var candlesticks: [CandleChartDataEntry] = []
    
    func createCandlestick(index: Int, item: [String: Any]) -> CandleChartDataEntry {
        var stick = CandleChartDataEntry(
            x: Double(index),
            shadowH: item["high"] as! Double,
            shadowL: item["low"] as! Double,
            open: item["open"] as! Double,
            close: item["close"] as! Double
        )
        
        return stick
    }
    
    @objc
    func setNewData(_ candles: NSArray) {
        candlesticks.removeAll(keepingCapacity: true)
        var index: Int = -1
        for item in candles.enumerated() {
            index += 1
            candlesticks.append(createCandlestick(index: index, item: item.element as! [String : Any]))
        }
        
        let set1 = CandleChartDataSet(entries: candlesticks, label: "Data Set")
        set1.drawIconsEnabled = false
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.9
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor.green
        set1.increasingFilled = true
        set1.neutralColor = .blue
        set1.drawValuesEnabled = false
        
        self.data = CandleChartData(dataSet: set1)
        
        if !didInitiallyMove {
            moveViewToX(Double(set1.count - 1))
            didInitiallyMove = true
        } else {
            notifyDataSetChanged()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
