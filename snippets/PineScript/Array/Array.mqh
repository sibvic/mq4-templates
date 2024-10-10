// Array v1.3
#include <PineScript/Array/IArray.mqh>
#include <PineScript/Array/LineArray.mqh>
#include <PineScript/Array/IntArray.mqh>
#include <PineScript/Array/BoolArray.mqh>
#include <PineScript/Array/FloatArray.mqh>
#include <PineScript/Array/BoxArray.mqh>
#include <PineScript/Array/StringArray.mqh>
#include <PineScript/Array/ColorArray.mqh>

class Array
{
public:
   static void Unshift(IIntArray* array, int value) { if (array == NULL) { return; } array.Unshift(value); }
   static void Unshift(IFloatArray* array, double value) { if (array == NULL) { return; } array.Unshift(value); }
   static void Unshift(ILineArray* array, Line* value) { if (array == NULL) { return; } array.Unshift(value); }
   static void Unshift(IBoxArray* array, Box* value) { if (array == NULL) { return; } array.Unshift(value); }
   static void Unshift(IStringArray* array, string value) { if (array == NULL) { return; } array.Unshift(value); }
   static void Unshift(IBoolArray* array, int value) { if (array == NULL) { return; } array.Unshift(value); }
   static void Unshift(IColorArray* array, uint value) { if (array == NULL) { return; } array.Unshift(value); }
   
   static int Size(IIntArray* array) { if (array == NULL) { return EMPTY_VALUE;} return array.Size(); }
   static int Size(IFloatArray* array) { if (array == NULL) { return EMPTY_VALUE;} return array.Size(); }
   static int Size(ILineArray* array) { if (array == NULL) { return EMPTY_VALUE;} return array.Size(); }
   static int Size(IBoxArray* array) { if (array == NULL) { return EMPTY_VALUE;} return array.Size(); }
   static int Size(IStringArray* array) { if (array == NULL) { return EMPTY_VALUE;} return array.Size(); }
   static int Size(IBoolArray* array) { if (array == NULL) { return EMPTY_VALUE;} return array.Size(); }
   static int Size(IColorArray* array) { if (array == NULL) { return EMPTY_VALUE;} return array.Size(); }

   static int Shift(IIntArray* array) { if (array == NULL) { return EMPTY_VALUE; } return array.Shift(); }
   static double Shift(IFloatArray* array) { if (array == NULL) { return EMPTY_VALUE; } return array.Shift(); }
   static Line* Shift(ILineArray* array) { if (array == NULL) { return NULL; } return array.Shift(); }
   static Box* Shift(IBoxArray* array) { if (array == NULL) { return NULL; } return array.Shift(); }
   static string Shift(IStringArray* array) { if (array == NULL) { return NULL; } return array.Shift(); }
   static int Shift(IBoolArray* array) { if (array == NULL) { return EMPTY_VALUE; } return array.Shift(); }
   static uint Shift(IColorArray* array) { if (array == NULL) { return EMPTY_VALUE; } return array.Shift(); }

   static void Push(IIntArray* array, int value) { if (array == NULL) { return; } array.Push(value); }
   static void Push(IFloatArray* array, double value) { if (array == NULL) { return; } array.Push(value); }
   static void Push(ILineArray* array, Line* value) { if (array == NULL) { return; } array.Push(value); }
   static void Push(IBoxArray* array, Box* value) { if (array == NULL) { return; } array.Push(value); }
   static void Push(IStringArray* array, string value) { if (array == NULL) { return; } array.Push(value); }
   static void Push(IBoolArray* array, int value) { if (array == NULL) { return; } array.Push(value); }
   static void Push(IColorArray* array, uint value) { if (array == NULL) { return; } array.Push(value); }

