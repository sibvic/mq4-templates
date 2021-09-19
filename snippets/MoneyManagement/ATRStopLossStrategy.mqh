#include <MoneyManagement/IStopLossStrategy.mqh>

// ATR stop loss strategy v1.1

#ifndef ATRStopLossStrategy_IMP
#define ATRStopLossStrategy_IMP

class ATRStopLossStrategy : public IStopLossStrategy
{
   int _period;
   double _multiplicator;
   bool _isBuy;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   ATRStopLossStrategy(string symbol, ENUM_TIMEFRAMES timeframe, int period, double multiplicator, bool isBuy)
   {
      _symbol = symbol;
      _timeframe = timeframe;
      _period = period;
      _multiplicator = multiplicator;
      _isBuy = isBuy;
   }

   virtual double GetValue(const int period, double entryPrice)
   {
      double atrValue = iATR(_symbol, _timeframe, _period, period) * _multiplicator;
      return _isBuy ? (entryPrice - atrValue) : (entryPrice + atrValue);
   }
};
#endif