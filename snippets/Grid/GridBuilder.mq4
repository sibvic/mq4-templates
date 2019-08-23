// Grid builder v1.0

#ifndef GridBuilder_IMP
#define GridBuilder_IMP
class GridBuilder
{
   string sym_arr[];
   int sym_count;
   Grid *grid;
   int Original_x;
   Iterator xIterator;
   Signaler* _signaler;
public:
   GridBuilder(int x, Signaler* signaler)
      :xIterator(x, -cell_width)
   {
      _signaler = signaler;
      Original_x = x;
      grid = new Grid();
   }

   void SetSymbols(const string symbols)
   {
      split(sym_arr, symbols, ",");
      sym_count = ArraySize(sym_arr);

      Iterator yIterator(50, cell_height);
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
      Iterator yIterator(50, cell_height);
      for (int i = 0; i < sym_count; i++)
      {
         row.Add(new TrendValueCell(IndicatorObjPrefix + sym_arr[i] + "_" + label, x, yIterator.GetNext(), sym_arr[i], timeframe, _signaler));
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
#endif