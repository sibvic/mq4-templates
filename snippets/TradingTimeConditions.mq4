// Conditions of time v.1.0
class ABaseCondition : public ICondition
{
protected:
   ENUM_TIMEFRAMES _timeframe;
   InstrumentInfo *_instrument;
   TradingTime *_tradingTime;
   bool _lastStatus;
public:
   ABaseCondition(const string symbol, ENUM_TIMEFRAMES timeframe, TradingTime *tradingTime)
   {
      _tradingTime = tradingTime;
      _instrument = new InstrumentInfo(symbol);
      _timeframe = timeframe;
   }

   ~ABaseCondition()
   {
      delete _tradingTime;
      delete _instrument;
   }
};

class LongCondition : public ABaseCondition
{
public:
   LongCondition(const string symbol, ENUM_TIMEFRAMES timeframe, TradingTime *tradingTime)
      :ABaseCondition(symbol, timeframe, tradingTime)
   {
      _lastStatus = _tradingTime.IsTradingTime(TimeCurrent());
   }

   bool IsPass(const int period)
   {
      OrdersIterator it;
      return it.WhenMagicNumber(magic_number).Count() == 0;
   }
};

class ExitLongCondition : public ABaseCondition
{
public:
   ExitLongCondition(const string symbol, ENUM_TIMEFRAMES timeframe, TradingTime *tradingTime)
      :ABaseCondition(symbol, timeframe, tradingTime)
   {
      _lastStatus = _tradingTime.IsTradingTime(TimeCurrent());
   }
   
   bool IsPass(const int period)
   {
      bool tradingTime = _tradingTime.IsTradingTime(TimeCurrent());
      if (_lastStatus && !tradingTime)
      {
         _lastStatus = tradingTime;
         return true;
      }
      _lastStatus = tradingTime;
      return false;
   }
};

class ShortCondition : public ABaseCondition
{
public:
   ShortCondition(const string symbol, ENUM_TIMEFRAMES timeframe, TradingTime *tradingTime)
      :ABaseCondition(symbol, timeframe, tradingTime)
   {
      _lastStatus = _tradingTime.IsTradingTime(TimeCurrent());
   }

   bool IsPass(const int period)
   {
      OrdersIterator it;
      return it.WhenMagicNumber(magic_number).Count() == 0;
   }
};

class ExitShortCondition : public ABaseCondition
{
public:
   ExitShortCondition(const string symbol, ENUM_TIMEFRAMES timeframe, TradingTime *tradingTime)
      :ABaseCondition(symbol, timeframe, tradingTime)
   {
      _lastStatus = _tradingTime.IsTradingTime(TimeCurrent());
   }
   
   bool IsPass(const int period)
   {
      bool tradingTime = _tradingTime.IsTradingTime(TimeCurrent());
      if (_lastStatus && !tradingTime)
      {
         _lastStatus = tradingTime;
         return true;
      }
      _lastStatus = tradingTime;
      return false;
   }
};