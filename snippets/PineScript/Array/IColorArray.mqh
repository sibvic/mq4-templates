// Color array interface v1.0

class IColorArray
{
public:
   virtual void Unshift(uint value) = 0;
   virtual int Size() = 0;
   virtual IColorArray* Push(uint value) = 0;
   virtual uint Pop() = 0;
   virtual uint Get(int index) = 0;
   virtual void Set(int index, uint value) = 0;
   virtual IColorArray* Slice(int from, int to) = 0;
   virtual IColorArray* Clear() = 0;
   virtual uint Shift() = 0;
   virtual uint Remove(int index) = 0;
   virtual int Includes(uint value) = 0;
};