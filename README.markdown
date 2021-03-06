# Anonymous Public Posts plugin for Movable Type and Melody #

This plugin enables you to accept anonymous entry submissions from any visitor to your published blog, regardless of whether or not they have an account or they are logged in.

## VERSION ##

1.3 (Released September 28, 2009)

## REQUIREMENTS ##

* Movable Type 4.2 or higher or any version of Melody
* The Movable Type Community Pack, which is normally bundled with MT Pro and Enterprise

## INSTALLATION ##

Download the code or the Git repo. Inside you will find a directory (under `plugins`) called `AnonPublicPost`. Simply copy the that directory from the archive into your plugins directory so that you have:

    MT_DIR/plugins/AnonPublicPost

## INITIAL SETUP ##

In order to use this plugin, you need to first set up two things:

* An MT user account designated to be the default author for anonymous submitters
* A modified version of the "create entry" index template that doesn't force users to sign in.

### Setting up the default user ###

1. Create a new role that only has the permission to create entries ([screenshot](http://emberapp.com/jayallen/images/post-only-role-for-anonymous-public-post-plug))
2. Create a new user to act as the author of all anonymous entries.
3. Assign the post-only role in #1 to the new author created in #2

### Modify the Create Entry template ###

In this step, you need to modify the styles and/or javascript on the Create Entry index template so that the user has a choice whether to sign in or to post anonymously.  This is an exercise left to the reader although contribution of a clear set of simple instructions would be welcome.
 
## CONFIGURATION ##

The plugin has a **mandatory** configuration directive (set in `mt-config.cgi`), `PublicPostDefaultUser`, through which you  specify the default author username created above:

    PublicPostDefaultUser joeschmoe

Once this is set correctly, you should be set to go.

## VERSION HISTORY ##

* **09/19/2009** - Initial private beta release of v0.1-beta
* **09/22/2009** - Version 1.0, initial production release
* **09/22/2009** - Version 1.1, cleans up the cookie/session data so that the user cannot log in under the anonymous user
* **09/22/2009** - Version 1.2, Commented code and very minor readability tweaks
* **09/28/2009** - Version 1.3, Fixed posting by registered logged in users

## AUTHOR ##

This plugin was brought to you by [Jay Allen][], Principal of [Endevver Consulting][].

## LICENSE ##

This program is distributed under the terms of the GNU General Public License, version 2.

## BUG REPORTS AND FEATURE REQUESTS ##

If you find a bug in the plugin or would like to request a feature, you can [check our bug tracker](https://endevver.lighthouseapp.com/projects/37823-anonymous-public-posts/tickets) to see if it's already been filed and, if not, [file a new ticket](https://endevver.lighthouseapp.com/projects/37823-anonymous-public-posts/tickets/new).

[Movable Type]: http://movabletype.org
[Melody]: http://openmelody.org
[Jay Allen]: http://jayallen.org
[Endevver Consulting]: http://endevver.com
