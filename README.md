# My Vim Config 
This is my current Vim setup that I use with GVim, on a Linux box. You should be able to use this in Windows and with MacVim as well - making sure to update your vimrc file accordingly.

## Credits
This is based of the scrooloose repo, minus some menu settings and so on.

## Installation
The simplest thing you can do is to clone this repo and put it to your drive somewhere ('~/VimSettings/' for instance), then you need to setup some aliases to point to the vimrc and gvimrc files and to the .vim folder.

By default, Vim will look for these files in your root, so you'll need to alias them like this:

     $ ln -s ~/VimSettings/vimrc .vimrc 
     $ ln -s ~/VimSettings/gvimrc .gvimrc 
     $ ln -s ~/VimSettings/vimfiles .vim 

Once that's done, run this command inside it to download the plugins using Vundle (plugin manager):

     :BundleInstall

## Installation: Windows
If you've installed GVim you have a directory in Program Files (if you're on 64 bit, this is Program Files (x86)) called "Vim". Inside there is where you'll want to put all these files.

 # Clone this repository somewhere on your hard drive. 
 # Make a back of your Vim directory. 
 # Drop "vimrc" from the download into the Vim directory, replacing what's there
 # Double-click the Inconsolata font to install it (if you want it, that is)
 # Open up vimfiles directory and remove everything
 # copy/paste the directories inside the downloaded vim-settings directory
 # If you have a color scheme you liked using - copy that back from your old vimfiles directory (which hopefully you saved)

### If you get an error about Ctags...
This happens a lot and it's not a biggie. Just go here:
http://sourceforge.net/projects/ctags/files/ctags/5.8/ctags58.zip/download

And get the ctags download. This is a tool that parses your code and allows to do some tagging "stuff". It's core to Vim and a lot of plugins. In the Windows download you'll see all the source files. You only need one: ctags.exe. Take that and drop it in your C:\Windows directory (or somewhere in your PATH) and restart Vim - all fixed.

The plugins I use are managed through "Pathogen" - a plugin bundler that makes thing pretty simple. If you ever want to install a new plugin in the future, just drop it into the "bundle" directory and you're good to go.


## Colors
I'm using Wombat, which is a easy on the eyes dark scheme, but there's a ton of others schemes included, pick your preferred.

I've also included Inconsolata - my favorite programming font. If you're on Windows you can use Consolas - the setting for the font is in gvimrc (size, etc)
