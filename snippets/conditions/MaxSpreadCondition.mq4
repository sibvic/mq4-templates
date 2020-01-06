// Max spead condition v2.0
class MaxSpreadCondition : public ACondition
{
   double _maxSpread;
public:
   MaxSpreadCondition(const string symbol, ENUM_TIMEFRAMES timeframe, double maxSpread)
      :ACondition(symbol, timeframe)
   {
      _maxSpread = maxSpread;
   }

   bool IsPass(const int period, const datetime date)
   {
      return _instrument.GetSpread() < _maxSpread;
   }
};