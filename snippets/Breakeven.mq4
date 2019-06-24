// Breakeven logic v. 2.0
interface IBreakevenLogic
{
public:
   virtual void DoLogic(const int period) = 0;
   virtual void CreateBreakeven(const int order, const int period) = 0;
};

class DisabledBreakevenLogic : public IBreakevenLogic
{
public:
   void DoLogic(const int period) {}
   void CreateBreakeven(const int order, const int period) {}
};

class BreakevenController
{
   IOrder *_order;
   bool _finished;
   double _trigger;
   double _target;
   Signaler *_signaler;
   InstrumentInfo *_instrument;
   ICondition *_condition;
   string _name;
public:
   BreakevenController(Signaler *signaler)
   {
      _order = NULL;
      _condition = NULL;
      _instrument = NULL;
      _signaler = signaler;
      _finished = true;
   }

   ~BreakevenController()
   {
      delete _order;
      delete _condition;
      delete _instrument;
   }
   
   bool SetOrder(IOrder *order, const double trigger, const double target, ICondition *condition)
   {
      return SetOrder(order, trigger, target, condition, "");
   }

   bool SetOrder(IOrder *order, const double trigger, const double target, ICondition *condition, const string name)
   {
      if (!_finished)
         return false;
      if (!order.Select())
         return false;

      string symbol = OrderSymbol();
      if (_instrument == NULL || symbol != _instrument.GetSymbol())
      {
         delete _instrument;
         _instrument = new InstrumentInfo(symbol);
      }
      _finished = false;
      _trigger = trigger;
      _target = target;
      delete _order;
      _order = order;
      delete _condition;
      _name = name;
      _condition = condition;
      return true;
   }

   void DoLogic(const int period)
   {
      if (_finished || !_order.Select())
      {
         _finished = true;
         return;
      }

      int type = OrderType();
      if (type == OP_BUY)
      {
         if (_instrument.GetAsk() >= _trigger || (_condition != NULL && _condition.IsPass(period)))
         {
            int ticket = OrderTicket();
            if (_signaler != NULL)
               _signaler.SendNotifications(GetNamePrefix() + "Trade " + IntegerToString(ticket) + " has reached " 
                  + DoubleToString(_trigger, _instrument.GetDigits()) + ". Stop loss moved to " 
                  + DoubleToString(_target, _instrument.GetDigits()));
            int res = OrderModify(ticket, OrderOpenPrice(), _target, OrderTakeProfit(), 0, CLR_NONE);
            _finished = true;
         }
      }
      else if (type == OP_SELL)
      {
         if (_instrument.GetBid() < _trigger || (_condition != NULL && _condition.IsPass(period)))
         {
            int ticket = OrderTicket();
            if (_signaler != NULL)
               _signaler.SendNotifications(GetNamePrefix() + "Trade " + IntegerToString(ticket) + " has reached " 
                  + DoubleToString(_trigger, _instrument.GetDigits()) + ". Stop loss moved to " 
                  + DoubleToString(_target, _instrument.GetDigits()));
            int res = OrderModify(ticket, OrderOpenPrice(), _target, OrderTakeProfit(), 0, CLR_NONE);
            _finished = true;
         }
      }
   }
private:
   string GetNamePrefix()
   {
      if (_name == "")
         return "";
      return _name + ". ";
   }
};

class BreakevenLogic : public IBreakevenLogic
{
   StopLimitType _triggerType;
   double _trigger;
   double _target;
   TradeCalculator *_calculator;
   Signaler *_signaler;
   ActionOnConditionLogic* _actions;
public:
   BreakevenLogic(const StopLimitType triggerType, const double trigger,
      const double target, Signaler *signaler, ActionOnConditionLogic* actions)
   {
      Init();
      _signaler = signaler;
      _triggerType = triggerType;
      _trigger = trigger;
      _target = target;
      _actions = actions;
   }

   BreakevenLogic()
   {
      Init();
   }

   ~BreakevenLogic()
   {
      delete _calculator;
   }

