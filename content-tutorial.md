# Changing content

## How to find the file you want to edit

All the content to be changed will be found in `web/templates`. These can be
tricky to navigate, so the best way to find the file you want to change is to

1. Go to [healthlocker site](https://www.healthlocker.uk/)
2. Find the page you want to edit and copy some text.
3. Search for that text on GitHub by going to the
 [repo](https://github.com/healthlocker/oxleas-adhd), and pasting it in the
 search bar.
 ![github-search](https://user-images.githubusercontent.com/1287388/28594406-c1ed11ee-7187-11e7-99fb-608ccf57b833.png)
4. If more than one result shows up, you will need to open each file to discern
which is the correct page. You can usually identify the correct file by looking
at the path. For example, a snippet from the about section also appears on the
homepage, and the project README.
![image](https://user-images.githubusercontent.com/1287388/28595293-349b23d6-718b-11e7-931c-4bbe3b43acf8.png)
  * We can already rule out the README as the file that needs editing because it is
  not in `web/templates`. If we are editing the `about` page, about is in the file
  path. If we are editing the homepage, then `page` is in the file path.
  * If you are still unsure which file you want to edit then trying opening the
  file and checking to see if other text also matches the page you wish to edit
  on the website.
5. Once you have found the file, we need to follow that file path from
the main code page on the repo. We need to do this because in search, you
are not allowed to edit the file.
  * If you are editing the `Get Support` page, the path will be
  `web/templates/support/index.html.eex.`, which you will have found from search.
  * Go to the [code on GitHub](https://github.com/healthlocker/oxleas-adhd)
  * Click on `web` -> `templates` -> `support` -> `index.html.eex`


## How to change and add paragraphs

Once you have found the correct file, click on the pencil in the top right
corner of the file.
![edit-file](https://cloud.githubusercontent.com/assets/1287388/24212494/74f767d0-0f27-11e7-95b8-2b3bff21cbc5.png)

If we are keeping a paragraph, but only changing the text, then all we need to do
is change the text between the `<p>` tags.

Eg.

```
<p class="b">
  It is currently in development, more
  features and improvements will be added in the coming months.
</p>
```

can change to

```
<p class="b">
  This is the new text that will appear on the site!
</p>
```

NB: The `class="b"` will leave the text as **bold**. This can be removed if you
want it to be normal text, or change it to `class="i"` if you want the
text to be *italics*. If there are any other `classes` on the `<p>` tag, then leave them as is. There are more details on styling, as well as using other HTML tags
[here](/html-basics.md).

If you need to add an entirely new paragraph, then you need to wrap the text in
new `<p></p>` tags. Note the closing tag starts with a `/`.

```
<p>
  Adding a new paragraph!
</p>
```

Please ensure that if you are adding new HTML tags and content to the bottom on the page, that it stays within the closing `</div>`s.

## Making a pull request

After you are done making changes, you can find a box underneath the file that
says `Commit changes`.

**Always** check the box that says `create a new branch` as shown in the image below. **Never** select the option for committing directly to master branch.

![commit-changes](https://cloud.githubusercontent.com/assets/1287388/24213604/fb238f2a-0f2a-11e7-8a60-251e40e3251c.png)

In here, you can write a short message in the box that says `Update` describing
the change e.g. Add new option, update content in about page, etc.

Remember, **ALWAYS** check the option to `create a new branch`. Committing directly to the master branch is a big no no!

Click on `Propose file change`.

You will be taken to a new page where you can create a pull request. You can
leave the default text as the title, and reference any related issues in the
comment box.

Click `Create pull request` in the bottom right.

![create-pr](https://cloud.githubusercontent.com/assets/1287388/24213909/e2c6164a-0f2b-11e7-8ccf-d3f206108488.png)

If you are happy with the changes, change the label to `awaiting-review`:

![awaiting-review](https://cloud.githubusercontent.com/assets/1287388/24214001/21fe0ac0-0f2c-11e7-96a5-8f58110637c5.png)

Then add a `Reviewer` and `Assignee` of your choice.

## Carrying on work from a pull request

If you are not yet done making changes, you should still make the pull request
so it is easy to access your work later. However, instead of adding the
`awaiting-review` label, you can add an `in-progress` label and add yourself as
an assignee.

When you are ready to continue working on the same branch, you can go to the
[pull request section on GitHub](https://github.com/healthlocker/oxleas-adhd/pulls)
and select your pull request. Click on the `Files changed` tab.

![files-changed](https://user-images.githubusercontent.com/1287388/28664895-d06c4fb8-72b9-11e7-8133-2c4712205cb7.png)

Click on the pencil again.

![edit-pencil](https://user-images.githubusercontent.com/1287388/28665071-4ab80dc0-72ba-11e7-8ff8-497c19de56c8.png)

Make any other changes you wish. Then you are going to make another commit
using the `Commit changes` box underneath the file again. However, this time
it looks slightly different.

![image](https://user-images.githubusercontent.com/1287388/28665151-a143b644-72ba-11e7-9de5-7af53011edcc.png)

Notice that the options underneath the optional description box have changed.
Instead of an option to commit directly to master, it says
`Commit directly to <your-branch-name-here> branch.`

We want to keep all the changes on this same branch, so you are going to
select this option.

Then click the `Commit changes` button, which will add your new changes as a
commit to the pull request. If you are done, you can follow the instructions
above for changing labels and assignees and reviewers.
