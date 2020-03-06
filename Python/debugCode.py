# import sys
# import os
#
# localappdata_path=os.environ.get('LOCALAPPDATA')
# pydev_path = os.path.join(localappdata_path,"JetBrains\PyCharm 2019.3.3\plugins\python\helpers\pydev")
# if not pydev_path in sys.path:
#     sys.path.append(pydev_path)
#
# import pydevd_pycharm
# pydevd_pycharm.settrace('localhost', port=7720, suspend=False)