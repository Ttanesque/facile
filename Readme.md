Facile
======

## Dependencies
* dot environnement
* monodis
* ilasm
* flex
* bison
* cmake
* glib
* gcc

## Compilation
Build and test the project
```bash
./build
make
./facile <fichier>
ilasm <fichier>
chmod +x <fichier>
./<fichier> 
```

## Test il language
Build cs program for understand il language.
```bash
mcs <fichier>.cs
monodis <fichier> > fichier.il
```