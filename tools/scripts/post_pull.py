# -*- coding: utf-8 -*-

import os

print("update svnlibs")
os.chdir("./svnlibs")
print(os.popen("svn up").read())
os.chdir("../")
