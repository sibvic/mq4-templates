#include <MoneyManagement/ILotsProvider.mqh>
#include <Logic/ActionOnConditionLogic.mqh>
#include <enums/MartingaleLotSizingType.mqh>
#include <Order/OrderByTicketId.mqh>
#include <Actions/AOrderAction.mqh>
#include <InstrumentInfo.mqh>
#include <Conditions/ProfitInRangeCondition.mqh>
#include <TradingCalculator.mqh>
// v3.0

class CustomLotsProvider : public ILotsProvider
{
   double _lots;
public:
   void SetLots(double lots)
   {
      _lots = lots;
   }

   virtual double GetValue(int period, double entryPrice)
   {
      return _lots;
   }
};

class CreateMartingaleAction : public AOrderAction
{
   ActionOnConditionLogic* _actions;
   double _martingaleStepPips;
   IAction* _longAction;
   IAction* _shortAction;
   int _maxLongPositions;
   int _maxShortPositions;
   double _lotsValue;
   MartingaleLotSizingType _lotsSizingType;
   CustomLotsProvider* _lots;
   bool _inProfit;
   int _magicNumber;
public:
   CreateMartingaleAction(CustomLotsProvider* lots, MartingaleLotSizingType lotsSizingType, double lotsValue, 
      double martingaleStepPips, IAction* longAction, IAction* shortAction, 
      int maxLongPositions, int maxShortPositions, ActionOnConditionLogic* actions, bool inProfit, int magicNumber)
   {
      _magicNumber = magicNumber;
      _lots = lots;
      _lotsValue = lotsValue;
      _lotsSizingType = lotsSizingType;
      _maxLongPositions = maxLongPositions;
      _maxShortPositions = maxShortPositions;
      _longAction = longAction;
      _longAction.AddRef();
      _shortAction = shortAction;
      _shortAction.AddRef();
      _actions = actions;
      _martingaleStepPips = martingaleStepPips;
      _inProfit = inProfit;
   }

   ~CreateMartingaleAction()
   {
      _longAction.Release();
      _shortAction.Release();
   }

   void RestoreActions(string symbol, int magicNumber)
   {
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      if (IsLimitHit())
      {
         return false;
      }
      OrderByTicketId* order = new OrderByTicketId(_currentTicket);
      if (!order.Select())
      {
         order.Release();
         return false;
      }
      InstrumentInfo instrument(OrderSymbol());
      switch (_lotsSizingType)
      {
         case MartingaleLotSizingNo:
            _lots.SetLots(OrderLots());
            break;
         case MartingaleLotSizingMultiplicator:
            _lots.SetLots(instrument.NormalizeLots(OrderLots() * _lotsValue));
            break;
         case MartingaleLotSizingAdd:
            _lots.SetLots(instrument.NormalizeLots(OrderLots() + _lotsValue));
            break;
      }
      ProfitInRangeCondition* condition;
      if (_inProfit)
      {
         condition = new ProfitInRangeCondition(order, _martingaleStepPips, 100000);
      }
      else
      {
         condition = new ProfitInRangeCondition(order, -100000, -_martingaleStepPips);
      }
      if (TradingCalculator::IsBuyOrder())
      {
         _actions.AddActionOnCondition(_longAction, condition);
      }
      else
      {
         _actions.AddActionOnCondition(_shortAction, condition);
      }
      condition.Release();
      order.Release();

      return true;
   }
private:
   bool IsLimitHit()
   {
      OrdersIterator sideSpecificIterator();
      sideSpecificIterator.WhenMagicNumber(_magicNumber).WhenTrade();
      sideSpecificIterator.WhenSymbol(OrderSymbol());
      if (TradingCalculator::IsBuyOrder())
      {
         sideSpecificIterator.WhenSide(BuySide);
         int side_positions = sideSpecificIterator.Count();
         return side_positions >= _maxLongPositions;
      }
      sideSpecificIterator.WhenSide(SellSide);
      return sideSpecificIterator.Count() >= _maxShortPositions;
   }
};
