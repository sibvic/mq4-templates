#include <Grid/GridCells.mq4>

// Account statistics v1.4

string IndicatorObjPrefix = "EA";
class AccountStatistics
{
   InstrumentInfo *_symbol;
   int _fontSize;
   string _fontName;
   GridCells* cells0;
public:
   AccountStatistics(string eaName)
   {
      _fontSize = 10;
      _symbol = new InstrumentInfo(_Symbol);
      _fontName = "Cambria";
      cells0 = new GridCells(IndicatorObjPrefix + "0", 1.2);
   }

   ~AccountStatistics()
   {
      delete cells0;
      delete _symbol;
   }

   void Update()
   {
      int row = 0;
      cells0.Add("Take Profit", color_text, _fontName, _fontSize, 0, row);
      cells0.Add(DoubleToString(last_tp, _symbol.GetDigits()), color_text, _fontName, _fontSize, 1, row++);
      cells0.Add("Stop Loss", color_text, _fontName, _fontSize, 0, row);
      cells0.Add(DoubleToString(last_sl, _symbol.GetDigits()), color_text, _fontName, _fontSize, 1, row++);
      cells0.Add("---", color_text, _fontName, _fontSize, 0, row);
      cells0.Add("---", color_text, _fontName, _fontSize, 1, row++);
      cells0.Add("Current Signal", color_text, _fontName, _fontSize, 0, row);
      cells0.Add(last_signal == BuySide ? "BUY" : "SELL", last_signal == BuySide ? color_buy_signal : color_sell_signal, _fontName, _fontSize, 1, row++);
      cells0.Add("Signal Price", color_text, _fontName, _fontSize, 0, row);
      cells0.Add(DoubleToString(last_price, _symbol.GetDigits()), color_text, _fontName, _fontSize, 1, row++);
      
      int distance = iBarShift(_Symbol, _Period, last_time);
      cells0.Add("Signal Time", color_text, _fontName, _fontSize, 0, row);
      cells0.Add("From " + IntegerToString(distance) + " Candles", color_text, _fontName, _fontSize, 1, row++);

      double pl = last_signal == BuySide ? (Bid - last_price) : (Ask - last_price);
      cells0.Add("Signal Profit", color_text, _fontName, _fontSize, 0, row);
      cells0.Add(DoubleToString(pl / _symbol.GetPipSize(), 2), pl < 0 ? color_loss : color_profit, _fontName, _fontSize, 1, row++);

      int height0 = cells0.GetTotalHeight();
      int width0 = cells0.GetTotalWidth();
      ResetLastError();
      string id = IndicatorObjPrefix + "idValue2";
      ObjectCreate(0, id, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, id, OBJPROP_BGCOLOR, background_color);
      ObjectSetInteger(0, id, OBJPROP_FILL, true);
      ObjectSetInteger(0, id, OBJPROP_XDISTANCE, x - 10); 
      ObjectSetInteger(0, id, OBJPROP_YDISTANCE, y - 10); 
      ObjectSetInteger(0, id, OBJPROP_XSIZE, width0 + 10); 
      ObjectSetInteger(0, id, OBJPROP_YSIZE, height0 + 10);
      
      cells0.Draw(x, y);
   }
};
