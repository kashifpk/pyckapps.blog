<%inherit file="/base.mako"/>

<%def name="categories_option_tags(records, name_prefix='')">
    %for category in records:
      %if name_prefix:
        <option value="${category.id}">${name_prefix}${category.name}</option>
      %else:
        <option value="${category.id}">${category.name}</option>
      %endif
      
      %if len(category.sub_categories)>0:
        ${categories_option_tags(category.sub_categories, name_prefix + category.name + ' -> ')}
      %endif
    %endfor 
</%def>

<%def name="title()">
New Blog Post
</%def>

<!--<div>
  <div class="middle align-center">
    <p class="app-welcome">
    <img src="${request.static_url(APP_BASE + ':static/webapp.png')}" />  Welcome to blog app
    </p>
  </div>
</div>-->

<%def name="extra_head()">
## extra_head should be defined in project's base.mako


<link rel="stylesheet" href="/js/dojox/editor/plugins/resources/css/PageBreak.css" />
<link rel="stylesheet" href="/js/dojox/editor/plugins/resources/css/ShowBlockNodes.css" />
<link rel="stylesheet" href="/js/dojox/editor/plugins/resources/css/Preview.css" />
<link rel="stylesheet" href="/js/dojox/editor/plugins/resources/css/Save.css" />
<link rel="stylesheet" href="/js/dojox/editor/plugins/resources/css/Breadcrumb.css" />
<link rel="stylesheet" href="/js/dojox/editor/plugins/resources/css/FindReplace.css" />
<link rel="stylesheet" href="/js/dojox/editor/plugins/resources/css/PasteFromWord.css" />
<link rel="stylesheet" href="/js/dojox/editor/plugins/resources/css/InsertAnchor.css" />
<link rel="stylesheet" href="/js/dojox/editor/plugins/resources/css/CollapsibleToolbar.css" />
<link rel="stylesheet" href="/js/dojox/editor/plugins/resources/css/Blockquote.css" />
<link rel="stylesheet" href="/js/dojox/editor/plugins/resources/css/Smiley.css" />
 
<script>
    // Include the class
    require([
        "dijit/Editor",
        "dojo/parser",
        "dijit/_editor/plugins/ViewSource",
        "dojox/editor/plugins/PrettyPrint",
        "dojox/editor/plugins/PageBreak",
        "dojox/editor/plugins/ShowBlockNodes",
        "dojox/editor/plugins/Preview",
        "dojox/editor/plugins/Save",
        "dojox/editor/plugins/ToolbarLineBreak",
        "dojox/editor/plugins/NormalizeIndentOutdent",
        "dojox/editor/plugins/Breadcrumb",
        "dojox/editor/plugins/FindReplace",
        "dojox/editor/plugins/PasteFromWord",
        "dojox/editor/plugins/InsertAnchor",
        "dojox/editor/plugins/CollapsibleToolbar",
        "dojox/editor/plugins/TextColor",
        "dojox/editor/plugins/Blockquote",
        "dojox/editor/plugins/Smiley",
        "dojox/editor/plugins/UploadImage"
    ]);
</script>
</%def>

<form action="${request.route_url(APP_NAME + '.add_blog')}" method="POST" role="form">
<p>
<label for="title">Title</label><br /> <input required=True data-dojo-props=" constraints: {}" data-dojo-type="dijit/form/ValidationTextBox" id="title" name="title" type="text" value=""> </p>

<p>
<label for="category_id">Category</label><br />
<select data-dojo-type="dijit/form/FilteringSelect" id="category_id" name="category_id">
  <option selected value=""></option>
  ${categories_option_tags(categories)}
  
</select>
</p>

<p>
<label for="slug">Slug</label><br /> <input required=True data-dojo-props=" constraints: {}" data-dojo-type="dijit/form/ValidationTextBox" id="slug" name="slug" type="text" value=""> </p>

<p>
<label for="keywords">Keywords</label><br /> <input  data-dojo-props=" constraints: {}" data-dojo-type="dijit/form/ValidationTextBox" id="keywords" name="keywords" type="text" value=""> </p>

<p>
<label for="comments_allowed">Comments Allowed</label><br /> <input checked data-dojo-type="dijit/form/CheckBox" id="comments_allowed" name="comments_allowed" type="checkbox" value="y"> </p>

<label for="body">Content</label><br />
<div data-dojo-type="dijit.Editor" style="width:800px;min-height:100px;" id="body" name="body"
     data-dojo-props="extraPlugins:['prettyprint','pagebreak','showblocknodes','preview','viewsource','save','toolbarlinebreak','normalizeindentoutdent','breadcrumb','findreplace','pastefromword','insertanchor','collapsibletoolbar','foreColor', 'hiliteColor','blockquote','smiley','uploadImage']">
    This is the <strong>default</strong> content.
</div>


<br />
<input class="btn btn-success" type="submit" name="form.submitted" value="Add Blog Posts" />
</form>
