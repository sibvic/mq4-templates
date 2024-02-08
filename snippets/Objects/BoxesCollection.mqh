// Collection of boxes v1.0

#ifndef BoxesCollection_IMPL
#define BoxesCollection_IMPL

#include <Objects/Box.mqh>

class BoxesCollection
{
   string _id;
   Box* _boxes[];
   static BoxesCollection* _collections[];
public:
   BoxesCollection(string id)
   {
      _id = id;
   }

   ~BoxesCollection()
   {
      for (int i = 0; i < ArraySize(_boxes); ++i)
      {
         delete _boxes[i];
      }
      ArrayResize(_boxes, 0);
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

   static void Delete(Box* box)
   {
      if (box == NULL)
      {
         return;
      }
      BoxesCollection* collection = FindCollection(box.GetCollectionId());
      if (collection == NULL)
      {
         return;
      }
      collection.DeleteBox(box);
   }

   static Box* Create(string id, int left, double top, int right, double bottom, datetime dateId)
   {
      ResetLastError();
      dateId = iTime(_Symbol, _Period, iBars(_Symbol, _Period) - left - 1);
      string boxId = id + "_" 
         + IntegerToString(TimeDay(dateId)) + "_"
         + IntegerToString(TimeMonth(dateId)) + "_"
         + IntegerToString(TimeYear(dateId)) + "_"
         + IntegerToString(TimeHour(dateId)) + "_"
         + IntegerToString(TimeMinute(dateId)) + "_"
         + IntegerToString(TimeSeconds(dateId));
      
      Box* box = new Box(left, top, right, bottom, boxId, id, WindowOnDropped());
      BoxesCollection* collection = FindCollection(id);
      if (collection == NULL)
      {
         collection = new BoxesCollection(id);
         AddCollection(collection);
      }
      collection.Add(box);
      return box;
   }

   static void Redraw()
   {
      for (int i = 0; i < ArraySize(_collections); ++i)
      {
         _collections[i].RedrawBoxs();
      }
   }
private:
   int FindIndex(Box* box)
   {
      int size = ArraySize(_boxes);
      for (int i = 0; i < size; ++i)
      {
         if (_boxes[i] == box)
         {
            return i;
         }
      }
      return -1;
   }

   void DeleteBox(Box* box)
   {
      int index = FindIndex(box);
      if (index == -1)
      {
         return;
      }
      delete _boxes[index];
      int size = ArraySize(_boxes);
      for (int i = index + 1; i < size; ++i)
      {
         _boxes[i - 1] = _boxes[i];
      }
      ArrayResize(_boxes, size - 1);
   }
   
   void Add(Box* box)
   {
      int index = FindIndex(box);
      if (index != -1)
      {
         delete _boxes[index];
         _boxes[index] = box;
         return;
      }
      int size = ArraySize(_boxes);
      ArrayResize(_boxes, size + 1);
      _boxes[size] = box;
   }

   void RedrawBoxs()
   {
      int size = ArraySize(_boxes);
      for (int i = 0; i < size; ++i)
      {
         _boxes[i].Redraw();
      }
   }
   
   static void AddCollection(BoxesCollection* collection)
   {
      int size = ArraySize(_collections);
      ArrayResize(_collections, size + 1);
      _collections[size] = collection;
   }
   
   static BoxesCollection* FindCollection(string id)
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
BoxesCollection* BoxesCollection::_collections[];
#endif