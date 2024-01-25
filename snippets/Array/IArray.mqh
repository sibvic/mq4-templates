// Array interface v1.0

class IIntArray
{
public:
   virtual void Unshift(int value) = 0;
   virtual int Size() = 0;
   virtual void Push(int value) = 0;
   virtual int Pop() = 0;
   virtual int Get(int index) = 0;
   virtual IIntArray* Slice(int from, int to) = 0;
   virtual void Clear() = 0;
};