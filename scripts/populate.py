import os
import sys
import transaction

from sqlalchemy import engine_from_config

from pyramid.paster import (
    get_appsettings,
    setup_logging,
    )

from ..models import Base, db, Post

from .. import project_package
Permission = project_package.models.Permission

def populate_app(engine, db_session):
    Base.metadata.create_all(engine)
    rec = db.query(Permission).filter_by(permission='blogger').first()
    if not rec:
        with transaction.manager:
            rec = Permission(permission='blogger',
                            description='Allow posting new blog posts')
            db_session.add(rec)

    #with transaction.manager:
    #    model = Post('Test', 'Just testing')
    #    db_session.add(model)
