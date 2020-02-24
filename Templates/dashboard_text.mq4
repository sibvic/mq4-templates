// ProfitRobots Dashboard text template v.1.2
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
input int x_shift = 900; // X coordinate
input int y_shift = 50; // Y coordinate
input DisplayMode display_mode = Horizontal; // Display mode
input int font_size = 10; // Font Size;
input int cell_width = 80; // Cell width
input int cell_height = 30; // Cell height

#define MAX_LOOPBACK 500

string   WindowName;
int      WindowNumber;

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

class TextValueCell : public ICell
{
   string _id; 
   int _x; 
   int _y; 
   string _symbol; 
   ENUM_TIMEFRAMES _timeframe; 
   datetime _lastDatetime;
public:
   TextValueCell(const string id, const int x, const int y, const string symbol, const ENUM_TIMEFRAMES timeframe)
   { 
      _id = id; 
      _x = x; 
      _y = y; 
      _symbol = symbol; 
      _timeframe = timeframe; 
   }

   ~TextValueCell()
   {
   }

   virtual void Draw()
   { 
      string label = "...";
      ObjectMakeLabel(_id, _x, _y, label, Labels_Color, 1, WindowNumber, "Arial", font_size); 
   }
};

#include <Grid/TextValueCellFactory.mq4>

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

int init()
{
   double temp = iCustom(NULL, 0, "...", 0, 0);
   if (GetLastError() == ERR_INDICATOR_CANNOT_LOAD)
   {
      Alert("Please, install the '...' indicator");
      return INIT_FAILED;
   }

   IndicatorName = GenerateIndicatorName("...");
   IndicatorObjPrefix = "__" + IndicatorName + "__";
   IndicatorShortName(IndicatorName);

   GridBuilder builder(x_shift, y_shift, cell_height, cell_height, display_mode == Vertical, new TextValueCellFactory());
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
   grid.Draw();
   
   return 0;
}
