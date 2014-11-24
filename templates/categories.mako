<%inherit file="/base.mako"/>
<%namespace name="util" file="util.mako" />

<%def name="title()">
Blog categories
</%def>


<%def name="extra_head()">
## extra_head should be defined in project's base.mako
<script src="${request.static_url(APP_BASE + ':static/common.js')}" type="text/javascript"></script>
</%def>

<form action="${request.route_url(APP_NAME + '.categories')}" name="category_form" id="category_form" method="POST" role="form">
<p>
<label for="Name">Name</label><br />
<input required="True"
       data-dojo-props=" constraints: {}"
       data-dojo-type="dijit/form/ValidationTextBox"
       id="name"
       name="name"
       type="text"
       onkeyup="document.getElementById('slug').value=slugify(document.getElementById('name').value);"
       value="">
</p>

<p>
<label for="slug">Slug</label><br /> <input required=True data-dojo-props=" constraints: {}" data-dojo-type="dijit/form/ValidationTextBox" id="slug" name="slug" type="text" value=""> </p>

<p>
<label for="description">Description</label><br /> 
<textarea id="description" name="description" data-dojo-type="dijit/form/Textarea" style="width:200px;"></textarea>
</p>

<p>
<label for="parent_category">Parent category</label><br />
<select data-dojo-type="dijit/form/FilteringSelect" id="parent_category" name="parent_category">
  <option selected value=""></option>
  ${util.categories_option_tags(categories)}
  
</select>
</p>

<input type="hidden" name="action" id="action" value="add" />

<br /><br />

<button class="btn btn-success" type="submit">Add category</button>

</form>
