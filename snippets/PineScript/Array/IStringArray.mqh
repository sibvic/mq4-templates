// string array interface v1.0

class IStringArray
{
public:
   virtual void Unshift(string value) = 0;
   virtual int Size() = 0;
   virtual IStringArray* Push(string value) = 0;
   virtual string Pop() = 0;
   virtual string Get(int index) = 0;
   virtual void Set(int index, string value) = 0;
   virtual IStringArray* Slice(int from, int to) = 0;
   virtual IStringArray* Clear() = 0;
   virtual string Shift() = 0;
   virtual string Remove(int index) = 0;
   virtual int Includes(string value) = 0;
};