   void CreateBreakeven(const int order, const int period, const StopLimitType triggerType, 
      const double trigger, const double target)
   {
      if (triggerType == StopLimitDoNotUse)
         return;
      
      if (!OrderSelect(order, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
         return;

      string symbol = OrderSymbol();
      if (_calculator == NULL || symbol != _calculator.GetSymbol())
      {
         delete _calculator;
         _calculator = TradeCalculator::Create(symbol);
         if (_calculator == NULL)
            return;
      }
      int isBuy = TradeCalculator::IsBuyOrder();
      double basePrice = OrderOpenPrice();
      double targetValue = _calculator.CalculateTakeProfit(isBuy, target, StopLimitPips, OrderLots(), basePrice);
      double triggerValue = _calculator.CalculateTakeProfit(isBuy, trigger, triggerType, OrderLots(), basePrice);
      CreateBreakeven(order, triggerValue, targetValue, "");
   }

   void CreateBreakeven(const int orderId, const int period)
   {
      CreateBreakeven(orderId, period, _triggerType, _trigger, _target);
   }
private:
   void Init()
   {
      _calculator = NULL;
      _signaler = NULL;
      _triggerType = StopLimitDoNotUse;
      _trigger = 0;
      _target = 0;
   }

   void CreateBreakeven(const int ticketId, const double trigger, const double target, const string name)
   {
      if (!OrderSelect(ticketId, SELECT_BY_TICKET, MODE_TRADES))
         return;
      IOrder *order = new OrderByMagicNumber(OrderMagicNumber());
      HitProfitCondition* condition = new HitProfitCondition();
      condition.Set(order, trigger);
      IAction* action = new MoveToBreakevenAction(trigger, target, name, order, _signaler);
      if (!_actions.AddActionOnCondition(action, condition))
      {
         delete action;
         delete condition;
      }
   }
};

class NetBreakevenController
{
   int _order;
   bool _finished;
   double _trigger;
   double _target;
   StopLimitType _triggerType;
   Signaler *_signaler;
   TradeCalculator *_calculator;
public:
   NetBreakevenController(TradeCalculator *calculator, Signaler *signaler)
   {
      _calculator = calculator;
      _signaler = signaler;
      _finished = true;
   }

   ~NetBreakevenController()
   {
   }
   
   bool SetOrder(const int order, const double trigger, const StopLimitType triggerType, const double target)
   {
      if (!_finished)
      {
         return false;
      }
      if (!OrderSelect(order, SELECT_BY_TICKET, MODE_TRADES))
         return false;

      string symbol = OrderSymbol();
      if (symbol != _calculator.GetSymbol())
         return false;
      _finished = false;
      _trigger = trigger;
      _target = target;
      _order = order;
      _triggerType = triggerType;
      return true;
   }

   void DoLogic(const int period)
   {
      if (_finished || !OrderSelect(_order, SELECT_BY_TICKET, MODE_TRADES))
      {
         _finished = true;
         return;
      }

      int type = OrderType();
      double totalAmount;
      int magicNumber = OrderMagicNumber();
      double orderLots = OrderLots();
      int ticket = OrderTicket();
      double orderOpenPrice = OrderOpenPrice();
      double orderTakeProfit = OrderTakeProfit();
      double averagePrice = _calculator.GetBreakevenPrice(type, magicNumber, totalAmount);
      double trigger = _calculator.CalculateTakeProfit(type == OP_BUY, _trigger, _triggerType, orderLots, averagePrice);
      if (type == OP_BUY)
      {
         if (_calculator.GetAsk() >= trigger)
         {
            double target = averagePrice + _target * _calculator.GetPipSize();
            _signaler.SendNotifications("Trade " + IntegerToString(ticket) + " has reached " 
               + DoubleToString(_trigger, 1) + ". Stop loss moved to " 
               + DoubleToString(target, _calculator.GetDigits()));
            int res = OrderModify(ticket, orderOpenPrice, target, orderTakeProfit, 0, CLR_NONE);
            _finished = true;
         }
      } 
      else if (type == OP_SELL)
      {
         if (_calculator.GetBid() < trigger) 
         {
            double target = averagePrice - _target * _calculator.GetPipSize();
            _signaler.SendNotifications("Trade " + IntegerToString(ticket) + " has reached " 
               + DoubleToString(_trigger, 1) + ". Stop loss moved to " 
               + DoubleToString(target, _calculator.GetDigits()));
            int res = OrderModify(ticket, orderOpenPrice, target, orderTakeProfit, 0, CLR_NONE);
            _finished = true;
         }
      } 
   }
};

class NetBreakevenLogic : public IBreakevenLogic
{
   NetBreakevenController *_breakeven[];
   StopLimitType _triggerType;
   double _trigger;
   double _target;
   TradeCalculator *_calculator;
   Signaler *_signaler;
public:
   NetBreakevenLogic(TradeCalculator *calculator, const StopLimitType triggerType, const double trigger,
      const double target, Signaler *signaler)
   {
      _signaler = signaler;
      _calculator = calculator;
      _triggerType = triggerType;
      _trigger = trigger;
      _target = target;
   }

   ~NetBreakevenLogic()
   {
      int i_count = ArraySize(_breakeven);
      for (int i = 0; i < i_count; ++i)
      {
         delete _breakeven[i];
      }
   }

   void DoLogic(const int period)
   {
      int i_count = ArraySize(_breakeven);
      for (int i = 0; i < i_count; ++i)
      {
         _breakeven[i].DoLogic(period);
      }
   }

   void CreateBreakeven(const int order, const int period)
   {
      if (_triggerType == StopLimitDoNotUse)
         return;
      
      if (!OrderSelect(order, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
         return;

      string symbol = OrderSymbol();
      if (symbol != _calculator.GetSymbol())
      {
         Print("Error in breakeven logic usage");
         return;
      }
      int i_count = ArraySize(_breakeven);
      for (int i = 0; i < i_count; ++i)
      {
         if (_breakeven[i].SetOrder(order, _trigger, _triggerType, _target))
         {
            return;
         }
      }

      ArrayResize(_breakeven, i_count + 1);
      _breakeven[i_count] = new NetBreakevenController(_calculator, _signaler);
      _breakeven[i_count].SetOrder(order, _trigger, _triggerType, _target);
   }
};