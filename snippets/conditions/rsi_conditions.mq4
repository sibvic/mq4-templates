// RSI conditions v1.0
// More templates and snippets on https://github.com/sibvic/mq4-templates

class RSIAboveLevelCondition : public ABaseCondition
{
   int _rsiPeriod;
   double _level;
public:
   RSIAboveLevelCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int rsiPeriod, double level)
      :ABaseCondition(symbol, timeframe)
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

class RSIBelowLevelCondition : public ABaseCondition
{
   int _rsiPeriod;
   double _level;
public:
   RSIBelowLevelCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int rsiPeriod, double level)
      :ABaseCondition(symbol, timeframe)
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