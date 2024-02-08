// Collection of boxes v1.1

#ifndef BoxesCollection_IMPL
#define BoxesCollection_IMPL

#include <Objects/Box.mqh>

class BoxesCollection
{
   string _id;
   Box* _boxes[];
   static BoxesCollection* _collections[];
   static BoxesCollection* _all;
   static int _maxBoxes;
public:
   BoxesCollection(string id)
   {
      _id = id;
   }

   ~BoxesCollection()
   {
      ClearBoxes();
   }
   
   void ClearBoxes()
   {
      for (int i = 0; i < ArraySize(_boxes); ++i)
      {
         _boxes[i].Release();
      }
      ArrayResize(_boxes, 0);
   }
   
   string GetId()
   {
      return _id;
   }

   int Count()
   {
      return ArraySize(_boxes);
   }

   Box* GetFirst()
   {
      return _boxes[0];
   }

   Box* GetByIndex(int index)
   {
      int size = ArraySize(_boxes);
      if (index < 0 || index >= size)
      {
         return NULL;
      }
      return _boxes[size - 1 - index];
   }

   static Box* Get(Box* box, int index)
   {
      if (box == NULL)
      {
         return NULL;
      }
      BoxesCollection* collection = FindCollection(box.GetCollectionId());
      if (collection == NULL)
      {
         return NULL;
      }
      return collection.GetByIndex(index);
   }

   static void Clear()
   {
      for (int i = 0; i < ArraySize(_collections); ++i)
      {
         delete _collections[i];
      }
      ArrayResize(_collections, 0);
      if (_all == NULL)
      {
         _all = new BoxesCollection("");
      }
      _all.ClearBoxes();
   }

   static void Delete(Box* box)
   {
      if (box == NULL)
      {
         return;
      }
      if (!_all.RemoveBox(box))
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
      _all.Add(box);
      if (_all.Count() > _maxBoxes)
      {
         Delete(_all.GetFirst());
      }
      return box;
   }
   
   static void SetMaxBoxes(int max)
   {
      _maxBoxes = max;
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

   bool RemoveBox(Box* box)
   {
      int index = FindIndex(box);
      if (index == -1)
      {
         return false;
      }
      int size = ArraySize(_boxes);
      for (int i = index + 1; i < size; ++i)
      {
         _boxes[i - 1] = _boxes[i];
      }
      ArrayResize(_boxes, size - 1);
      return true;
   }
   void DeleteBox(Box* box)
   {
      if (RemoveBox(box))
      {
         box.Release();
      }
   }
   
   void Add(Box* box)
   {
      int index = FindIndex(box);
      
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
BoxesCollection* BoxesCollection::_all;
int BoxesCollection::_maxBoxes = 50;
#endif