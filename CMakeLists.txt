cmake_minimum_required(VERSION 3.14)

# Use `ccache` if it is installed in system's PATH.
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
endif()

# Export compilation database in JSON format.
set(CMAKE_EXPORT_COMPILE_COMMANDS on)

project(AlyCompiler C)

add_executable(
  alyc
  src/codegen.c
  src/error.c
  src/environment.c
  src/file_io.c
  src/main.c
  src/parser.c
  src/typechecker.c
  src/opt.c
  src/codegen/intermediate_representation.c
  src/codegen/register_allocation.c
  src/codegen/x86_64/arch_x86_64.c
)
target_include_directories(
  alyc
  PUBLIC src/
)

if (NOT MSVC)
  target_compile_options(
    alyc
    PRIVATE
    -Wall -Wextra
    -Wshadow -Wconversion
    -Werror=return-type -Werror=implicit-function-declaration
    -Werror=implicit-int -Werror=pointer-arith
    -Wno-unused-parameter -Wno-unused-function
  )

  if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_options(alyc PRIVATE -O0 -g)
  else()
    target_compile_options(alyc PRIVATE -O3)
  endif()

  if (DEFINED DEBUG AND NOT WIN32)
    target_compile_options(alyc PRIVATE -fsanitize=address)
    target_link_options(alyc PRIVATE -fsanitize=address)
  endif()
else()
  target_compile_options(alyc PRIVATE /W4)
endif()
