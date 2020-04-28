// MA Conditions v3.0

#ifndef MAConditions_IMP
#define MAConditions_IMP

#include <ACondition.mq4>
#include <../enums/TwoStreamsConditionType.mq4>

class MAMACondition : public ACondition
{
   ENUM_MA_METHOD _method1;
   int _period1;
   ENUM_MA_METHOD _method2;
   int _period2;
   TwoStreamsConditionType _condition;
   int _shift1;
   int _shift2;
public:
   MAMACondition(const string symbol, ENUM_TIMEFRAMES timeframe, TwoStreamsConditionType condition
      , ENUM_MA_METHOD method1, int period1
      , ENUM_MA_METHOD method2, int period2
      , int shift1 = 0, int shift2 = 0)
      :ACondition(symbol, timeframe)
   {
      _condition = condition;
      _method1 = method1;
      _period1 = period1;
      _method2 = method2;
      _period2 = period2;
      _shift1 = shift1;
      _shift2 = shift2;
   }

   bool IsPass(const int period, const datetime date)
   {
      double ma1Value0 = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period + _shift1);
      double ma1Value1 = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period + 1 + _shift1);
      double ma2Value0 = iMA(_symbol, _timeframe, _period2, 0, _method2, PRICE_CLOSE, period + _shift2);
      double ma2Value1 = iMA(_symbol, _timeframe, _period2, 0, _method2, PRICE_CLOSE, period + 1 + _shift2);
      switch (_condition)
      {
         case FirstAboveSecond:
            return ma1Value0 > ma2Value0;
         case FirstBelowSecond:
            return ma1Value0 < ma2Value0;
         case FirstCrossOverSecond:
            return ma1Value0 >= ma2Value0 && ma1Value1 < ma2Value1;
         case FirstCrossUnderSecond:
            return ma1Value0 <= ma2Value0 && ma1Value1 > ma2Value1;
      }
      return ma1Value0 >= ma2Value0 && ma1Value1 < ma2Value1;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      switch (_condition)
      {
         case FirstAboveSecond:
            return "MA > MA: " + (result ? "true" : "false");
         case FirstBelowSecond:
            return "MA < MA: " + (result ? "true" : "false");
         case FirstCrossOverSecond:
            return "MA co MA: " + (result ? "true" : "false");
         case FirstCrossUnderSecond:
            return "MA cu MA: " + (result ? "true" : "false");
      }
      return "MA-MA: " + (result ? "true" : "false");
   }
};

class MAAbovePriceCondition : public ACondition
{
   ENUM_MA_METHOD _method;
   int _period;
   double _maxDistance;
public:
   MAAbovePriceCondition(const string symbol, ENUM_TIMEFRAMES timeframe, ENUM_MA_METHOD method, int period, double maxDistancePips = 0)
      :ACondition(symbol, timeframe)
   {
      _method = method;
      _period = period;
      _maxDistance = maxDistancePips * _instrument.GetPipSize(); 
   }

   bool IsPass(const int period, const datetime date)
   {
      double maValue = iMA(_symbol, _timeframe, _period, 0, _method, PRICE_CLOSE, period);
      double diff = maValue - iClose(_symbol, _timeframe, period);
      if (_maxDistance != 0.0 && diff > _maxDistance)
      {
         return false;
      }
      return diff > 0;
   }
};

class MABelowPriceCondition : public ACondition
{
   ENUM_MA_METHOD _method;
   int _period;
   double _maxDistance;
public:
   MABelowPriceCondition(const string symbol, ENUM_TIMEFRAMES timeframe, ENUM_MA_METHOD method, int period, double maxDistancePips = 0)
      :ACondition(symbol, timeframe)
   {
      _method = method;
      _period = period;
      _maxDistance = maxDistancePips * _instrument.GetPipSize(); 
   }

   bool IsPass(const int period, const datetime date)
   {
      double maValue = iMA(_symbol, _timeframe, _period, 0, _method, PRICE_CLOSE, period);
      double diff = iClose(_symbol, _timeframe, period) - maValue;
      if (_maxDistance != 0.0 && diff > _maxDistance)
      {
         return false;
      }
      return diff > 0;
   }
};

#endif