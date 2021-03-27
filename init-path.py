import os
BIN_PATH = '/usr/local/bin:/usr/bin:/bin:/opt/bin:'
print(BIN_PATH+os.environ.get('PATH').replace(BIN_PATH,''))
