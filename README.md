Cheminformatics
===============

This is an early attempt to use OpenCog for cheminformatics, with specialized support for cosmetic chemistry applications.

## Features

### Core Cheminformatics
- Chemical element atom types (H, C, N, O, etc.)
- Chemical bond types (single, double, triple, aromatic)
- Molecule and reaction representations
- Basic chemical structure modeling

### Cosmetic Chemistry Specializations
- **Cosmetic Ingredient Types**: Active ingredients, preservatives, emulsifiers, humectants, surfactants, thickeners, emollients, antioxidants, UV filters, fragrances, colorants
- **Formulation Types**: Skincare, haircare, makeup, and fragrance formulations
- **Property Modeling**: pH, viscosity, stability, texture, color, scent, SPF properties
- **Interaction Analysis**: Compatibility, incompatibility, synergy, and antagonism relationships
- **Safety & Regulatory**: Safety assessments, allergen classifications, concentration limits

Building and Installing
=======================
To build the code, you will need to build and install the
[OpenCog AtomSpace](https://github.com/opencog/atomspace) first.
All of the pre-requistes listed there are sufficient to also build
this project. Building is as "usual":
```
    cd to project root dir
    mkdir build
    cd build
    cmake ..
    make -j
    sudo make install
    make -j test
```

## Documentation

- [Cosmetic Chemistry Guide](docs/COSMETIC_CHEMISTRY.md) - Comprehensive guide to cosmetic chemistry specializations

Examples
========
Examples can be found in the [examples](examples) directory.

### Cosmetic Chemistry Examples
- **Python**: 
  - [cosmetic_intro_example.py](examples/python/cosmetic_intro_example.py) - Basic cosmetic ingredient and formulation creation
  - [cosmetic_chemistry_example.py](examples/python/cosmetic_chemistry_example.py) - Advanced cosmetic formulation analysis
- **Scheme**: 
  - [cosmetic_formulation.scm](examples/scheme/cosmetic_formulation.scm) - Complex formulation modeling and compatibility analysis

### Basic Cheminformatics Examples  
- **Python**: [intro_example.py](examples/python/intro_example.py) - Basic molecule creation
- **Scheme**: [reaction.scm](examples/scheme/reaction.scm) - Chemical reaction modeling

If you run python virtualenv, and are experiencing issues with undefined
symbols, then try adding `/usr/local/lib/python3.11/dist-packages/`
to your `PYTHON_PATH` and adding `/usr/local/lib/opencog/` to your
`LD_LIBRARY_PATH`.
