// Stop loss and amount strategy for position size risk v1.1

#include <IStopLossAndAmountStrategy.mq4>
#include <../TradingCalculator.mq4>

#ifndef PositionSizeRiskStopLossAndAmountStrategy_IMP
#define PositionSizeRiskStopLossAndAmountStrategy_IMP

class PositionSizeRiskStopLossAndAmountStrategy : public IStopLossAndAmountStrategy
{
   double _lots;
   TradingCalculator *_calculator;
   StopLimitType _stopLossType;
   double _stopLoss;
   bool _isBuy;
public:
   PositionSizeRiskStopLossAndAmountStrategy(TradingCalculator *calculator, double lots,
      StopLimitType stopLossType, double stopLoss, bool isBuy)
   {
      _calculator = calculator;
      _lots = lots;
      _stopLossType = stopLossType;
      _stopLoss = stopLoss;
      _isBuy = isBuy;
   }
   
   void GetStopLossAndAmount(const int period, const double entryPrice, double &amount, double &stopLoss)
   {
      stopLoss = _calculator.CalculateStopLoss(_isBuy, _stopLoss, _stopLossType, 0.0, entryPrice);
      amount = _calculator.GetLots(PositionSizeRisk, _lots, _isBuy ? (entryPrice - stopLoss) : (stopLoss - entryPrice));
   }
};

class HighLowPositionSizeRiskStopLossAndAmountStrategy : public IStopLossAndAmountStrategy
{
   double _lots;
   TradingCalculator *_calculator;
   int _bars;
   bool _isBuy;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   HighLowPositionSizeRiskStopLossAndAmountStrategy(TradingCalculator *calculator, double lots,
      int bars, bool isBuy, string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
      _calculator = calculator;
      _lots = lots;
      _bars = bars;
      _isBuy = isBuy;
   }
   
   void GetStopLossAndAmount(const int period, const double entryPrice, double &amount, double &stopLoss)
   {
      if (_isBuy)
      {
         int lowestIndex = iLowest(_symbol, _timeframe, MODE_LOW, _bars, period);
         stopLoss = iLow(_symbol, _timeframe, lowestIndex);
      }
      else
      {
         int highestIndex = iHighest(_symbol, _timeframe, MODE_HIGH, _bars, period);
         stopLoss = iHigh(_symbol, _timeframe, highestIndex);
      }
      amount = _calculator.GetLots(PositionSizeRisk, _lots, _isBuy ? (entryPrice - stopLoss) : (stopLoss - entryPrice));
   }
};

#endif