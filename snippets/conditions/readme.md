# Conditions

## ICondition

Condition interface.

## ABaseCondition

Base condition implementation.

## RSI conditions

### RSIAboveLevelCondition

Check wether RSI about level.

### RSIBelowLevelCondition

Check wether RSI below level.

## Ichimoku conditions

### PriceAboveKumhoCondition

Close above Senkou Span A and B.

### PriceBelowKumhoCondition

Close below Senkou Span A and B.

## Parabolic SAR conditions

### PSARBelowPriceCondition

PSAR below close.

### PSARAbovePriceCondition

PSAR above close.

## HitProfitCondition

Check whether required proifit is reached.

## NoCondition

Always true.

## BandCrossUnderCondition and BandCrossOverCondition

Boilinger Band crossed by the close (over the top or under the bottom).

## VolumeRiseCondition and VolumeFallCondition

Volume rise/fall conditions.

## MaxSpreadCondition

True when the spread less that the specified amount.

## AndCondition

True when all subconditions are true.

## SecondsBeforeCandleClose

True when there is n seconds remained before candle close.

## PriceOutsideBandCondition

Price outside Boilinger bands condition.

## TroughCondition

Checks for the lowest point n bars in both sides.

Example:

    n = 2;
    54345 // true

## PeakCondition

Checks for the highest point n bars in both sides.

Example:

    n = 2;
    56765 // true
    
## RegularBearishDivergenceCondition

Regular bearish divergence condition. indicator fall + high rise

## RegularBullishDivergenceCondition

Regular bullish divergence condition. indicator rise + low fall

## OrCondition

Or condition.

## ma_conditions

Conditions for MA above/below price/another MA, MA cross over/under MA.

## cci_conditions

Conditions for CCI above/below value.

## macd_conditions

Conditions for MACD above/below signal.

## stoch_conditions

Conditions for Stochastic K above/below D.

## bar_conditions

Bar conditions: ascending/descending.

Reference period is a main traiding period. 

## TradingTimeCondition

Trading time condition. Returns true only during the selected time.

## ProfitInRangeCondition

Returns true when profit of the order in the specified range.