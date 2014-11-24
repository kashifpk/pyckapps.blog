<%def name="categories_option_tags(records, name_prefix='', selected_item=None)">
    <% selected_str = "" %>
    %for category in records:
      %if category.id == selected_item:
        <% selected_str = "selected" %>
      %else:
        <% selected_str = "" %>
      %endif

      %if name_prefix:
        <option value="${category.id}" ${selected_str}>${name_prefix}${category.name}</option>
      %else:
        <option value="${category.id}" ${selected_str}>${category.name}</option>
      %endif
      
      %if len(category.sub_categories)>0:
        ${categories_option_tags(category.sub_categories, name_prefix + category.name + ' -> ', selected_item)}
      %endif
    %endfor 
</%def>