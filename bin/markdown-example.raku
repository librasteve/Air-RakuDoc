#!/usr/bin/env raku

use Air::Functional :BASE;
use Air::Base;

my &index = &page.assuming(
    title       => 'hÅrc',
    description => 'HTMX, Air, Red, Cro',
    footer      => footer p ['Aloft on ', b 'Åir'],
    );

my $base-examples =
    site :!scss,
        index
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
            ];

$base-examples.serve;