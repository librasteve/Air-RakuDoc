use RakuDoc::Render;
use RakuDoc::To::HTML;
use Air::Component;

#| CSS controls - default for Pico CSS theme (#comments denote Bulma originals)
#|
#| NB. Air::Component does not yet have a way to expose/handshake Theme parameters
#| Would need to be done at component build time and be constant for all instances of
#| RakuDoc, perhaps method PREPARE?
constant %css-controls = (
    :code-background-color('var(--pico-code-background-color)'),    #'linen' / '#eee'
    :heading-color('var(--pico-primary)'),                          #'maroon'
    :caption-color('var(--pico-primary)'),                          #'maroon'
);

role Air::Plugin::RakuDoc does Component {
    #| rakudoc source to be converted
    has Str $.rakudoc;

    # cache the result
    has Str $!result;
    # cache the CSS (same for all instances)
    my Str $css;

    #| .new positional takes Str $code
    multi method new(Str $rakudoc, *%h) {
        self.bless: :$rakudoc, |%h;
    }

    multi method HTML {
        $!result = self.internal-rakudoc($!rakudoc) unless $!result;
        $!result
    }

    submethod internal-rakudoc( $source ) {
        state HTML::Processor $rend-obj;

        $rend-obj .= new(:output-format<html>);
        $rend-obj.add-templates(RakuDoc::To::HTML.new.html-templates, :source<HTML-Standard-Templates> );
        $rend-obj.add-templates( templates, :source<Air-RakuDoc>);
        $rend-obj.add-data('css', self.vanilla-css());
        $rend-obj.render( $source.AST );
    }

    # noting Use of uninitialized value %!data{'css'} of type Any in string context.
    sub templates {
        %(
        #| These sub-templates should allow sub-classes of RakuDoc::To::HTML
        #| to provide replacement templates on a more granular basis
            final => -> %prm, $tmpl {
                qq:to/PAGE/
                    <style>{ $tmpl.globals.data<css> }</style>
                    { $tmpl<main-content> }
                    { $tmpl<footer> }
                    PAGE
                },
            footer => -> %, $ { '' }, # remove footer
        )
    }

    submethod vanilla-css {
        return $css with $css;

        $css = css-base();

        my %h := %css-controls;
        $css ~~ s:g/'%CODE-BACKGROUND-COLOR%'/%h<code-background-color>/;
        $css ~~ s:g/'%HEADING-COLOR%'/%h<heading-color>/;
        $css ~~ s:g/'%CAPTION-COLOR%'/%h<caption-color>/;

        return $css;

        sub css-base {
            q:to/CSS/;
            @charset "UTF-8";
            /*! Vanilla CSS */
            span.basis {
              font-weight: 800;
            }

            span.important {
              font-style: italic;
            }

            span.unusual {
              text-decoration: underline;
            }

            span.weighty {
              font-variant: small-caps;
            }

            span.code {
              font-weight: 500;
              background-color: %CODE-BACKGROUND-COLOR%;
              display: inline-block;
              margin: 2px;
              padding: 2px;
            }

            span.overstrike {
              text-decoration: line-through;
            }

            span.high {
              vertical-align: super;
            }

            span.junior {
              vertical-align: sub;
            }

            span.replace {
              font-style: italic;
              font-variant-caps: small-caps;
              text-shadow: -1px 1px;
            }

            span.indexed {
              text-shadow: 1px 1px orange;
            }
            span.indexed:hover::before {
              content: attr(data-index-text);
              translate: 0 -1.5em;
              position: absolute;
              opacity: 75%;
              background-color: turquoise;
              color: indigo;
            }

            span.keyboard {
              text-shadow: 1px 1px;
            }

            span.terminal {
              text-decoration: overline underline;
            }

            span.footnote {
              vertical-align: super;
            }

            a.footnote-anchor {
              text-decoration: none;
            }

            span.developer-version {
              display: none;
              color: red;
            }
            span.developer-version span.developer-note {
              font-family: "Brush Script MT", cursive;
            }
            span.developer-version:hover {
              display: inline-block;
              transform: translate(50px, 100px);
              z-index: 5;
            }

            span.bad-markdown {
              text-shadow: 1px 1px red;
            }

            .raku-code pre.rakudoc:first-child {
              background-color: %CODE-BACKGROUND-COLOR;
              margin: 0 1rem;
              padding: 0.5rem 1rem 0.5rem 1rem;
            }
            .raku-code .code-caption {
              color: %CAPTION-COLOR%;
              font-size: 0.875rem;
              font-weight: 500;
              font-style: italic;
              margin: 0 0 1rem 1rem;
            }

            .raku-input pre.rakudoc:first-child {
              background-color: %CODE-BACKGROUND-COLOR%;
              margin: 0 1rem;
              padding: 0.5rem 1rem 0.5rem 1rem;
            }
            .raku-input .input-caption {
              color: %CAPTION-COLOR%;
              font-size: 0.875rem;
              font-weight: 500;
              font-style: italic;
              margin: 0 0 1rem 1rem;
            }

            .raku-output pre.rakudoc:first-child {
              background-color: %CODE-BACKGROUND-COLOR%;
              margin: 0 1rem;
              padding: 0.5rem 1rem 0.5rem 1rem;
            }
            .raku-output .output-caption {
              color: %CAPTION-COLOR%;
              font-size: 0.875rem;
              font-weight: 500;
              font-style: italic;
              margin: 0 0 1rem 1rem;
            }

            div.defn-text {
              margin-left: 1rem;
            }
            div.defn-text p {
              margin: 0;
            }

            div.defn-term {
              font-weight: bold;
              font-style: italic;
            }
            div.defn-term .N {
              margin-right: 5px;
            }

            div.id-target {
              display: none;
            }

            div.nested {
              margin-left: 5rem;
            }

            div.toc .toc-item {
              margin-left: calc(var(--level) * 1rem);
            }
            div.toc .toc-item::before {
              content: attr(data-bullet);
            }
            div.toc .toc-item a {
              padding-left: 0.4rem;
            }

            div.index-section {
              margin-left: calc((var(--level) - 1) * 1rem);
              /*
                > a.index-ref {
                    white-space: nowrap;
                    display:inline-block;
                    width: 1em;
                    + span {
                        display: none;
                        width: 0;
                    }
                    &:hover+span {
                        display: inline-block;
                        position: absolute;
                        width: auto;
                        z-index: 5;
                        background-color: seashell;
                    }
                }
                */
            }
            div.index-section[data-index-level="1"] {
              text-shadow: 1px 1px orange;
            }
            div.index-section > a.index-ref {
              margin-left: calc(var(--level) * 1rem);
              display: block;
              width: auto;
              white-space: normal;
            }

            span.developer-note {
              display: none;
              width: 0;
              color: blue;
              text-shadow: 2px 2px 5px green;
            }

            span.developer-version {
              display: none;
              width: 0;
              color: red;
              text-shadow: 2px 2px 5px green;
            }

            .delta::before, span.developer-text::before {
              content: "🛈";
              vertical-align: super;
            }
            .delta:hover .developer-version, span.developer-text:hover .developer-version {
              display: inline-block;
              position: absolute;
              width: 100%;
              z-index: 5;
              transform: translate(0.5rem, -1rem);
            }
            .delta:hover .developer-note, span.developer-text:hover .developer-note {
              display: inline-block;
              position: absolute;
              width: auto;
              z-index: 5;
              margin-left: 1rem;
            }

            span.developer-text:hover {
              text-decoration: overline;
            }

            div.footer {
              border-top: 2px dashed;
              margin: 1rem 0;
              padding: 2rem;
            }
            div.footer .footer-field {
              display: inline-block;
            }
            div.footer .footer-line {
              display: block;
            }

            .heading > a {
              color: %HEADING-COLOR%;
              text-decoration: none;
            }

            h.title {
              font-size: larger;
            }

            .rakudoc-table {
              display: flex;
              align-content: flex-start;
              flex-direction: column;
              margin: 1rem;
              width: fit-content;
            }
            .rakudoc-table table, .rakudoc-table th, .rakudoc-table td {
              border: 1px solid lightgray;
              border-collapse: collapse;
            }
            .rakudoc-table .table-caption.rakudoc {
              color: %CAPTION-COLOR%;
              font-size: 0.875rem;
              font-weight: 500;
              font-style: italic;
            }
            .rakudoc-table .table {
              padding: 15px;
              margin-bottom: 10px;
              margin-top: 10px;
              border: 1px solid black;
            }
            .rakudoc-table .table td, .rakudoc-table .table td {
              padding: 5px;
            }
            .rakudoc-table .table caption {
              margin-bottom: 5px;
            }

            tbody.procedural tr.procedural .procedural-cell-left {
              text-align: left;
            }

            tbody.procedural tr.procedural .procedural-cell-centre {
              text-align: center;
            }

            tbody.procedural tr.procedural .procedural-cell-center {
              text-align: center;
            }

            tbody.procedural tr.procedural .procedural-cell-right {
              text-align: right;
            }

            tbody.procedural tr.procedural .procedural-cell-top {
              vertical-align: text-top;
            }

            tbody.procedural tr.procedural .procedural-cell-middle {
              vertical-align: baseline;
            }

            tbody.procedural tr.procedural .procedural-cell-bottom {
              vertical-align: text-bottom;
            }

            tbody.procedural tr.procedural .procedural-cell-label {
              font-weight: bold;
            }

            li.item {
              padding-left: 0.4rem;
              margin-left: calc(var(--level) * 1rem);
            }
            li.item::marker {
              content: attr(data-bullet);
            }
            li.item.extended-item > p {
              margin: 0;
            }

            li.numitem {
              padding-left: 0.4rem;
            }
            li.numitem::marker {
              content: attr(data-bullet);
            }

            div.rakudoc-image-placement {
              display: flex;
              flex-direction: column;
              align-items: center;
            }

            .rakudoc-placement-error {
              display: flex;
              justify-content: space-around;
              align-items: center;
              color: red;
              font-weight: bold;
            }

            .raku-anchor {
              font-size: 0.9em;
              text-decoration: none;
              visibility: hidden;
            }

            .heading:hover .raku-anchor {
              visibility: visible;
              padding-left: 5px;
            }

            .enumeration-N {
              margin: 0 5px 0 5px;
            }

            .formula {
              margin: 1rem;
            }
            .formula .formula-caption {
              color: %CAPTION-COLOR%;
              padding: 0.2rem 0 1rem 0;
              font-size: 0.875rem;
              font-weight: 500;
              font-style: italic;
            }

            p span.numpara {
              position: absolute;
              text-indent: -3rem;
            }

            div.extended-para {
              margin: 1rem 0;
            }
            div.extended-para span.numpara {
              position: absolute;
              text-indent: -3rem;
            }
            div.extended-para p.extended-para {
              margin: 0.5rem 0;
            }

            .rakudoc-singlepage {
              margin-left: 4rem;
            }

            CSS
        }
    }

}

sub rakudoc(*@a, *%h) is export { Air::Plugin::RakuDoc.new( |@a, |%h ) };