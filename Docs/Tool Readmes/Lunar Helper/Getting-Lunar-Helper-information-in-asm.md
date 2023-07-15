In some cases, it may be useful to get information about Lunar Helper from within asm files.

Information about Lunar Helper is available in the `.lunar_helper/defines.asm` file, which 
can be freely included using `incsrc` from any other resource and is generated before each (Quick) Build.

For details on the available defines, feel free to take a look at the contents of the file.

Note that the defines in the file are automatically included by Lunar Helper when assembling globules and patches,
this can potentially be used to let code authors detect that their code is being assembled by a 
project using Lunar Helper and account for that if they want to.

_See also:_ [Profiles for coders](Multiple-build-profiles#advanced-profiles-for-coders)