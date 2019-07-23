// Move net stop loss action v 1.0

#ifndef MoveNetStopLossAction_IMP

class MoveNetStopLossAction : public AAction
{
   TradeCalculator *_calculator;
   int _magicNumber;
   double _stopLoss;
   StopLimitType _type;
   Signaler *_signaler;
public:
   MoveNetStopLossAction(TradeCalculator *calculator, StopLimitType type, const double stopLoss, Signaler *signaler, const int magicNumber)
   {
      _type = type;
      _calculator = calculator;
      _stopLoss = stopLoss;
      _signaler = signaler;
      _magicNumber = magicNumber;
   }

   virtual void DoAction()
   {
      MoveStopLoss(OP_BUY);
      MoveStopLoss(OP_SELL);
   }
private:
   void MoveStopLoss(const int side)
   {
      OrdersIterator it();
      it.WhenMagicNumber(_magicNumber);
      it.WhenOrderType(side);
      it.WhenTrade();
      if (it.Count() <= 1)
         return;
      double totalAmount;
      double averagePrice = _calculator.GetBreakevenPrice(side, _magicNumber, totalAmount);
      if (averagePrice == 0.0)
         return;
         
      double stopLoss = _calculator.CalculateStopLoss(side == OP_BUY, _stopLoss, _type, totalAmount, averagePrice);
      
      OrdersIterator it1();
      it1.WhenMagicNumber(_magicNumber);
      it1.WhenSymbol(_calculator.GetSymbol());
      it1.WhenOrderType(side);
      it1.WhenTrade();
      int count = 0;
      while (it1.Next())
      {
         if (OrderStopLoss() != stopLoss)
         {
            int res = OrderModify(OrderTicket(), OrderOpenPrice(), stopLoss, OrderTakeProfit(), 0, CLR_NONE);
            if (res == 0)
            {
               int error = GetLastError();
               switch (error)
               {
                  case ERR_NO_RESULT:
                     break;
                  case ERR_INVALID_TICKET:
                     break;
               }
            }
            else
               ++count;
         }
      }
      if (_signaler != NULL && count > 0)
         _signaler.SendNotifications("Moving net stop loss to " + DoubleToStr(stopLoss));
   }
};

#define MoveNetStopLossAction_IMP

#endif