WSL
======

Installing WSL on a non-system driver: https://kontext.tech/article/308/how-to-install-windows-subsystem-for-linux-on-a-non-c-drive

# Trouble shooting

## Can't see contents of files copied from Windows to Linux

Usually this is because of denied permission. 
Run `chmod`  to solve the problem.

## VSCode configuration 

Be mindful of setting override: 
it's possible that a reasonable configuration in 
"setting in WSL" is overridden 
by an unreasonable configuration in "user setting".