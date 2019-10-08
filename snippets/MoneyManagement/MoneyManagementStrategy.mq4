// Money management strategy v1.0

#include <IMoneyManagementStrategy.mq4>
#include <IStopLossAndAmountStrategy.mq4>
#include <ITakeProfitStrategy.mq4>

#ifndef MoneyManagementStrategy_IMP
#define MoneyManagementStrategy_IMP

class MoneyManagementStrategy : public IMoneyManagementStrategy
{
public:
   IStopLossAndAmountStrategy* _stopLossAndAmount;
   ITakeProfitStrategy* _takeProfit;

   MoneyManagementStrategy(IStopLossAndAmountStrategy* stopLossAndAmount, ITakeProfitStrategy* takeProfit)
   {
      _stopLossAndAmount = stopLossAndAmount;
      _takeProfit = takeProfit;
   }

   ~MoneyManagementStrategy()
   {
      delete _stopLossAndAmount;
      delete _takeProfit;
   }

   void Get(const int period, const double entryPrice, double &amount, double &stopLoss, double &takeProfit)
   {
      _stopLossAndAmount.GetStopLossAndAmount(period, entryPrice, amount, stopLoss);
      _takeProfit.GetTakeProfit(period, entryPrice, stopLoss, amount, takeProfit);
   }
};

#endif