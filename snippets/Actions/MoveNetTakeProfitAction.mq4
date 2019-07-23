// Move net take profit action v 1.0

#ifndef MoveNetStopLossAction_IMP

class MoveNetTakeProfitAction : public AAction
{
   TradeCalculator *_calculator;
   int _magicNumber;
   double _takeProfit;
   StopLimitType _type;
   Signaler *_signaler;
public:
   MoveNetTakeProfitAction(TradeCalculator *calculator, StopLimitType type, const double takeProfit, Signaler *signaler, const int magicNumber)
   {
      _type = type;
      _calculator = calculator;
      _takeProfit = takeProfit;
      _signaler = signaler;
      _magicNumber = magicNumber;
   }

   virtual void DoAction()
   {
      MoveTakeProfit(OP_BUY);
      MoveTakeProfit(OP_SELL);
   }
private:
   void MoveTakeProfit(const int side)
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
         
      double takeProfit = _calculator.CalculateTakeProfit(side == OP_BUY, _takeProfit, _type, totalAmount, averagePrice);
      
      OrdersIterator it1();
      it1.WhenMagicNumber(_magicNumber);
      it1.WhenSymbol(_calculator.GetSymbol());
      it1.WhenOrderType(side);
      it1.WhenTrade();
      int count = 0;
      while (it1.Next())
      {
         if (OrderTakeProfit() != takeProfit)
         {
            int res = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), takeProfit, 0, CLR_NONE);
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
         _signaler.SendNotifications("Moving net take profit to " + DoubleToStr(takeProfit));
   }
};

#define MoveNetStopLossAction_IMP

#endif