   static int Pop(IIntArray* array) { if (array == NULL) { return EMPTY_VALUE; } return array.Pop(); }
   static double Pop(IFloatArray* array) { if (array == NULL) { return EMPTY_VALUE; } return array.Pop(); }
   static Line* Pop(ILineArray* array) { if (array == NULL) { return NULL; } return array.Pop(); }
   static Box* Pop(IBoxArray* array) { if (array == NULL) { return NULL; } return array.Pop(); }
   static string Pop(IStringArray* array) { if (array == NULL) { return NULL; } return array.Pop(); }
   static int Pop(IBoolArray* array) { if (array == NULL) { return EMPTY_VALUE; } return array.Pop(); }
   static uint Pop(IColorArray* array) { if (array == NULL) { return EMPTY_VALUE; } return array.Pop(); }

   static int Get(IIntArray* array, int index) { if (array == NULL) { return EMPTY_VALUE; } return array.Get(index); }
   static double Get(IFloatArray* array, int index) { if (array == NULL) { return EMPTY_VALUE; } return array.Get(index); }
   static Line* Get(ILineArray* array, int index) { if (array == NULL) { return NULL; } return array.Get(index); }
   static Box* Get(IBoxArray* array, int index) { if (array == NULL) { return NULL; } return array.Get(index); }
   static string Get(IStringArray* array, int index) { if (array == NULL) { return NULL; } return array.Get(index); }
   static int Get(IBoolArray* array, int index) { if (array == NULL) { return EMPTY_VALUE; } return array.Get(index); }
   static uint Get(IColorArray* array, int index) { if (array == NULL) { return EMPTY_VALUE; } return array.Get(index); }
   
   static void Set(IIntArray* array, int index, int value) { if (array == NULL) { return; } array.Set(index, value); }
   static void Set(IFloatArray* array, int index, double value) { if (array == NULL) { return; } array.Set(index, value); }
   static void Set(ILineArray* array, int index, Line* value) { if (array == NULL) { return; } array.Set(index, value); }
   static void Set(IBoxArray* array, int index, Box* value) { if (array == NULL) { return; } array.Set(index, value); }
   static void Set(IStringArray* array, int index, string value) { if (array == NULL) { return; } array.Set(index, value); }
   static void Set(IBoolArray* array, int index, int value) { if (array == NULL) { return; } array.Set(index, value); }
   static void Set(IColorArray* array, int index, uint value) { if (array == NULL) { return; } array.Set(index, value); }

   static int Remove(IIntArray* array, int index) { if (array == NULL) { return EMPTY_VALUE; } return array.Remove(index); }
   static double Remove(IFloatArray* array, int index) { if (array == NULL) { return EMPTY_VALUE; } return array.Remove(index); }
   static Line* Remove(ILineArray* array, int index) { if (array == NULL) { return NULL; } return array.Remove(index); }
   static Box* Remove(IBoxArray* array, int index) { if (array == NULL) { return NULL; } return array.Remove(index); }
   static string Remove(IStringArray* array, int index) { if (array == NULL) { return NULL; } return array.Remove(index); }
   static int Remove(IBoolArray* array, int index) { if (array == NULL) { return EMPTY_VALUE; } return array.Remove(index); }
   static uint Remove(IColorArray* array, int index) { if (array == NULL) { return EMPTY_VALUE; } return array.Remove(index); }
   
   static int Includes(IIntArray* array, int value) { if (array == NULL) { return -1; } return array.Includes(value); }
   static int Includes(IFloatArray* array, double value) { if (array == NULL) { return -1; } return array.Includes(value); }
   static int Includes(ILineArray* array, Line* value) { if (array == NULL) { return -1; } return array.Includes(value); }
   static int Includes(IBoxArray* array, Box* value) { if (array == NULL) { return -1; } return array.Includes(value); }
   static int Includes(IStringArray* array, string value) { if (array == NULL) { return -1; } return array.Includes(value); }
   static int Includes(IBoolArray* array, int value) { if (array == NULL) { return -1; } return array.Includes(value); }
   static int Includes(IColorArray* array, uint value) { if (array == NULL) { return -1; } return array.Includes(value); }

