---
title:  "GA4GH:GKS Examples & Guides"
layout: default
permalink: /howto.html
category:
  - howto
---

## Examples & Guides

{% for item in site.categories.howto %}
<div class="excerpt">
{{ item.excerpt }}
<p><a href="{{ item.url | relative_url }}">more ...</a></p>
</div>
{% endfor %}
