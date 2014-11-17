from datetime import datetime
from collections import OrderedDict

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

    @classmethod
    def get_tree(cls, parent_category=None):
        """
        Get categories tree (List) with sub categories tucked
        under the parent categories
        """

        categories = []
        # Get top level categories
        top_cats = db.query(cls).filter_by(
            parent_category=parent_category).order_by(cls.name).all()

        for cat in top_cats:
            cat.sub_categories = cls.get_tree(parent_category=cat.id)
            categories.append(cat)

        return categories


class Post(Base):
    "Holds blog posts"

    __tablename__ = 'posts'

    id = Column(Integer, primary_key=True)
    title = Column(Unicode(150), nullable=False)
    slug = Column(Unicode(150), nullable=False)
    keywords = Column(Unicode(250), default=None)
    timestamp = Column(DateTime, default=datetime.utcnow)
    body = Column(UnicodeText, nullable=False)
    view_count = Column(Integer, default=0)
    comments_allowed = Column(Boolean, default=True)
    published = Column(Boolean, default=False)

    # FKs
    user_id = Column(Unicode(100), ForeignKey(User.user_id))
    category_id = Column(Integer, ForeignKey(Category.id))

    # Relationships
    category = relationship(Category, backref=backref('blog_posts'))


class Comment(Base):
    "Holds comments for a blog post"

    __tablename__ = 'comments'

    id = Column(Integer, primary_key=True)
    timestamp = Column(DateTime, default=datetime.utcnow)
    body = Column(UnicodeText, nullable=False)
    commentor = Column(Unicode(250))

    # FKs
    post_id = Column(Integer, ForeignKey(Post.id))

    # Relationships
    post = relationship(Post, backref=backref('comments'))
