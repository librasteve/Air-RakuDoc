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
    site :register[RakuDoc.new], :scss-off, #:theme-color<blue>,
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