// ProfitRobots Dashboard template v.1.1
// You can find more templates at https://github.com/sibvic/mq4-templates

#property indicator_separate_window
#property strict

input string   Comment1                 = "- Comma Separated Pairs - Ex: EURUSD,EURJPY,GBPUSD - ";
input string   Pairs                    = "EURUSD,EURJPY,USDJPY,GBPUSD,GBPJPY,EURGBP,AUDUSD,NZDUSD";
input bool     Include_M1               = true;
input bool     Include_M5               = true;
input bool     Include_M15              = true;
input bool     Include_M30              = true;
input bool     Include_H1               = true;
input bool     Include_H4               = true;
input bool     Include_D1               = true;
input bool     Include_W1               = true;
input bool     Include_MN1              = true;
input color    Labels_Color             = clrWhite;
input color    Up_Color                 = clrLime;
input color    Dn_Color                 = clrRed;
input color    Neutral_Color            = clrDarkGray;
input int x_shift = 1000; // X coordinate
input int font_size = 10; // Font Size;
input int cell_width = 120; // Cell width
input int cell_height = 30; // Cell height

#include <Signaler.mq4>

#define MAX_LOOPBACK 500

string   WindowName;
int      WindowNumber;

#include <conditions/ICondition.mq4>
#include <InstrumentInfo.mq4>
#include <conditions/ABaseCondition.mq4>

class UpCondition : public ABaseCondition
{
public:
   UpCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {
   }

   virtual bool IsPass(const int period)
   {
      return false;
   }
};

class DownCondition : public ABaseCondition
{
public:
   DownCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {
   }

   virtual bool IsPass(const int period)
   {
      return false;
   }
};

// Dashboard v.1.2
class Iterator
{
   int _initialValue; int _shift; int _current;
public:
   Iterator(int initialValue, int shift) { _initialValue = initialValue; _shift = shift; _current = _initialValue - _shift; }
   int GetNext() { _current += _shift; return _current; }
};

class ICell
{
public:
   virtual void Draw() = 0;
protected:
   void ObjectMakeLabel( string nm, int xoff, int yoff, string LabelTexto, color LabelColor, int LabelCorner=1, int Window = 0, string Font = "Arial", int FSize = 8 )
   { ObjectDelete(nm); ObjectCreate(nm, OBJ_LABEL, Window, 0, 0); ObjectSet(nm, OBJPROP_CORNER, LabelCorner); ObjectSet(nm, OBJPROP_XDISTANCE, xoff); ObjectSet(nm, OBJPROP_YDISTANCE, yoff); ObjectSet(nm, OBJPROP_BACK, false); ObjectSetText(nm, LabelTexto, FSize, Font, LabelColor); }
};

class Row
{
   ICell *_cells[];
public:
   ~Row() { int count = ArraySize(_cells); for (int i = 0; i < count; ++i) { delete _cells[i]; } }
   void Draw() { int count = ArraySize(_cells); for (int i = 0; i < count; ++i) { _cells[i].Draw(); } }
   void Add(ICell *cell) { int count = ArraySize(_cells); ArrayResize(_cells, count + 1); _cells[count] = cell; } 
};

//draws nothing
class EmptyCell : public ICell
{
public:
   virtual void Draw() { }
};

//draws a label
class LabelCell : public ICell
{
   string _id; string _text; int _x; int _y;
public:
   LabelCell(const string id, const string text, const int x, const int y) { _id = id; _text = text; _x = x; _y = y; } 
   virtual void Draw() { ObjectMakeLabel(_id, _x, _y, _text, Labels_Color, 1, WindowNumber, "Arial", font_size); }
};

#define ENTER_BUY_SIGNAL 1
#define ENTER_SELL_SIGNAL -1
#define EXIT_BUY_SIGNAL 2
#define EXIT_SELL_SIGNAL -2
class BarsBackValueCell : public ICell
{
   string _id; int _x; int _y; string _symbol; ENUM_TIMEFRAMES _timeframe; datetime _lastDatetime;
   ICondition* _upCondition;
   ICondition* _downCondition;
public:
   BarsBackValueCell(const string id, const int x, const int y, const string symbol, const ENUM_TIMEFRAMES timeframe)
   { 
      _id = id; 
      _x = x; 
      _y = y; 
      _symbol = symbol; 
      _timeframe = timeframe; 
      _upCondition = new UpCondition(_symbol, _timeframe);
      _downCondition = new DownCondition(_symbol, _timeframe);
   }

