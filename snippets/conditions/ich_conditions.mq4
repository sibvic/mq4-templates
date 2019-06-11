// Ichimoku conditions v1.0
// More templates and snippets on https://github.com/sibvic/mq4-templates

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
   
   bool IsPass(const int period)
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
   
   bool IsPass(const int period)
   {
      double close = iClose(_symbol, _timeframe, period);
      double saValue = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, MODE_SENKOUSPANA, period);
      double sbValue = iIchimoku(_symbol, _timeframe, _tenkanSen, _kijunSen, _senkoiSpanB, MODE_SENKOUSPANB, period);
      return close < saValue && close < sbValue;
   }
};