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


<style type="text/css">
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Save.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Preview.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/ShowBlockNodes.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/InsertEntity.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/PageBreak.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Breadcrumb.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/FindReplace.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/InsertAnchor.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Breadcrumb.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/TextColor.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/CollapsibleToolbar.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Blockquote.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/InsertAnchor.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/PasteFromWord.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/editorPlugins.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Smiley.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/StatusBar.css";
  @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/SafePaste.css";
</style>
 
<script src="${request.static_url(APP_BASE + ':static/common.js')}" type="text/javascript"></script>
 
<script >
    
    // Load the editor and all its plugins.
    require([
    "dijit/Editor",

    // Commom plugins
    "dijit/_editor/plugins/FullScreen",
    "dijit/_editor/plugins/LinkDialog",
    "dijit/_editor/plugins/Print",
    "dijit/_editor/plugins/ViewSource",
    "dijit/_editor/plugins/FontChoice",
    //"dijit/_editor/plugins/TextColor",
    "dijit/_editor/plugins/NewPage",
    "dijit/_editor/plugins/ToggleDir",

    //Extension (Less common) plugins
    "dojox/editor/plugins/ShowBlockNodes",
    "dojox/editor/plugins/ToolbarLineBreak",
    "dojox/editor/plugins/Save",
    "dojox/editor/plugins/InsertEntity",
    "dojox/editor/plugins/Preview",
    "dojox/editor/plugins/PageBreak",
    "dojox/editor/plugins/PrettyPrint",
    "dojox/editor/plugins/InsertAnchor",
    "dojox/editor/plugins/CollapsibleToolbar",
    "dojox/editor/plugins/Blockquote",
    "dojox/editor/plugins/InsertAnchor",

    // Experimental Plugins
    "dojox/editor/plugins/NormalizeIndentOutdent",
    "dojox/editor/plugins/FindReplace",
    "dojox/editor/plugins/TablePlugins",
    "dojox/editor/plugins/TextColor",
    "dojox/editor/plugins/Breadcrumb",
    "dojox/editor/plugins/PasteFromWord",
    "dojox/editor/plugins/Smiley",
    "dojox/editor/plugins/NormalizeStyle",
    "dojox/editor/plugins/StatusBar",
    "dojox/editor/plugins/SafePaste",
    ]);

function submit_form(blog_action) {
  var editor = dijit.byId("_body");
  document.getElementById('body').value = editor.attr("value");
  document.getElementById('blog_action').value=blog_action;
  document.blog_form.submit();
  
}

</script>
</%def>

<form action="${request.route_url(APP_NAME + '.add_blog')}" name="blog_form" id="blog_form" method="POST" role="form">
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
<select data-dojo-type="dijit/form/FilteringSelect" id="category_id" name="category_id">
  <option selected value=""></option>
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

<div data-dojo-type="dijit.Editor" style="width:90%;min-height:100px;" id="_body" name="_body"
     data-dojo-props="extraPlugins:['collapsibletoolbar', 'breadcrumb', 'newpage',
					{name: 'viewSource', stripScripts: true, stripComments: true}, 
					'showBlockNodes', '||',
					{name: 'fullscreen', zIndex: 900}, 'preview', 'print', '|',
					'findreplace', 'selectAll',  'pastefromword', 'delete', '|',
					'pageBreak', 'insertHorizontalRule', 'blockquote', '|',
					'toggleDir', '|',
					'superscript', 'subscript', 'foreColor', 'hiliteColor', 'removeFormat', '||',
					'fontName', {name: 'fontSize', plainText: true}, {name: 'formatBlock', plainText: true}, '||',
					'insertEntity', 'smiley', 'createLink', 'insertanchor', 'unlink', 'insertImage', '|', 
					{name: 'dojox.editor.plugins.TablePlugins', command: 'insertTable'},
					{name: 'dojox.editor.plugins.TablePlugins', command: 'modifyTable'},
					{name: 'dojox.editor.plugins.TablePlugins', command: 'InsertTableRowBefore'},
					{name: 'dojox.editor.plugins.TablePlugins', command: 'InsertTableRowAfter'},
					{name: 'dojox.editor.plugins.TablePlugins', command: 'insertTableColumnBefore'},
					{name: 'dojox.editor.plugins.TablePlugins', command: 'insertTableColumnAfter'},
					{name: 'dojox.editor.plugins.TablePlugins', command: 'deleteTableRow'},
					{name: 'dojox.editor.plugins.TablePlugins', command: 'deleteTableColumn'},
					{name: 'dojox.editor.plugins.TablePlugins', command: 'colorTableCell'},
					{name: 'dojox.editor.plugins.TablePlugins', command: 'tableContextMenu'}, 
					{name: 'prettyprint', indentBy: 4, lineLength: 80, entityMap: dojox.html.entities.html.concat(dojox.html.entities.latin)},
					{name: 'dijit._editor.plugins.EnterKeyHandling', blockNodeForEnter: 'P'},
					'normalizeindentoutdent', 'normalizestyle', {name: 'statusbar', resizer: false}, 'safepaste']">
</div>

<input type="hidden" name="body" id="body" value="" />
<input type="hidden" name="blog_action" id="blog_action" value="" />

<br /><br />

<button class="btn btn-success" onclick="submit_form('save');">Save</button>
<button class="btn btn-primary" onclick="submit_form('publish');">Publish</button>

</form>
