import {
  requireNativeComponent,
  UIManager,
  Platform,
  ViewStyle,
  StyleProp,
} from 'react-native';
import React, { forwardRef, memo, useImperativeHandle, useRef } from 'react';

const LINKING_ERROR =
  `The package 'react-native-rn-charts' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

type RnChartsProps = {
  data: Record<any, any>;
  style: ViewStyle;
};

const ComponentName = 'AppCandleChartView';

const RnChartsView: any =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<RnChartsProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };

interface CandleStick {
  close: number;
  high: number;
  low: number;
  open: number;
  time: number;
  volume: number;
}

export interface AppCandleChartViewRef {
  append: (items: CandleStick[]) => void;
}

interface Props {
  readonly data: CandleStick[];
  readonly style?: StyleProp<ViewStyle>;
}

export const AppCandleChartView = memo(
  forwardRef<AppCandleChartViewRef, Props>((props, ref) => {
    const _ref = useRef<any>(null);
    useImperativeHandle(
      ref,
      () => ({
        append: (item) => _ref.current?.setNativeProps({ addCandles: item }),
      }),
      []
    );
    return <RnChartsView {...props} ref={_ref} />;
  })
);
