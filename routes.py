from . import APP_NAME, PROJECT_NAME, APP_BASE


def application_routes(config):

    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route(APP_NAME + '.home', '/')
    config.add_route(APP_NAME + '.add_blog', '/new')
    config.add_route(APP_NAME + '.categories', '/categories')
    config.add_route(APP_NAME + '.view_blog', '/*slugs')
