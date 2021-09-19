#include <Grid/GridCells.mqh>
#include <InstrumentInfo.mqh>

// Account statistics v1.5

string IndicatorObjPrefix = "EA";
class AccountStatistics
{
   InstrumentInfo *_symbol;
   int _fontSize;
   string _fontName;
   GridCells* cells0;
   color _backgroundColor;
   int _x;
   int _y;
public:
   AccountStatistics(color backgroundColor, int x, int y)
   {
      _x = x;
      _y = y;
      _backgroundColor = backgroundColor;
      _fontSize = 10;
      _symbol = new InstrumentInfo(_Symbol);
      _fontName = "Cambria";
      cells0 = new GridCells(IndicatorObjPrefix + "0", 1.2, 0);
   }

   ~AccountStatistics()
   {
      delete cells0;
      delete _symbol;
   }

   void Update()
   {
      int row = 0;
      //TODO: add your own data
      // cells0.Add("Take Profit", color_text, _fontName, _fontSize, 0, row);
      // cells0.Add(DoubleToString(last_tp, _symbol.GetDigits()), color_text, _fontName, _fontSize, 1, row++);
      
      int height0 = cells0.GetTotalHeight();
      int width0 = cells0.GetTotalWidth();
      ResetLastError();
      string id = IndicatorObjPrefix + "idValue2";
      ObjectCreate(0, id, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, id, OBJPROP_BGCOLOR, _backgroundColor);
      ObjectSetInteger(0, id, OBJPROP_FILL, true);
      ObjectSetInteger(0, id, OBJPROP_XDISTANCE, _x - 10); 
      ObjectSetInteger(0, id, OBJPROP_YDISTANCE, _y - 10); 
      ObjectSetInteger(0, id, OBJPROP_XSIZE, width0 + 20); 
      ObjectSetInteger(0, id, OBJPROP_YSIZE, height0 + 20);
      
      cells0.Draw(_x, _y);
   }
};
