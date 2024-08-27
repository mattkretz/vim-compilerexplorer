# compilerexplorer.vim

This is a proof-of-concept vim plugin for local Compiler Explorer 
functionality, similar to https://compiler-explorer.com/. Press `<F6>` to open 
a new tab which opens the files `ce.cpp` and `ce.asm` in the CWD. On top, the 
invocations of the C++ compiler and llvm-mca can be configured.

After editing `ce.cpp`, press `<F6>` again to update `ce.asm`. If any 
diagnostic output was produced, a QuickFix window opens at the bottom and a new 
window on the left jumps to the first error. Now, if you want to analyze the 
assembly using llvm-mca, make visual selection in the `ce.asm` buffer and press 
`<F6>` again. This will open another vertical split showing the output of 
llvm-mca for the selected instruction sequence.

At this point, this plugin is a quick solution for supporting my work: Inspect 
the codegen of certain C++ library calls, while developing the library.
If you find this plugin useful but need more features, please contribute your 
ideas or even better PRs.

## Installation

    mkdir -p ~/.vim/pack/mattkretz/start
    cd ~/.vim/pack/mattkretz/start
    git clone https://github.com/mattkretz/vim-compilerexplorer

## License

Copyright © Matthias Kretz.  Distributed under the same terms as Vim itself.
See `:help license`.
