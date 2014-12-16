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

    @property
    def parent(self):
        "Returns the parent category object if one exists"

        if not self.parent_category:
            return None

        return db.query(Category).filter_by(id=self.parent_category).first()

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

    @classmethod
    def by_slug(cls, slug, parent_category=None):
        """
        Get categories tree (List) with sub categories tucked
        under the parent categories
        """

        # This assumes that categories at the same level
        # (same parent or no parent) don't have the same slugs
        cat_id = None
        if parent_category:
            cat_id = parent_category.id

        category = db.query(cls).filter_by(parent_category=cat_id,
                                           slug=slug).first()

        return category


class Post(Base):
    "Holds blog posts"

    __tablename__ = 'posts'

    id = Column(Integer, primary_key=True)
    title = Column(Unicode(150), nullable=False)
    slug = Column(Unicode(150), nullable=False)
    keywords = Column(Unicode(250), default=None)
    body = Column(UnicodeText, nullable=False)
    rst_source = Column(UnicodeText)
    created = Column(DateTime, default=datetime.utcnow)
    updated = Column(DateTime, default=None)
    view_count = Column(Integer, default=0)
    comments_allowed = Column(Boolean, default=True)
    published = Column(Boolean, default=False)

    # FKs
    user_id = Column(Unicode(100), ForeignKey(User.user_id))
    category_id = Column(Integer, ForeignKey(Category.id))

    # Relationships
    category = relationship(Category, backref=backref('blog_posts'))

    @classmethod
    def by_slug(cls, slug, category_id):
        """
        Get categories tree (List) with sub categories tucked
        under the parent categories
        """

        # This assumes that categories at the same level
        # (same parent or no parent) don't have the same slugs
        post = db.query(cls).filter_by(category_id=category_id,
                                       slug=slug).first()

        return post

    @classmethod
    def match_by_slugs(cls, slugs):
        """
        Finds a blog that matches the given blog post and parent categor(y/ies) slugs


        Example url: /development/programming/python/hello-python
        Slugs would have ['development', 'programming', 'python', 'hello-python']
        first three are category slugs (parent to child), last is blog's slug
        """

        current_parent = None
        slugs.reverse()
        print(slugs)
        while slugs:
            slug = slugs.pop()
            print(slug)
            if slugs:  # there are still more slugs so this slug is category
                print("fetching category")
                category = Category.by_slug(slug, current_parent)

                if not category:
                    return None

                current_parent = category

            else:  # this is the last slug so it's the blog post
                print("fetching post")
                return cls.by_slug(slug, current_parent.id)


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
