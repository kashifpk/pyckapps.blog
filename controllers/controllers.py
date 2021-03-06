from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound, HTTPNotFound, HTTPNotAcceptable
from sqlalchemy.exc import IntegrityError

from ..models import (
    db,
    Category, Post, Comment
    )

from .. import APP_NAME, PROJECT_NAME, APP_BASE
from docutils.core import publish_parts
from os import path
from ...visit_counter.lib import count_visit


@view_config(route_name=APP_NAME+'.home',
             renderer='%s:templates/list.mako' % APP_BASE)
def my_view(request):
    return {'APP_BASE': APP_BASE}


@view_config(route_name=APP_NAME+'.categories',
             renderer='%s:templates/categories.mako' % APP_BASE)
def categories_view(request):
    "Categories custom CRUD interface"

    def _get_category(msg=''):
        category_id = request.GET.get('category_id', None)
        if not category_id:
            category_id = request.POST.get('id', None)

        if not category_id:
            raise HTTPNotFound(msg)

        category = db.query(Category).filter_by(id=int(category_id)).first()

        if not category:
            raise HTTPNotFound(msg)

        return category

    action = request.GET.get('action', 'add')
    category = None

    if 'add' == action and 'POST' == request.method:
        category = Category(name=request.POST['name'],
                            slug=request.POST['slug'],
                            description=request.POST['description'])

        if '' != request.POST.get('parent_category', ''):
            category.parent_category = int(request.POST['parent_category'])

        db.add(category)
        request.session.flash("category {name} added!".format(
            name=category.name))

    elif 'edit' == action and 'GET' == request.method:
        try:
            category = _get_category("Cannot edit, category not found.")
        except HTTPNotFound as exp:
            return exp

    elif 'edit' == action and 'POST' == request.method:

        action = 'add'
        try:
            category = _get_category("Cannot update, category not found.")

            category.name = request.POST['name']
            category.slug = request.POST['slug']
            category.description = request.POST['description']

            if '' != request.POST.get('parent_category', ''):
                category.parent_category = int(request.POST['parent_category'])

            request.session.flash("category {name} updated!".format(
                name=category.name))

        except HTTPNotFound as exp:
            return exp

    elif 'delete' == action:
        try:
            category = _get_category("Cannot delete, category not found.")

            db.delete(category)
            db.flush()

            request.session.flash("category {name} deleted!".format(
                name=category.name))

        except HTTPNotFound as exp:
            return exp
        except IntegrityError:
            return HTTPNotAcceptable(
                detail="Cannot delete category as it has dependent records\n")

    categories = Category.get_tree()
    print(categories)

    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'categories': categories, 'action': action, 'category': category}


def _save_post(request, rst):
    "Code for saving a blog post, used by save_blog and add_blog"

    if rst:
        post = Post(title=request.POST['title'],
                    slug=request.POST['slug'],
                    keywords=request.POST['keywords'],
                    rst_source=request.POST['body'],
                    body=publish_parts(request.POST['body'],
                                       writer_name='html')['html_body'])
    else:
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


@view_config(route_name=APP_NAME+'.save_blog', renderer="json")
def save_blog(request):
    "Allows saving the blog post via AJAX"

    if 'POST' == request.method:
        _save_post(request, rst=True)

    return {"status": 200, "msg": "OK"}

@view_config(route_name=APP_NAME+'.add_blog',
             renderer='%s:templates/add_blog.mako' % APP_BASE)
def add_blog(request):

    if 'POST' == request.method:
        _save_post(request, rst=False)

        request.session.flash("Post added!")
        return HTTPFound(location=request.route_url('admin.PostCRUD_list'))

    categories = Category.get_tree()

    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'categories': categories}


@view_config(route_name=APP_NAME+'.add_blog_rst',
             renderer='%s:templates/add_blog_rst.mako' % APP_BASE)
def add_blog_rst(request):

    if 'POST' == request.method:
        _save_post(request, rst=True)

        request.session.flash("Post added!")
        return HTTPFound(location=request.route_url('admin.PostCRUD_list'))

    categories = Category.get_tree()

    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'categories': categories}


@view_config(route_name=APP_NAME+'.upload_image', renderer="json")
def upload_image(request):
    "Allows saving the blog post via AJAX"

    ret = []
    if 'POST' == request.method:
        print(request.POST)
        for fieldname, field in request.POST.items():
            if 'uploadedfiles[]' == fieldname:
                print(field)
                print(dir(field))
                print(field.filename)
                print(field.length)
                print(field.type)
                here = path.dirname(path.abspath(__file__))
                filename = path.join(here, '../static/blog_images/', field.filename)
                print(filename)
                file_data = field.file.read()
                open(filename, 'wb').write(file_data)
                file_dict = {'file': request.static_url(APP_BASE + ':static/blog_images/' + field.filename),
                             'name': field.filename,
                             'width': 250, 'height': 250,
                             'type': field.type, 'size': 1000,
                             'uploadType': request.POST['uploadType']}
                ret.append(file_dict)

    #$htmldata['file'] = $download_path . $name;
    #$htmldata['name'] = $name;
    #$htmldata['width'] = $width;
    #$htmldata['height'] = $height;
    #$htmldata['type'] = $type;
    #$htmldata['uploadType'] = $uploadType;
    #$htmldata['size'] = filesize($file);
    #$htmldata['additionalParams'] = $postdata;
    #$data = $json->encode($htmldata);
    #trace($data);
    #print $data;
    #return $data;
    return ret


@view_config(route_name=APP_NAME+'.view_blog',
             renderer='%s:templates/view_blog.mako' % APP_BASE)
def view_blog(request):
    "Match the slugs in the url and display appropriate blog entry if found"

    # TODO: category display when only category slug is given
    slugs = list(request.matchdict.get('slugs', []))
    #print(slugs)
    blog_post = Post.match_by_slugs(slugs)

    if not blog_post:
        return HTTPNotFound("Sorry this blog does not exist")

    count_visit(request)

    extra_css = None
    if blog_post.rst_source:   # this is a reStructuredText post
        extra_css = publish_parts(blog_post.rst_source, writer_name='html')['stylesheet']

    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME, 'blog': blog_post,
            'extra_css': extra_css}
