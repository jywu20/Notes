Using VSCode and NVim together 
======

1. Install NVim; just download a .zip file from the release page 
   and extract it into a folder 
2. Install the NVim plugin in VSCode
3. Add the path to the NVim executable to the `vscode-neovim.neovimExecutablePaths.win32` option.
4. Goto `C:\Users\<username>\AppData\Local\nvim` and create `init.vim`; 
   it's a good idea to add 
   ```
   " Make the cursor move to the next line/the previous line 
    " when it arrives at the end/the initial of this line
    set whichwrap+=<,>,h,l,[,]
    ```
    to the file. 
5. Delete the C-c keybinding created by NVim to *enable* copying by C-c