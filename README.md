# MLIRView Plugin for Vim

A simple plugin to visualize MLIR lowering by mapping source lines to lowered lines using `loc` metadata.

## Features
- Side-by-side view of source and lowered MLIR files.
- Highlights lowered MLIR lines corresponding to the current source line.
- Automatically parses `loc` metadata.

## Usage

Open the MLIR files side by side:
:MLIRView source.mlir lowered.mlir
Move the cursor in the source file window to highlight corresponding lines in the lowered file.

### Commands

:MLIRView <source.mlir> <lowered.mlir>: Opens the files in a vertical split and sets up mapping/highlighting.