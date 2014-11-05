from datetime import datetime
from sqlalchemy import (Column, ForeignKey, Integer, DateTime,
                        Unicode, UnicodeText, Boolean)
from sqlalchemy.orm import backref, relationship

from . import db, Base

from .. import project_package, APP_NAME
User = project_package.models.User


class Category(Base):
    "Blog category"

    __tablename__ = 'categories'

    id = Column(Integer, primary_key=True)
    name = Column(Unicode(150), nullable=False)
    slug = Column(Unicode(150), nullable=False)
    description = Column(Unicode(500), nullable=True)

    parent_category = Column(Integer, ForeignKey(APP_NAME + "_categories.id"),
                             nullable=True)


class Post(Base):
    "Holds blog posts"

    __tablename__ = 'posts'

    id = Column(Integer, primary_key=True)
    title = Column(Unicode(150), nullable=False)
    slug = Column(Unicode(150), nullable=False)
    keywords = Column(Unicode(250), default=None)
    timestamp = Column(DateTime, default=datetime.utcnow)
    body = Column(UnicodeText, nullable=False)

    # FKs
    user_id = Column(Unicode(100), ForeignKey(User.user_id))
    category_id = Column(Integer, ForeignKey(Category.id))

    # Relationships
    category = relationship(Category, backref=backref('blog_posts'))

