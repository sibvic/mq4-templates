// Collection of lines v1.1

#ifndef LinesCollection_IMPL
#define LinesCollection_IMPL

#include <Objects/Line.mqh>

class LinesCollection
{
   string _id;
   Line* _lines[];
   static LinesCollection* _collections[];
public:
   LinesCollection(string id)
   {
      _id = id;
   }

   ~LinesCollection()
   {
      for (int i = 0; i < ArraySize(_lines); ++i)
      {
         delete _lines[i];
      }
      ArrayResize(_lines, 0);
   }
   
   string GetId()
   {
      return _id;
   }

   static void Clear()
   {
      for (int i = 0; i < ArraySize(_collections); ++i)
      {
         delete _collections[i];
      }
      ArrayResize(_collections, 0);
   }

   static void Delete(Line* line)
   {
      if (line == NULL)
      {
         return;
      }
      LinesCollection* collection = FindCollection(line.GetId());
      if (collection == NULL)
      {
         return;
      }
      collection.DeleteLine(line);
   }

   static Line* Create(string id, int x1, double y1, int x2, double y2, datetime dateId)
   {
      ResetLastError();
      dateId = iTime(_Symbol, _Period, iBars(_Symbol, _Period) - x1 - 1);
      string lineId = id + "_" 
         + IntegerToString(TimeDay(dateId)) + "_"
         + IntegerToString(TimeMonth(dateId)) + "_"
         + IntegerToString(TimeYear(dateId)) + "_"
         + IntegerToString(TimeHour(dateId)) + "_"
         + IntegerToString(TimeMinute(dateId)) + "_"
         + IntegerToString(TimeSeconds(dateId));
      
      Line* line = new Line(x1, y1, x2, y2, lineId);
      LinesCollection* collection = FindCollection(id);
      if (collection == NULL)
      {
         collection = new LinesCollection(id);
         AddCollection(collection);
      }
      collection.Add(line);
      return line;
   }

   static void Redraw()
   {
      for (int i = 0; i < ArraySize(_collections); ++i)
      {
         _collections[i].RedrawLines();
      }
   }
private:
   int FindIndex(Line* line)
   {
      int size = ArraySize(_lines);
      for (int i = 0; i < size; ++i)
      {
         if (_lines[i].GetId() == line.GetId())
         {
            return i;
         }
      }
      return -1;
   }

   void DeleteLine(Line* line)
   {
      int index = FindIndex(line);
      if (index != -1)
      {
         return;
      }
      delete _lines[index];
      int size = ArraySize(_lines);
      for (int i = index + 1; i < size; ++i)
      {
         _lines[i - 1] = _lines[i];
      }
      ArrayResize(_lines, size - 1);
   }
   
   void Add(Line* line)
   {
      int index = FindIndex(line);
      if (index != -1)
      {
         delete _lines[index];
         _lines[index] = line;
         return;
      }
      int size = ArraySize(_lines);
      ArrayResize(_lines, size + 1);
      _lines[size] = line;
   }

   void RedrawLines()
   {
      int size = ArraySize(_lines);
      for (int i = 0; i < size; ++i)
      {
         _lines[i].Redraw();
      }
   }
   
   static void AddCollection(LinesCollection* collection)
   {
      int size = ArraySize(_collections);
      ArrayResize(_collections, size + 1);
      _collections[size] = collection;
   }
   
   static LinesCollection* FindCollection(string id)
   {
      for (int i = 0; i < ArraySize(_collections); ++i)
      {
         if (_collections[i].GetId() == id)
         {
            return _collections[i];
         }
      }
      return NULL;
   }
};
LinesCollection* LinesCollection::_collections[];
#endif