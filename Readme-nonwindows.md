## How to set up when you are not using Windows:

1. **Install Dependencies.** This will differ between operating systems, but you should use your OS's package manager to make sure the following executables available on your system (these may be available by default):
    - 7z (7zip)
    - patch
    - curl

2. **Run the setup script.** Run `./setup.sh`.

3. **You can now use callisto from the terminal.** Run `./run-callisto.sh ACTION` where `ACTION` is one of `rebuild`, `update`, `save`, `edit`, `package`, or `profiles`. See `./run-callisto.sh --help` for more info.
