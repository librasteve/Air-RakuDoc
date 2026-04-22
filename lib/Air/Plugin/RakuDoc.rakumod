use RakuDoc::Render;
use RakuDoc::To::HTML;
use Air::Component;

sub internal-rakudoc( $source ) is export {
    state HTML::Processor $rend-obj;
    INIT {
        $rend-obj .= new(:output-format<html>);
        $rend-obj.add-templates(RakuDoc::To::HTML.new.html-templates, :source<HTML-Standard-Templates> );
        $rend-obj.add-templates( templates, :source<Air-RakuDoc>)
    }
    $rend-obj.render( $source.AST )
}

role Air::Plugin::RakuDoc does Component {
    #| rakudoc source to be converted
    has Str $.rakudoc;
    # cache the result
    has Str $!result;

    #| .new positional takes Str $code
    multi method new(Str $rakudoc, *%h) {
        self.bless: :$rakudoc, |%h;
    }

    multi method HTML {
        $!result = internal-rakudoc($!rakudoc) unless $!result;
        $!result
    }
}

sub templates {
    %(
    #| These sub-templates should allow sub-classes of RakuDoc::To::HTML
    #| to provide replacement templates on a more granular basis
        final => -> %prm, $tmpl {
            qq:to/PAGE/
                    { $tmpl<top-of-page> }
                    { $tmpl<main-content> }
                    { $tmpl<footer> }
                    PAGE
                },
        footer => -> %, $ { '' }, # remove footer
    )
}

sub rakudoc(*@a, *%h) is export { Air::Plugin::RakuDoc.new( |@a, |%h ) };