   static int PercentRank(IIntArray* array, int index)
   {
      int arraySize = array.Size();
      if (array == NULL || arraySize == 0 || arraySize <= index) { return EMPTY_VALUE; }
      int target = array.Get(index);
      if (target == EMPTY_VALUE)
      {
         return EMPTY_VALUE;
      }
      int count = 0;
      for (int i = 0; i < arraySize; ++i)
      {
         int current = array.Get(i);
         if (current != EMPTY_VALUE && target >= current)
         {
            count++;
         }
      }
      return (count * 100.0) / arraySize;
   }
   static double PercentRank(IFloatArray* array, int index)
   {
      int arraySize = array.Size();
      if (array == NULL || arraySize == 0 || arraySize <= index) { return EMPTY_VALUE; }
      double target = array.Get(index);
      if (target == EMPTY_VALUE)
      {
         return EMPTY_VALUE;
      }
      int count = 0;
      for (int i = 0; i < arraySize; ++i)
      {
         double current = array.Get(i);
         if (current != EMPTY_VALUE && target >= current)
         {
            count++;
         }
      }
      return (count * 100.0) / arraySize;
   }

   static int Max(IIntArray* array)
   {
      if (array == NULL || array.Size() == 0) { return EMPTY_VALUE; }
      int max = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         int current = array.Get(i);
         if (max == EMPTY_VALUE || (current != EMPTY_VALUE && max < current))
         {
            max = current;
         }
      }
      return max;
   }
   static double Max(IFloatArray* array)
   {
      if (array == NULL || array.Size() == 0) { return EMPTY_VALUE; }
      double max = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         double current = array.Get(i);
         if (max == EMPTY_VALUE || (current != EMPTY_VALUE && max < current))
         {
            max = current;
         }
      }
      return max;
   }
   static int Min(IIntArray* array)
   {
      if (array == NULL || array.Size() == 0) { return EMPTY_VALUE; }
      int min = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         int current = array.Get(i);
         if (min == EMPTY_VALUE || (current != EMPTY_VALUE && min > current))
         {
            min = current;
         }
      }
      return min;
   }
   static double Min(IFloatArray* array)
   {
      if (array == NULL || array.Size() == 0) { return EMPTY_VALUE; }
      double min = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         double current = array.Get(i);
         if (min == EMPTY_VALUE || (current != EMPTY_VALUE && min > current))
         {
            min = current;
         }
      }
      return min;
   }

   static int Sum(IIntArray* array)
   {
      if (array == NULL)
      {
         return 0;
      }
      int sum = 0;
      for (int i = 0; i < array.Size(); ++i)
      {
         sum += array.Get(i);
      }
      return sum;
   }
   static double Sum(IFloatArray* array)
   {
      if (array == NULL)
      {
         return 0;
      }
      double sum = 0;
      for (int i = 0; i < array.Size(); ++i)
      {
         sum += array.Get(i);
      }
      return sum;
   }
   
   static double Stdev(IIntArray* array)
   {
      if (array == NULL)
      {
         return EMPTY_VALUE;
      }
      double sum = 0;
      double ssum = 0;
      int size = array.Size();
      if (size < 2)
      {
         return 0;
      }
      for (int i = 0; i < size; i++)
      {
         int value = array.Get(i);
         sum += value;
         ssum += MathPow(value, 2);
      }
      return MathSqrt((ssum * size - sum * sum) / (size * (size - 1)));
   }
   static double Stdev(IFloatArray* array)
   {
      if (array == NULL)
      {
         return EMPTY_VALUE;
      }
      double sum = 0;
      double ssum = 0;
      int size = array.Size();
      if (size < 2)
      {
         return 0;
      }
      for (int i = 0; i < size; i++)
      {
         double value = array.Get(i);
         sum += value;
         ssum += MathPow(value, 2);
      }
      return MathSqrt((ssum * size - sum * sum) / (size * (size - 1)));
   }
   
   static string Join(IStringArray* array, string concat)
   {
      string res = "";
      for (int i = 0; i < array.Size(); ++i)
      {
         string val = array.Get(i);
         if (val == NULL)
         {
            continue;
         }
         if (i > 0)
         {
            res += concat;
         }
         res += array.Get(i);
      }
      return res;
   }
};

