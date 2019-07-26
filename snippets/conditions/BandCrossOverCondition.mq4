// Band cross over condition v1.0
class BandCrossOverCondition : public ABaseCondition
{
public:
   BandCrossOverCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period)
   {
      double lowerValue0 = iBands(_symbol, _timeframe, Bollinger_Bands_Periods, Bollinger_Bands_Deviations, 0, PRICE_CLOSE, MODE_LOWER, period);
      double lowerValue1 = iBands(_symbol, _timeframe, Bollinger_Bands_Periods, Bollinger_Bands_Deviations, 0, PRICE_CLOSE, MODE_LOWER, period + 1);
      double close0 = iClose(_symbol, _timeframe, period);
      double close1 = iClose(_symbol, _timeframe, period + 1);
      return lowerValue0 < close0 && lowerValue1 >= close1;
   }
};