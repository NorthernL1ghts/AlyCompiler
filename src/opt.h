#ifndef ALY_COMPILER_OPT_H
#define ALY_COMPILER_OPT_H

#include <codegen/codegen_forward.h>

extern int optimise;

/// Currently, we don’t have optimisation levels, so this
/// will simply perform all available optimisations.
void codegen_optimise(CodegenContext *ctx);

#endif /* ALY_COMPILER_OPT_H */
