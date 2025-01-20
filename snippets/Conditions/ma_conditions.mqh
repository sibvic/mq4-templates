// MA Conditions v4.1

#ifndef MAConditions_IMP
#define MAConditions_IMP

#include <conditions/ACondition.mqh>
#include <enums/TwoStreamsConditionType.mqh>

class MAMACondition : public ACondition
{
   ENUM_MA_METHOD _method1;
   int _period1;
   ENUM_MA_METHOD _method2;
   int _period2;
   TwoStreamsConditionType _condition;
   int _shift1;
   int _shift2;
   ENUM_APPLIED_PRICE _price1;
   ENUM_APPLIED_PRICE _price2;
public:
   MAMACondition(const string symbol, ENUM_TIMEFRAMES timeframe, TwoStreamsConditionType condition
      , ENUM_MA_METHOD method1, int period1, ENUM_APPLIED_PRICE price1
      , ENUM_MA_METHOD method2, int period2, ENUM_APPLIED_PRICE price2
      , int shift1 = 0, int shift2 = 0)
      :ACondition(symbol, timeframe)
   {
      _price1 = price1;
      _price2 = price2;
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
      double value10 = iMA(_symbol, _timeframe, _period1, 0, _method1, _price1, period + _shift1);
      double value11 = iMA(_symbol, _timeframe, _period1, 0, _method1, _price1, period + 1 + _shift1);
      double value20 = iMA(_symbol, _timeframe, _period2, 0, _method2, _price2, period + _shift2);
      double value21 = iMA(_symbol, _timeframe, _period2, 0, _method2, _price2, period + 1 + _shift2);
      switch (_condition)
      {
         case FirstAboveSecond:
            return value10 > value20;
         case FirstBelowSecond:
            return value10 < value20;
         case FirstCrossOverSecond:
            return value10 >= value20 && value11 < value21;
         case FirstCrossUnderSecond:
            return value10 <= value20 && value11 > value21;
      }
      return value10 >= value20 && value11 < value21;
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

class MAPriceCondition : public ACondition
{
   ENUM_MA_METHOD _method1;
   int _period1;
   TwoStreamsConditionType _condition;
   ENUM_APPLIED_PRICE _price;
   int _shift1;
public:
   MAPriceCondition(const string symbol, ENUM_TIMEFRAMES timeframe, TwoStreamsConditionType condition
      , ENUM_MA_METHOD method1, int period1
      , ENUM_APPLIED_PRICE price
      , int shift1 = 0)
      :ACondition(symbol, timeframe)
   {
      _price = price;
      _condition = condition;
      _method1 = method1;
      _period1 = period1;
      _shift1 = shift1;
   }

   bool IsPass(const int period, const datetime date)
   {
      double value10 = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period + _shift1);
      double value11 = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period + 1 + _shift1);
      double value20 = GetPrice(period);
      double value21 = GetPrice(period + 1);
      switch (_condition)
      {
         case FirstAboveSecond:
            return value10 > value20;
         case FirstBelowSecond:
            return value10 < value20;
         case FirstCrossOverSecond:
            return value10 >= value20 && value11 < value21;
         case FirstCrossUnderSecond:
            return value10 <= value20 && value11 > value21;
      }
      return value10 >= value20 && value11 < value21;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      switch (_condition)
      {
         case FirstAboveSecond:
            return "MA > price: " + (result ? "true" : "false");
         case FirstBelowSecond:
            return "MA < price: " + (result ? "true" : "false");
         case FirstCrossOverSecond:
            return "MA co price: " + (result ? "true" : "false");
         case FirstCrossUnderSecond:
            return "MA cu price: " + (result ? "true" : "false");
      }
      return "MA-price: " + (result ? "true" : "false");
   }
private:
   double GetPrice(int period)
   {
      switch (_price)
      {
         case PRICE_CLOSE:
            return iClose(_symbol, _timeframe, period);
         case PRICE_OPEN:
            return iOpen(_symbol, _timeframe, period);
         case PRICE_HIGH:
            return iHigh(_symbol, _timeframe, period);
         case PRICE_LOW:
            return iLow(_symbol, _timeframe, period);
         case PRICE_MEDIAN:
            return (iHigh(_symbol, _timeframe, period) + iLow(_symbol, _timeframe, period)) / 2.0;
         case PRICE_TYPICAL:
            return (iHigh(_symbol, _timeframe, period) + iLow(_symbol, _timeframe, period) + iClose(_symbol, _timeframe, period)) / 3.0;
         case PRICE_WEIGHTED:
            return (iHigh(_symbol, _timeframe, period) + iLow(_symbol, _timeframe, period) + iClose(_symbol, _timeframe, period) * 2) / 4.0;
      }
      return 0;
   }
};

class PriceMACondition : public ACondition
{
   ENUM_MA_METHOD _method1;
   int _period1;
   TwoStreamsConditionType _condition;
   ENUM_APPLIED_PRICE _price;
   int _shift1;
   int _shift2;
public:
   PriceMACondition(const string symbol, ENUM_TIMEFRAMES timeframe, TwoStreamsConditionType condition
      , ENUM_APPLIED_PRICE price
      , ENUM_MA_METHOD method1, int period1
      , int shift1 = 0
      , int shift2 = 0)
      :ACondition(symbol, timeframe)
   {
      _price = price;
      _condition = condition;
      _method1 = method1;
      _period1 = period1;
      _shift1 = shift1;
      _shift2 = shift2;
   }

   bool IsPass(const int period, const datetime date)
   {
      double value20 = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period + _shift1);
      double value21 = iMA(_symbol, _timeframe, _period1, 0, _method1, PRICE_CLOSE, period + 1 + _shift1);
      double value10 = GetPrice(period + _shift2);
      double value11 = GetPrice(period + 1 + _shift2);
      switch (_condition)
      {
         case FirstAboveSecond:
            return value10 > value20;
         case FirstBelowSecond:
            return value10 < value20;
         case FirstCrossOverSecond:
            return value10 >= value20 && value11 < value21;
         case FirstCrossUnderSecond:
            return value10 <= value20 && value11 > value21;
      }
      return value10 >= value20 && value11 < value21;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      switch (_condition)
      {
         case FirstAboveSecond:
            return "MA > price: " + (result ? "true" : "false");
         case FirstBelowSecond:
            return "MA < price: " + (result ? "true" : "false");
         case FirstCrossOverSecond:
            return "MA co price: " + (result ? "true" : "false");
         case FirstCrossUnderSecond:
            return "MA cu price: " + (result ? "true" : "false");
      }
      return "MA-price: " + (result ? "true" : "false");
   }
private:
   double GetPrice(int period)
   {
      switch (_price)
      {
         case PRICE_CLOSE:
            return iClose(_symbol, _timeframe, period);
         case PRICE_OPEN:
            return iOpen(_symbol, _timeframe, period);
         case PRICE_HIGH:
            return iHigh(_symbol, _timeframe, period);
         case PRICE_LOW:
            return iLow(_symbol, _timeframe, period);
         case PRICE_MEDIAN:
            return (iHigh(_symbol, _timeframe, period) + iLow(_symbol, _timeframe, period)) / 2.0;
         case PRICE_TYPICAL:
            return (iHigh(_symbol, _timeframe, period) + iLow(_symbol, _timeframe, period) + iClose(_symbol, _timeframe, period)) / 3.0;
         case PRICE_WEIGHTED:
            return (iHigh(_symbol, _timeframe, period) + iLow(_symbol, _timeframe, period) + iClose(_symbol, _timeframe, period) * 2) / 4.0;
      }
      return 0;
   }
};

#endif