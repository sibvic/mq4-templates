// MACD conditions v3.0
#include <ACondition.mq4>
#include <../enums/TwoStreamsConditionType.mq4>

#ifndef MACDConditions_IMP
#define MACDConditions_IMP

class MACDSignalCondition : public ACondition
{
   TwoStreamsConditionType _condition;
   int _fastEmaPeriod;
   int _slowEmaPeriod;
   int _signalPeriod;
public:
   MACDSignalCondition(const string symbol, ENUM_TIMEFRAMES timeframe, TwoStreamsConditionType condition, int fastEmaPeriod, int slowEmaPeriod, int signalPeriod)
      :ACondition(symbol, timeframe)
   {
      _condition = condition;
      _fastEmaPeriod = fastEmaPeriod;
      _slowEmaPeriod = slowEmaPeriod;
      _signalPeriod = signalPeriod;
   }

   bool IsPass(const int period, const datetime date)
   {
      double value10 = iMACD(_symbol, _timeframe, _fastEmaPeriod, _slowEmaPeriod, _signalPeriod, PRICE_CLOSE, MODE_MAIN, period);
      double value11 = iMACD(_symbol, _timeframe, _fastEmaPeriod, _slowEmaPeriod, _signalPeriod, PRICE_CLOSE, MODE_MAIN, period + 1);
      double value20 = iMACD(_symbol, _timeframe, _fastEmaPeriod, _slowEmaPeriod, _signalPeriod, PRICE_CLOSE, MODE_SIGNAL, period);
      double value21 = iMACD(_symbol, _timeframe, _fastEmaPeriod, _slowEmaPeriod, _signalPeriod, PRICE_CLOSE, MODE_SIGNAL, period + 1);
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
      return false;
   }
};

class MACDAboveLevelCondition : public ACondition
{
   int _shortPeriod;
   int _longPeriod;
   int _signalPeriod;
   int _stream;
   double _level;
public:
   MACDAboveLevelCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int shortPeriod, int longPeriod, int signalPeriod,
      int stream, double level)
      :ACondition(symbol, timeframe)
   {
      _shortPeriod = shortPeriod;
      _longPeriod = longPeriod;
      _signalPeriod = signalPeriod;
      _stream = stream;
      _level = level;
   }

   bool IsPass(const int period, const datetime date)
   {
      double macdValue = iMACD(_symbol, _timeframe, _shortPeriod, _longPeriod, _signalPeriod, PRICE_CLOSE, _stream, period);
      return macdValue > _level;
   }
};

class MACDBelowLevelCondition : public ACondition
{
   int _shortPeriod;
   int _longPeriod;
   int _signalPeriod;
   int _stream;
   double _level;
public:
   MACDBelowLevelCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int shortPeriod, int longPeriod, int signalPeriod,
      int stream, double level)
      :ACondition(symbol, timeframe)
   {
      _shortPeriod = shortPeriod;
      _longPeriod = longPeriod;
      _signalPeriod = signalPeriod;
      _stream = stream;
      _level = level;
   }

   bool IsPass(const int period, const datetime date)
   {
      double macdValue = iMACD(_symbol, _timeframe, _shortPeriod, _longPeriod, _signalPeriod, PRICE_CLOSE, _stream, period);
      return macdValue < _level;
   }
};
#endif