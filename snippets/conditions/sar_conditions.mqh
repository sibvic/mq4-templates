// Parabolic SAR conditions v1.0
// More templates and snippets on https://github.com/sibvic/mq4-templates

class PSARBelowPriceCondition : public ACondition
{
   double _step;
   double _max;
   double _level;
public:
   PSARBelowPriceCondition(const string symbol, ENUM_TIMEFRAMES timeframe, double step, double max)
      :ACondition(symbol, timeframe)
   {
      _step = step;
      _max = max;
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double close = iClose(_symbol, _timeframe, period);
      double sarValue = iSAR(_symbol, _timeframe, _step, _max, period);
      return close > sarValue;
   }
};

class PSARAbovePriceCondition : public ACondition
{
   double _step;
   double _max;
   double _level;
public:
   PSARAbovePriceCondition(const string symbol, ENUM_TIMEFRAMES timeframe, double step, double max)
      :ACondition(symbol, timeframe)
   {
      _step = step;
      _max = max;
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double close = iClose(_symbol, _timeframe, period);
      double sarValue = iSAR(_symbol, _timeframe, _step, _max, period);
      return close < sarValue;
   }
};