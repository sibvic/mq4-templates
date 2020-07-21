// ProfitRobots Dashboard template v2.3
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
input color    historical_Up_Color      = Green; // Historical up color
input color    Up_Color                 = Lime; // Up color
input color    historical_Dn_Color      = Red; // Historical down color
input color    Dn_Color                 = Pink; // Down color
input color    Neutral_Color            = clrDarkGray;
input int x_shift = 900; // X coordinate
input DisplayMode display_mode = Vertical; // Display mode
input int font_size = 10; // Font Size;
input int cell_width = 80; // Cell width
input int cell_height = 30; // Cell height
input bool alert_on_close = false; // Alert on bar close

#include <Signaler.mq4>

#define MAX_LOOPBACK 500

string   WindowName;
int      WindowNumber;

#include <conditions/ACondition.mq4>

class UpCondition : public ACondition
{
public:
   UpCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ACondition(symbol, timeframe)
   {
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      return false;
   }
};

class DownCondition : public ACondition
{
public:
   DownCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ACondition(symbol, timeframe)
   {
   }

   virtual bool IsPass(const int period, const datetime date)
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

#include <Grid/EmptyCell.mq4>
#include <Grid/LabelCell.mq4>
#include <Grid/Grid.mq4>
#include <Grid/TrendValueCellFactory.mq4>

string IndicatorObjPrefix;

bool NamesCollision(const string name)
{
   for (int k = ObjectsTotal(); k >= 0; k--)
   {
      if (StringFind(ObjectName(0, k), name) == 0)
      {
         return true;
      }
   }
   return false;
}

string GenerateIndicatorPrefix(const string target)
{
   for (int i = 0; i < 1000; ++i)
   {
      string prefix = target + "_" + IntegerToString(i);
      if (!NamesCollision(prefix))
      {
         return prefix;
      }
   }
   return target;
}

Grid *grid;

#include <Grid/GridBuilder.mq4>

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   grid.HandleButtonClicks();
}

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

string IndicatorName = "...";
int init()
{
   if (!IsDllsAllowed() && advanced_alert)
   {
      Print("Error: Dll calls must be allowed!");
      return INIT_FAILED;
   }

   IndicatorObjPrefix = GenerateIndicatorPrefix("indi_short");
   IndicatorShortName(IndicatorName);

   GridBuilder builder(x_shift, 50, cell_height, cell_height, display_mode == Vertical);
   builder.AddCell(new TrendValueCellFactory(alert_on_close ? 1 : 0, Up_Color, Dn_Color, historical_Up_Color, historical_Dn_Color));
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
   grid.HandleButtonClicks();
   grid.Draw();
   
   return 0;
}
