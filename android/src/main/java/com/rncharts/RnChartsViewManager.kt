package com.rncharts

import android.graphics.Color
import android.graphics.Paint
import android.view.MotionEvent
import com.androidplot.xy.CandlestickSeries
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.github.mikephil.charting.charts.CandleStickChart
import com.github.mikephil.charting.components.XAxis.XAxisPosition
import com.github.mikephil.charting.components.YAxis
import com.github.mikephil.charting.data.CandleData
import com.github.mikephil.charting.data.CandleDataSet
import com.github.mikephil.charting.data.CandleEntry
import com.github.mikephil.charting.listener.ChartTouchListener
import com.github.mikephil.charting.listener.OnChartGestureListener


//typealias CandleStick = XYPlot
typealias CandleStick = CandleStickChart

class RnChartsViewManager : SimpleViewManager<CandleStick>() {
  override fun getName() = "RnChartsView"

  override fun createViewInstance(reactContext: ThemedReactContext): CandleStick {
    return CandleStick(reactContext)
  }

  var isAddEnabled = true

  @ReactProp(name = "data")
  fun setData(chart: CandleStick, data: ReadableArray) {
    val values = mutableListOf<CandleEntry>()
    for (i in 0 until data.size()) {
      val item = data.getMap(i)
      values.add(CandleEntry(
        i.toFloat(),
        item.getDouble("high").toFloat(),
        item.getDouble("low").toFloat(),
        item.getDouble("open").toFloat(),
        item.getDouble("close").toFloat()
      ))
    }


    chart.getDescription().setEnabled(false);
    chart.setMaxVisibleValueCount(60);
    chart.setPinchZoom(false);
    chart.setDrawGridBackground(false);
    val xAxis = chart.xAxis
    xAxis.position = XAxisPosition.BOTTOM
    xAxis.setDrawGridLines(false)
    val leftAxis = chart.axisLeft
    leftAxis.setLabelCount(7, false);
    leftAxis.setDrawGridLines(false);
    leftAxis.setDrawAxisLine(false);
    val rightAxis = chart.axisRight
    rightAxis.isEnabled = false
    chart.getLegend().setEnabled(false);

    val set1 = CandleDataSet(values, "Data Set")
    set1.setDrawIcons(false);
    set1.setAxisDependency(YAxis.AxisDependency.LEFT);
//        set1.setColor(Color.rgb(80, 80, 80));
    set1.setShadowColor(Color.DKGRAY);
    set1.setShadowWidth(0.7f);
    set1.setDecreasingColor(Color.RED);
    set1.setDecreasingPaintStyle(Paint.Style.FILL);
    set1.setIncreasingColor(Color.rgb(122, 242, 84));
    set1.setDrawValues(false)
    set1.setIncreasingPaintStyle(Paint.Style.FILL);
    set1.setNeutralColor(Color.BLUE);
    val d = CandleData(set1)

    chart.data = d
    chart.setScaleMinima(4f, 1f)
    chart.setPinchZoom(false)
    chart.isScaleXEnabled = true
    chart.isScaleYEnabled = false
    chart.notifyDataSetChanged()
    chart.moveViewToX(d.entryCount.toFloat())
    chart.onChartGestureListener = object : OnChartGestureListener {
      override fun onChartGestureStart(
        me: MotionEvent?,
        lastPerformedGesture: ChartTouchListener.ChartGesture?
      ) {
        println("start")
        isAddEnabled = false
      }

      override fun onChartGestureEnd(
        me: MotionEvent?,
        lastPerformedGesture: ChartTouchListener.ChartGesture?
      ) {
        println("end")
        isAddEnabled = true
      }

      override fun onChartLongPressed(me: MotionEvent?) {
      }

      override fun onChartDoubleTapped(me: MotionEvent?) {
      }

      override fun onChartSingleTapped(me: MotionEvent?) {
      }

      override fun onChartFling(
        me1: MotionEvent?,
        me2: MotionEvent?,
        velocityX: Float,
        velocityY: Float
      ) {
      }

      override fun onChartScale(me: MotionEvent?, scaleX: Float, scaleY: Float) {
      }

      override fun onChartTranslate(me: MotionEvent?, dX: Float, dY: Float) {
      }

    }
  }

  @ReactProp(name = "addCandle")
  fun appendCandle(view: CandleStick, item: ReadableMap) {
    val set = view.data.getDataSetByIndex(0)
    view.data.addEntry(CandleEntry(
      set.entryCount.toFloat(),
      item.getDouble("high").toFloat(),
      item.getDouble("low").toFloat(),
      item.getDouble("open").toFloat(),
      item.getDouble("close").toFloat()
    ), 0)
    //view.data.notifyDataChanged()
    if (isAddEnabled) {
      view.notifyDataSetChanged()
      //view.moveViewToAnimated(view.data.entryCount.toFloat(), 0f, YAxis.AxisDependency.LEFT, 500)
    }

    println(" ${view.viewPortHandler.transX}, ${view.viewPortHandler.ma}")
//    println("==== addCandle ${data}")
//    val x = candlestickSeries!!.closeSeries.size() + 1
//    candlestickSeries!!.closeSeries.addLast(x, data.getDouble("close"))
//    candlestickSeries!!.lowSeries.addLast(x, data.getDouble("low"))
//    candlestickSeries!!.highSeries.addLast(x, data.getDouble("high"))
//    candlestickSeries!!.openSeries.addLast(x, data.getDouble("open"))
//
//    // add some padding to range boundaries:
//    val minMax = SeriesUtils.minMax(
//      candlestickSeries!!.lowSeries.getyVals(),
//      candlestickSeries!!.highSeries.getyVals());
//
//    //view.setRangeBoundaries(minMax.min.toDouble() - 1, minMax.max.toDouble() + 1, BoundaryMode.FIXED);
//    //view.setRangeBoundaries(0, -1, BoundaryMode.GROW);
//
//
//    view.redraw()
  }
}
