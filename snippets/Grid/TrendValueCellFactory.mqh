#include <Grid/ICellFactory.mqh>
#include <Grid/TrendValueCell.mqh>
#include <Grid/FixedTextFormatter.mqh>

// Trend value cell factory v7.0

#ifndef TrendValueCellFactory_IMP
#define TrendValueCellFactory_IMP

class TrendValueCellFactory : public ICellFactory
{
   int _alertShift;
   color _upColor;
   color _downColor;
   color _historicalUpColor;
   color _historicalDownColor;
   color _neutralColor;
   color _buttonTextColor;
   string _buyText;
   string _buyFont;
   string _sellText;
   string _sellFont;
public:
   TrendValueCellFactory(int alertShift = 0, color upColor = Green, color downColor = Red, color historicalUpColor = Lime, color historicalDownColor = Pink)
   {
      _buyFont = "Arial";
      _sellFont = "Arial";
      _buyText = "Buy";
      _sellText = "Sell";
      _alertShift = alertShift;
      _upColor = upColor;
      _downColor = downColor;
      _historicalUpColor = historicalUpColor;
      _historicalDownColor = historicalDownColor;
   }

   void SetBuyText(string text, string font)
   {
      _buyText = text;
      _buyFont = font;
   }
   void SetSellText(string text, string font)
   {
      _sellText = text;
      _sellFont = font;
   }

   void SetNeutralColor(color clr)
   {
      _neutralColor = clr;
   }

   void SetButtonTextColor(color clr)
   {
      _buttonTextColor = clr;
   }

   virtual string GetHeader()
   {
      return "Value";
   }

   virtual ICell* Create(const string id, const int x, const int y, ENUM_BASE_CORNER corner, const string symbol, 
      const ENUM_TIMEFRAMES timeframe, bool showHistorical)
   {
      IValueFormatter* defaultValue = new FixedTextFormatter("-", GetTextColor(_neutralColor), GetBackgroundColor(_neutralColor), "Arial");
      TrendValueCell* cell = new TrendValueCell(id, corner, symbol, timeframe, _alertShift, defaultValue, output_mode);
      defaultValue.Release();

      ICondition* upCondition = new UpCondition(symbol, timeframe);
      IValueFormatter* upValue = new FixedTextFormatter(_buyText, GetTextColor(_upColor), GetBackgroundColor(_upColor), _buyFont);
      IValueFormatter* historyUpValue = NULL;
      if (showHistorical)
      {
         historyUpValue = new FixedTextFormatter(_buyText, GetTextColor(_historicalUpColor), GetBackgroundColor(_historicalUpColor), _buyFont);
      }
      cell.AddCondition(upCondition, upValue, historyUpValue, upValue);
      upCondition.Release();
      upValue.Release();
      if (historyUpValue != NULL)
      {
         historyUpValue.Release();
      }

      ICondition* downCondition = new DownCondition(symbol, timeframe);
      IValueFormatter* downValue = new FixedTextFormatter(_sellText, GetTextColor(_downColor), GetBackgroundColor(_downColor), _sellFont);
      IValueFormatter* historyDownValue = NULL;
      if (showHistorical)
      {
         historyDownValue = new FixedTextFormatter(_sellText, GetTextColor(_historicalDownColor), GetBackgroundColor(_historicalDownColor), _sellFont);
      }
      cell.AddCondition(downCondition, downValue, historyDownValue, downValue);
      downCondition.Release();
      downValue.Release();
      if (historyDownValue != NULL)
      {
         historyDownValue.Release();
      }

      return cell;
   }
private:
   color GetTextColor(color clr)
   {
      return output_mode == OutputLabels ? clr : _buttonTextColor;
   }
   color GetBackgroundColor(color clr)
   {
      return output_mode != OutputLabels ? clr : _buttonTextColor;
   }
};
#endif