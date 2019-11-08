// Ichimoku conditions v2.1
// More templates and snippets on https://github.com/sibvic/mq4-templates

#include <ABaseCondition.mq4>

#ifndef ICH_Conditions_IMP
#define ICH_Conditions_IMP

class PriceAboveKumhoCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
   int _streamPeriodShift;
public:
   PriceAboveKumhoCondition(const string symbol, 
      ENUM_TIMEFRAMES timeframe, 
      int tenkanSen,
      int kijunSen, 
      int senkoiSpanB,
      int streamPeriodShift = 0)

      :ABaseCondition(symbol, timeframe)
   {
      _streamPeriodShift = streamPeriodShift;
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return "Price > Kumho: " + (IsPass(period, date) ? "true" : "false");
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double close = iClose(_symbol, _timeframe, period);
      double saValue = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, MODE_SENKOUSPANA, period + _streamPeriodShift);
      double sbValue = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, MODE_SENKOUSPANB, period + _streamPeriodShift);
      return close > saValue && close > sbValue;
   }
};

class PriceBelowKumhoCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
   int _streamPeriodShift;
public:
   PriceBelowKumhoCondition(const string symbol, 
      ENUM_TIMEFRAMES timeframe, 
      int tenkanSen, 
      int kijunSen, 
      int senkoiSpanB,
      int streamPeriodShift = 0)

      :ABaseCondition(symbol, timeframe)
   {
      _streamPeriodShift = streamPeriodShift;
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return "Price < Kumho: " + (IsPass(period, date) ? "true" : "false");
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double close = iClose(_symbol, _timeframe, period);
      double saValue = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, MODE_SENKOUSPANA, period + _streamPeriodShift);
      double sbValue = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, MODE_SENKOUSPANB, period + _streamPeriodShift);
      return close < saValue && close < sbValue;
   }
};

string GetIchimokuStreamName(int streamIndex)
{
   switch (streamIndex)
   {
      case MODE_TENKANSEN:
         return "Tenkan-sen";
      case MODE_KIJUNSEN:
         return "Kijun-sen";
      case MODE_SENKOUSPANA:
         return "Senkou Span A";
      case MODE_SENKOUSPANB:
         return "Senkou Span B";
      case MODE_CHIKOUSPAN:
         return "Chikou Span";
   }
   return "";
}

class PriceAboveIchimokuStreamCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
   int _streamIndex;
   int _streamPeriodShift;
public:
   PriceAboveIchimokuStreamCondition(const string symbol, 
      ENUM_TIMEFRAMES timeframe, 
      int tenkanSen, 
      int kijunSen, 
      int senkoiSpanB, 
      int streamIndex, 
      int streamPeriodShift = 0)

      :ABaseCondition(symbol, timeframe)
   {
      _streamPeriodShift = streamPeriodShift;
      _streamIndex = streamIndex;
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return "Price > " + GetIchimokuStreamName(_streamIndex) + ": " + (IsPass(period, date) ? "true" : "false");
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double close = iClose(_symbol, _timeframe, period);
      double value = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _streamIndex, period + _streamPeriodShift);
      return close > value;
   }
};

class PriceBelowIchimokuStreamCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
   int _streamIndex;
   int _streamPeriodShift;
public:
   PriceBelowIchimokuStreamCondition(const string symbol, 
      ENUM_TIMEFRAMES timeframe, 
      int tenkanSen, 
      int kijunSen, 
      int senkoiSpanB, 
      int streamIndex, 
      int streamPeriodShift = 0)
      :ABaseCondition(symbol, timeframe)
   {
      _streamPeriodShift = streamPeriodShift;
      _streamIndex = streamIndex;
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return "Price < " + GetIchimokuStreamName(_streamIndex) + ": " + (IsPass(period, date) ? "true" : "false");
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double close = iClose(_symbol, _timeframe, period);
      double value = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _streamIndex, period + _streamPeriodShift);
      return close < value;
   }
};

class IchimokeStreamAboveIchimokuStreamCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
   int _firstStreamIndex;
   int _firstStreamPeriodShift;
   int _secondStreamIndex;
   int _secondStreamPeriodShift;
public:
   IchimokeStreamAboveIchimokuStreamCondition(const string symbol, 
      ENUM_TIMEFRAMES timeframe, 
      int tenkanSen, 
      int kijunSen, 
      int senkoiSpanB, 
      int firstStreamIndex, 
      int secondStreamIndex,
      int firstStreamPeriodShift = 0,
      int secondStreamPeriodShift = 0)
      :ABaseCondition(symbol, timeframe)
   {
      _firstStreamPeriodShift = firstStreamPeriodShift;
      _secondStreamPeriodShift = secondStreamPeriodShift;
      _firstStreamIndex = firstStreamIndex;
      _secondStreamIndex = secondStreamIndex;
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return GetIchimokuStreamName(_firstStreamIndex) + " > " + GetIchimokuStreamName(_secondStreamIndex) + ": " + (IsPass(period, date) ? "true" : "false");
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double value1 = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _firstStreamIndex, period + _firstStreamPeriodShift);
      double value2 = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _secondStreamIndex, period + _secondStreamPeriodShift);
      return value1 > value2;
   }
};

class IchimokeStreamBelowIchimokuStreamCondition : public ABaseCondition
{
   int _tenkanSen;
   int _kijunSen;
   int _senkoiSpanB;
   int _firstStreamIndex;
   int _firstStreamPeriodShift;
   int _secondStreamIndex;
   int _secondStreamPeriodShift;
public:
   IchimokeStreamBelowIchimokuStreamCondition(const string symbol, 
      ENUM_TIMEFRAMES timeframe, 
      int tenkanSen, 
      int kijunSen, 
      int senkoiSpanB, 
      int firstStreamIndex, 
      int secondStreamIndex,
      int firstStreamPeriodShift = 0,
      int secondStreamPeriodShift = 0)
      :ABaseCondition(symbol, timeframe)
   {
      _firstStreamPeriodShift = firstStreamPeriodShift;
      _secondStreamPeriodShift = secondStreamPeriodShift;
      _firstStreamIndex = firstStreamIndex;
      _secondStreamIndex = secondStreamIndex;
      _tenkanSen = tenkanSen;
      _kijunSen = kijunSen;
      _senkoiSpanB = senkoiSpanB;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      return GetIchimokuStreamName(_firstStreamIndex) + " < " + GetIchimokuStreamName(_secondStreamIndex) + ": " + (IsPass(period, date) ? "true" : "false");
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double value1 = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _firstStreamIndex, period + _firstStreamPeriodShift);
      double value2 = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, _secondStreamIndex, period + _secondStreamPeriodShift);
      return value1 < value2;
   }
};

#endif