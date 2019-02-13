---
title: "Melissa Konopko"
layout: default
excerpt_separator: <!--more-->
image_file: 
category:
  - contact
tags:
  - contacts
  - contributors
  - admins
  - GA4GH
  - GKS
  - CP
---

{% for static_file in site.static_files %}
  {% if static_file.path contains page.image_file %}
<img style="float: right; width: 100px;" src="{{ static_file.path | relative_url}}" />
  {% endif %}
{% endfor %}

## {{ page.title }}

Technical Program Manager, GA4GH Data Use and Researcher IDs, Genomic Knowledge Standards, and Data Security Workstreams  
Global Alliance for Genomics and Health  

<!--more-->

email [melissa.konopko@ga4gh.org](mailto:melissa.konopko@ga4gh.org)  
web []()  
