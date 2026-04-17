import os
import sys

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
APP_DIR = os.path.join(ROOT_DIR, 'app')

for path in (ROOT_DIR, APP_DIR):
    if path not in sys.path:
        sys.path.insert(0, path)

from vercel_wsgi import handle_request
import importlib.util

app_file = os.path.join(APP_DIR, 'app.py')
spec = importlib.util.spec_from_file_location('zyntra_app', app_file)
app_module = importlib.util.module_from_spec(spec)
sys.modules['zyntra_app'] = app_module
spec.loader.exec_module(app_module)
app = app_module.app


def handler(request, response):
    return handle_request(app, request, response)
