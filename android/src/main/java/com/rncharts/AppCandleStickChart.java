package com.rncharts;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Paint;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.github.mikephil.charting.charts.CandleStickChart;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.CandleData;
import com.github.mikephil.charting.data.CandleDataSet;
import com.github.mikephil.charting.data.CandleEntry;

import java.util.ArrayList;
import java.util.List;

public class AppCandleStickChart extends CandleStickChart {
  boolean isInitiallyMovedToTheEnd = false;

  public AppCandleStickChart(Context context) {
    super(context);
    getDescription().setEnabled(false);
    setMaxVisibleValueCount(0);
    setPinchZoom(false);
    setDrawGridBackground(false);

    getXAxis().setPosition(XAxis.XAxisPosition.BOTTOM);
    getXAxis().setDrawGridLines(true);
    getXAxis().setTextColor(Color.WHITE);

    getAxisLeft().setLabelCount(5, true);
    getAxisLeft().setDrawGridLines(true);
    getAxisLeft().setDrawAxisLine(false);
    getAxisLeft().setTextColor(Color.WHITE);
    getAxisLeft().setValueFormatter(new AxisValueFormatter());

    getAxisRight().setEnabled(false);

    getDescription().setEnabled(false);
    getLegend().setEnabled(false);

    setScaleMinima(5f, 1f);
    setPinchZoom(false);
    setScaleXEnabled(true);
    setScaleYEnabled(false);
    setAutoScaleMinMaxEnabled(true);
    setDragOffsetX(100);
  }

  public void setData(ReadableArray data) {
    List<CandleEntry> values = new ArrayList<>(data.size());
    for (int i = 0; i < data.size(); i++) {
      ReadableMap item = data.getMap(i);
      values.add(new CandleEntry(
        (float) i,
        (float) item.getDouble("high"),
        (float) item.getDouble("low"),
        (float) item.getDouble("open"),
        (float) item.getDouble("close")
      ));
    }

    CandleDataSet set = new CandleDataSet(values, "Data Set");
    set.setDrawIcons(false);
    set.setAxisDependency(YAxis.AxisDependency.LEFT);
    set.setShadowColor(Color.DKGRAY);
    set.setShadowWidth(0.9f);
    set.setDecreasingColor(Color.RED);
    set.setDecreasingPaintStyle(Paint.Style.FILL);
    set.setIncreasingColor(Color.rgb(122, 242, 84));
    set.setDrawValues(false);
    set.setIncreasingPaintStyle(Paint.Style.FILL);
    set.setNeutralColor(Color.BLUE);

    CandleData candleData = new CandleData(set);
    setData(candleData);
    getData().notifyDataChanged();
    notifyDataSetChanged();
    if (!isInitiallyMovedToTheEnd) {
      isInitiallyMovedToTheEnd = true;
      moveViewToX(set.getEntryCount() - 1);
    }
  }
}
