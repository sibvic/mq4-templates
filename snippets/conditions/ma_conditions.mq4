// MA Conditions v1.0

#ifndef MAConditions_IMP
#define MAConditions_IMP

#include <ABaseCondition.mq4>

class MAAbovePriceCondition : public ABaseCondition
{
   ENUM_MA_METHOD _method;
   int _period;
public:
   MAAbovePriceCondition(const string symbol, ENUM_TIMEFRAMES timeframe, ENUM_MA_METHOD method, int period)
      :ABaseCondition(symbol, timeframe)
   {
      _method = method;
      _period = period;
   }

   bool IsPass(const int period)
   {
      double maValue = iMA(_symbol, _timeframe, _period, 0, _method, PRICE_CLOSE, period);
      return maValue > iClose(_symbol, _timeframe, period);
   }
};

class MABelowPriceCondition : public ABaseCondition
{
   ENUM_MA_METHOD _method;
   int _period;
public:
   MABelowPriceCondition(const string symbol, ENUM_TIMEFRAMES timeframe, ENUM_MA_METHOD method, int period)
      :ABaseCondition(symbol, timeframe)
   {
      _method = method;
      _period = period;
   }

   bool IsPass(const int period)
   {
      double maValue = iMA(_symbol, _timeframe, _period, 0, _method, PRICE_CLOSE, period);
      return maValue < iClose(_symbol, _timeframe, period);
   }
};
#endif