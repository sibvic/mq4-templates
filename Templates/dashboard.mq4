// ProfitRobots Dashboard template v.1.0
// You can find more templates at https://github.com/sibvic/mq4-templates

#property indicator_separate_window
#property strict

extern string   Comment1                 = "- Comma Separated Pairs - Ex: EURUSD,EURJPY,GBPUSD - ";
extern string   Pairs                    = "EURUSD,EURJPY,USDJPY,GBPUSD,GBPJPY,EURGBP,AUDUSD,NZDUSD";
extern bool     Include_M1               = true;
extern bool     Include_M5               = true;
extern bool     Include_M15              = true;
extern bool     Include_M30              = true;
extern bool     Include_H1               = true;
extern bool     Include_H4               = true;
extern bool     Include_D1               = true;
extern bool     Include_W1               = true;
extern bool     Include_MN1              = true;
extern color    Labels_Color             = clrWhite;
extern color    Up_Color                 = clrLime;
extern color    Dn_Color                 = clrRed;
extern color    Neutral_Color            = clrDarkGray;

#define MAX_LOOPBACK 500

string   WindowName;
int      WindowNumber;

#include <ICondition.mq4>
#include <InstrumentInfo.mq4>
#include <ABaseCondition.mq4>

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
   virtual void Draw() { ObjectMakeLabel(_id, _x, _y, _text, Labels_Color, 1, WindowNumber, "Arial", 12); }
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
      ObjectMakeLabel(_id, _x, _y, label, GetDirectionColor(direction), 1, WindowNumber, "Arial", 10); 
   }

private:
   string GetTimeframe()
   {
      switch (_timeframe)
      {
         case PERIOD_M1: return "M1";
         case PERIOD_M5: return "M5";
         case PERIOD_D1: return "D1";
         case PERIOD_H1: return "H1";
         case PERIOD_H4: return "H4";
         case PERIOD_M15: return "M15";
         case PERIOD_M30: return "M30";
         case PERIOD_MN1: return "MN1";
         case PERIOD_W1: return "W1";
      }
      return "M1";
   }

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

class TrendValueCell : public ICell
{
   string _id; int _x; int _y; string _symbol; ENUM_TIMEFRAMES _timeframe; datetime _lastDatetime;
   ICondition* _upCondition;
   ICondition* _downCondition;
public:
   TrendValueCell(const string id, const int x, const int y, const string symbol, const ENUM_TIMEFRAMES timeframe)
   { 
      _id = id; 
      _x = x; 
      _y = y; 
      _symbol = symbol; 
      _timeframe = timeframe; 
      _upCondition = new UpCondition(_symbol, _timeframe);
      _downCondition = new DownCondition(_symbol, _timeframe);
   }

   ~TrendValueCell()
   {
      delete _upCondition;
      delete _downCondition;
   }

   virtual void Draw()
   { 
      int direction = GetDirection(); 
      ObjectMakeLabel(_id, _x, _y, GetDirectionSymbol(direction), GetDirectionColor(direction), 1, WindowNumber, "Arial", 10); 
   }

private:
   string GetTimeframe()
   {
      switch (_timeframe)
      {
         case PERIOD_M1: return "M1";
         case PERIOD_M5: return "M5";
         case PERIOD_D1: return "D1";
         case PERIOD_H1: return "H1";
         case PERIOD_H4: return "H4";
         case PERIOD_M15: return "M15";
         case PERIOD_M30: return "M30";
         case PERIOD_MN1: return "MN1";
         case PERIOD_W1: return "W1";
      }
      return "M1";
   }

   int GetDirection()
   {
      if (_upCondition.IsPass(0))
         return ENTER_BUY_SIGNAL;
      if (_downCondition.IsPass(0))
         return ENTER_SELL_SIGNAL;
      // return EXIT_BUY_SIGNAL for the up trend end/exit buy
      // return EXIT_SELL_SIGNAL for the down trend end/exit sell
      // return 0 for the neutral/no action
      return 0;
   }

   color GetDirectionColor(const int direction) { if (direction >= 1) { return Up_Color; } else if (direction <= -1) { return Dn_Color; } return Neutral_Color; }
   string GetDirectionSymbol(const int direction)
   {
      if (direction == ENTER_BUY_SIGNAL)
      {
         return "BUY";
      }
      else if (direction == ENTER_SELL_SIGNAL)
      {
         return "SELL";
      }
      if (direction == EXIT_BUY_SIGNAL)
      {
         return "EXIT BUY";
      }
      else if (direction == EXIT_SELL_SIGNAL)
      {
         return "EXIT SELL";
      }
      return "-";
   }
};

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

class GridBuilder
{
   string sym_arr[];
   int sym_count;
   Grid *grid;
   int Original_x;
   Iterator xIterator;
public:
   GridBuilder()
      :xIterator(1000, -120)
   {
      Original_x = 1000;
      grid = new Grid();
   }

   void SetSymbols(const string symbols)
   {
      split(sym_arr, symbols, ",");
      sym_count = ArraySize(sym_arr);

      Iterator yIterator(50, 30);
      Row *row = grid.AddRow();
      row.Add(new EmptyCell());
      for (int i = 0; i < sym_count; i++)
      {
         row.Add(new LabelCell(IndicatorObjPrefix + sym_arr[i] + "_Name", sym_arr[i], Original_x + 80, yIterator.GetNext()));
      }
   }

   void AddTimeframe(const string label, const ENUM_TIMEFRAMES timeframe)
   {
      int x = xIterator.GetNext();
      Row *row = grid.AddRow();
      row.Add(new LabelCell(IndicatorObjPrefix + label + "_Label", label, x, 20));
      Iterator yIterator(50, 30);
      for (int i = 0; i < sym_count; i++)
      {
         row.Add(new TrendValueCell(IndicatorObjPrefix + sym_arr[i] + "_" + label, x, yIterator.GetNext(), sym_arr[i], timeframe));
      }
   }

   Grid *Build()
   {
      return grid;
   }

private:
   void split(string& arr[], string str, string sym) 
   {
      ArrayResize(arr, 0);
      int len = StringLen(str);
      for (int i=0; i < len;)
      {
         int pos = StringFind(str, sym, i);
         if (pos == -1)
            pos = len;
   
         string item = StringSubstr(str, i, pos-i);
         item = StringTrimLeft(item);
         item = StringTrimRight(item);
   
         int size = ArraySize(arr);
         ArrayResize(arr, size+1);
         arr[size] = item;
   
         i = pos+1;
      }
   }
};

int init()
{
   IndicatorName = GenerateIndicatorName("...");
   IndicatorObjPrefix = "__" + IndicatorName + "__";
   IndicatorShortName(IndicatorName);

   GridBuilder builder();
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
   return 0;
}

int start()
{
   WindowNumber = WindowFind(IndicatorName);
   grid.Draw();
   
   return 0;
}
