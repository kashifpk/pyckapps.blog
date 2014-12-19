<%inherit file="/base.mako"/>
<%namespace name="util" file="util.mako" />

<%!
dojo_url_prefix = "http://ajax.googleapis.com/ajax/libs/dojo/1.10.1"
%>

<%def name="title()">
New Blog Post
</%def>


<%def name="extra_head()">
## extra_head should be defined in project's base.mako

<style>
  textarea {font-family: monospace}
</style>
 
<script src="${request.static_url(APP_BASE + ':static/common.js')}" type="text/javascript"></script>
 
<script type="application/x-javascript">

function submit_form(blog_action) {
  var editor = dijit.byId("_body");
  document.getElementById('body').value = editor.attr("value");
  document.getElementById('blog_action').value=blog_action;
  document.blog_form.submit();
  
}

function preview(){
  
}

</script>
</%def>

<form action="${request.route_url(APP_NAME + '.add_blog_rst')}" enctype="multipart/form-data"
      name="blog_form" id="blog_form" method="POST" role="form">
<div class="row">
  <div class="col-xs-12 col-sm-12 col-md-8 col-lg-8">
    
    <p>
    <label for="title">Title</label><br />
    <input required="True"
           data-dojo-props=" constraints: {}"
           data-dojo-type="dijit/form/ValidationTextBox"
           id="title"
           name="title"
           type="text"
           onkeyup="document.getElementById('slug').value=slugify(document.getElementById('title').value);"
           value=""> </p>
    
    <p>
    <label for="category_id">Category</label><br />
    <select data-dojo-type="dijit/form/FilteringSelect" id="category_id" name="category_id" required="True">
      <option value=""></option>
      ${util.categories_option_tags(categories)}
      
    </select>
    </p>
    
    <p>
    <label for="slug">Slug</label><br /> <input required=True data-dojo-props=" constraints: {}" data-dojo-type="dijit/form/ValidationTextBox" id="slug" name="slug" type="text" value=""> </p>
    
    <p>
    <label for="keywords">Keywords</label><br /> <input  data-dojo-props=" constraints: {}" data-dojo-type="dijit/form/ValidationTextBox" id="keywords" name="keywords" type="text" value=""> </p>
    
    <p>
    <label for="comments_allowed">Comments Allowed</label><br /> <input checked data-dojo-type="dijit/form/CheckBox" id="comments_allowed" name="comments_allowed" type="checkbox" value="y"> </p>
    
    <label for="_body">Content</label><br />
    
    <div data-dojo-type="dijit/form/Textarea" style="width:90%;min-height:100px;" id="body" name="body"></div>
    
    <input type="hidden" name="blog_action" id="blog_action" value="" />
    
    
    
    
  </div>
  <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4">
    <input type="file" multiple="true" data-dojo-type="dojox/form/Uploader"
    data-dojo-props="
        label: 'Select Some Files',
        url: '/${APP_NAME}/upload_image',
        uploadOnSelect: true">
  </div>
</div>
<br /><br />
<div class="row">
  <button class="btn btn-success" onclick="submit_form('save');">Save</button>
  <button class="btn btn-primary" onclick="submit_form('publish');">Publish</button>
  <button class="btn btn-info pull-right" onclick="preview();">Preview</button>
</div>

</form>