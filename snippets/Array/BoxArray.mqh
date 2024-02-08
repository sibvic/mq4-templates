// Box array v1.2
#include <Array/IBoxArray.mqh>
class BoxArray : public IBoxArray
{
   Box* array[];
   int _defaultSize;
   Box* _defaultValue;
public:
   BoxArray(int size, Box* defaultValue)
   {
      _defaultSize = size;
      Clear();
   }

   IBoxArray* Clear()
   {
      ArrayResize(array, _defaultSize);
      for (int i = 0; i < _defaultSize; ++i)
      {
         array[i] = _defaultValue;
      }
      return &this;
   }

   void Unshift(Box* value)
   {
      int size = ArraySize(array);
      ArrayResize(array, size + 1);
      for (int i = size - 1; i >= 0; --i)
      {
         array[i + 1] = array[i];
      }
      array[0] = value;
      if (value != NULL)
      {
         value.AddRef();
      }
   }

   int Size()
   {
      return ArraySize(array);
   }

   void Push(Box* value)
   {
      int size = ArraySize(array);
      ArrayResize(array, size + 1);
      array[size] = value;
      if (value != NULL)
      {
         value.AddRef();
      }
   }

   Box* Pop()
   {
      int size = ArraySize(array);
      Box* value = array[size - 1];
      ArrayResize(array, size - 1);
      if (value.Release() == 0)
      {
         return NULL;
      }
      return value;
   }

   Box* Shift()
   {
      return Remove(0);
   }

   Box* Get(int index)
   {
      return array[index];
   }
   
   IBoxArray* Slice(int from, int to)
   {
      return NULL; //TODO;
   }

   Box* Remove(int index)
   {
      int size = ArraySize(array);
      Box* value = array[index];
      for (int i = index; i < size - 1; ++i)
      {
         array[i] = array[i + 1];
      }
      ArrayResize(array, size - 1);
      if (value.Release() == 0)
      {
         return NULL;
      }
      return value;
   }
};