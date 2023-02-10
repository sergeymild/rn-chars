package com.rncharts;

import com.github.mikephil.charting.formatter.ValueFormatter;

public class AxisValueFormatter extends ValueFormatter {
    public static double round(double value, int places) {
        if (places < 0) throw new IllegalArgumentException();

        long factor = (long) Math.pow(10, places);
        value = value * factor;
        long tmp = Math.round(value);
        return (double) tmp / factor;
    }

    @Override
    public String getFormattedValue(float value) {
        // avoid memory allocations here (for performance)
        return String.valueOf(round(value, 4));
    }
}
