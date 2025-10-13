#!/bin/bash

# --- Cocotb Environment Setup for Poetry/Pyenv ---
#
# Run this script using 'source' to configure your shell for simulation.
# Example: source env_setup.sh

echo "Setting up Cocotb environment..."

# 1. Find the path to the Python shared library for the pyenv version
#    This is for the dynamic linker (LD_LIBRARY_PATH).
PYENV_PYTHON_VERSION="3.11.11" # Change this if your version is different
PYTHON_LIB_DIR=$(find ~/.pyenv/versions/$PYENV_PYTHON_VERSION -name "libpython*.so" -exec dirname {} \; | head -n1)

if [ -z "$PYTHON_LIB_DIR" ]; then
    echo "❌ ERROR: Could not find Python shared library directory for version $PYENV_PYTHON_VERSION."
    echo "         Please ensure you have installed it with '--enable-shared'."
    return 1
else
    export LD_LIBRARY_PATH=$PYTHON_LIB_DIR:$LD_LIBRARY_PATH
    echo "  -> LD_LIBRARY_PATH is set."
fi

# 2. Find the path to the Python executable within the Poetry virtualenv.
#    This is for Cocotb's GPI layer (PYGPI_PYTHON_BIN).
PYTHON_BIN=$(poetry run which python)

if [ -z "$PYTHON_BIN" ]; then
    echo "❌ ERROR: Could not find the python executable in the poetry environment."
    echo "         Is poetry set up correctly in this directory?"
    return 1
else
    export PYGPI_PYTHON_BIN=$PYTHON_BIN
    echo "  -> PYGPI_PYTHON_BIN is set."
fi

echo ""
echo "✅ Cocotb environment is ready for this terminal session."
