// Grid row v2.0

#include <GridTextCell.mq4>

#ifndef GridRow_IMP
#define GridRow_IMP

class GridRow
{
   GridTextCell* _cells[];
   string _id;
   string _fontName;
   int _fontSize;
public:
   GridRow(string id, string fontName, int fontSize)
   {
      _fontName = fontName;
      _fontSize = fontSize;
      _id = id;
   }

   ~GridRow()
   {
      for (int i = 0; i < ArraySize(_cells); ++i)
      {
         delete _cells[i];
      }
      ArrayResize(_cells, 0);
   }

   void EnsureEnoughtCells(int newSize)
   {
      int oldSize = ArraySize(_cells);
      if (newSize <= oldSize)
         return;
      ArrayResize(_cells, newSize);
      for (int i = oldSize; i < newSize; ++i)
      {
         _cells[i] = new GridTextCell(_id + "-" + IntegerToString(i), _fontName, _fontSize);
      }
   }

   int Size()
   {
      return ArraySize(_cells);
   }

   GridTextCell* Get(int index)
   {
      return _cells[index];
   }
};
#endif