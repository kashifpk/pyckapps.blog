from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

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

    if 'POST' == request.method:
        #print(request.POST['blog_action'])
        post = Post(title=request.POST['title'],
                    slug=request.POST['slug'],
                    keywords=request.POST['keywords'],
                    body=request.POST['body'])

        if 'y' != request.POST.get('comments_allowed', 'n'):
            post.comments_allowed = False

        if '' != request.POST.get('category_id', ''):
            post.category_id = int(request.POST['category_id'])


        if 'publish' == request.POST['blog_action']:
            post.published = True

        # TODO, add user ID

        db.add(post)

        request.session.flash("Post added!")
        return HTTPFound(location=request.route_url('admin.PostCRUD_list'))

    categories = Category.get_tree()
    print(categories)
    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'categories': categories}