alybuild() {
    local DIALECT="att"
    local VERBOSE=1
    local BUILD_DIR=""
    local MAKE_JOBS=4   # Default parallel jobs

    # ANSI colors
    local RED="\033[0;31m"
    local GREEN="\033[0;32m"
    local YELLOW="\033[1;33m"
    local NC="\033[0m"

    # Parse options
    while getopts "d:qj:o:" opt; do
        case $opt in
            d) DIALECT="$OPTARG" ;;
            q) VERBOSE=0 ;;
            j) MAKE_JOBS="$OPTARG" ;;
            o) BUILD_DIR="$OPTARG" ;;
            *) echo -e "${YELLOW}Usage:${NC} alybuild [-d dialect] [-q] [-j jobs] [-o build-dir] <file>" >&2
               return 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    # Require a file argument
    if [ $# -lt 1 ]; then
        echo -e "${RED}Error:${NC} Missing input file." >&2
        return 1
    fi

    local INPUT_FILE="$1"

    # Check if input file exists
    if [ ! -f "$INPUT_FILE" ]; then
        echo -e "${RED}Error:${NC} File '$INPUT_FILE' does not exist." >&2
        return 1
    fi

    # Convert input file to absolute path to avoid cwd issues
    INPUT_FILE="$(realpath "$INPUT_FILE")"

    # Set compiler directories
    local COMPILER_DIR="/c/Dev/AlyCompiler"
    BUILD_DIR="${BUILD_DIR:-$COMPILER_DIR/bld}"

    mkdir -p "$BUILD_DIR" || { echo -e "${RED}Failed to create build directory${NC}"; return 1; }
    cd "$BUILD_DIR" || { echo -e "${RED}Failed to enter build directory${NC}"; return 1; }

    echo -e "${GREEN}Building AlyCompiler in $BUILD_DIR...${NC}"

    # Only run cmake if Makefile doesn't exist (incremental build)
    if [ ! -f "Makefile" ]; then
        cmake -G "MinGW Makefiles" -DCMAKE_C_COMPILER=gcc "$COMPILER_DIR" || { echo -e "${RED}CMake configuration failed${NC}"; return 1; }
    fi

    # Build the compiler
    if [ $VERBOSE -eq 1 ]; then
        mingw32-make -j"$MAKE_JOBS" || { echo -e "${RED}Build failed${NC}"; return 1; }
    else
        mingw32-make -j"$MAKE_JOBS" >/dev/null 2>&1 || { echo -e "${RED}Build failed${NC}"; return 1; }
    fi

    # Compile the user's file
    echo -e "${GREEN}Compiling '$INPUT_FILE' with dialect '$DIALECT'...${NC}"
    "$BUILD_DIR/bin/alyc.exe" -v -d "$DIALECT" "$INPUT_FILE"
}
