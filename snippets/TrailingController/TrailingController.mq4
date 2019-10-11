// Trailing controller v1.0

#include <../InstrumentInfo.mq4>

#ifndef TrailingController_IMP
#define TrailingController_IMP

class TrailingController : public ITrailingController
{
   int _order;
   bool _finished;
   double _distance;
   double _trailingStep;
   double _trailingStart;
   InstrumentInfo *_instrument;
public:
   TrailingController()
   {
      _finished = true;
      _order = -1;
      _instrument = NULL;
   }

   ~TrailingController()
   {
      delete _instrument;
   }
   
   bool IsFinished()
   {
      return _finished;
   }

   bool SetOrder(const int order, const double distance, const double trailingStep, const double trailingStart = 0)
   {
      if (!_finished)
      {
         return false;
      }
      if (!OrderSelect(order, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
      {
         return false;
      }
      string symbol = OrderSymbol();
      if (_instrument == NULL || _instrument.GetSymbol() != symbol)
      {
         delete _instrument;
         _instrument = new InstrumentInfo(symbol);
      }
      _trailingStep = _instrument.RoundRate(trailingStep);
      if (_trailingStep == 0)
         return false;

      _trailingStart = trailingStart;

      _finished = false;
      _order = order;
      _distance = distance;
      
      return true;
   }

   void UpdateStop()
   {
      if (_finished || !OrderSelect(_order, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
      {
         _finished = true;
         return;
      }
      int type = OrderType();
      if (type == OP_BUY)
      {
         UpdateStopForLong();
      } 
      else if (type == OP_SELL) 
      {
         UpdateStopForShort();
      } 
   }

   TrailingControllerType GetType()
   {
      return TrailingControllerTypeStandard;
   }
private:
   void UpdateStopForLong()
   {
      double initialStop = OrderStopLoss();
      if (initialStop == 0.0)
         return;
      double ask = _instrument.GetAsk();
      double openPrice = OrderOpenPrice();
      if (openPrice > ask + _trailingStart * _instrument.GetPipSize())
         return;
      double newStop = initialStop;
      int digits = _instrument.GetDigits();
      while (NormalizeDouble(newStop + _trailingStep, digits) < NormalizeDouble(ask - _distance, digits))
      {
         newStop = NormalizeDouble(newStop + _trailingStep, digits);
      }
      if (newStop == initialStop) 
         return;

      int res = OrderModify(OrderTicket(), openPrice, newStop, OrderTakeProfit(), 0, CLR_NONE);
      if (res == 0)
      {
         int error = GetLastError();
         switch (error)
         {
            case ERR_INVALID_TICKET:
               _finished = true;
               break;
         }
      }
   }

   void UpdateStopForShort()
   {
      double initialStop = OrderStopLoss();
      if (initialStop == 0.0)
         return;
      double bid = _instrument.GetBid();
      double openPrice = OrderOpenPrice();
      if (openPrice < bid - _trailingStart * _instrument.GetPipSize())
         return;
      double newStop = initialStop;
      int digits = _instrument.GetDigits();
      while (NormalizeDouble(newStop - _trailingStep, digits) > NormalizeDouble(bid + _distance, digits))
      {
         newStop = NormalizeDouble(newStop - _trailingStep, digits);
      }
      if (newStop == initialStop) 
         return;
         
      int res = OrderModify(OrderTicket(), openPrice, newStop, OrderTakeProfit(), 0, CLR_NONE);
      if (res == 0)
      {
         int error = GetLastError();
         switch (error)
         {
            case ERR_INVALID_TICKET:
               _finished = true;
               break;
         }
      }
   }
};

#endif