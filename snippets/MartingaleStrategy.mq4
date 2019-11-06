// Martingale strategy v2.1
#include <enums/OrderSide.mq4>
#include <conditions/ICondition.mq4>

interface IMartingaleStrategy
{
public:
   virtual void OnOrder(const int order) = 0;
   virtual bool NeedAnotherPosition(OrderSide &side) = 0;
   virtual IMoneyManagementStrategy *GetMoneyManagement() = 0;
};

class NoMartingaleStrategy : public IMartingaleStrategy
{
public:
   void OnOrder(const int order) { }
   bool NeedAnotherPosition(OrderSide &side) { return false; }
   IMoneyManagementStrategy *GetMoneyManagement() { return NULL; }
};

class ACustomAmountMoneyManagementStrategy : public IMoneyManagementStrategy
{
protected:
   TradingCalculator *_calculator;
   double _amount;
public:
   ACustomAmountMoneyManagementStrategy(TradingCalculator *calculator)
   {
      _calculator = calculator;
      _amount = 0.0;
   }

   void SetAmount(const double amount)
   {
      _amount = amount;
   }
};

class CustomAmountLongMoneyManagementStrategy : public ACustomAmountMoneyManagementStrategy
{
public:
   CustomAmountLongMoneyManagementStrategy(TradingCalculator *calculator)
      :ACustomAmountMoneyManagementStrategy(calculator)
   {
   }

   void Get(const int period, const double rate, double &amount, double &stopLoss, double &takeProfit)
   {
      double ask = rate;
      amount = _amount;
      switch (stop_loss_type)
      {
         case SLDoNotUse:
            stopLoss = _calculator.CalculateStopLoss(true, stop_loss_value, StopLimitDoNotUse, amount, ask);
            break;
         case SLPercent:
            stopLoss = _calculator.CalculateStopLoss(true, stop_loss_value, StopLimitPercent, amount, ask);
            break;
         case SLPips:
            stopLoss = _calculator.CalculateStopLoss(true, stop_loss_value, StopLimitPips, amount, ask);
            break;
         case SLDollar:
            stopLoss = _calculator.CalculateStopLoss(true, stop_loss_value, StopLimitDollar, amount, ask);
            break;
         case SLAbsolute:
            stopLoss = _calculator.CalculateStopLoss(true, stop_loss_value, StopLimitAbsolute, amount, ask);
            break;
         case SLAtr:
            Print("Not supported yet");
            stopLoss = -1;
            break;
      }
      
      switch (take_profit_type)
      {
         case TPDoNotUse:
            takeProfit = _calculator.CalculateTakeProfit(true, take_profit_value, StopLimitDoNotUse, amount, ask);
            break;
         case TPPercent:
            takeProfit = _calculator.CalculateTakeProfit(true, take_profit_value, StopLimitPercent, amount, ask);
            break;
         case TPPips:
            takeProfit = _calculator.CalculateTakeProfit(true, take_profit_value, StopLimitPips, amount, ask);
            break;
         case TPDollar:
            takeProfit = _calculator.CalculateTakeProfit(true, take_profit_value, StopLimitDollar, amount, ask);
            break;
         case TPRiskReward:
            Print("Not supported yet");
            takeProfit = -1;
            break;
         case TPAbsolute:
            takeProfit = _calculator.CalculateTakeProfit(true, take_profit_value, StopLimitAbsolute, amount, ask);
            break;
         case TPAtr:
            Print("Not supported yet");
            takeProfit = -1;
            break;
      }
   }
};

class CustomAmountShortMoneyManagementStrategy : public ACustomAmountMoneyManagementStrategy
{
public:
   CustomAmountShortMoneyManagementStrategy(TradingCalculator *calculator)
      :ACustomAmountMoneyManagementStrategy(calculator)
   {
   }

