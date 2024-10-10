// Float martix interface
// v1.0

interface IFloatMatrix
{
public:
   virtual IFloatMatrix* Clear() = 0;
   virtual double Get(int row, int col) = 0;
   virtual void Set(int row, int col, double val) = 0;
};