   ~BarsBackValueCell()
   {
      delete _upCondition;
      delete _downCondition;
   }

   virtual void Draw()
   { 
      int barsBack;
      int direction = GetDirection(barsBack); 
      string label = direction != 0 ? IntegerToString(barsBack) : "-";
      ObjectMakeLabel(_id, _x, _y, label, GetDirectionColor(direction), 1, WindowNumber, "Arial", font_size);
   }

private:
   int GetDirection(int& barsBack)
   {
      for (barsBack = 0; barsBack < MathMin(MAX_LOOPBACK, iBars(_symbol, _timeframe) - 1); ++barsBack)
      {
         if (_upCondition.IsPass(barsBack))
            return ENTER_BUY_SIGNAL;
         if (_downCondition.IsPass(barsBack))
            return ENTER_SELL_SIGNAL;
      }
      barsBack = -1;
      return 0;
   }

   color GetDirectionColor(const int direction) { if (direction >= 1) { return Up_Color; } else if (direction <= -1) { return Dn_Color; } return Neutral_Color; }
};

class TextValueCell : public ICell
{
   string _id; int _x; int _y; string _symbol; ENUM_TIMEFRAMES _timeframe; datetime _lastDatetime;
   ICondition* _upCondition;
   ICondition* _downCondition;
public:
   TextValueCell(const string id, const int x, const int y, const string symbol, const ENUM_TIMEFRAMES timeframe)
   { 
      _id = id; 
      _x = x; 
      _y = y; 
      _symbol = symbol; 
      _timeframe = timeframe; 
      _upCondition = new UpCondition(_symbol, _timeframe);
      _downCondition = new DownCondition(_symbol, _timeframe);
   }

   ~TextValueCell()
   {
      delete _upCondition;
      delete _downCondition;
   }

   virtual void Draw()
   { 
      string label;
      int direction = GetDirection(label); 
      ObjectMakeLabel(_id, _x, _y, label, GetDirectionColor(direction), 1, WindowNumber, "Arial", font_size); 
   }

private:
   int GetDirection(string& text)
   {
      if (_upCondition.IsPass(0))
      {
         text = "";
         return ENTER_BUY_SIGNAL;
      }
      if (_downCondition.IsPass(0))
      {
         text = "";
         return ENTER_SELL_SIGNAL;
      }
      return 0;
   }

   color GetDirectionColor(const int direction) { if (direction >= 1) { return Up_Color; } else if (direction <= -1) { return Dn_Color; } return Neutral_Color; }
};

#include <Grid/TrendValueCell.mq4>

string IndicatorName;
string IndicatorObjPrefix;

string GenerateIndicatorName(const string target)
{
   string name = target;
   int try = 2;
   while (WindowFind(name) != -1)
   {
      name = target + " #" + IntegerToString(try++);
   }
   return name;
}

class Grid
{
   Row *_rows[];
public:
   ~Grid()
   {
      int count = ArraySize(_rows);
      for (int i = 0; i < count; ++i)
      {
         delete _rows[i];
      }
   }

   Row *AddRow()
   {
      int count = ArraySize(_rows);
      ArrayResize(_rows, count + 1);
      _rows[count] = new Row();
      return _rows[count];
   }
   
   Row *GetRow(const int index)
   {
      return _rows[index];
   }
   
   void Draw()
   {
      int count = ArraySize(_rows);
      for (int i = 0; i < count; ++i)
      {
         _rows[i].Draw();
      }
   }
};

Grid *grid;

#include <Grid/GridBuilder.mq4>

// void OnChartEvent(const int id,
//                   const long &lparam,
//                   const double &dparam,
//                   const string &sparam)
// {
//    handleButtonClicks();
// }

// void handleButtonClicks()
// {
//    int pair_num = ArraySize(pairs) - 1;
//    for (int p = 0; p < pair_num; p++)
//    {
//       string pair = pairs[p];
//       for (int t = 0; t < ArraySize(iTF); t++)
//       {  
//          if (!bTF[t])
//             continue;
      
