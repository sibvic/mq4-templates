// iWPR conditions v1.0

#include <ACondition.mqh>

#ifndef WPR_Conditions_IMP
#define WPR_Conditions_IMP

class WPRAboveLevel : public ACondition
{
   int _period;
   double _level;
public:
   WPRAboveLevel(const string symbol, ENUM_TIMEFRAMES timeframe, int period, double level)
      :ACondition(symbol, timeframe)
   {
      _period = period;
      _level = level;
   }

   bool IsPass(const int period, const datetime date)
   {
      return iWPR(_symbol, _timeframe, _period, period) > _level;
   }
};

class WPRBelowLevel : public ACondition
{
   int _period;
   double _level;
public:
   WPRBelowLevel(const string symbol, ENUM_TIMEFRAMES timeframe, int period, double level)
      :ACondition(symbol, timeframe)
   {
      _period = period;
      _level = level;
   }

   bool IsPass(const int period, const datetime date)
   {
      return iWPR(_symbol, _timeframe, _period, period) < _level;
   }
};

#endif