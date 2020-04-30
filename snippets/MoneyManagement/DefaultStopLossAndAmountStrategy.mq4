// Default stop loss and amount strategy v1.0

#include <IStopLossAndAmountStrategy.mq4>
#include <../TradingCalculator.mq4>

#ifndef DefaultStopLossAndAmountStrategy_IMP
#define DefaultStopLossAndAmountStrategy_IMP

class DefaultStopLossAndAmountStrategy : public IStopLossAndAmountStrategy
{
   TradingCalculator *_calculator;
   StopLimitType _stopLossType;
   double _stopLoss;
   bool _isBuy;
   ILotsProvider* _lotsProvider;
public:
   DefaultStopLossAndAmountStrategy(TradingCalculator *calculator, ILotsProvider* lotsProvider,
      StopLimitType stopLossType, double stopLoss, bool isBuy)
   {
      _lotsProvider = lotsProvider;
      _isBuy = isBuy;
      _calculator = calculator;
      _stopLossType = stopLossType;
      _stopLoss = stopLoss;
   }

   ~DefaultStopLossAndAmountStrategy()
   {
      delete _lotsProvider;
   }
   
   void GetStopLossAndAmount(const int period, const double entryPrice, double &amount, double &stopLoss)
   {
      amount = _lotsProvider.GetLots(0.0);
      stopLoss = _calculator.CalculateStopLoss(_isBuy, _stopLoss, _stopLossType, amount, entryPrice);
   }
};

class HighLowStopLossAndAmountStrategy : public IStopLossAndAmountStrategy
{
   int _bars;
   bool _isBuy;
   ILotsProvider* _lotsProvider;
   ENUM_TIMEFRAMES _timeframe;
   string _symbol;
public:
   HighLowStopLossAndAmountStrategy(ILotsProvider* lotsProvider, int bars, bool isBuy, string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _lotsProvider = lotsProvider;
      _isBuy = isBuy;
      _bars = bars;
      _timeframe = timeframe;
      _symbol = symbol;
   }

   ~HighLowStopLossAndAmountStrategy()
   {
      delete _lotsProvider;
   }
   
   void GetStopLossAndAmount(const int period, const double entryPrice, double &amount, double &stopLoss)
   {
      amount = _lotsProvider.GetLots(0.0);
      if (_isBuy)
      {
         int lowestIndex = iLowest(_symbol, _timeframe, MODE_LOW, _bars, period);
         stopLoss = iLow(_symbol, _timeframe, lowestIndex);
         return;
      }
      int highestIndex = iHighest(_symbol, _timeframe, MODE_HIGH, _bars, period);
      stopLoss = iHigh(_symbol, _timeframe, highestIndex);
   }
};

#endif