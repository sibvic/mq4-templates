# Conditions

## ICondition

Condition interface.

## ACondition

Condition based on symbol/timeframe data.

## AConditionBase

Base condition implementation.

## ACandleCondition

Abstract base for a candle condition. 

## RSI conditions

### RSIAboveLevelCondition

Check wether RSI about level.

### RSIBelowLevelCondition

Check wether RSI below level.

## Parabolic SAR conditions

### PSARBelowPriceCondition

PSAR below close.

### PSARAbovePriceCondition

PSAR above close.

## HitProfitCondition

Check whether required proifit is reached.

## NoCondition

Always true.

## bb_conditions

Bands conditions.

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

## HiddenBearishDivergenceCondition

Hidden bearish divergence condition. indicator fall + high rise

## HiddenBullishDivergenceCondition

Hidden bullish divergence condition. indicator rise + low fall

## OrCondition

Or condition.

## ma_conditions

Conditions for MA-MA and MA-price.

### MACrossOverMACondition

MA crosses over MA condition.

### MACrossUnderMACondition

MA crosses under MA condition.

### MAAbovePriceCondition

MA above price condition. Can check max distance to price.

### MABelowPriceCondition

MA below price condition. Can check max distance to price.

### MAAboveMACondition

MA above MA condition.

### MABelowMACondition

MA below MA conditon.

## cci_conditions

Conditions for CCI above/below value.

## macd_conditions

Conditions for MACD above/below signal, MACD stream above/below level.

## stoch_conditions

Conditions for Stochastic K above/below D.

## bar_conditions

Bar conditions: ascending/descending.

Reference period is a main traiding period. 

## TradingTimeCondition

Trading time condition. Returns true only during the selected time.

## TimeFilterCondition

Intraday time filter for trading conditions. Restricts trading activities to specific time periods within a trading day, helping to avoid trading during low-liquidity periods, news events, or other unfavorable market conditions.

**Features:**
- Intraday time filtering (e.g., 9:00 AM to 4:00 PM)
- PineScript-compatible time handling
- Easy integration with other trading conditions
- Flexible start and end time configuration

**Usage:**
```mql4
// Create a TimeFilterCondition with start and end times in HHMM format
TimeFilterCondition* timeFilter = new TimeFilterCondition(900, 1600); // 9:00 AM to 4:00 PM
condition.Add(timeFilter, true); // Add to your condition chain
```

**Time Format:**
Times should be provided in HHMM format (24-hour):
- 900 = 9:00 AM
- 1330 = 1:30 PM  
- 1600 = 4:00 PM
- 2300 = 11:00 PM

**Examples:**
```mql4
// Only trade between 9:00 AM and 4:00 PM
TimeFilterCondition* tradingHours = new TimeFilterCondition(900, 1600);

// Avoid trading during lunch break (12:00 PM to 1:00 PM)
TimeFilterCondition* avoidLunch = new TimeFilterCondition(1200, 1300);
NotCondition* notLunch = new NotCondition(avoidLunch);
```

## ProfitInRangeCondition

Returns true when profit of the order in the specified range.

## NotCondition

Inverts result of the condition.

## NoStopLossOrTakeProfitCondition

No stop loss or take profit.

## MinDistanceSinceLastTradeCondition

Min distance since last trade.

## wpr_conditions

Larry Williams' Percent Range conditions: above/below level.

## ADXDMIConditions

### ADXOverADXCondition

ADX/DMI stream over ADX/DMI stream condition.

### ADXUnderADXCondition

ADX/DMI stream under ADX/DMI stream condition.

### ADXCrossOverADXCondition

ADX/DMI stream cross over ADX/DMI stream condition.

### ADXCrossUnderADXCondition

ADX/DMI stream cross under ADX/DMI stream condition.

## ActOnSwitchCondition

Returns true when the given condition starts to return true (true on the current bar and false on the previous bar). Timeframe sensitive.

## ActOnSwitchInstantCondition

Returns true when the given condition return true after the false on the previous call. Timeframe insensitive.

## PositionLimitHitCondition

Position limit hit condition.

## OrderEOLCondition

Trade end of life condition. Starts return true when the specified number of seconds passed since open of the trade (or trade was closed).

## NewBarCondition

New bar condition.

## DayOfWeekCondition

Used to enable/disable actions per day of week.

## StreamConditions

Stream-stream condition.

## HitEquityLevelCondition

Hit equity level condition.

## HitTotalProfitCondition

Hit total profit (equity - balance) condition.

## LineCrossCondition

Line cross condition.

## DayTimeCondition

Triggers at the specific day of the month and time.

## MinMarginCondition

Min marging condition.

## FibCrossCondition

Fibonacci cross condition.

## NewObjectCondition

Acts when new object appears with the specified id start.

## DayTradesLimitCondition

Max trades at day condition.

## StreamStreamCondition

Condition between two streams (over/under/cross over/cross under)

## OrderOlderThanCondition

Returns true when given order older that given number of bars.

## StreamValueCondition

Compares stream value with a fixed value.

## FallingCondition

Stream falling condition

## IConditionFactory

Interface for a condition factory

## RisingCondition

Stream rising condition