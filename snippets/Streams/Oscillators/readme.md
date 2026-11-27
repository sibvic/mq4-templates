## RSIStream

RSI stream on another stream.

## TSIOnStream

TSI on a stream.

## ROCOnStream

Rate of change on stream.

## StochOnStream

Stochastics on stream.

## CCIOnStream

Commodity Channel Index on stream. `(source - sma) / (0.015 * meanDeviation)`, where mean deviation is the average absolute distance from that same SMA. A flat window returns 0.

## CorrelationStream

Correlation on stream

## DevStream

Measure of difference between the series and it's SMA stream 

## DMIOnStream

Calculates the Directional Movement Index (DMI) and related values (such as +DI, -DI, and ADX) on a bar stream. Useful for identifying trend strength and direction by analyzing the relationship between upward and downward price movements over a specified period. Can be used for trend-following and filtering strategies.

## SupertrendOnStream

Supertrend indicator stream. Returns the supertrend line value and trend direction based on ATR bands.
