
# An addon to Air to allow for RakuDoc segments

<div id="SYNOPSIS"></div>

## SYNOPSIS
<span class="para" id="ee53798"></span>In an Air website definition, include `use Air::RakuDoc`.

<div id="Example"></div>

## Example
<span class="para" id="5466754"></span>The following is based on `07-baseexamples.raku` in the Air-Examples distribution.   
<span class="para" id="49cbaa4"></span>The program is in `bin/rakudoc-example.raku`   

```
#!/usr/bin/env raku

use Air::Functional :BASE;
use Air::Base;
use Air::RakuDoc;

my &index = &page.assuming(
    title       => 'hÅrc',
    description => 'HTMX, Air, Red, Cro',
    footer      => footer p ['Aloft on ', b 'Åir'],
    );

my $base-examples =
    site :register[RakuDoc.new], #:theme-color<blue>,
        index #:REFRESH(5),
        main
            div [
                h3 'Markdown';
                markdown q:to/END/;
                        # My Markdown Example

                        ## Subheading

                        **Bold text** and *italic text*.

                        Here's a [link](https://www.example.com).

                         - Item 1
                         - Item 2
                         - Item 3

                        > This is a blockquote.

                        `Inline code` is useful!
                        END
                    hr;

                h3 'RakuDoc';
                rakudoc q:to/RAKUDOC/;
                    =begin rakudoc :!toc
                    =config item :bullet«\c[palm tree]»
                    =config item2 :bullet«\c[Earth Globe Europe-Africa]»
                    =head This is some RakuDoc source

                    Lets include a snazzy list:
                    =item First item with a palm tree bullet
                    =item Second item with palm tree
                    =item2 Now a second layer with a world
                    =item Back to the palm tree

                    And now some ordinary text.
                    =end rakudoc
                    RAKUDOC
                    hr;

            ];

$base-examples.serve;
```



----

----

Rendered from docs/README.rakudoc/README at 09:14 UTC on 2026-04-21

Source last modified at 11:28 UTC on 2025-10-16

