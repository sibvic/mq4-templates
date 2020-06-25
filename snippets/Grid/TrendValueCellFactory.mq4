#include <ICellFactory.mq4>
#include <TrendValueCell.mq4>
#include <FixedTextFormatter.mq4>

// Trend value cell factory v3.0

#ifndef TrendValueCellFactory_IMP
#define TrendValueCellFactory_IMP

class TrendValueCellFactory : public ICellFactory
{
   int _alertShift;
   color _upColor;
   color _downColor;
   color _historicalUpColor;
   color _historicalDownColor;
public:
   TrendValueCellFactory(int alertShift = 0, color upColor = Green, color downColor = Red, color historicalUpColor = Lime, color historicalDownColor = Pink)
   {
      _alertShift = alertShift;
      _upColor = upColor;
      _downColor = downColor;
      _historicalUpColor = historicalUpColor;
      _historicalDownColor = historicalDownColor;
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
      IValueFormatter* historyUpValue = new FixedTextFormatter("Buy", _historicalUpColor);
      cell.AddCondition(upCondition, upValue, historyUpValue);
      upCondition.Release();
      upValue.Release();
      historyUpValue.Release();

      ICondition* downCondition = new DownCondition(symbol, timeframe);
      IValueFormatter* downValue = new FixedTextFormatter("Sell", _downColor);
      IValueFormatter* historyDownValue = new FixedTextFormatter("Sell", _historicalDownColor);
      cell.AddCondition(downCondition, downValue, historyDownValue);
      downCondition.Release();
      downValue.Release();
      historyDownValue.Release();

      return cell;
   }
};
#endif