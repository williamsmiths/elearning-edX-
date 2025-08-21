"""
Development settings for Open edX LMS based on test.py structure
"""

import logging
from collections import OrderedDict
from uuid import uuid4

import openid.oidutil
from django.utils.translation import gettext_lazy
from edx_django_utils.plugins import add_plugins
from path import Path as path

from openedx.core.djangoapps.plugins.constants import ProjectType, SettingsType
from openedx.core.lib.derived import derive_settings
from openedx.core.lib.tempdir import mkdtemp_clean
from xmodule.modulestore.modulestore_settings import update_module_store_settings

from .common import *

# Debug
DEBUG = True
TEMPLATE_DEBUG = True

# Allow all hosts during development
ALLOWED_HOSTS = ['*']

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'edxapp',
        'USER': 'edxapp001',
        'PASSWORD': 'password',
        'HOST': 'localhost',
        'PORT': '3306',
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
        },
    },
    'student_module_history': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'edxapp_csmh',
        'USER': 'edxapp001',
        'PASSWORD': 'password',
        'HOST': 'localhost',
        'PORT': '3306',
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
        },
    }
}

# Caching
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.PyLibMCCache',
        'LOCATION': '127.0.0.1:11211',
    }
}

# Basic site configuration
SITE_NAME = 'localhost:18000'
LMS_BASE = 'localhost:18000'
CMS_BASE = 'localhost:18010'
LMS_ROOT_URL = 'http://localhost:18000'

# Email (for development)
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# Logging
LOGGING_ENV = 'dev'

# Basic security - use a consistent secret key for development
SECRET_KEY = 'dev-secret-key-change-in-production-' + str(uuid4())

# MongoDB for content store
DOC_STORE_CONFIG = {
    'host': 'localhost',
    'port': 27017,
    'db': 'edxapp',
    'user': 'edxapp',
    'password': 'password',
    'authSource': 'admin',
}

MODULESTORE = {
    'default': {
        'ENGINE': 'xmodule.modulestore.mongo.MongoModuleStore',
        'DOC_STORE_CONFIG': DOC_STORE_CONFIG,
        'OPTIONS': {
            'default_class': 'xmodule.hidden_block.HiddenBlock',
            'fs_root': '/tmp/edx-modulestore',
            'render_template': 'edxmako.shortcuts.render_to_string',
        }
    }
}

CONTENTSTORE = {
    'ENGINE': 'xmodule.contentstore.mongo.MongoContentStore',
    'DOC_STORE_CONFIG': DOC_STORE_CONFIG,
}

# Create necessary directories
import os
os.makedirs('/tmp/edx-modulestore', exist_ok=True)
