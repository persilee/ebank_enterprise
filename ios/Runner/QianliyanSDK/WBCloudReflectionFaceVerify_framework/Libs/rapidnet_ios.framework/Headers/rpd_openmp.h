#ifndef _RPD_OPENMP_20171113_H_
#define _RPD_OPENMP_20171113_H_
#include "platforms/platforms.h"

namespace RPNNameSpace {

int get_default_num_threads();
int set_default_num_threads(int num_threads);

int get_omp_num_threads();
void set_omp_num_threads(int num_threads);

int get_omp_dynamic();
void set_omp_dynamic(int dynamic);

} // namespace RPNNameSpace

#endif // _RPD_OPENMP_20171113_H_
