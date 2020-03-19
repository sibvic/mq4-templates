// Trend value cell factory v2.0

#include <ICellFactory.mq4>
#include <TrendValueCell.mq4>

#ifndef TrendValueCellFactory_IMP
#define TrendValueCellFactory_IMP

class TrendValueCellFactory : public ICellFactory
{
   bool _alertUnconfirmed;
public:
   TrendValueCellFactory(bool alertUnconfirmed = false)
   {
      _alertUnconfirmed = alertUnconfirmed;
   }

   virtual ICell* Create(const string id, const int x, const int y, const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      return new TrendValueCell(id, x, y, symbol, timeframe, _alertUnconfirmed);
   }
};
#endif