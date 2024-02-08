// Line array v1.2
#include <Array/ILineArray.mqh>
class LineArray : public ILineArray
{
   Line* array[];
   int _defaultSize;
   Line* _defaultValue;
public:
   LineArray(int size, Line* defaultValue)
   {
      _defaultSize = size;
      Clear();
   }

   ILineArray* Clear()
   {
      ArrayResize(array, _defaultSize);
      for (int i = 0; i < _defaultSize; ++i)
      {
         array[i] = _defaultValue;
      }
      return &this;
   }

   void Unshift(Line* value)
   {
      int size = ArraySize(array);
      ArrayResize(array, size + 1);
      for (int i = size - 1; i >= 0; --i)
      {
         array[i + 1] = array[i];
      }
      array[0] = value;
   }

   int Size()
   {
      return ArraySize(array);
   }

   void Push(Line* value)
   {
      int size = ArraySize(array);
      ArrayResize(array, size + 1);
      array[size] = value;
   }

   Line* Pop()
   {
      int size = ArraySize(array);
      Line* value = array[size - 1];
      ArrayResize(array, size - 1);
      return value;
   }

   Line* Shift()
   {
      return Remove(0);
   }

   Line* Get(int index)
   {
      return array[index];
   }
   
   ILineArray* Slice(int from, int to)
   {
      return NULL; //TODO;
   }

   Line* Remove(int index)
   {
      int size = ArraySize(array);
      Line* value = array[index];
      for (int i = index; i < size - 1; ++i)
      {
         array[i] = array[i + 1];
      }
      ArrayResize(array, size - 1);
      return value;
   }
};