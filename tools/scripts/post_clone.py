# -*- coding: utf-8 -*-

import sys 
import os 

if __name__ == '__main__':
    os.chdir(os.path.dirname(sys.argv[0]))
    if len(sys.argv) < 2:
        print("Usage: python post_clone.py [GAMEDATA_URL]")
        exit(1)
    gamedata_url = sys.argv[1]
    os.chdir("../..")
    # print(os.getcwd())
    cmd = "svn co " + gamedata_url
    # print(cmd)
    print(os.popen(cmd).read())
