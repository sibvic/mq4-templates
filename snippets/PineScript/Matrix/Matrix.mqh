// Matrix
// v1.0

#include <PineScript/Matrix/FloatMatrix.mqh>
#include <PineScript/Matrix/TableMatrix.mqh>

class Matrix
{
public:
   static double Get(IFloatMatrix* matrix, int row, int col) { if (matrix == NULL) { return EMPTY_VALUE; } return matrix.Get(row, col); }
   static Table* Get(ITableMatrix* matrix, int row, int col) { if (matrix == NULL) { return NULL; } return matrix.Get(row, col); }
   
   static void Set(IFloatMatrix* matrix, int row, int col, double val) { if (matrix == NULL) { return; } matrix.Set(row, col, val); }
   static void Set(ITableMatrix* matrix, int row, int col, Table* val) { if (matrix == NULL) { return; } matrix.Set(row, col, val); }
};