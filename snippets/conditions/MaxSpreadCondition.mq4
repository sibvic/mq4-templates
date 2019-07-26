// Max spead condition v1.0
class MaxSpreadCondition : public ABaseCondition
{
   double _maxSpread;
public:
   MaxSpreadCondition(const string symbol, ENUM_TIMEFRAMES timeframe, double maxSpread)
      :ABaseCondition(symbol, timeframe)
   {
      _maxSpread = maxSpread;
   }

   bool IsPass(const int period)
   {
      return _instrument.GetSpread() < maxSpread;
   }
};