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