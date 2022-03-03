To hide the status bar on a per-level basis, apply `NoStatus.asm` to each level number that you want in the `list_uberasm.txt` file in the `common` folder (it is already applied to level 105). 

If you are using other UberASM on your level you can use the following method to hide the status bar by calling it from the library folder in your chosen asm by adding the following to your desired uberASM file:

```
load:
    jsl NoStatus_load
    rtl
```