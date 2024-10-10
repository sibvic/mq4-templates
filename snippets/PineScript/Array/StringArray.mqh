// String array v1.0
#include <PineScript/Array/IStringArray.mqh>

class StringArray : public IStringArray
{
   string _array[];
   int _defaultSize;
   string _defaultValue;
public:
   StringArray(int size, string defaultValue)
   {
      _defaultSize = size;
      Clear();
   }

   IStringArray* Clear()
   {
      ArrayResize(_array, _defaultSize);
      for (int i = 0; i < _defaultSize; ++i)
      {
         _array[i] = _defaultValue;
      }
      return &this;
   }

   void Unshift(string value)
   {
      int size = ArraySize(_array);
      ArrayResize(_array, size + 1);
      for (int i = size - 1; i >= 0; --i)
      {
         _array[i + 1] = _array[i];
      }
      _array[0] = value;
   }

   int Size()
   {
      return ArraySize(_array);
   }

   IStringArray* Push(string value)
   {
      int size = ArraySize(_array);
      ArrayResize(_array, size + 1);
      _array[size] = value;
      return &this;
   }

   string Pop()
   {
      int size = ArraySize(_array);
      string value = _array[size - 1];
      ArrayResize(_array, size - 1);
      return value;
   }

   string Shift()
   {
      return Remove(0);
   }

   string Get(int index)
   {
      if (index < 0 || index >= Size())
      {
         return NULL;
      }
      return _array[index];
   }
   
   void Set(int index, string value)
   {
      if (index < 0 || index >= Size())
      {
         return;
      }
      _array[index] = value;
   }
   
   IStringArray* Slice(int from, int to)
   {
      return NULL; //TODO;
   }

   string Remove(int index)
   {
      int size = ArraySize(_array);
      string value = _array[index];
      for (int i = index; i < size - 1; ++i)
      {
         _array[i] = _array[i + 1];
      }
      ArrayResize(_array, size - 1);
      return value;
   }
   
   int Includes(string value)
   {
      int size = ArraySize(_array);
      for (int i = 0; i < size; ++i)
      {
         if (_array[i] == value)
         {
            return true;
         }
      }
      return false;
   }
};