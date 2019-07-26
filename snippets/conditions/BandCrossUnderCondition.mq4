// Band cross under v1.0
class BandCrossUnderCondition : public ABaseCondition
{
public:
   BandCrossUnderCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period)
   {
      double upperValue0 = iBands(_symbol, _timeframe, Bollinger_Bands_Periods, Bollinger_Bands_Deviations, 0, PRICE_CLOSE, MODE_UPPER, period);
      double upperValue1 = iBands(_symbol, _timeframe, Bollinger_Bands_Periods, Bollinger_Bands_Deviations, 0, PRICE_CLOSE, MODE_UPPER, period + 1);
      double close0 = iClose(_symbol, _timeframe, period);
      double close1 = iClose(_symbol, _timeframe, period + 1);
      return upperValue0 > close0 && upperValue1 <= close1;
   }
};