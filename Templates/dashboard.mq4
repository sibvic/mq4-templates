// ProfitRobots Dashboard template v.1.4
// You can find more templates at https://github.com/sibvic/mq4-templates

#property indicator_separate_window
#property strict

enum DisplayMode
{
   Vertical,
   Horizontal
};

input string   Comment1                 = "- Comma Separated Pairs - Ex: EURUSD,EURJPY,GBPUSD - ";
input string   Pairs                    = "EURUSD,EURJPY,USDJPY,GBPUSD";
input bool     Include_M1               = false;
input bool     Include_M5               = false;
input bool     Include_M15              = false;
input bool     Include_M30              = false;
input bool     Include_H1               = true;
input bool     Include_H4               = false;
input bool     Include_D1               = true;
input bool     Include_W1               = true;
input bool     Include_MN1              = false;
input color    Labels_Color             = clrWhite;
input color    Up_Color                 = clrLime;
input color    Dn_Color                 = clrRed;
input color    Neutral_Color            = clrDarkGray;
input int x_shift = 900; // X coordinate
input DisplayMode display_mode = Horizontal; // Display mode
input int font_size = 10; // Font Size;
input int cell_width = 80; // Cell width
input int cell_height = 30; // Cell height

#include <Signaler.mq4>

#define MAX_LOOPBACK 500

string   WindowName;
int      WindowNumber;

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

ICondition* CreateUpCondition(string symbol, ENUM_TIMEFRAMES timeframe)
{
   return new UpCondition(symbol, timeframe);
}

ICondition* CreateDownCondition(string symbol, ENUM_TIMEFRAMES timeframe)
{
   return new DownCondition(symbol, timeframe);
}

// Dashboard v.1.2
class Iterator
{
   int _initialValue; int _shift; int _current;
public:
   Iterator(int initialValue, int shift) { _initialValue = initialValue; _shift = shift; _current = _initialValue - _shift; }
   int GetNext() { _current += _shift; return _current; }
};

#include <Grid/EmptyCell.mq4>
#include <Grid/LabelCell.mq4>
#include <Grid/Grid.mq4>
#include <Grid/TrendValueCellFactory.mq4>

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


int init()
{
   if (!IsDllsAllowed() && advanced_alert)
   {
      Print("Error: Dll calls must be allowed!");
      return INIT_FAILED;
   }

   IndicatorName = GenerateIndicatorName("...");
   IndicatorObjPrefix = "__" + IndicatorName + "__";
   IndicatorShortName(IndicatorName);

   GridBuilder builder(x_shift, 50, display_mode == Vertical, new TrendValueCellFactory());
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
   WindowNumber = MathMax(0, WindowFind(IndicatorName));
   grid.Draw();
   
   return 0;
}
