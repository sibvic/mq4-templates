// MA Conditions v2.0

#ifndef MAConditions_IMP
#define MAConditions_IMP

#include <ACondition.mq4>

class MACrossOverMACondition : public ACondition
{
   ENUM_MA_METHOD _method1;
   int _period1;
   ENUM_MA_METHOD _method2;
   int _period2;
public:
   MACrossOverMACondition(const string symbol, ENUM_TIMEFRAMES timeframe, ENUM_MA_METHOD method1, int period1
      , ENUM_MA_METHOD method2, int period2)
      :ACondition(symbol, timeframe)
   {
      _method1 = method1;
      _period1 = period1;
      _method2 = method2;
      _period2 = period2;
   }

   bool IsPass(const int period, const datetime date)
   {
      double ma1Value0 = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period);
      double ma1Value1 = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period + 1);
      double ma2Value0 = iMA(_symbol, _timeframe, _period2, 0, _method2, PRICE_CLOSE, period);
      double ma2Value1 = iMA(_symbol, _timeframe, _period2, 0, _method2, PRICE_CLOSE, period + 1);
      return ma1Value0 >= ma2Value0 && ma1Value1 < ma2Value1;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "MA cross over MA: " + (result ? "true" : "false");
   }
};

class MACrossUnderMACondition : public ACondition
{
   ENUM_MA_METHOD _method1;
   int _period1;
   ENUM_MA_METHOD _method2;
   int _period2;
public:
   MACrossUnderMACondition(const string symbol, ENUM_TIMEFRAMES timeframe, ENUM_MA_METHOD method1, int period1
      , ENUM_MA_METHOD method2, int period2)
      :ACondition(symbol, timeframe)
   {
      _method1 = method1;
      _period1 = period1;
      _method2 = method2;
      _period2 = period2;
   }

   bool IsPass(const int period, const datetime date)
   {
      double ma1Value0 = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period);
      double ma1Value1 = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period + 1);
      double ma2Value0 = iMA(_symbol, _timeframe, _period2, 0, _method2, PRICE_CLOSE, period);
      double ma2Value1 = iMA(_symbol, _timeframe, _period2, 0, _method2, PRICE_CLOSE, period + 1);
      return ma1Value0 <= ma2Value0 && ma1Value1 > ma2Value1;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "MA cross under MA: " + (result ? "true" : "false");
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

class MAAboveMACondition : public ACondition
{
   ENUM_MA_METHOD _method1;
   int _period1;
   ENUM_MA_METHOD _method2;
   int _period2;
   ENUM_TIMEFRAMES _timeframe2;
public:
   MAAboveMACondition(const string symbol, ENUM_TIMEFRAMES timeframe1, ENUM_MA_METHOD method1, int period1,
      ENUM_TIMEFRAMES timeframe2, ENUM_MA_METHOD method2, int period2)
      :ACondition(symbol, timeframe1)
   {
      _method1 = method1;
      _period1 = period1;
      _method2 = method2;
      _period2 = period2;
      _timeframe2 = timeframe2;
   }

   bool IsPass(const int period, const datetime date)
   {
      double ma1Value = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period);
      int secondPeriod = period;
      if (_timeframe2 != _timeframe)
      {
         secondPeriod = iBarShift(_symbol, _timeframe2, date);
         if (secondPeriod < 0)
         {
            return false;
         }
      }
      double ma2Value = iMA(_symbol, _timeframe2, _period2, 0, _method2, PRICE_CLOSE, secondPeriod);
      return ma1Value > ma2Value;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "MA above MA: " + (result ? "true" : "false");
   }
};

class MABelowMACondition : public ACondition
{
   ENUM_MA_METHOD _method1;
   int _period1;
   ENUM_MA_METHOD _method2;
   int _period2;
   ENUM_TIMEFRAMES _timeframe2;
public:
   MABelowMACondition(const string symbol, ENUM_TIMEFRAMES timeframe1, ENUM_MA_METHOD method1, int period1,
      ENUM_TIMEFRAMES timeframe2, ENUM_MA_METHOD method2, int period2)
      :ACondition(symbol, timeframe1)
   {
      _method1 = method1;
      _period1 = period1;
      _method2 = method2;
      _period2 = period2;
      _timeframe2 = timeframe2;
   }

   bool IsPass(const int period, const datetime date)
   {
      double ma1Value = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period);
      int secondPeriod = period;
      if (_timeframe2 != _timeframe)
      {
         secondPeriod = iBarShift(_symbol, _timeframe2, date);
         if (secondPeriod < 0)
         {
            return false;
         }
      }
      double ma2Value = iMA(_symbol, _timeframe2, _period2, 0, _method2, PRICE_CLOSE, secondPeriod);
      return ma1Value < ma2Value;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "MA below MA: " + (result ? "true" : "false");
   }
};
#endif