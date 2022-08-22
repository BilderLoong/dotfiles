# `.zshenv' is sourced on all invocations of the shell, unless the -f option is set. It should contain commands to set the command search path, plus other important environment variables. `.zshenv' should not contain commands that produce output or assume the shell is attached to a tty.
# Source: https://zsh.sourceforge.io/Intro/intro_3.html
skip_global_compinit=1
