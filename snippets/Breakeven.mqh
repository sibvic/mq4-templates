// Breakeven logic v. 2.0
class NetBreakevenController
{
   int _order;
   bool _finished;
   double _trigger;
   double _target;
   StopLimitType _triggerType;
   Signaler *_signaler;
   TradingCalculator *_calculator;
public:
   NetBreakevenController(TradingCalculator *calculator, Signaler *signaler)
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
   TradingCalculator *_calculator;
   Signaler *_signaler;
public:
   NetBreakevenLogic(TradingCalculator *calculator, const StopLimitType triggerType, const double trigger,
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