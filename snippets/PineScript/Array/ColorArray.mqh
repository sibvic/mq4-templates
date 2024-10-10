// Color array v1.0
#include <PineScript/Array/IColorArray.mqh>

class ColorArray : public IColorArray
{
   uint _array[];
   int _defaultSize;
   uint _defaultValue;
public:
   ColorArray(int size, uint defaultValue)
   {
      _defaultSize = size;
      Clear();
   }

   IColorArray* Clear()
   {
      ArrayResize(_array, _defaultSize);
      for (int i = 0; i < _defaultSize; ++i)
      {
         _array[i] = _defaultValue;
      }
      return &this;
   }

   void Unshift(uint value)
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

   IColorArray* Push(uint value)
   {
      int size = ArraySize(_array);
      ArrayResize(_array, size + 1);
      _array[size] = value;
      return &this;
   }

   uint Pop()
   {
      int size = ArraySize(_array);
      uint value = _array[size - 1];
      ArrayResize(_array, size - 1);
      return value;
   }

   uint Shift()
   {
      return Remove(0);
   }

   uint Get(int index)
   {
      if (index < 0 || index >= Size())
      {
         return EMPTY_VALUE;
      }
      return _array[index];
   }
   
   void Set(int index, uint value)
   {
      if (index < 0 || index >= Size())
      {
         return;
      }
      _array[index] = value;
   }
   
   IColorArray* Slice(int from, int to)
   {
      return NULL; //TODO;
   }

   uint Remove(int index)
   {
      int size = ArraySize(_array);
      uint value = _array[index];
      for (int i = index; i < size - 1; ++i)
      {
         _array[i] = _array[i + 1];
      }
      ArrayResize(_array, size - 1);
      return value;
   }
   
   int Includes(uint value)
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