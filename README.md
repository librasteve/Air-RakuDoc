
# An addon to Air to allow for RakuDoc segments

<div id="SYNOPSIS"></div>

## SYNOPSIS
<span class="para" id="21486a4"></span>In an Air website definition, include `use Air::RakuDoc`. It will render all of the blocks and markup codes defined for RakuDoc v2, with [some caveats](Limitations).

<div id="Example"></div>

## Example
<span class="para" id="50c01bc"></span>The following is in `bin/rakudoc-example.raku`   

```
#!/usr/bin/env raku
#!/usr/bin/env raku

use Air::Functional :BASE;
use Air::Base;
use Air::Plugin::RakuDoc;

my &index = &page.assuming(
    title       => 'hÅrc',
    description => 'HTMX, Air, Red, Cro',
    footer      => footer p ['Aloft on ', b 'Åir'],
    );

my $base-examples =
    site :register[Air::Plugin::RakuDoc.new], :!scss,
        index
        main
            div [
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
<div id="Limitations"></div>

## Limitations
<span class="para" id="05e9d8a"></span>Citation blocks and `Q&lt; >` markup will not render properly without the external programs:   
&nbsp;&nbsp;• pandoc  
&nbsp;&nbsp;• citeproc  
<span class="para" id="2c69159"></span>And for more estoteric citation formats only, some of the utilities in the BibUtils repository.   
<span class="para" id="2f66299"></span>Currently, not all the Plugins available in the Rakuast::RakuDoc::Render distribution can be used, eg, GraphViz and Fontawesome.



----

----

Rendered from docs/README.rakudoc/README at 20:09 UTC on 2026-04-23

Source last modified at 20:08 UTC on 2026-04-23

