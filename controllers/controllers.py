from pyramid.view import view_config

from ..models import (
    db,
    Category, Post, Comment
    )

from .. import APP_NAME, PROJECT_NAME, APP_BASE


@view_config(route_name=APP_NAME+'.home', renderer='%s:templates/list.mako' % APP_BASE)
def my_view(request):
    return {'APP_BASE': APP_BASE}


@view_config(route_name=APP_NAME+'.add_blog', renderer='%s:templates/add_blog.mako' % APP_BASE)
def add_blog(request):

    categories = Category.get_tree()
    print(categories)
    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'categories': categories}