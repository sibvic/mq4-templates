// ProfitRobots Dashboard template v3.1
// You can find more templates at https://github.com/sibvic/mq4-templates

// Implement UpCondition and DownCondition!
string IndicatorName = "...";
string IndicatorShortName = "indi_short";

#property indicator_separate_window
#property strict

#define USE_HISTORIC
#define EXCLUDE_PERIOD_HEADER

enum DisplayMode
{
   Vertical,
   Horizontal
};

enum OutputMode
{
   OutputLabels, // Labels
   OutputButtonsNewWindow, // New chart buttons
   OutputButtons // Current chart buttons
};
input OutputMode output_mode            = OutputLabels; // Mode
input string   Comment1                 = "- Comma Separated Pairs - Ex: EURUSD,EURJPY,GBPUSD - ";
input string   Pairs                    = "EURUSD,EURJPY,USDJPY,GBPUSD"; // Pairs
input bool     Include_M1               = false; // Include M1
input bool     Include_M5               = false; // Include M5
input bool     Include_M15              = false; // Include M15
input bool     Include_M30              = false; // Include M30
input bool     Include_H1               = true; // Include H1
input bool     Include_H4               = false; // Include H4
input bool     Include_D1               = true; // Include D1
input bool     Include_W1               = true; // Include W1
input bool     Include_MN1              = false; // Include MN1
input color    Labels_Color             = clrWhite; // Labels color
input color    button_text_color        = Black; // Button text color
input int min_button_width              = 30; // Min button width
#ifdef USE_HISTORIC
   input color    historical_Up_Color   = Green; // Historical up color
#else
   color    historical_Up_Color         = Green; // Historical up color
#endif
input color    Up_Color                 = Lime; // Up color
input bool draw_arrows = false; // Draw arrows instead of text
#ifdef USE_HISTORIC
   input color    historical_Dn_Color   = Red; // Historical down color
#else
   color    historical_Dn_Color         = Red; // Historical down color
#endif
input color    Dn_Color                 = Pink; // Down color
input color    neutral_color            = clrDarkGray; // Neutral color
input int x_shift                       = 900; // X coordinate
input ENUM_BASE_CORNER corner           = CORNER_LEFT_UPPER; // Corner
input DisplayMode display_mode          = Vertical; // Display mode
input int font_size                     = 10; // Font Size;
input int cell_width                    = 80; // Cell width
input int cell_height                   = 30; // Cell height
input bool alert_on_close               = false; // Alert on bar close

#include <Signaler.mqh>

#define MAX_LOOPBACK 500

string   WindowName;
int      WindowNumber;

#include <conditions/ACondition.mqh>

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

#include <Grid/EmptyCell.mqh>
#include <Grid/LabelCell.mqh>
#include <Grid/Grid.mqh>
#include <Grid/TrendValueCellFactory.mqh>

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

#include <Grid/GridBuilder.mqh>

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   grid.HandleButtonClicks();
}

#include <Conditions/IConditionFactory.mqh>

class ConditionFactory : public IConditionFactory
{
public:
   ICondition* CreateUpCondition(const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      return new UpCondition(symbol, timeframe);
   }
   ICondition* CreateDownCondition(const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      return new DownCondition(symbol, timeframe);
   }
};

TrendValueCellFactory* Create(IConditionFactory* conditionFactory)
{
   TrendValueCellFactory* factory = new TrendValueCellFactory(conditionFactory, alert_on_close ? 1 : 0, Up_Color, Dn_Color, historical_Up_Color, historical_Dn_Color);
   if (draw_arrows)
   {
      factory.SetBuyText(CharToStr(225), "Wingdings");
      factory.SetSellText(CharToStr(226), "Wingdings"); 
   }
   factory.SetNeutralColor(neutral_color);
   factory.SetButtonTextColor(button_text_color);
   return factory;
}

int init()
{
   if (!IsDllsAllowed() && advanced_alert)
   {
      Print("Error: Dll calls must be allowed!");
      return INIT_FAILED;
   }

   IndicatorObjPrefix = GenerateIndicatorPrefix(IndicatorShortName);
   IndicatorShortName(IndicatorName);

   #ifdef USE_HISTORIC
   bool showHistorical = true;
   #else
   bool showHistorical = false;
   #endif
   GridBuilder builder(x_shift, 50, display_mode == Vertical, corner, showHistorical, IndicatorObjPrefix, ChartWindowFind());
   builder.AddCell(Create(new ConditionFactory()));
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

   if (output_mode != OutputLabels)
   {
      ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, 1);
   }

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
   WindowNumber = MathMax(0, WindowFind(IndicatorName));
   grid.HandleButtonClicks();
   grid.Draw(cell_height, cell_height);
   
   return 0;
}
