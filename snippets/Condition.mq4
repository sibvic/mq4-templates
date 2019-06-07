// Condition v1.0
interface ICondition
{
public:
   virtual bool IsPass(const int period) = 0;
};

interface IConditionFactory
{
public:
   virtual ICondition *CreateCondition(const int order) = 0;
};

class ABaseCondition : public ICondition
{
protected:
   ENUM_TIMEFRAMES _timeframe;
   InstrumentInfo *_instrument;
   string _symbol;
public:
   ABaseCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _instrument = new InstrumentInfo(symbol);
      _timeframe = timeframe;
      _symbol = symbol;
   }
   ~ABaseCondition()
   {
      delete _instrument;
   }
};

class LongCondition : public ABaseCondition
{
public:
   LongCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period)
   {
      //TODO: implement
      return false;
   }
};

class ShortCondition : public ABaseCondition
{
public:
   ShortCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period)
   {
      //TODO: implement
      return false;
   }
};

class ExitLongCondition : public ABaseCondition
{
public:
   ExitLongCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }
   
   bool IsPass(const int period)
   {
      //TODO: implement
      return false;
   }
};

class ExitShortCondition : public ABaseCondition
{
public:
   ExitShortCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }
   
   bool IsPass(const int period)
   {
      //TODO: implement
      return false;
   }
};

class DisabledCondition : public ICondition
{
public:
   bool IsPass(const int period) { return false; }
};

class NoCondition : public ICondition
{
public:
   bool IsPass(const int period) { return true; }
};

class AndCondition : public ICondition
{
   ICondition *_conditions[];
public:
   ~AndCondition()
   {
      int size = ArraySize(_conditions);
      for (int i = 0; i < size; ++i)
      {
         delete _conditions[i];
      }
   }

   void Add(ICondition *condition)
   {
      int size = ArraySize(_conditions);
      ArrayResize(_conditions, size + 1);
      _conditions[size] = condition;
   }

   virtual bool IsPass(const int period)
   {
      int size = ArraySize(_conditions);
      for (int i = 0; i < size; ++i)
      {
         if (!_conditions[i].IsPass(period))
            return false;
      }
      return true;
   }
};

class OrCondition : public ICondition
{
   ICondition *_conditions[];
public:
   ~OrCondition()
   {
      int size = ArraySize(_conditions);
      for (int i = 0; i < size; ++i)
      {
         delete _conditions[i];
      }
   }

   void Add(ICondition *condition)
   {
      int size = ArraySize(_conditions);
      ArrayResize(_conditions, size + 1);
      _conditions[size] = condition;
   }

   virtual bool IsPass(const int period)
   {
      int size = ArraySize(_conditions);
      for (int i = 0; i < size; ++i)
      {
         if (_conditions[i].IsPass(period))
            return true;
      }
      return false;
   }
};