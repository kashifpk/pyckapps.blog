pyckapps.blog
=============

Pluggable blog app for PyCK framework. This app goes under the apps folder in a pyck project and cannot be used standalone(without modification). If you're using git to manage your project you can put this app's repo as a subtree without your project.

For example you can add this as a subtree to your PyCK project like:

    git remote add blogapp git@github.com:kashifpk/pyckapps.blog.git
    git subtree add --prefix myproject/apps/blog blogapp master
