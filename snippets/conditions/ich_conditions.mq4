// Ichimoku conditions v2.0
// More templates and snippets on https://github.com/sibvic/mq4-templates

#include <ABaseCondition.mq4>

#ifndef ICH_Conditions_IMP
#define ICH_Conditions_IMP

class PriceAboveKumhoCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
public:
   PriceAboveKumhoCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int tenkanSen, int kijunSen, int senkoiSpanB)
      :ABaseCondition(symbol, timeframe)
   {
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double close = iClose(_symbol, _timeframe, period);
      double saValue = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, MODE_SENKOUSPANA, period);
      double sbValue = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, MODE_SENKOUSPANB, period);
      return close > saValue && close > sbValue;
   }
};

class PriceBelowKumhoCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
public:
   PriceBelowKumhoCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int tenkanSen, int kijunSen, int senkoiSpanB)
      :ABaseCondition(symbol, timeframe)
   {
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double close = iClose(_symbol, _timeframe, period);
      double saValue = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, MODE_SENKOUSPANA, period);
      double sbValue = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, MODE_SENKOUSPANB, period);
      return close < saValue && close < sbValue;
   }
};

class PriceAboveIchimokuStreamCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
   int _streamIndex;
public:
   PriceAboveIchimokuStreamCondition(const string symbol, ENUM_TIMEFRAMES timeframe, 
      int tenkanSen, int kijunSen, int senkoiSpanB, int streamIndex)
      :ABaseCondition(symbol, timeframe)
   {
      _streamIndex = streamIndex;
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double close = iClose(_symbol, _timeframe, period);
      double value = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _streamIndex, period);
      return close > value;
   }
};

class PriceBelowIchimokuStreamCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
   int _streamIndex;
public:
   PriceBelowIchimokuStreamCondition(const string symbol, ENUM_TIMEFRAMES timeframe, 
      int tenkanSen, int kijunSen, int senkoiSpanB, int streamIndex)
      :ABaseCondition(symbol, timeframe)
   {
      _streamIndex = streamIndex;
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double close = iClose(_symbol, _timeframe, period);
      double value = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _streamIndex, period);
      return close < value;
   }
};

class IchimokeStreamAboveIchimokuStreamCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
   int _firstStreamIndex;
   int _secondStreamIndex;
public:
   IchimokeStreamAboveIchimokuStreamCondition(const string symbol, ENUM_TIMEFRAMES timeframe, 
      int tenkanSen, int kijunSen, int senkoiSpanB, int firstStreamIndex, int secondStreamIndex)
      :ABaseCondition(symbol, timeframe)
   {
      _firstStreamIndex = firstStreamIndex;
      _secondStreamIndex = secondStreamIndex;
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double value1 = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _firstStreamIndex, period);
      double value2 = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _secondStreamIndex, period);
      return value1 > value2;
   }
};

class IchimokeStreamBelowIchimokuStreamCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
   int _firstStreamIndex;
   int _secondStreamIndex;
public:
   IchimokeStreamBelowIchimokuStreamCondition(const string symbol, ENUM_TIMEFRAMES timeframe, 
      int tenkanSen, int kijunSen, int senkoiSpanB, int firstStreamIndex, int secondStreamIndex)
      :ABaseCondition(symbol, timeframe)
   {
      _firstStreamIndex = firstStreamIndex;
      _secondStreamIndex = secondStreamIndex;
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double value1 = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _firstStreamIndex, period);
      double value2 = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _secondStreamIndex, period);
      return value1 < value2;
   }
};

#endif