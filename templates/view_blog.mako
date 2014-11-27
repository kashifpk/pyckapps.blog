<%inherit file="/base.mako"/>
<%namespace name="util" file="util.mako" />

<%def name="title()">
${blog.title|n}
</%def>

<%def name="extra_head()">
<meta name="keywords" content="${blog.keywords}" />
</%def>

<h1>${blog.title|n}</h1>

<p>
  ${blog.body|n}
</p>