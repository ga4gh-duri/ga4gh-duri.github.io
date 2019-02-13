---
layout: default
---

{%- assign this_name = page.name | split: "." -%}
{%- assign this_category = this_name[0] -%}

<h2 class="page_title">{{ this_category | capitalize }}</h2>

### Background reading

[The mandate of  of the Data Access Product line & 2018 roadmap](https://docs.google.com/document/d/1D7-CJc5GI-m2LUnnBqHgcTBUH04yQcKB64UgN5rprEc/edit#heading=h.4k2yyo8a2zek)

[What is the Data Use Ontology](https://github.com/EBISPOT/DUO)? (read the Readme on the Github page, scroll down)

[The Library Card concept ](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5851345/) (the Library Card paper)

[Registered Access data access policy model](https://www.nature.com/articles/s41431-018-0219-y) (the Registered Access paper)

[DURI definitions](https://docs.google.com/spreadsheets/d/1jlXvkjYrg8KbHBfr6AsfzYwaSAnk5PkDDmsBqfWCGdk/edit#gid=0) 


#### Reference papers

This set of papers describe the foundational standard work and the motivation for the standards DURI is creating.

Consent codes - Dyke et al.  [https://doi.org/10.1371/journal.pgen.1005772](https://doi.org/10.1371/journal.pgen.1005772)

ADA-M - Woolley & Brooks et al. [https://www.nature.com/articles/s41525-018-0057-4](https://www.nature.com/articles/s41525-018-0057-4)

Library Card- Cabili & Pandya et al. [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5851345/](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5851345/) 

Registered access model- Dyke et al.  [https://www.nature.com/articles/s41431-018-0219-y](https://www.nature.com/articles/s41431-018-0219-y)

Federated identity management for research collaborations [https://zenodo.org/record/1307551](https://zenodo.org/record/1307551#.W-xc-OgzYuU) 

ELIXIR Authentication and Authorisation [https://f1000research.com/articles/7-1199/v1](https://f1000research.com/articles/7-1199/v1) 


#### Product design documents

[GA4GH research identity claims (RFC)](https://docs.google.com/document/d/1jvMpHmCWqcigqy1FuEzqXzHlaGeNP2mClOU2Ui4Djhg/edit)

[DUO github repo](https://github.com/EBISPOT/DUO)

[Meeting minutes ](https://drive.google.com/open?id=0B09Q6AWnrBnScGR2VmJ3OHNicWs)(directory)


#### Presentations at Basel 2018 plenary meeting

[Researcher Identity product](https://docs.google.com/presentation/d/1H9p0rbnYUx64mFWO_iHBYchxs6lBGHJyJ1bm5flcztg/edit#slide=id.p) 2018

[Data Use Ontology](https://docs.google.com/presentation/d/1B4jsqnZIqwxLjL8Y1q41kYFNN8BsmmiEC6I9_WZZPt0/edit#slide=id.p) 2018

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

