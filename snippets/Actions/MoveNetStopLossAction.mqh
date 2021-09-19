// Move net stop loss action v 2.0
#include <TradingCalculator.mqh>
#include <TradingCommands.mqh>
#include <Actions/AAction.mqh>

#ifndef MoveNetStopLossAction_IMP
#define MoveNetStopLossAction_IMP

class MoveNetStopLossAction : public AAction
{
   TradingCalculator *_calculator;
   int _magicNumber;
   double _stopLoss;
   double _breakevenTrigger;
   double _breakevenTarget;
   bool _useBreakeven;
   StopLimitType _type;
public:
   MoveNetStopLossAction(TradingCalculator *calculator, 
      StopLimitType type, 
      const double stopLoss, 
      const int magicNumber)
   {
      _useBreakeven = false;
      _type = type;
      _calculator = calculator;
      _stopLoss = stopLoss;
      _magicNumber = magicNumber;
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      MoveStopLoss(OP_BUY);
      MoveStopLoss(OP_SELL);
      return false;
   }

   void SetBreakeven(const double breakevenTrigger, const double breakevenTarget)
   {
      _useBreakeven = true;
      _breakevenTrigger = breakevenTrigger;
      _breakevenTarget = breakevenTarget;
   }
private:
   double GetDistance(const int side, double averagePrice)
   {
      if (side == OP_BUY)
      {
         return (_calculator.GetBid() - averagePrice) / _calculator.GetPipSize();
      }
      return (averagePrice - _calculator.GetAsk()) / _calculator.GetPipSize();
   }

   double GetTarget(const int side, double averagePrice)
   {
      if (!_useBreakeven)
      {
         return _stopLoss;
      }
      double distance = GetDistance(side, averagePrice);
      if (distance < _breakevenTrigger)
      {
         return _stopLoss;
      }
      return _breakevenTarget;
   }

   double GetStopLoss(int side)
   {
      double totalAmount;
      double averagePrice = _calculator.GetBreakevenPrice(side, _magicNumber, totalAmount);
      if (averagePrice == 0.0)
      {
         return 0;
      }
      return _calculator.CalculateStopLoss(side == OP_BUY, GetTarget(side, averagePrice), _type, totalAmount, averagePrice);
   }

   void MoveStopLoss(const int side)
   {
      OrdersIterator it();
      it.WhenMagicNumber(_magicNumber);
      it.WhenOrderType(side);
      it.WhenTrade();
      if (it.Count() <= 1)
      {
         return;
      }
      double stopLoss = GetStopLoss(side);
      if (stopLoss == 0)
      {
         return;
      }
      
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
            string error;
            if (!TradingCommands::MoveSL(OrderTicket(), stopLoss, error))
            {
               Print(error);
            }
            else
            {
               ++count;
            }
         }
      }
   }
};

#endif