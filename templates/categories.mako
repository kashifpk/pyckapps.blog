<%inherit file="/base.mako"/>
<%namespace name="util" file="util.mako" />

<%def name="title()">
Blog categories
</%def>

<%def name="categories_rows(records, name_prefix='')">
    %for category in records:
      <tr>
        <td>${category.id}</td>
        
        %if name_prefix:
          <td>${name_prefix}${category.name}</td>
        %else:
          <td>${category.name}</td>
        %endif
        
        <td>${category.slug}</td>
        <td>${category.description}</td>
        
        <td>
          <a href="${request.route_url(APP_NAME + '.categories')}?action=edit&category_id=${category.id}">Edit</a>
          <a href="${request.route_url(APP_NAME + '.categories')}?action=delete&category_id=${category.id}">Delete</a>
        </td>
      </tr>
      
      %if len(category.sub_categories)>0:
        ${categories_rows(category.sub_categories, name_prefix + category.name + ' -> ')}
      %endif
    %endfor 
</%def>

<%def name="extra_head()">
## extra_head should be defined in project's base.mako
<script src="${request.static_url(APP_BASE + ':static/common.js')}" type="text/javascript"></script>
</%def>

<form action="${request.route_url(APP_NAME + '.categories')}?action=${action}" name="category_form" id="category_form" method="POST" role="form">

%if 'edit' == action:
<input type="hidden" name="id" id="id" value="${category.id}" />
%endif

<p>
<label for="Name">Name</label><br />
<input required="True"
       data-dojo-props=" constraints: {}"
       data-dojo-type="dijit/form/ValidationTextBox"
       id="name"
       name="name"
       type="text"
       %if 'edit' == action:
        value="${category.name}"
       %endif
       onkeyup="document.getElementById('slug').value=slugify(document.getElementById('name').value);" />
</p>

<p>
<label for="slug">Slug</label><br /> <input required=True data-dojo-props=" constraints: {}"
                                            data-dojo-type="dijit/form/ValidationTextBox"
                                            id="slug" name="slug" type="text"
                                            %if 'edit' == action:
                                              value="${category.slug}"
                                            %endif
                                            /> </p>

<p>
<label for="description">Description</label><br /> 
<textarea id="description" name="description" data-dojo-type="dijit/form/Textarea" style="width:200px;">
%if 'edit' == action:
${category.description}\
%endif
</textarea>
</p>

<p>
<label for="parent_category">Parent category</label><br />
<select data-dojo-type="dijit/form/FilteringSelect" id="parent_category" name="parent_category">
  <option value=""></option>
  %if 'edit' == action:
  ${util.categories_option_tags(categories, selected_item=category.parent_category)}
  %else:
  ${util.categories_option_tags(categories)}
  %endif
</select>
</p>

<br />

<button class="btn btn-success" type="submit">${action.title()} category</button>

</form>
<br /><br />

<table class="table table-stripped table-hover table-bordered">
  <tr>
    <th>ID</th>
    <th>Name</th>
    <th>Slug</th>
    <th>Description</th>
    <th></th>
  </tr>
  ${categories_rows(categories)}
</table>