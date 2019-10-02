// MACD conditions v1.0

#ifndef MACDConditions_IMP
#define MACDConditions_IMP
#include <ABaseCondition.mq4>
class MACDAboveSignalCondition : public ABaseCondition
{
   int _shortPeriod;
   int _longPeriod;
   int _signalPeriod;
public:
   MACDAboveSignalCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int shortPeriod, int longPeriod, int signalPeriod)
      :ABaseCondition(symbol, timeframe)
   {
      _shortPeriod = shortPeriod;
      _longPeriod = longPeriod;
      _signalPeriod = signalPeriod;
   }

   bool IsPass(const int period)
   {
      double macdValue = iMACD(_symbol, _timeframe, _shortPeriod, _longPeriod, _signalPeriod, PRICE_CLOSE, MODE_MAIN, period);
      double signalValue = iMACD(_symbol, _timeframe, _shortPeriod, _longPeriod, _signalPeriod, PRICE_CLOSE, MODE_SIGNAL, period);
      return macdValue > signalValue;
   }
};

class MACDBelowSignalCondition : public ABaseCondition
{
   int _shortPeriod;
   int _longPeriod;
   int _signalPeriod;
public:
   MACDBelowSignalCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int shortPeriod, int longPeriod, int signalPeriod)
      :ABaseCondition(symbol, timeframe)
   {
      _shortPeriod = shortPeriod;
      _longPeriod = longPeriod;
      _signalPeriod = signalPeriod;
   }

   bool IsPass(const int period)
   {
      double macdValue = iMACD(_symbol, _timeframe, _shortPeriod, _longPeriod, _signalPeriod, PRICE_CLOSE, MODE_MAIN, period);
      double signalValue = iMACD(_symbol, _timeframe, _shortPeriod, _longPeriod, _signalPeriod, PRICE_CLOSE, MODE_SIGNAL, period);
      return macdValue > signalValue;
   }
};
#endif