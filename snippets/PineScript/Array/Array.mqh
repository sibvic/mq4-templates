// Array v1.6
#include <PineScript/Array/IArray.mqh>
#include <PineScript/Array/LineArray.mqh>
#include <PineScript/Array/LabelArray.mqh>
#include <PineScript/Array/IntArray.mqh>
#include <PineScript/Array/BoolArray.mqh>
#include <PineScript/Array/FloatArray.mqh>
#include <PineScript/Array/BoxArray.mqh>
#include <PineScript/Array/StringArray.mqh>
#include <PineScript/Array/ColorArray.mqh>
#include <PineScript/Array/CustomTypeArray.mqh>
#include <PineScript/Array/SimpleTypeArray.mqh>

class Array
{
public:
   template <typename ARRAY_TYPE, typename VALUE_TYPE>
   static void Unshift(ARRAY_TYPE array, VALUE_TYPE value) { if (array == NULL) { return; } array.Unshift(value); }
   
   static double Avg(ISimpleTypeArray<double>* array)
   {
      if (array == NULL || array.Size() == 0)
      {
         return EMPTY_VALUE;
      }
      return Sum(array) / array.Size();
   }
   static double Avg(ISimpleTypeArray<int>* array)
   {
      if (array == NULL || array.Size() == 0)
      {
         return EMPTY_VALUE;
      }
      return Sum(array) / array.Size();
   }
   template <typename DUMMY_TYPE, typename ARRAY_TYPE>
   static int Size(ARRAY_TYPE array, int defaultValue) { if (array == NULL) { return INT_MIN;} return array.Size(); }

   template <typename ARRAY_TYPE>
   static void Clear(ARRAY_TYPE array) { if (array == NULL) { return;} array.Clear(); }

   template <typename ARRAY_TYPE, typename VALUE_TYPE>
   static VALUE_TYPE Shift(ARRAY_TYPE array, VALUE_TYPE emptyValue) { if (array == NULL) { return emptyValue; } return array.Shift(); }

   template <typename ARRAY_TYPE, typename VALUE_TYPE>
   static void Push(ARRAY_TYPE array, VALUE_TYPE value) { if (array == NULL) { return; } array.Push(value); }
   template <typename VALUE_TYPE, typename ARRAY_TYPE>
   static VALUE_TYPE First(ARRAY_TYPE array, VALUE_TYPE defaultValue)
   {
      if (array == NULL || array.Size() == 0) { return defaultValue; } 
      return array.Get(0);
   }
   template <typename VALUE_TYPE, typename ARRAY_TYPE>
   static VALUE_TYPE Last(ARRAY_TYPE array, VALUE_TYPE defaultValue)
   {
      if (array == NULL || array.Size() == 0) { return defaultValue; } 
      return array.Get(array.Size() - 1);
   }
   
   template <typename VALUE_TYPE, typename ARRAY_TYPE>
   static VALUE_TYPE Pop(ARRAY_TYPE array, VALUE_TYPE emptyValue) { if (array == NULL) { return emptyValue; } return array.Pop(); }

   template <typename RETURN_TYPE, typename ARRAY_TYPE, typename DUMMY_TYPE>
   static RETURN_TYPE Get(ARRAY_TYPE array, int index, RETURN_TYPE emptyValue) { if (array == NULL) { return emptyValue; } return array.Get(index); }
   
   template <typename ARRAY_TYPE, typename DUMMY_TYPE, typename VALUE_TYPE>
   static void Set(ARRAY_TYPE array, int index, VALUE_TYPE value) { if (array == NULL) { return; } array.Set(index, value); }

   template <typename RETURN_TYPE, typename ARRAY_TYPE, typename DUMMY_TYPE>
   static RETURN_TYPE Remove(ARRAY_TYPE array, int index, RETURN_TYPE emptyValue) { if (array == NULL) { return emptyValue; } return array.Remove(index); }
   
   static int Includes(IIntArray* array, int value) { if (array == NULL) { return -1; } return array.Includes(value); }
   static int Includes(ILineArray* array, Line* value) { if (array == NULL) { return -1; } return array.Includes(value); }
   static int Includes(IBoxArray* array, Box* value) { if (array == NULL) { return -1; } return array.Includes(value); }
   static int Includes(IStringArray* array, string value) { if (array == NULL) { return -1; } return array.Includes(value); }
   static int Includes(IBoolArray* array, int value) { if (array == NULL) { return -1; } return array.Includes(value); }
   static int Includes(IColorArray* array, uint value) { if (array == NULL) { return -1; } return array.Includes(value); }

   template <typename RETURN_TYPE, typename ARRAY_TYPE, typename DUMMY_TYPE>
   static ARRAY_TYPE PercentRank(ISimpleTypeArray<ARRAY_TYPE>* array) { if (array == NULL) { return -1; } return array.PercentRank(index); }

   template <typename RETURN_TYPE, typename ARRAY_TYPE, typename DUMMY_TYPE>
   static ARRAY_TYPE Sum(ISimpleTypeArray<ARRAY_TYPE>* array) { if (array == NULL) { return -1; } return array.Sum(); }
   
   template <typename RETURN_TYPE, typename ARRAY_TYPE, typename DUMMY_TYPE>
   static ARRAY_TYPE Stdev(ISimpleTypeArray<ARRAY_TYPE>* array) { if (array == NULL) { return -1; } return array.Stdev(); }
   
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

