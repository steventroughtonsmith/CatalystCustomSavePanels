#  CatalystCustomSavePanels

This Mac Catalyst example showcases a way to use NSSavePanel through an AppKit bridge, allowing you to add an accessory view with options for e.g. output format. It should work for both iPad Idiom and Mac Idiom Catalyst apps, and various versions of macOS.

Changing the format via the popup menu also changes the file extension in the name field. The destination URL and format type is returned to the UIKit part of the codebase for it to handle as required.

### Screenshots

![https://hccdata.s3.amazonaws.com/gh_catalystcustomsavepanels.jpg](https://hccdata.s3.amazonaws.com/gh_catalystcustomsavepanels.jpg)
