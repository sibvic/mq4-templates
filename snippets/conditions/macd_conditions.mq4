// MACD conditions v2.0

#ifndef MACDConditions_IMP
#define MACDConditions_IMP
#include <ABaseCondition.mq4>
class MACDAboveSignalCondition : public ABaseCondition
{
   int _shortPeriod;
   int _longPeriod;
   int _signalPeriod;
public:
   MACDAboveSignalCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int shortPeriod, int longPeriod, int signalPeriod)
      :ABaseCondition(symbol, timeframe)
   {
      _shortPeriod = shortPeriod;
      _longPeriod = longPeriod;
      _signalPeriod = signalPeriod;
   }

   bool IsPass(const int period, const datetime date)
   {
      double macdValue = iMACD(_symbol, _timeframe, _shortPeriod, _longPeriod, _signalPeriod, PRICE_CLOSE, MODE_MAIN, period);
      double signalValue = iMACD(_symbol, _timeframe, _shortPeriod, _longPeriod, _signalPeriod, PRICE_CLOSE, MODE_SIGNAL, period);
      return macdValue > signalValue;
   }
};

class MACDBelowSignalCondition : public ABaseCondition
{
   int _shortPeriod;
   int _longPeriod;
   int _signalPeriod;
public:
   MACDBelowSignalCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int shortPeriod, int longPeriod, int signalPeriod)
      :ABaseCondition(symbol, timeframe)
   {
      _shortPeriod = shortPeriod;
      _longPeriod = longPeriod;
      _signalPeriod = signalPeriod;
   }

   bool IsPass(const int period, const datetime date)
   {
      double macdValue = iMACD(_symbol, _timeframe, _shortPeriod, _longPeriod, _signalPeriod, PRICE_CLOSE, MODE_MAIN, period);
      double signalValue = iMACD(_symbol, _timeframe, _shortPeriod, _longPeriod, _signalPeriod, PRICE_CLOSE, MODE_SIGNAL, period);
      return macdValue > signalValue;
   }
};

class MACDAboveLevelCondition : public ABaseCondition
{
   int _shortPeriod;
   int _longPeriod;
   int _signalPeriod;
   int _stream;
   double _level;
public:
   MACDAboveLevelCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int shortPeriod, int longPeriod, int signalPeriod,
      int stream, double level)
      :ABaseCondition(symbol, timeframe)
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


class MACDBelowLevelCondition : public ABaseCondition
{
   int _shortPeriod;
   int _longPeriod;
   int _signalPeriod;
   int _stream;
   double _level;
public:
   MACDBelowLevelCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int shortPeriod, int longPeriod, int signalPeriod,
      int stream, double level)
      :ABaseCondition(symbol, timeframe)
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