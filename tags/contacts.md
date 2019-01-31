---
layout: default
---

{% assign this_name = page.name | split: "." %}
{% assign this_tag = this_name[0] | downcase %}
{% assign this_pagetitle = this_tag  | capitalize | replace: '_', ' ' %}

<h2 class="page_title">Pages tagged "{{ this_pagetitle  }}"</h2>

{% assign today = site.time | date: '%Y%m%d' %}
{% assign page_tag = this_tag | downcase %}
{% assign posts_all = site.documents | sort: 'date' | reverse %}

{% for post in posts_all %}
  {% if post.tags %}
    {% assign post_tags = post.tags | sort %}
    {% assign post_author = post.author | downcase %}
    {% for tag in post_tags %}
      {% assign tag_lower = tag | downcase %}
      {% if tag_lower == page_tag %}
        {% assign post_day = post.date | date: '%Y%m%d' %}
        {% assign post_year = post.date | date: '%Y' %}
        {% if post_day > today %}
          {% assign post_year = 'Upcoming' %}
        {% endif %}
        {% if current_year != post_year %}
          {% assign current_year = post_year %}
<h2 id="y{{post.date | date: "%Y"}}" style="margin-top: 20px;">{{ current_year }}</h2>
        {% endif %}
<div class="excerpt">
        {% if post_day > today %}
  <h3 style="color: red">{{ post.date | date: "%Y-%m-%d" }}</h3>
        {% endif %}
      {{ post.excerpt }}
  <p class="footnote">
      {%if post.author %}{{post.author}}, {% endif %}
      {%if post.date %}{{ post.date | date: "%Y-%m-%d" }}: {% endif %}
      <a href="{{ post.url | relative_url }}">more ...</a>
  </p>
</div>
        {% break %}
      {% endif %}
    {% endfor %}
  {% endif %}
{% endfor %}
