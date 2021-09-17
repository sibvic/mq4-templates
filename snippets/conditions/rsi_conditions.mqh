// RSI conditions v1.1
// More templates and snippets on https://github.com/sibvic/mq4-templates

#ifndef RSICondition_IMP
#define RSICondition_IMP

#include <ACondition.mqh>

class RSIAboveLevelCondition : public ACondition
{
   int _rsiPeriod;
   double _level;
public:
   RSIAboveLevelCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int rsiPeriod, double level)
      :ACondition(symbol, timeframe)
   {
      _rsiPeriod = rsiPeriod;
      _level = level;
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double rsiValue = iRSI(_symbol, _timeframe, _rsiPeriod, PRICE_CLOSE, period);
      return rsiValue > _level;
   }
};

class RSIBelowLevelCondition : public ACondition
{
   int _rsiPeriod;
   double _level;
public:
   RSIBelowLevelCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int rsiPeriod, double level)
      :ACondition(symbol, timeframe)
   {
      _rsiPeriod = rsiPeriod;
      _level = level;
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double rsiValue = iRSI(_symbol, _timeframe, _rsiPeriod, PRICE_CLOSE, period);
      return rsiValue < _level;
   }
};
#endif