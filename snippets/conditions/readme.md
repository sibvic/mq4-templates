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