// bool array interface v1.0

class IBoolArray
{
public:
   virtual void Unshift(int value) = 0;
   virtual int Size() = 0;
   virtual IBoolArray* Push(int value) = 0;
   virtual int Pop() = 0;
   virtual int Get(int index) = 0;
   virtual void Set(int index, int value) = 0;
   virtual IBoolArray* Slice(int from, int to) = 0;
   virtual IBoolArray* Clear() = 0;
   virtual int Shift() = 0;
   virtual int Remove(int index) = 0;
   virtual int Includes(int value) = 0;
};