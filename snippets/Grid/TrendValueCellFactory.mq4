#include <ICellFactory.mq4>
#include <TrendValueCell.mq4>
#include <FixedTextFormatter.mq4>

// Trend value cell factory v2.0

#ifndef TrendValueCellFactory_IMP
#define TrendValueCellFactory_IMP

class TrendValueCellFactory : public ICellFactory
{
   int _alertShift;
   color _upColor;
   color _downColor;
public:
   TrendValueCellFactory(int alertShift = 0, color upColor = Green, color downColor = Red)
   {
      _alertShift = alertShift;
      _upColor = upColor;
      _downColor = downColor;
   }

   virtual string GetHeader()
   {
      return "Value";
   }

   virtual ICell* Create(const string id, const int x, const int y, const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      IValueFormatter* defaultValue = new FixedTextFormatter("-", Neutral_Color);
      TrendValueCell* cell = new TrendValueCell(id, x, y, symbol, timeframe, _alertShift, defaultValue);
      defaultValue.Release();

      ICondition* upCondition = new UpCondition(symbol, timeframe);
      IValueFormatter* upValue = new FixedTextFormatter("Buy", _upColor);
      cell.AddCondition(upCondition, upValue);
      upCondition.Release();
      upValue.Release();

      ICondition* downCondition = new DownCondition(symbol, timeframe);
      IValueFormatter* downValue = new FixedTextFormatter("Sell", _downColor);
      cell.AddCondition(downCondition, downValue);
      downCondition.Release();
      downValue.Release();

      return cell;
   }
};
#endif