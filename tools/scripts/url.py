import sys 
import json


if __name__ == '__main__':
    url = 'http://msgame.woa.com/v2/api/getbranchinfo/?branchName=master'
    if sys.version_info < (3, 0):
        import urllib
        rsp = urllib.urlopen(url)
        text = rsp.read()
    else:
        import urllib.request
        rsp = urllib.request.urlopen(url=url)
        text = rsp.read().decode('utf-8')
    json_obj = json.loads(text)
    if json_obj['code'] == '0':
        svnUrl = json_obj['data'][0]['svnUrl']
    else:
        print('[Error]')
        exit(1)
    print(svnUrl)