# -*- coding: utf-8 -*-

import sys
import os

if __name__ == "__main__":
    os.chdir(os.path.dirname(sys.argv[0]))
    # print(os.getcwd())
    print("update svnlibs")
    os.chdir("../../svnlibs")
    print(os.popen("svn up").read())
    # os.chdir("../")
