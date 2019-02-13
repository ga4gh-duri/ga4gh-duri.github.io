---
layout: default
---

{%- assign this_name = page.name | split: "." -%}
{%- assign this_category = this_name[0] -%}

<h2 class="page_title">{{ this_category | capitalize }}</h2>

{%- comment -%}
  * collecting the pages
{%- endcomment -%}

{%- assign cat_posts = site.emptyArray -%}
{%- for post in site.documents -%}
  {%- if post.categories contains this_category -%}
    {%- assign cat_posts = cat_posts | push: post -%}
  {%- endif -%}
{%- endfor -%}

{%- assign cat_posts = cat_posts | sort: 'date' | reverse -%}

{%- comment -%}
  * special posts for prepending content to the listing pages
  * they are processed first, so separate loops are needed  
{%- endcomment -%}

{%- for post in cat_posts -%}
  {%- if post.tags contains '.prepend' -%}
<div style="margin-bottom: 20px;">
{{ post.content | markdownify }}
</div>
  {%- endif -%}
{%- endfor -%}

{%- comment -%}
  * featured posts on top, so new loop
{%- endcomment -%}

{%- for post in cat_posts -%}
  {%- if post.tags contains '.featured' -%}
<div class="excerpt">
    {{ post.excerpt }}
  <p class="footnote">
    {% if post.author %}{{ post.author | remove: "@" }}, {% endif %}
    {% if post.date %}{{ post.date | date: "%Y-%m-%d" }}: {% endif %}
    <a href="{{ post.url | relative_url }}">more ...</a>
  </p>
</div>
  {%- endif -%}
{%- endfor -%}

{%- comment -%}
  * remaining normal posts, again new loop
{%- endcomment -%}

{%- for post in cat_posts -%}
  {%- unless post.tags contains '.featured' or post.tags contains '.prepend' or post.tags contains '.append' -%} 
<div class="excerpt">
    {{ post.excerpt }}
  <p class="footnote">
    {% if post.author %}{{ post.author | remove: "@" }}, {% endif %}
    {% if post.date %}{{ post.date | date: "%Y-%m-%d" }}: {% endif %}
    <a href="{{ post.url | relative_url }}">more ...</a>
  </p>
</div>
  {%- endunless -%}
{%- endfor -%}

{%- comment -%}
  * special posts for appending content to the listing pages
  * they are processed last, so again a separate loop is needed  
{%- endcomment -%}

{%- for post in cat_posts -%}
  {%- if post.tags contains '.append' -%}
<div style="margin-top: 20px;">
{{ post.content | markdownify }}
</div>
  {%- endif -%}
{%- endfor -%}

