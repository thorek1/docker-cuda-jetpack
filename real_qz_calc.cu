#if (defined __GNUC__) && (__GNUC__>4 || __GNUC_MINOR__>=7)
  #undef _GLIBCXX_ATOMIC_BUILTINS
  #undef _GLIBCXX_USE_INT128
#endif

#define EIGEN_TEST_NO_LONGDOUBLE
#define EIGEN_TEST_NO_COMPLEX
#define EIGEN_DEFAULT_DENSE_INDEX_TYPE int

#include "main.h"
#include "gpu_common.h"

// Check that dense modules can be properly parsed by nvcc
#include <Eigen/Dense>
#include <iostream>

using namespace Eigen;
using namespace std;

int main1(){
MatrixXf A = MatrixXf::Random(4,4);
MatrixXf B = MatrixXf::Random(4,4);
RealQZ<MatrixXf> qz(A,B); // preallocate space for 4x4 matrices
//qz.compute(A,B);  // A = Q S Z,  B = Q T Z

// print original matrices and result of decomposition
cout << "A:\n" << A << "\n" << "B:\n" << B << "\n";
cout << "S:\n" << qz.matrixS() << "\n" << "T:\n" << qz.matrixT() << "\n";
cout << "Q:\n" << qz.matrixQ() << "\n" << "Z:\n" << qz.matrixZ() << "\n";

// verify precision
cout << "\nErrors:"
  << "\n|A-QSZ|: " << (A-qz.matrixQ()*qz.matrixS()*qz.matrixZ()).norm()
  << ", |B-QTZ|: " << (B-qz.matrixQ()*qz.matrixT()*qz.matrixZ()).norm()
  << "\n|QQ* - I|: " << (qz.matrixQ()*qz.matrixQ().adjoint() - MatrixXf::Identity(4,4)).norm()
  << ", |ZZ* - I|: " << (qz.matrixZ()*qz.matrixZ().adjoint() - MatrixXf::Identity(4,4)).norm()
  << "\n";
return 0;
}

//int main1(){
//ei_test_init_gpu();
//return 0;
//}


//int main(){
//MatrixXf A = MatrixXf::Random(4,4);
//MatrixXf B = MatrixXf::Random(4,4);
//RealQZ<MatrixXf> qz(A,B); // preallocate space for 4x4 matrices


// print original matrices and result of decomposition
//cout << "A:\n" << A << "\n" << "B:\n" << B << "\n";
//cout << "S:\n" << qz.matrixS() << "\n" << "T:\n" << qz.matrixT() << "\n";
//cout << "Q:\n" << qz.matrixQ() << "\n" << "Z:\n" << qz.matrixZ() << "\n";

// verify precision
//cout << "\nErrors:"
//  << "\n|A-QSZ|: " << (A-qz.matrixQ()*qz.matrixS()*qz.matrixZ()).norm()
//  << ", |B-QTZ|: " << (B-qz.matrixQ()*qz.matrixT()*qz.matrixZ()).norm()
//  << "\n|QQ* - I|: " << (qz.matrixQ()*qz.matrixQ().adjoint() - MatrixXf::Identity(4,4)).norm()
//  << ", |ZZ* - I|: " << (qz.matrixZ()*qz.matrixZ().adjoint() - MatrixXf::Identity(4,4)).norm()
//  << "\n";
//return 0;
//}
