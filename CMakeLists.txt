cmake_minimum_required(VERSION 3.20)

# Project definition
project(AlyCompiler C)

# Use 'ccache' if available
find_program(CCACHE_PROGRAM ccache)
if (CCACHE_PROGRAM)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
endif()

# Export compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Source files
set(SOURCE_FILES
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

# Define executable
add_executable(alyc ${SOURCE_FILES})

# Include directories
target_include_directories(alyc PUBLIC src)

if (NOT MSVC)
  target_compile_options(
    alyc
    PRIVATE
    -Wall -Wextra
    -Wshadow -Wconversion
    -Werror=return-type -Werror=implicit-function-declaration
    -Werror=implicit-int -Werror=pointer-arith
    -Wno-unused
    -O0 -g
  )
  if (DEFINED DEBUG AND NOT WIN32)
    target_compile_options(func PRIVATE -fsanitize=address)
    target_link_options(func PRIVATE -fsanitize=address)
  endif()
endif()
