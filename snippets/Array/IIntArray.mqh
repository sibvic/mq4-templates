// int array interface v1.1

class IIntArray
{
public:
   virtual void Unshift(int value) = 0;
   virtual int Size() = 0;
   virtual void Push(int value) = 0;
   virtual int Pop() = 0;
   virtual int Get(int index) = 0;
   virtual IIntArray* Slice(int from, int to) = 0;
   virtual IIntArray* Clear() = 0;
   virtual int Shift() = 0;
   virtual int Remove(int index) = 0;
};