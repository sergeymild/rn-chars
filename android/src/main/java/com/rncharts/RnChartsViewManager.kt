package com.rncharts

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp


//typealias CandleStick = XYPlot
typealias CandleStick = AppCandleStickChart

class RnChartsViewManager : SimpleViewManager<CandleStick>() {
  override fun getName() = "AppCandleStickChartView"

  override fun createViewInstance(reactContext: ThemedReactContext): CandleStick {
    return CandleStick(reactContext)
  }

  var isAddEnabled = true

  @ReactProp(name = "data")
  fun setData(chart: CandleStick, data: ReadableArray) {
    chart.setData(data)
  }
}