//          string arrow_id = Pref + "AO direction " + pair + " " + sTF[t];
//          if (ObjectGetInteger(0, arrow_id, OBJPROP_STATE))
//          {
//             ObjectSetInteger(0, arrow_id, OBJPROP_STATE, false);
//             ChartSetSymbolPeriod(0, pair, iTF[t]);
//             return;
//          }
//       }
//       string symbolId = "ADR " + pair;
//       if (ObjectGetInteger(0, symbolId, OBJPROP_STATE))
//       {
//          ObjectSetInteger(0, symbolId, OBJPROP_STATE, false);
//          ChartOpen(pair, _Period);
//          return;
//       }
//    }
// }

// void DrawSymbolButton(string name, int corn, int x, int y, int width, int height, string symbol, color Clr=Green, int Win=0, int FSize=10)
// {
//    int Error = ObjectFind(name);
//    if (Error != Win)
//       ObjectCreate(name, OBJ_BUTTON, Win, 0, 0);
     
//    ObjectSet(name, OBJPROP_CORNER, corn);
//    ObjectSet(name, OBJPROP_XDISTANCE, x);
//    ObjectSet(name, OBJPROP_YDISTANCE, y);
//    ObjectSetString(0, name, OBJPROP_FONT, "Arial");
//    ObjectSetString(0, name, OBJPROP_TEXT, symbol);
//    ObjectSetInteger(0, name, OBJPROP_COLOR, Clr);
//    ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
//    ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
//    ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FSize);
// }
 
// void DrawButton(string name, int corn, int x, int y, int code=0, color Clr=Green, int Win=0, int FSize=10)
// {
//    int Error = ObjectFind(name);
//    if (Error != Win)
//       ObjectCreate(name, OBJ_BUTTON, Win, 0, 0);
     
//    ObjectSet(name, OBJPROP_CORNER, corn);
//    ObjectSet(name, OBJPROP_XDISTANCE, x);
//    ObjectSet(name, OBJPROP_YDISTANCE, y);
//    ObjectSetString(0, name, OBJPROP_FONT, "Wingdings");
//    ObjectSetString(0, name, OBJPROP_TEXT, CharToStr(code));
//    ObjectSetInteger(0, name, OBJPROP_COLOR, Clr);
//    ObjectSetInteger(0, name, OBJPROP_XSIZE, 13);
//    ObjectSetInteger(0, name, OBJPROP_YSIZE, 13);
//    ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FSize);
// }

Signaler* mainSignaler;

int init()
{
   if (!IsDllsAllowed() && advanced_alert)
   {
      Print("Error: Dll calls must be allowed!");
      return INIT_FAILED;
   }
   mainSignaler = new Signaler(_Symbol, (ENUM_TIMEFRAMES)_Period);
   mainSignaler.SetMessagePrefix(_Symbol + "/" + mainSignaler.GetTimeframeStr() + ": ");

   IndicatorName = GenerateIndicatorName("...");
   IndicatorObjPrefix = "__" + IndicatorName + "__";
   IndicatorShortName(IndicatorName);

   GridBuilder builder(x_shift);
   builder.SetSymbols(Pairs);

   if (Include_M1)
      builder.AddTimeframe("M1", PERIOD_M1);
   if (Include_M5)
      builder.AddTimeframe("M5", PERIOD_M5);
   if (Include_M15)
      builder.AddTimeframe("M15", PERIOD_M15);
   if (Include_M30)
      builder.AddTimeframe("M30", PERIOD_M30);
   if (Include_H1)
      builder.AddTimeframe("H1", PERIOD_H1);
   if (Include_H4)
      builder.AddTimeframe("H4", PERIOD_H4);
   if (Include_D1)
      builder.AddTimeframe("D1", PERIOD_D1);
   if (Include_W1)
      builder.AddTimeframe("W1", PERIOD_W1);
   if (Include_MN1)
      builder.AddTimeframe("MN1", PERIOD_MN1);

   grid = builder.Build();

   //ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, 1);

   return(0);
}

int deinit()
{
   ObjectsDeleteAll(ChartID(), IndicatorObjPrefix);
   delete grid;
   grid = NULL;
   return 0;
}

int start()
{
   //handleButtonClicks();
   WindowNumber = WindowFind(IndicatorName);
   grid.Draw();
   
   return 0;
}
