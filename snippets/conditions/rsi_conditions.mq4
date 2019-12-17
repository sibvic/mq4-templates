// RSI conditions v1.0
// More templates and snippets on https://github.com/sibvic/mq4-templates

#ifndef RSICondition_IMP
#define RSICondition_IMP

#include <ACondition.mq4>

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
   
   bool IsPass(const int period)
   {
      double rsiValue = iRSI(_symbol, _timeframe, _rsiPeriod, MODE_CLOSE, period);
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
   
   bool IsPass(const int period)
   {
      double rsiValue = iRSI(_symbol, _timeframe, _rsiPeriod, MODE_CLOSE, period);
      return rsiValue < _level;
   }
};
#endif