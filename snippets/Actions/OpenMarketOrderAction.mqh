#include <../Logic/ActionOnConditionLogic.mqh>
#include <../MarketOrderBuilder.mqh>
#include <../InstrumentInfo.mqh>
#include <../TradingCalculator.mqh>
#include <../enums/PositionSizeType.mqh>
#include <../enums/OrderSide.mqh>
#include <../enums/StopLossType.mqh>
#include <../enums/TakeProfitType.mqh>
#include <../MoneyManagement/functions.mqh>

// Open market order action v1.0

#ifndef OpenMarketOrderAction_IMP
#define OpenMarketOrderAction_IMP

class OpenMarketOrderAction : public AAction
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   double _amount;
   PositionSizeType _lotsType;
   OrderSide _side;
   StopLossType _stopLossType;
   double _stopLossValue;
   double _stopLossAtrMultiplicator;
   TakeProfitType _takeProfitType;
   double _takeProfitValue;
   double _takeProfitAtrMultiplicator;
   bool _ecnBroker;
   double _slippagePoints;
   int _magicNumber;
   ActionOnConditionLogic* _actions;
public:
   OpenMarketOrderAction(string symbol, PositionSizeType lotsType, double lotsValue, OrderSide side, ActionOnConditionLogic* actions)
   {
      _actions = actions;
      _side = side;
      _timeframe = PERIOD_CURRENT;
      _symbol = symbol;
      _amount = lotsValue;
      _lotsType = lotsType;
      _stopLossType = SLDoNotUse;
      _takeProfitType = TPDoNotUse;
   }

   void SetECNBroker(bool ecn)
   {
      _ecnBroker = ecn;
   }

   void SetSlippagePoints(double points)
   {
      _slippagePoints = points;
   }

   void SetMagicNumber(int number)
   {
      _magicNumber = number;
   }

   void SetTimeframe(ENUM_TIMEFRAMES tf)
   {
      _timeframe = tf;
   }

   void SetStopLoss(StopLossType stopLossType, double stopLossValue, double stopLossAtrMultiplicator)
   {
      _stopLossAtrMultiplicator = stopLossAtrMultiplicator;
      _stopLossType = stopLossType;
      _stopLossValue = stopLossValue;
   }

   void SetTakeProfit(TakeProfitType takeProfitType, double takeProfitValue, double takeProfitAtrMultiplicator)
   {
      _takeProfitAtrMultiplicator = takeProfitAtrMultiplicator;
      _takeProfitType = takeProfitType;
      _takeProfitValue = takeProfitValue;
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      string error;
      TradingCalculator* tradingCalculator = TradingCalculator::Create(_symbol);
      if (tradingCalculator == NULL || !tradingCalculator.IsLotsValid(_amount, _lotsType, error))
      {
         delete tradingCalculator;
         return false;
      }
      IMoneyManagementStrategy* moneyManagement = CreateMoneyManagementStrategy(tradingCalculator, _symbol, _timeframe, _side == BuySide, 
         _lotsType, _amount, _stopLossType, _stopLossValue, _stopLossAtrMultiplicator, _takeProfitType, _takeProfitValue, _takeProfitAtrMultiplicator);
      double entryPrice = _side == BuySide ? InstrumentInfo::GetAsk(_symbol) : InstrumentInfo::GetBid(_symbol);
      double takeProfit;
      double stopLoss;
      double amount;
      moneyManagement.Get(0, entryPrice, amount, stopLoss, takeProfit);
      delete moneyManagement;
      delete tradingCalculator;
      if (amount == 0.0)
      {
         Print("Lot size is too small");
         return false;
      }
      MarketOrderBuilder *orderBuilder = new MarketOrderBuilder(_actions);
      int order = orderBuilder
         .SetSide(_side)
         .SetECNBroker(_ecnBroker)
         .SetInstrument(_symbol)
         .SetAmount(amount)
         .SetSlippage(_slippagePoints)
         .SetMagicNumber(_magicNumber)
         .SetStopLoss(stopLoss)
         .SetTakeProfit(takeProfit)
         .Execute(error);
      delete orderBuilder;
      if (error != "")
      {
         Print("Failed to open position: " + error);
      }

      return true;
   }
};

#endif