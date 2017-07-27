#HTML basics

This will cover some basic HTML you may be using when editing the content.
It includes tags you will use for different headers, bold text, paragraphs,
links, and lists. It will also outline using classes to bold, italicise, or
centre text.

## HTML Tags

HTML tags always have an opening and closing tag. The opening tag is in `<>` and
the closing tag is in `</>`.

### Headers

There are 4 header sizes used in Healthlocker and Headscape Focus.

# This is an H1 tag

```html
<h1>
  This is an H1 tag
</h1>
```

## This is an H2 tag

```html
<h2>
  This is an H2 tag
</h2>
```

### This is an H3 tag

```html
<h3>
  This is an H3 tag
</h3>
```

#### This is an H4 tag

```html
<h4>
  This is an H4 tag
</h4>
```

### Bold, Italicise, and Centre Text

Text can be bolded or italicised in 2 ways.
If you have a whole tag(i.e. a paragraph) that needs to be bolded or italicised,
then you can add classes to the opening tag to change how the tag displays.
`class="b"` makes **bold** text,
`class="i"` makes *italicised* text, and `class="tc"` makes centred text.
A **bold** paragraph would look like
`<p class="b">Bold text</p>`. An *italicised* paragraph would look like
`<p class="i">Italic text<p>`. A centred H2 header would look like
`<h2 class="tc">Centred H2 header</h2>`.

You can combine them as well if you want bold, italic and centred text, it would
look like `<p class="b i tc">`. Note that there must be spaces between the
different classes.

If you only want some words or phrases in a paragraph to be bold, but not the
whole paragraph, then you can wrap the relevant words
in `<strong></strong>` tags.

Eg.

```html
<p>
  This is a paragraph of text that I don't want to be bold. However, I want
  <strong>these words</strong> to be bold.
</p>
```

Similarly, if you only want to italicise certain words in a paragraph, then you
can wrap the words to be italicised in `<i></i>` tags.

```html
<p>
  I only want the word <i>italicise</i> to be in italics.
</p>
```

### Adding Links

The links follow a certain template which can be changed for the text you want
to display and the links you want to go to. There are also differences for if
you are going to an internal link, external link, to an email, or to a phone
number.

You can copy this link template and change the text to display
(`Displayed text`) and link(`url-path`). Everything else stays the same.

```html
<%= link "Displayed text", to: "/url-path", class: "hl-aqua flex-wrap underline" %>
```

#### Internal Links
If you are going to a path within the Headscape Focus website
(i.e. something that we built), then you only need to include the
"relative url path". So if the base url is `https://ourwebsite.co.uk/headscape`
and you wanted to go to `https://ourwebsite.co.uk/headscape/posts`, then your
link would look like this:

```html
<%= link "Posts", to: "/posts", class: "hl-aqua flex-wrap underline" %>
```

#### External Links
An external link is any link that does not use our base url of
`https://ourwebsite.co.uk/headscape`. Even if it is
`https://ourwebsite.co.uk/other-section`, then you need to include the full url.

Eg. to link to the GitHub repo for this project, the link would be:

```html
<%= link "GitHub Repo", to: "https://github.com/healthlocker/oxleas-adhd", class: "hl-aqua flex-wrap underline" %>
```

#### Email Links
You need to include `mailto:` before the email address for the url

```html
<%= link "Ines", to: "mailto:ines@dwyl.com", class: "hl-aqua flex-wrap underline" %>
```

#### Phone Number Links
This is used for any phone number (mobile, landline, etc). You include `tel:`
before the number for the url.

```
<%= link "Random phone number", to: "tel:07512345689", class: "hl-aqua flex-wrap underline" %>
```

### Bullet Point and Numbered Lists
A list can be *ordered*, which is a numbered list, or *unordered*, which is a bullet point list. Each item in a list is enclosed in `<li></li>` tags. To make the list ordered, all of the list items are wrapped in `<ol></ol>` tags. To make an unordered list, all of the list items are wrapped in `<ul></ul>` tags.

**Ordered (numbered) list example**

```html
<ol>
  <li>First list item</li>
  <li>Second list item</li>
  <li>Third list item</li>
</ol>
```

**Unordered (bullet point) list example**

```html
<ul>
  <li>First list item</li>
  <li>Second list item</li>
  <li>Third list item</li>
</ul>
```

### Images
Image tags require that the image is added into the repository (unless it is an
external image). So for now, you will not be changing the images. You can either
leave them as is, or delete the entire image. This would required you to delete a div
that images are usually wrapped in. If there are other items inside the div, then
delete the `<%= img_tag... %>` only.

## HTML Entities
There are some reserved characters in HTML which may not display as expected unless you use a special character entity. `&` is one of these reserved characters.

For example, instead of writing:

```html
<p>
  HTML entity example using an & symbol
</p>
```

You would instead need to write:

```html
<p>
  HTML entity example using an &amp symbol
</p>
```

A list of reserved characters, and the corresponding character entity,
can be found [here](https://www.w3schools.com/html/html_entities.asp)