   void Get(const int period, const double rate, double &amount, double &stopLoss, double &takeProfit)
   {
      double bid = rate;
      amount = _amount;
      switch (stop_loss_type)
      {
         case SLDoNotUse:
            stopLoss = _calculator.CalculateStopLoss(false, stop_loss_value, StopLimitDoNotUse, amount, bid);
            break;
         case SLPercent:
            stopLoss = _calculator.CalculateStopLoss(false, stop_loss_value, StopLimitPercent, amount, bid);
            break;
         case SLPips:
            stopLoss = _calculator.CalculateStopLoss(false, stop_loss_value, StopLimitPips, amount, bid);
            break;
         case SLDollar:
            stopLoss = _calculator.CalculateStopLoss(false, stop_loss_value, StopLimitDollar, amount, bid);
            break;
         case SLAbsolute:
            stopLoss = _calculator.CalculateStopLoss(false, stop_loss_value, StopLimitAbsolute, amount, bid);
            break;
         case SLAtr:
            Print("Not supported yet");
            stopLoss = -1;
            break;
      }
      switch (take_profit_type)
      {
         case TPDoNotUse:
            takeProfit = _calculator.CalculateTakeProfit(false, take_profit_value, StopLimitDoNotUse, amount, bid);
            break;
         case TPPercent:
            takeProfit = _calculator.CalculateTakeProfit(false, take_profit_value, StopLimitPercent, amount, bid);
            break;
         case TPPips:
            takeProfit = _calculator.CalculateTakeProfit(false, take_profit_value, StopLimitPips, amount, bid);
            break;
         case TPDollar:
            takeProfit = _calculator.CalculateTakeProfit(false, take_profit_value, StopLimitDollar, amount, bid);
            break;
         case TPRiskReward:
            Print("Not supported yet");
            takeProfit = -1;
            break;
         case TPAbsolute:
            takeProfit = _calculator.CalculateTakeProfit(false, take_profit_value, StopLimitAbsolute, amount, bid);
            break;
         case TPAtr:
            Print("Not supported yet");
            takeProfit = -1;
            break;
      }
   }
};

class ActiveMartingaleStrategy : public IMartingaleStrategy
{
   int _order;
   TradingCalculator *_calculator;
   CustomAmountLongMoneyManagementStrategy *_longMoneyManagement;
   CustomAmountShortMoneyManagementStrategy *_shortMoneyManagement;
   double _lotValue;
   MartingaleLotSizingType _martingaleLotSizingType;
   ICondition* _condition;
public:
   ActiveMartingaleStrategy(TradingCalculator *calculator, 
      MartingaleLotSizingType martingaleLotSizingType, 
      const double lotValue,
      ICondition* condition)
   {
      _condition = condition;
      _condition.AddRef();
      _martingaleLotSizingType = martingaleLotSizingType;
      _lotValue = lotValue;
      _order = -1;
      _calculator = calculator;
      _longMoneyManagement = new CustomAmountLongMoneyManagementStrategy(_calculator);
      _shortMoneyManagement = new CustomAmountShortMoneyManagementStrategy(_calculator);
   }

   ~ActiveMartingaleStrategy()
   {
      _condition.Release();
      delete _longMoneyManagement;
      delete _shortMoneyManagement;
   }

   void OnOrder(const int order)
   {
      _order = order;
   }

   IMoneyManagementStrategy *GetMoneyManagement()
   {
      if (_order == -1)
         return NULL;
      if (!OrderSelect(_order, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
         return NULL;

      double lots = OrderLots();
      switch (_martingaleLotSizingType)
      {
         case MartingaleLotSizingNo:
            break;
         case MartingaleLotSizingMultiplicator:
            lots = _calculator.NormalizeLots(lots * _lotValue);
            break;
         case MartingaleLotSizingAdd:
            lots = _calculator.NormalizeLots(lots + _lotValue);
            break;
      }
      if (OrderType() == OP_BUY)
      {
         _longMoneyManagement.SetAmount(lots);
         return _longMoneyManagement;
      }
      _shortMoneyManagement.SetAmount(lots);
      return _shortMoneyManagement;
   }

   bool NeedAnotherPosition(OrderSide &side)
   {
      if (_order == -1)
         return false;
      if (!OrderSelect(_order, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
      {
         _order = -1;
         return false;
      }
      if (!_condition.IsPass(0, 0))
         return false;
      if (OrderType() == OP_BUY)
         side = BuySide;
      else
         side = SellSide;
      return true;
   }
};

